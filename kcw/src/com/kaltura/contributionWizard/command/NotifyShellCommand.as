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
	import com.kaltura.contributionWizard.events.ExternalInterfaceEvent;
	import com.kaltura.contributionWizard.events.NotifyShellEvent;
	import com.kaltura.contributionWizard.events.shell.WizardShellEvent;
	import com.kaltura.contributionWizard.model.ExternalFunctionIds;
	import com.kaltura.contributionWizard.model.WizardModelLocator;

	import mx.managers.SystemManager;
	import mx.utils.ObjectUtil;

	public class NotifyShellCommand extends SequenceCommand
	{
		private var _model:WizardModelLocator = WizardModelLocator.getInstance();
		private var _externalFucntionsIds:ExternalFunctionIds = WizardModelLocator.getInstance().externalFunctions;
		private var _systemManager:SystemManager;
		private var _externalFunctionToCall:String;
		private var _parameters:Array;
		private var _eventType:String;

		private var _entryIdList:Array;

		public override function execute(event:CairngormEvent):void
		{
			/*We use the model SystemManager reference because of hack that we use:The contribution wizard is being loaded into a swf ApplicationDomain.currentDomain instead of child or
			In that case, the  SystemManager.getSWFRoot(this) returns a random SystemManager (either the expected SystemManager which ius the root of the contribution wizard or the loading swf SystemManager object)
			*/
			_systemManager = _model.systemManager;//SystemManager.getSWFRoot(this) as SystemManager;
			var notifyShellEvent:NotifyShellEvent = event as NotifyShellEvent;
			_entryIdList = notifyShellEvent.entryIdList;

			switch (notifyShellEvent.type)
			{
				case NotifyShellEvent.ADD_ENTRY_NOTIFICATION:
					_eventType = WizardShellEvent.ENTRIES_ADDED;
					_externalFunctionToCall = _externalFucntionsIds.addEntryFunction;
					_parameters = _entryIdList;

					trace("notifyEntriesAdded", ObjectUtil.toString(_entryIdList));
				break;

				case NotifyShellEvent.CLOSE_WIZARD_NOTIFICATION:
					_eventType = WizardShellEvent.WIZARD_CLOSE;
					_externalFunctionToCall = _externalFucntionsIds.onWizardFinishFunction;
					_parameters = [_model.importData.hasEntriesAddedPerLifetime ? 1 : 0];
				break;

				case NotifyShellEvent.WIZARD_READY_NOTIFICATION:
					_externalFunctionToCall = _externalFucntionsIds.wizardReadyFunction;
					_eventType = "wizardReady";
				break;

				case NotifyShellEvent.PENDING:
					_externalFunctionToCall = _externalFucntionsIds.kcwPendingChangeHandler;
					_parameters = [_model.pendingActions.isPending];
				break;
			}

			if (_externalFunctionToCall)
			{
				callExternalFucntion();
			}
			if (_eventType)
			{
				dispatchShellEvent();
			}

		}

		private function callExternalFucntion():void
		{
			var event:ExternalInterfaceEvent = new ExternalInterfaceEvent(ExternalInterfaceEvent.CALL_EXTERNAL_INTERFACE, _externalFunctionToCall, _parameters);
			event.dispatch();
		}

		private function dispatchShellEvent():void
		{
			var event:WizardShellEvent = new WizardShellEvent(_eventType, _parameters, true);
			_systemManager.dispatchEvent(event);
		}

	}
}