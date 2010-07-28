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
	import com.adobe_cw.adobe.cairngorm.commands.SequenceCommand;
	import com.adobe_cw.adobe.cairngorm.control.CairngormEvent;
	import com.bjorn.event.EventChainFactory;
	import com.kaltura.contributionWizard.events.ClearImportStateEvent;
	import com.kaltura.contributionWizard.events.GotoScreenEvent;
	import com.kaltura.contributionWizard.events.LoadUIEvent;
	import com.kaltura.contributionWizard.events.MediaProviderEvent;
	import com.kaltura.contributionWizard.model.WizardModelLocator;
	import com.kaltura.contributionWizard.vo.ImportScreenVO;
	import com.kaltura.contributionWizard.vo.providers.MediaProviderVO;

	public class ChangeMediaProviderCommand extends SequenceCommand
	{
		private var _model:WizardModelLocator = WizardModelLocator.getInstance();
		public override function execute(event:CairngormEvent):void
		{
			var evtChangeMediaProvider:MediaProviderEvent = event as MediaProviderEvent;
			var newProvider:MediaProviderVO = evtChangeMediaProvider.mediaProviderVO;
			var screenVo:ImportScreenVO = new ImportScreenVO(_model.mediaProviders.activeMediaProvider.mediaInfo.mediaType, newProvider.providerName);
			var gotoScreenCommand:GotoScreenEvent = new GotoScreenEvent(GotoScreenEvent.GOTO_SCREEN, screenVo);
			gotoScreenCommand.dispatch();
/* 			var evtChangeMediaProvider:MediaProviderEvent = event as MediaProviderEvent;
			var newProvider:MediaProviderVO = evtChangeMediaProvider.mediaProviderVO;
			_model.mediaProviders.activeMediaProvider = newProvider;
			//TODO: what if the login is cache at the server or if the user is already logged in. Also, this should not reside in here.
			_model.providerLoginStatus.loginStatus = ProviderLoginStatus.LOGIN_NOT_SENT;

			clearImportState();
			loadStylesAndLocales(newProvider); */
		}

		private function clearImportState():void
		{
			var clearImportStateEvent:ClearImportStateEvent = new ClearImportStateEvent(ClearImportStateEvent.CLEAR_IMPORT_STATE);
			clearImportStateEvent.dispatch();
		}


		private function loadStylesAndLocales(newProviderVo:MediaProviderVO):void
		{
			var loadStyleEvent:LoadUIEvent	= new LoadUIEvent(LoadUIEvent.LOAD_STYLE, 	newProviderVo.uiConfig);
			var loadLocaleEvent:LoadUIEvent	= new LoadUIEvent(LoadUIEvent.LOAD_LOCALE, 	newProviderVo.uiConfig);

			var eventList:Array = [loadStyleEvent, loadLocaleEvent];
			nextEvent = EventChainFactory.chainEvents(eventList);
			executeNextCommand();
		}
	}
}