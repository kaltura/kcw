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
package com.kaltura.contributionWizard.business.mlb.search
{
	import com.adobe_cw.adobe.cairngorm.business.ServiceLocator;
	import com.kaltura.contributionWizard.business.ServiceCanceller;
	import com.kaltura.contributionWizard.business.Services;
	import com.kaltura.contributionWizard.business.factories.SearchResultsFactory;
	import com.kaltura.contributionWizard.business.factories.serialization.SearchRequestDecoder;
	import com.kaltura.contributionWizard.model.WizardModelLocator;
	import com.kaltura.contributionWizard.vo.SearchMediaRequestVO;
	import com.kaltura.net.TemplateURLVariables;

	import flash.net.URLVariables;

	import mx.collections.ArrayCollection;
	import mx.rpc.AsyncToken;
	import mx.rpc.IResponder;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;

	public class MLBSearchDelegate implements IResponder
	{
		private var responder:IResponder;
		private var service:HTTPService;
		private var _model:WizardModelLocator = WizardModelLocator.getInstance();
		public function MLBSearchDelegate(responder:IResponder):void
		{
			this.responder = responder;
			this.service = ServiceLocator.getInstance().getHTTPService(Services.MLB_SEARCH_SERVICE);
		}

		public function searchMedia(searchMediaRequestVO:SearchMediaRequestVO, privateSearch:Boolean):ServiceCanceller
		{
			var requestVars:URLVariables = new TemplateURLVariables(_model.context.defaultUrlVars);
			//ContextDecorator.addVariables(requestVars);
			SearchRequestDecoder.addUrlVars(searchMediaRequestVO, requestVars);
			requestVars["privateSearch"] = requestVars.toString();
			MD5URLVarsDecoder.addUrlVars(requestVars);
			var call:AsyncToken = service.send(requestVars);
			call.addResponder(this);
			return new ServiceCanceller(this.service);

		}

		public function result(data:Object):void
		{
			var evtResult:ResultEvent = data as ResultEvent;

			var xmllResults:XMLList = evtResult.result.children();
			var searchResultsArray:Array = SearchResultsFactory.buildSearchResultsArray(xmllResults);

			var resultsList:ArrayCollection = new ArrayCollection(searchResultsArray)
			this.responder.result(resultsList);
		}

		public function fault(info:Object):void
		{
			this.responder.fault(info);
		}


	}
}