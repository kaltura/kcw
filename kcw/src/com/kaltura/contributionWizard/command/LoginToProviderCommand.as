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
	import com.adobe_cw.adobe.cairngorm.commands.SequenceCommand;
	import com.adobe_cw.adobe.cairngorm.control.CairngormEvent;
	import com.bjorn.event.ChainEvent;
	import com.bjorn.event.EventChainFactory;
	import com.kaltura.contributionWizard.business.ProviderAuthDelegate;
	import com.kaltura.contributionWizard.events.LoginEvent;
	import com.kaltura.contributionWizard.events.SearchMediaEvent;
	import com.kaltura.contributionWizard.model.ProviderLoginStatus;
	import com.kaltura.contributionWizard.model.WizardModelLocator;
	import com.kaltura.contributionWizard.vo.PageSearchDirection;
	import com.kaltura.contributionWizard.vo.ProviderLoginVO;
	import com.kaltura.contributionWizard.vo.providers.AuthentcationMethodTypes;
	import com.kaltura.contributionWizard.vo.providers.AuthenticationMethod;
	import com.kaltura.contributionWizard.vo.providers.MediaProviderVO;
	
	import mx.rpc.IResponder;

	public class LoginToProviderCommand extends SequenceCommand implements ICommand, IResponder
	{
		private var _model:WizardModelLocator = WizardModelLocator.getInstance();
		private var _targetMediaProvider:MediaProviderVO;

		public function LoginToProviderCommand():void
		{
			var evtSetSearchTerms:SearchMediaEvent = new SearchMediaEvent(SearchMediaEvent.SET_SEARCH_TERMS, PageSearchDirection.FIRST_PAGE, ""); //show all results
			var evtSearchMedia:SearchMediaEvent = new SearchMediaEvent(SearchMediaEvent.SEARCH_MEDIA, PageSearchDirection.FIRST_PAGE);
			var chainEvent:ChainEvent = EventChainFactory.chainEvents([evtSetSearchTerms, evtSearchMedia]);
			nextEvent = chainEvent;
		}

		public override function execute(event:CairngormEvent):void
		{
			_model.providerLoginStatus.isPending = true;
			_model.providerLoginStatus.loginStatus = ProviderLoginStatus.LOGIN_NOT_SENT;

			var evtLogin:LoginEvent = event as LoginEvent;
			_targetMediaProvider = _model.mediaProviders.activeMediaProvider;
			var authMethod:AuthenticationMethod = _targetMediaProvider.authMethodList.privateMethod

			var waitingForKey:Boolean = true;
			if (authMethod.methodType == AuthentcationMethodTypes.AUTH_METHOD_EXTERNAL && !authMethod.externalAuthUrl)
			{
				waitingForKey = false;
			}
			var username:String = evtLogin.username;
			var password:String = evtLogin.password;
			var providerCode:String = _targetMediaProvider.providerCode;

			var providerLoginVO:ProviderLoginVO = new ProviderLoginVO(username, password, providerCode);

			var providerAuthDelegate:ProviderAuthDelegate = new ProviderAuthDelegate(this);
			providerAuthDelegate.authenticate(providerLoginVO, authMethod.methodType, waitingForKey);

		}

		public function result(data:Object):void
		{
			//Since the user succeed to log in, switch the active method to private

			var resultAuthMethod:AuthenticationMethod = data as AuthenticationMethod;

			if (resultAuthMethod.key)
			{
				_targetMediaProvider.authMethodList.activeMethod = _targetMediaProvider.authMethodList.privateMethod;
				var activeAuthMethod:AuthenticationMethod = _targetMediaProvider.authMethodList.activeMethod;
				activeAuthMethod.key = resultAuthMethod.key;
				_model.providerLoginStatus.loginStatus = ProviderLoginStatus.LOGIN_SUCCESS;
			}
			else if (resultAuthMethod.externalAuthUrl)
			{
				_targetMediaProvider.authMethodList.privateMethod.externalAuthUrl = resultAuthMethod.externalAuthUrl;
				_model.providerLoginStatus.loginStatus = ProviderLoginStatus.LOGIN_URL_AVAILABLE;
			}
			_model.providerLoginStatus.isPending = false;

		}

		public function fault(info:Object):void
		{
			_model.providerLoginStatus.isPending = false;
			_model.providerLoginStatus.loginStatus = ProviderLoginStatus.LOGIN_FAILED;
		}

	}
}