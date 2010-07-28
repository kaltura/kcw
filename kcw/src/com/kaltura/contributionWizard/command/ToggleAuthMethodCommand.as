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
	import com.kaltura.contributionWizard.events.AuthMethodEvent;
	import com.kaltura.contributionWizard.events.ViewControllerEvent;
	import com.kaltura.contributionWizard.model.ProviderLoginStatus;
	import com.kaltura.contributionWizard.model.WizardModelLocator;
	import com.kaltura.contributionWizard.vo.providers.AuthenticationMethodList;

	public class ToggleAuthMethodCommand implements ICommand
	{
		private var _model:WizardModelLocator = WizardModelLocator.getInstance();
		public function execute(event:CairngormEvent):void
		{
			var evtToggleAuthMethod:AuthMethodEvent = event as AuthMethodEvent;
			var authMethodsList:AuthenticationMethodList = _model.mediaProviders.activeMediaProvider.authMethodList;
			//var evtUserNotLoggedIn:LogInViewEvent
			//TODO: consider a state pattern
			if (! authMethodsList.activeMethod.isPublic) // user is already in private mode
			{
				//start reset the private authentication mode
				authMethodsList.activeMethod.key = null;
				authMethodsList.activeMethod.externalAuthUrl = null;
				_model.providerLoginStatus.loginStatus = ProviderLoginStatus.LOGIN_NOT_SENT;
				//end reset the private authentication mode
				authMethodsList.activeMethod = authMethodsList.publicMethod;
			}
			else
			{
				if (authMethodsList.privateMethod.key)// || authMethodsList.privateMethod.externalAuthUrl) //the user has a key and therefore he's already authenticated
				{
					authMethodsList.activeMethod = authMethodsList.privateMethod;
				}
				else //private auth was not authenticated yet
				{
					//_model.providerLoginStatus.loginStatus = ProviderLoginStatus.LOGIN_NOT_SENT;
					CairngormEventDispatcher.getInstance().dispatchEvent(new ViewControllerEvent(ViewControllerEvent.NOT_LOGGED_IN, evtToggleAuthMethod.token));
				}

			}
		}

	}
}