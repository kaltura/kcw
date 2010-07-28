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
package com.kaltura.contributionWizard.business
{
	import com.adobe_cw.adobe.cairngorm.business.ServiceLocator;
	import com.kaltura.contributionWizard.business.factories.SearchResultsFactory;
	import com.kaltura.contributionWizard.model.WizardModelLocator;
	import com.kaltura.net.TemplateURLVariables;
	import com.kaltura.vo.importees.ImportURLVO;
	
	import flash.net.URLVariables;
	
	import mx.collections.ArrayCollection;
	import mx.rpc.AsyncToken;
	import mx.rpc.IResponder;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;

	public class MediaInfoDelegate implements IResponder
	{
		private var responder:IResponder;
		private var service:HTTPService;
		private var _model:WizardModelLocator = WizardModelLocator.getInstance();

		public function MediaInfoDelegate(responder:IResponder):void
		{
			this.responder = responder;
			//this.service = ServiceLocator.getInstance().getHTTPService(Services.GET_MEDIA_INFO_SERVICE);
			this.service = ServiceLocator.getInstance().getHTTPService(Services.MULTIREQUEST);
		}

		public function getMediaInfo(searchResultsList:ArrayCollection):ServiceCanceller
		{
			var mediaInfoURLVars:URLVariables = getMediaInfoUrlVars(searchResultsList);
			var call:AsyncToken = service.send(mediaInfoURLVars);
			call.addResponder(this);

			return new ServiceCanceller(this.service);
		}

		public function result(data:Object):void
		{
			var evtResult:ResultEvent = data as ResultEvent;
			var xmlRoot:XML = evtResult.result as XML;
			var xmlResults:XML = xmlRoot.result[0];
			var searchResultsVOArray:Array = SearchResultsFactory.buildSearchResultsArray( xmlResults..item );
		
			//if (xmlRoot.error.children().length() == 0) //no errors
			if (xmlRoot..error.length() == 0) //no errors
			{
				var event:ResultEvent = new ResultEvent(ResultEvent.RESULT, false, true, searchResultsVOArray, evtResult.token, evtResult.message);
				responder.result(event);
			}
			else
			{
				var errorCode:String = xmlRoot..error.code[0];
				var resultObject:Object = {result: searchResultsVOArray, errorCode: errorCode};
				responder.fault(resultObject);
			}
			//parse the media info data here
		}

		public function fault(info:Object):void
		{
			responder.fault(info);
		}

		private function getMediaInfoUrlVars(searchResultsList:ArrayCollection):URLVariables
		{
			var mediaInfoURLVars:URLVariables = new TemplateURLVariables(_model.context.defaultUrlVars);

			for (var i:int = 0; i < searchResultsList.length; i++)
			{
				var searchResultVO:ImportURLVO = searchResultsList[i];
				addMediaInfoURLVars(searchResultVO, mediaInfoURLVars, i + 1);
			}

			return mediaInfoURLVars;
		}

		private function addMediaInfoURLVars(importItemVo:ImportURLVO, mediaInfoURLVars:URLVariables, index:int):void
		{
			mediaInfoURLVars[index + ":service"] = Services.SERVICE_SEARCH;
			mediaInfoURLVars[index + ":action"] = Services.ACTION_GET_MEDIA_INFO;
			mediaInfoURLVars[index + ":searchResult:searchSource"] = importItemVo.mediaProviderCode;
			mediaInfoURLVars[index + ":searchResult:mediaType"] = importItemVo.mediaTypeCode;
			mediaInfoURLVars[index + ":searchResult:id"] = importItemVo.uniqueID;
			
			/*mediaInfoURLVars["media" + index + "_source"]	= importItemVo.mediaProviderCode;
			mediaInfoURLVars["media" + index + "_type"]		= importItemVo.mediaTypeCode;
			mediaInfoURLVars["media" + index + "_id"]		= importItemVo.uniqueID;*/
		}

	}
}