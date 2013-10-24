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
package com.kaltura.contributionWizard.command
{
	import com.adobe_cw.adobe.cairngorm.commands.ICommand;
	import com.adobe_cw.adobe.cairngorm.control.CairngormEvent;
	import com.adobe_cw.adobe.cairngorm.control.CairngormEventDispatcher;
	import com.arc90.modular.ModuleSequenceCommand;
	import com.kaltura.contributionWizard.business.SearchMediaDelegate;
	import com.kaltura.contributionWizard.business.ServiceCanceller;
	import com.kaltura.contributionWizard.events.SearchMediaEvent;
	import com.kaltura.contributionWizard.events.ViewControllerEvent;
	import com.kaltura.contributionWizard.model.PendingActions;
	import com.kaltura.contributionWizard.model.SearchResults;
	import com.kaltura.contributionWizard.model.WizardModelLocator;
	import com.kaltura.contributionWizard.model.importData.ImportCart;
	import com.kaltura.contributionWizard.util.MediaSourceDataInjector;
	import com.kaltura.contributionWizard.vo.PageSearchDirection;
	import com.kaltura.contributionWizard.vo.SearchMediaRequestVO;
	import com.kaltura.vo.importees.BaseImportVO;
	import com.kaltura.vo.importees.ImportURLVO;
	import com.kaltura.contributionWizard.vo.providers.AuthenticationMethod;
	import com.kaltura.utils.pager.Pager;
	import com.kaltura.vo.MediaMetaDataVO;

	import mx.collections.ArrayCollection;
	import mx.rpc.IResponder;
	import mx.rpc.events.ResultEvent;

	//TODO: refactor this class
	public class SearchMediaCommand extends ModuleSequenceCommand implements ICommand, IResponder
	{
		private var _model:WizardModelLocator = WizardModelLocator.getInstance();
		
		/**
		 * Saves the active media provider ID so that when the search results are retrieved, this can be injected to each of them.
		 * */
		private var _mediaProviderCode:String;
		
		/**
		 * Saves the active media type so that when the search results are retrieved, this can be injected to each of them.
		 * */
		private var _mediaTypeCode:int;

		private var _requestedLocalPage:int;
		private var _requestedRemotePage:int;
		private var _pager:Pager;
		private var _direction:int;

		public override function execute(event:CairngormEvent):void
		{
			var evtSearchMedia:SearchMediaEvent = event as SearchMediaEvent;
			if (needsToLogIn())
			{
				dispatchNotLoggedIn(evtSearchMedia.token);
				return;
			}

			_direction = evtSearchMedia.pagingDirection;

			if (evtSearchMedia.pagingDirection == PageSearchDirection.FIRST_PAGE)
			{
				//cleans
				_model.searchData.searchResults = new SearchResults();
				_model.importData.importCart = new ImportCart();
			}
			_pager = _model.searchData.searchResults.pager;

 			_requestedLocalPage = _pager.getLocalPageByDirection(_direction);

 			//try to go to this page, and check if it's fully cached
 			if (_pager.gotoPage(_requestedLocalPage) != Pager.PAGE_EXIST && _pager.allEntries.length != _maxEntries)
 			{
 				_requestedRemotePage = _pager.getRemotePageByDirection(_direction);
				var searchDelegate:SearchMediaDelegate = new SearchMediaDelegate(this);
				var serviceCanceller:ServiceCanceller = searchDelegate.searchMedia(getSearchRequest(_requestedRemotePage));
				_model.pendingActions.setPendingAction(PendingActions.SEARCHING, serviceCanceller);
				saveSearchSource();
			}

		}
		private  var _maxEntries:int = int.MAX_VALUE;

		public function result(event:Object):void
		{
			_model.pendingActions.isPending = false

			var evtResult:ResultEvent = event as ResultEvent;
			var resultsList:ArrayCollection = evtResult.result["results"] as ArrayCollection;
			addSearchTermsAsTitle(resultsList);
			var isMediaInfoNeeded:Boolean = evtResult.result.isMediaInfoNeeded;

			var numResults:int = resultsList.length;
			if (numResults == 0) //no search results found
			{
				if (_direction == PageSearchDirection.FIRST_PAGE)
				{
					_model.searchData.searchResults.resultsFound = false;
				}
				else //results not found but this is only because the user navigated to the last page
				{
					_pager.lastPageIndex = _pager.localPageNum;
				}
				return;
			}

			_pager.remotePageSize = numResults;

			if (isMediaInfoNeeded)
			{
				//TODO: this will cause all search results to ask for media info even if just one really needs it...
				_model.searchData.searchResults.isMediaInfoNeeded = true;
			}

			MediaSourceDataInjector.injectToList(resultsList.source, _mediaProviderCode, _mediaTypeCode);
			//WizardModelLocator.getInstance().searchData.searchResults = searchResults;

			if (repeatingResults(resultsList, _pager.allEntries))
			{
				_maxEntries = _pager.allEntries.length;
				_pager.lastPageIndex = _pager.localPageNum;
				return;
			}
			_pager.addDataSet(resultsList.source);

			if (_pager.gotoPage(_requestedLocalPage) != Pager.PAGE_EXIST)
			{
				nextEvent = new SearchMediaEvent(SearchMediaEvent.SEARCH_MEDIA, PageSearchDirection.CURRENT_PAGE, _model.searchData.searchTerms);
			}

			executeNextCommand();
		}


		public function fault(event:Object):void
		{
			_pager.lastPageIndex = _pager.localPageNum;
			if (_direction == PageSearchDirection.FIRST_PAGE)
			{
				_model.searchData.searchResults.resultsFound = false;
			}
			_model.pendingActions.isPending = false;
		}

		private function saveSearchSource():void
		{
			_mediaProviderCode = _model.mediaProviders.activeMediaProvider.providerCode;
			_mediaTypeCode = _model.mediaProviders.activeMediaProvider.mediaInfo.mediaCode;
		}

		private function getSearchRequest(pageIndex:int):SearchMediaRequestVO
		{
			//if the user didn't select to search in his private collection, don't pass the auth key to
			//var authKey:String = usePrivateSearch ? WizardModelLocator.getInstance().mediaProviders.activeMediaProvider.authSessionKey : null;

			var searchRequest:SearchMediaRequestVO = new SearchMediaRequestVO(
					_model.searchData.searchTerms,
					pageIndex,
					20,
					_model.mediaProviders.activeMediaProvider
				);
			return searchRequest;
		}

		private function repeatingResults(searchResults:ArrayCollection, cachedData:Array):Boolean
		{
			var numRepetitions:int;

			for each (var newImportVo:ImportURLVO in searchResults)
			{
				for each (var cachedImportItemVo:BaseImportVO in cachedData)
				{
					if (cachedImportItemVo is ImportURLVO && newImportVo.uniqueID == (cachedImportItemVo as ImportURLVO).uniqueID )
					{
						numRepetitions++
					}
				}
			}
			return numRepetitions == searchResults.length;
		}

		private function needsToLogIn():Boolean
		{
			var authMethod:AuthenticationMethod = _model.mediaProviders.activeMediaProvider.authMethodList.activeMethod;
			if (!authMethod.isPublic && !authMethod.key)
			{
				return true;
			}
			return false;
		}

		private function dispatchNotLoggedIn(token:Object):void
		{
			CairngormEventDispatcher.getInstance().dispatchEvent(new ViewControllerEvent(ViewControllerEvent.NOT_LOGGED_IN, token));
		}

		private function addSearchTermsAsTitle(importItemList:ArrayCollection):void
		{
			for each (var importItemVo:BaseImportVO in importItemList)
			{
				var metaData:MediaMetaDataVO = importItemVo.metaData;
				if (!metaData.title) // the results might already have meta data
				{
					metaData.title = _model.searchData.searchTerms;
				}
			}
		}

	}
}