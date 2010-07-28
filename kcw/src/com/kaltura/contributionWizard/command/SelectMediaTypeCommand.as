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
	import com.kaltura.contributionWizard.events.GotoScreenEvent;
	import com.kaltura.contributionWizard.events.MediaTypeSelectionEvent;
	import com.kaltura.contributionWizard.model.WizardModelLocator;
	import com.kaltura.contributionWizard.vo.ImportScreenVO;

	public class SelectMediaTypeCommand extends SequenceCommand implements ICommand
	{
		private static const DEFAULT_PROVIDER_INDEX:int = 0;
		private var _model:WizardModelLocator = WizardModelLocator.getInstance();

		public function SelectMediaTypeCommand():void
		{

			//nextEvent = new WorkflowEvent(WorkflowEvent.CHANGE_WORKFLOW, WizardModelLocator.IMPORT_MEDIA);
		}

		public override function execute(event:CairngormEvent):void
		{
			//convert it to GoToScreen...

 			var evtMediaTypeSelect:MediaTypeSelectionEvent = event as MediaTypeSelectionEvent;

 			var screenVo:ImportScreenVO = new ImportScreenVO(evtMediaTypeSelect.mediaType);
			var gotoScreenEvent:GotoScreenEvent = new GotoScreenEvent(GotoScreenEvent.GOTO_SCREEN, screenVo);
			gotoScreenEvent.dispatch();
		}

		public function executeChainCommands():void
		{
/* 			var workflowEvent:WorkflowEvent 			= new WorkflowEvent(WorkflowEvent.CHANGE_WORKFLOW, WizardModelLocator.IMPORT_MEDIA);

			var defaultMediaProviderVo:MediaProviderVO	= _model.mediaProviders.getProviderByIndex(DEFAULT_PROVIDER_INDEX);
			var changeMediaProvider:MediaProviderEvent	= new MediaProviderEvent(MediaProviderEvent.MEDIA_PROVIDER_CHANGE, defaultMediaProviderVo);

			var eventList:Array = [workflowEvent, changeMediaProvider];
			nextEvent = EventChainFactory.chainEvents(eventList);
			executeNextCommand(); */
		}
	}
}