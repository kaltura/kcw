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
	import com.kaltura.contributionWizard.business.factories.serialization.SearchRequestDecoder;
	import com.kaltura.contributionWizard.model.WizardModelLocator;
	import com.kaltura.contributionWizard.vo.SearchMediaRequestVO;
	import com.kaltura.net.TemplateURLVariables;
	
	import flash.net.URLVariables;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import mx.collections.ArrayCollection;
	import mx.rpc.AsyncToken;
	import mx.rpc.IResponder;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;
	import mx.styles.StyleManager;

	public class SearchMediaDelegate implements IResponder
	{
		private var _responder:IResponder;
		private var _service:HTTPService;
		private var _serviceCanceller:ServiceCanceller;
		private var _model:WizardModelLocator = WizardModelLocator.getInstance();
		private var _timeoutId:uint;

		public function SearchMediaDelegate(responder:IResponder):void
		{
			_responder = responder;
			_service = ServiceLocator.getInstance().getHTTPService(Services.SEARCH_MEDIA_SERVICE);
		}

		public function searchMedia(searchMediaRequestVO:SearchMediaRequestVO):ServiceCanceller
		{
			var requestVars:URLVariables = new TemplateURLVariables(_model.context.defaultUrlVars);
			SearchRequestDecoder.addUrlVars(searchMediaRequestVO, requestVars);

			//var service:HTTPService =  getService(searchMediaRequestVO)
			if (searchMediaRequestVO.mediaProviderVo.customData.searchUrl)
			{
				var genericSearchUrl:String = _service.url;
				_service.url = searchMediaRequestVO.mediaProviderVo.customData.searchUrl;
			}
			var call:AsyncToken = _service.send(requestVars);
			call.addResponder(this);
			_timeoutId = setTimeout(serviceTimeoutHandler, 60*1000);
			_serviceCanceller = new ServiceCanceller(_service);
			if (genericSearchUrl)
				_service.url = genericSearchUrl;
			return _serviceCanceller;
		}


		public function result(data:Object):void
		{
			clearTimeout(_timeoutId);
			var evtResult:ResultEvent = data as ResultEvent;

			try
			{
				//trace("evtResult.result.xml.result: " + evtResult.result.objects.result[0]);
				var xmlSearchResults:XML = evtResult.result.result.objects[0] as XML;
				var xmllResults:XMLList = xmlSearchResults.children();
				var searchResultsArray:Array = SearchResultsFactory.buildSearchResultsArray(xmllResults);
				var needMediaInfoNode:String = evtResult.result.result.needMediaInfo.text();
				var isMediaInfoNeeded:Boolean = evtResult.result.result.needMediaInfo.text() == "1";

				var resultsList:ArrayCollection = new ArrayCollection(searchResultsArray)
				var resultData:Object = {results: resultsList, isMediaInfoNeeded: isMediaInfoNeeded};
				
				var resultEventToPass:ResultEvent = new ResultEvent(ResultEvent.RESULT, false, true, resultData, evtResult.token, evtResult.message);
				_responder.result(resultEventToPass);
			}
			catch(E:Error)
			{
				//catch malformed result and let the responder handle it
				_responder.fault(data);
			}

		}

		public function fault(info:Object):void
		{
			clearTimeout(_timeoutId);
			_responder.fault(info);
		}

		private function serviceTimeoutHandler():void
		{
			_serviceCanceller.cancel();
			fault(null);
		}

	}
}