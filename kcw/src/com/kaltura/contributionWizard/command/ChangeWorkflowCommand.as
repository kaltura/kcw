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
	import com.bjorn.event.ChainEvent;
	import com.kaltura.contributionWizard.enums.KCWWorkflowState;
	import com.kaltura.contributionWizard.events.ClearImportStateEvent;
	import com.kaltura.contributionWizard.events.WorkflowEvent;
	import com.kaltura.contributionWizard.model.WizardModelLocator;

	public class ChangeWorkflowCommand extends SequenceCommand
	{
		private var _model:WizardModelLocator = WizardModelLocator.getInstance();

		public override function execute(event:CairngormEvent):void
		{
			var evtChangeWorkflow:WorkflowEvent = event as WorkflowEvent;
			_model.workflowState = evtChangeWorkflow.workflow;
			executeCommandOnState(_model.workflowState);
			chainEvent(ChainEvent(event).nextChainedEvent);
			executeNextCommand();
		}

		private function executeCommandOnState(workflowState:String):void
		{
			switch (workflowState)
			{
				case KCWWorkflowState.FINISH_SCREEN:
					var clearState:ChainEvent = new ClearImportStateEvent(ClearImportStateEvent.CLEAR_IMPORT_STATE);
					chainEvent(clearState);
				break;
			}
		}
		private function chainEvent(event:ChainEvent):void
		{
			if (nextEvent)
				ChainEvent(nextEvent).nextChainedEvent = event;
			else
				nextEvent = event;
		}
	}
}