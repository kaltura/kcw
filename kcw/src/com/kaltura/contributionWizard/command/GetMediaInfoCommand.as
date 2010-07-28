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
	import com.kaltura.contributionWizard.business.MediaInfoDelegate;
	import com.kaltura.contributionWizard.business.ServiceCanceller;
	import com.kaltura.contributionWizard.events.MediaInfoEvent;
	import com.kaltura.contributionWizard.events.ViewControllerEvent;
	import com.kaltura.contributionWizard.events.search.MediaInfoViewEvent;
	import com.kaltura.contributionWizard.model.PendingActions;
	import com.kaltura.contributionWizard.model.WizardModelLocator;
	import com.kaltura.contributionWizard.responders.MediaInfoResponder;
	import com.kaltura.vo.importees.ImportURLVO;

	import flash.utils.Dictionary;

	import mx.collections.ArrayCollection;

	public class GetMediaInfoCommand implements ICommand
	{
		private var _model:WizardModelLocator = WizardModelLocator.getInstance();
		private var _viewToken:Object;

		public function execute(event:CairngormEvent):void
		{
			var evtGetMediaInfo:MediaInfoEvent = event as MediaInfoEvent;
			_viewToken = evtGetMediaInfo.viewToken;

			if (_model.searchData.searchResults.isMediaInfoNeeded)
			{
				var serviceCanceller:ServiceCanceller = getMediaInfo(evtGetMediaInfo.importItemVoList);
				_model.pendingActions.setPendingAction(PendingActions.GETTING_MEDIA_INFO, serviceCanceller);
			}
			else
			{
				_model.importData.isMediaInfoExist = true;
				var e:MediaInfoViewEvent = new MediaInfoViewEvent(MediaInfoViewEvent.MEDIA_INFO_COMPLETE, _viewToken);
				CairngormEventDispatcher.getInstance().dispatchEvent(e);
			}
		}

		private function getMediaInfo(importItemVoList:ArrayCollection):ServiceCanceller
		{
			var mediaInfoResponder:MediaInfoResponder = new MediaInfoResponder(getIdToVoDictionary(importItemVoList), _viewToken);
			//var importList:ArrayCollection = _model.importData.importCart.importItemsArray;
			var delegate:MediaInfoDelegate = new MediaInfoDelegate(mediaInfoResponder);
			return delegate.getMediaInfo(importItemVoList);
		}

		private function getIdToVoDictionary(importItemVoList:ArrayCollection):Dictionary
		{
			var idToVO:Dictionary = new Dictionary();
			for each (var importUrlVO:ImportURLVO in importItemVoList)
			{
				var mediaInfoToken:String = importUrlVO.uniqueID;
				idToVO[mediaInfoToken] = importUrlVO;
			}
			return idToVO;
		}
	}
}