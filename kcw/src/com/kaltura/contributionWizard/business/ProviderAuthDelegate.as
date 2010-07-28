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
	import com.kaltura.contributionWizard.business.factories.serialization.importUrlVo.concrete.ProviderLoginVoDecoder;
	import com.kaltura.contributionWizard.model.WizardModelLocator;
	import com.kaltura.contributionWizard.vo.ProviderLoginVO;
	import com.kaltura.contributionWizard.vo.providers.AuthenticationMethod;
	import com.kaltura.net.TemplateURLVariables;

	import mx.rpc.AsyncToken;
	import mx.rpc.IResponder;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;

	public class ProviderAuthDelegate implements IResponder
	{
		//private var isExternalLogin:Boolean = false;
		private var _model:WizardModelLocator = WizardModelLocator.getInstance();
		private var _waitingForKey:Boolean;

		public function ProviderAuthDelegate(responder:IResponder):void
		{
			this.responder = responder;
			this.service = ServiceLocator.getInstance().getHTTPService(Services.PROVIDER_AUTHENTICATION_SERVICE);
		}

		public function authenticate(providerLoginVO:ProviderLoginVO, authMethodType:int, waitingForKey:Boolean):void
		{
			_waitingForKey = waitingForKey;
			var urlVars:TemplateURLVariables = getProviderLoginUrlVars(providerLoginVO);
			urlVars["authMethodType"] = authMethodType;

			var call:AsyncToken = service.send(urlVars);
			call.addResponder(this);
		}

		private function getProviderLoginUrlVars(providerLoginVO:ProviderLoginVO):TemplateURLVariables
		{
			var urlVars:TemplateURLVariables = new TemplateURLVariables(_model.context.defaultUrlVars);
			ProviderLoginVoDecoder.addUrlVars(providerLoginVO, urlVars);
			return urlVars;
		}

		public function result(data:Object):void
		{
			var evtResult:ResultEvent = data as ResultEvent;
			var xmlAuthdata:XML = (evtResult.result as XML)["result"]["authdata"][0];
			//var authInfo:String;

			if (xmlAuthdata["status"] == "error")
			{
				this.responder.fault( new FaultEvent(FaultEvent.FAULT) );
				return;
			}
			//authInfo = xmlAuthdata["loginUrl" ] || xmlAuthdata["authData"];

			var authMethod:AuthenticationMethod = new AuthenticationMethod();
			if (xmlAuthdata["authData"].toString())
			{
				authMethod.key = xmlAuthdata["authData"];
			}
			else if (xmlAuthdata["loginUrl"].toString() && !_waitingForKey)
			{
				authMethod.externalAuthUrl = xmlAuthdata["loginUrl"];
			}
			else
			{
				this.fault(new FaultEvent(FaultEvent.FAULT));
				return;
			}

			responder.result(authMethod);
		}

		public function fault(info:Object):void
		{
			responder.fault(info);
		}

		private var responder:IResponder;
		private var service:HTTPService;
	}
}