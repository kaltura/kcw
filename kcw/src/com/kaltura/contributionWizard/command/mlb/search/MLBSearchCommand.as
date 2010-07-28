/*
This file is part of the Kaltura Collaborative Media Suite which allows users
to do with audio, video, and animation what Wiki platfroms allow them to do with
text.

Copyright (C) 2006-2008  Kaltura Inc.

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as
published by the Free Software Foundation, either version 3 of the
License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Affero General Public License for more details.

You should have received a copy of the GNU Affero General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.

@ignore
*/
package com.kaltura.contributionWizard.command.mlb.search
{
	import com.adobe_cw.adobe.cairngorm.commands.ICommand;
	import com.adobe_cw.adobe.cairngorm.commands.SequenceCommand;
	import com.adobe_cw.adobe.cairngorm.control.CairngormEvent;
	import com.adobe_cw.adobe.cairngorm.control.CairngormEventDispatcher;
	import com.kaltura.contributionWizard.business.ServiceCanceller;
	import com.kaltura.contributionWizard.business.mlb.search.MLBSearchDelegate;
	import com.kaltura.contributionWizard.events.SearchMediaEvent;
	import com.kaltura.contributionWizard.events.ViewControllerEvent;
	import com.kaltura.contributionWizard.events.mlb.search.MLBSearchEvent;
	import com.kaltura.contributionWizard.model.PendingActions;
	import com.kaltura.contributionWizard.model.SearchResults;
	import com.kaltura.contributionWizard.model.WizardModelLocator;
	import com.kaltura.contributionWizard.model.importData.ImportCart;
	import com.kaltura.contributionWizard.util.MediaSourceDataInjector;
	import com.kaltura.contributionWizard.vo.PageSearchDirection;
	import com.kaltura.contributionWizard.vo.SearchMediaRequestVO;
	import com.kaltura.vo.importees.BaseImportVO;
	import com.kaltura.vo.importees.ImportURLVO;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.rpc.IResponder;
	import mx.rpc.events.FaultEvent;

	//TODO: refactor this class
	public class MLBSearchCommand extends SequenceCommand implements ICommand, IResponder
	{
		private var _model:WizardModelLocator = WizardModelLocator.getInstance();
		//Saves the active media provider ID so that when the search results are retrieved, this can be injected to each of them.
		private var _mediaProviderCode:String;
		//Saves the active media type so that when the search results are retrieved, this can be injected to each of them.
		private var _mediaTypeCode:int;

		private var _requestedLocalPage:int;
		private var _pager:Pager;
		private var _direction:int;

		public override function execute(event:CairngormEvent):void
		{
			var evtSearchMedia:MLBSearchEvent = event as MLBSearchEvent;

			_direction = evtSearchMedia.pagingDirection;

			if (evtSearchMedia.pagingDirection == PageSearchDirection.FIRST_PAGE)
			{
				//cleans
				//_model.searchData.searchResults.pager.isLastPage = false;
				_model.searchData.searchResults = new SearchResults();
				WizardModelLocator.getInstance().importData.importCart = new ImportCart();
			}
			_pager = _model.searchData.searchResults.pager;
			_pager.isLastPage = false;
			_pager.externalPageIndex = getRequestedPageNum(_pager.externalPageIndex, evtSearchMedia.pagingDirection);

			if (!_pager.isPageCached(_pager.pageIndex) && _direction != PageSearchDirection.PREVIOUS_PAGE)
			{
				//if the current page is not fully cached (7/10 = not fully cached 13/10, 10/10 is fully cached), then
				//keep fetching this page data and only when finished go to another page
				_requestedLocalPage = _pager.pageIndex;
			}
			else
			{
				//if the currently displayed page is already fully cached, then load another one
				_requestedLocalPage = getRequestedPageNum(_pager.pageIndex, evtSearchMedia.pagingDirection);
			}

			if (!_pager.gotoPage(_requestedLocalPage))
			{
				var searchDelegate:MLBSearchDelegate = new MLBSearchDelegate(this);
				var serviceCanceller:ServiceCanceller = searchDelegate.searchMedia(getSearchRequest(_pager.externalPageIndex), evtSearchMedia.privateSearch);
				_model.pendingActions.setPendingAction(PendingActions.SEARCHING, serviceCanceller);

				saveSearchSource();
			}

		}

		public function result(event:Object):void
		{
			_model.pendingActions.isPending = false

			var resultsList:ArrayCollection = event as ArrayCollection;

			if (resultsList.length == 0) //no search results found
			{
				if (_direction == PageSearchDirection.FIRST_PAGE)
				{
					_model.searchData.searchResults.resultsFound = false;
				}
				else //results not found but this is only because the user navigated to the last page
				{
					_pager.isLastPage = true;
				}

				return;
			}
			_pager.isLastPage = false;

			MediaSourceDataInjector.injectToList(resultsList.source, _mediaProviderCode, _mediaTypeCode);
			//WizardModelLocator.getInstance().searchData.searchResults = searchResults;

			if (repeatingResults(resultsList, _pager.pagesData))
			{
				_pager.isLastPage = true;
				return;
			}
			WizardModelLocator.getInstance().searchData.searchResults.pager.addPage(resultsList);

			if (!_pager.gotoPage(_requestedLocalPage))
			{
				nextEvent = new SearchMediaEvent(SearchMediaEvent.SEARCH_MEDIA, PageSearchDirection.NEXT_PAGE);
			}

			executeNextCommand();

		}

		public function fault(event:Object):void
		{
			var evtFault:FaultEvent = evtFault as FaultEvent;
			Alert.show("MLBSearchCommand failed to get data from the server");
			_model.pendingActions.isPending = false;
		}

		private function saveSearchSource():void
		{
			_mediaProviderCode = _model.mediaProviders.activeMediaProvider.providerCode;
			_mediaTypeCode = _model.mediaProviders.activeMediaProvider.mediaInfo.mediaCode;
		}

		private function getRequestedPageNum(currentPageNum:int, direction:int):int
		{
			var newPageNum:int;
			if (direction == PageSearchDirection.FIRST_PAGE)
			{
				newPageNum = 1;
			}
			else if (direction == PageSearchDirection.NEXT_PAGE)
			{
				newPageNum = ++currentPageNum;
			}
			else if (direction == PageSearchDirection.PREVIOUS_PAGE)
			{
				newPageNum = --currentPageNum;
			}
			return newPageNum;
		}

		private function getSearchRequest(pageIndex:int):SearchMediaRequestVO
		{
			var searchRequest:SearchMediaRequestVO = new SearchMediaRequestVO(
					_model.searchData.searchTerms,
					pageIndex,
					Pager.OUTER_PAGE_SIZE,
					_model.mediaProviders.activeMediaProvider.mediaInfo.mediaCode,
					_model.mediaProviders.activeMediaProvider.providerCode
				);
			return searchRequest;
		}

		private function repeatingResults(searchResults:ArrayCollection, cachedData:ArrayCollection):Boolean
		{
			for each (var newImportVo:ImportURLVO in searchResults)
			{
				for each (var cachedImportItemVo:BaseImportVO in cachedData)
				{
					if (cachedImportItemVo is ImportURLVO && newImportVo.uniqueID == (cachedImportItemVo as ImportURLVO).uniqueID )
					{
						return true;
					}
				}
			}
			return false;
		}

		private function dispatchNotLoggedIn(token:Object):void
		{
			CairngormEventDispatcher.getInstance().dispatchEvent(new ViewControllerEvent(ViewControllerEvent.NOT_LOGGED_IN, token));
		}

	}
}