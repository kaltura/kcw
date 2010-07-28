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
package com.kaltura.contributionWizard.responders
{
	import com.kaltura.contributionWizard.events.ViewControllerEvent;
	import com.kaltura.contributionWizard.events.search.MediaInfoViewEvent;
	import com.kaltura.contributionWizard.model.WizardModelLocator;
	import com.kaltura.vo.importees.ImportURLVO;
	
	import flash.utils.Dictionary;
	
	import mx.controls.Alert;
	import mx.rpc.IResponder;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;

	public class MediaInfoResponder implements IResponder
	{
		private var _model:WizardModelLocator = WizardModelLocator.getInstance();
		private var _mediaInfoIdsToVO:Dictionary;
		private var _mediaInfoEvent:ViewControllerEvent;
		private var _viewToken:Object;
		private var _errorCode:String;
		public function MediaInfoResponder(mediaInfoIdsToVO:Dictionary, viewToken:Object):void
		{
			_mediaInfoIdsToVO = mediaInfoIdsToVO;
			_viewToken = viewToken;
		}

		public function result(data:Object):void
		{
			//TODO: error checking
			setNotPending();
			var evtResult:ResultEvent = data as ResultEvent;
			var mediaInfoResults: Array = evtResult.result as Array;
			handleMediaInfoList(mediaInfoResults);
		}

		public function fault(info:Object):void
		{
			setNotPending();
			if (info is FaultEvent || info is Error)
			{
				_model.importData.isMediaInfoExist = true;
				Alert.show("IOError occurred while fetching media info");
			}
			else if (info.result)
			{
				_errorCode = info.errorCode;
				handleMediaInfoList(info.result);
			}
		}

		private function handleMediaInfoList(mediaInfoList:Array):void
		{
			mergeNewMediaInfo(mediaInfoList);
			verifyMediaInfo();

			_model.importData.isMediaInfoExist = true;
			_mediaInfoEvent.dispatch();
		}

		private function mergeNewMediaInfo(mediaInfoResults:Array):void
		{
			var mergedImportList:Array;

			for each (var voMediaInfo:ImportURLVO in mediaInfoResults)
			{
				var mediaInfoId:String = voMediaInfo.uniqueID;

				/*
				This check is vital as some media info responses will not supply any info,
				not even the media unique id token, in cases like adult content results.
				*/
				if (mediaInfoId)
				{
					var originalUrlVO:ImportURLVO = _mediaInfoIdsToVO[mediaInfoId] as ImportURLVO;
					originalUrlVO.mergeWith(voMediaInfo);
				}
			}
		}

		private function verifyMediaInfo():void
		{
			//var importItemCollection:ArrayCollection = _model.importData.importCart.importItemsArray;
			var isImportError:Boolean;
			var anySuccessItems:Boolean;

			for(var key:Object in _mediaInfoIdsToVO)
			{
				var importUrlVo:ImportURLVO = _mediaInfoIdsToVO[key] as ImportURLVO;
				if (!importUrlVo.fileUrl)
				{
					_model.importData.importCart.removeImportItem(importUrlVo);
					isImportError = true;
				}
				else
				{
					anySuccessItems = true;
				}
			}

			if (isImportError) //some import item do not contain the basic info for import
			{
				if (anySuccessItems) //some failed and some not
				{
					_mediaInfoEvent = new MediaInfoViewEvent(MediaInfoViewEvent.MEDIA_INFO_ERROR, _viewToken, _errorCode);
				}
				else //all failed
				{
					_mediaInfoEvent = new MediaInfoViewEvent(MediaInfoViewEvent.MEDIA_INFO_ERROR, _viewToken, _errorCode);
				}
			}
			else //all succeed
			{
				_mediaInfoEvent = new MediaInfoViewEvent(MediaInfoViewEvent.MEDIA_INFO_COMPLETE, _viewToken);
			}
		}



		private function setNotPending():void
		{
			_model.pendingActions.isPending = false;
		}

	}
}