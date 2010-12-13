package com.kaltura.contributionWizard.model
{
	import com.bjorn.event.ChainEvent;
	import com.kaltura.contributionWizard.enums.KCWWorkflowState;
	import com.kaltura.contributionWizard.events.AddEntriesEvent;
	import com.kaltura.contributionWizard.events.WorkflowEvent;

	import flash.events.MouseEvent;

	public class WorkflowStatesList
	{
		public function WorkflowStatesList(enableIntroScreen:Boolean, enableTagging:Boolean, enableFinishScreen:Boolean):void
		{
			var introScreen:WorkflowState = new WorkflowState(KCWWorkflowState.INTRO_SCREEN, 		new WorkflowEvent(WorkflowEvent.CHANGE_WORKFLOW, KCWWorkflowState.INTRO_SCREEN));
			var importMedia:WorkflowState = new WorkflowState(KCWWorkflowState.IMPORT_MEDIA, 		new WorkflowEvent(WorkflowEvent.CHANGE_WORKFLOW, KCWWorkflowState.IMPORT_MEDIA));
			var taggingScreen:WorkflowState = new WorkflowState(KCWWorkflowState.TAGGING,			new WorkflowEvent(WorkflowEvent.CHANGE_WORKFLOW, KCWWorkflowState.TAGGING));
			var addEntrieshEvent:WorkflowState = new WorkflowState(KCWWorkflowState.ADD_ENTRIES,	new AddEntriesEvent(AddEntriesEvent.ADD_ENTRIES));
			var finishScreenEvent:WorkflowState = new WorkflowState(KCWWorkflowState.FINISH_SCREEN, new WorkflowEvent(WorkflowEvent.CHANGE_WORKFLOW, KCWWorkflowState.FINISH_SCREEN));

			states = [introScreen, importMedia, taggingScreen, addEntrieshEvent, finishScreenEvent];

			if (!enableIntroScreen)
				removeStateByName(KCWWorkflowState.INTRO_SCREEN);

			if (!enableTagging)
				removeStateByName(KCWWorkflowState.TAGGING);

			if (!enableFinishScreen)
				removeStateByName(KCWWorkflowState.FINISH_SCREEN);

			mergeStates();
		}
		public var states:Array;

		public function getStateByName(stateName:String):WorkflowState
		{
			return states.filter(
				function statesNameFilter(state:WorkflowState, i:int, list:Array):Boolean
				{
					return state.name == stateName;
				}
			)[0];
		}

		private function removeStateByName(name:String):void
		{
			var state:WorkflowState = getStateByName(name);
			var stateIndex:int = states.indexOf(state);
			states.splice(stateIndex, 1);
		}

		/**
		 * Adds a nextEvent to the AddEntriesEvent if exists (currently only WorkflowEvent that navigates to the finish screen)
		 *
		 */
		private function mergeStates():void
		{
			var addEntriesState:WorkflowState = getStateByName(KCWWorkflowState.ADD_ENTRIES);
			var addEntriesIndex:int = states.indexOf(addEntriesState);
			var nextState:WorkflowState =  addEntriesIndex < states.length - 1 ? states[addEntriesIndex + 1] : null;

			var addEntriesEvent:ChainEvent = ChainEvent(addEntriesState.cairngormEvent);
			addEntriesEvent.nextChainedEvent = nextState ? ChainEvent(nextState.cairngormEvent) : null;
			addEntriesState.cairngormEvent = addEntriesEvent;
		}

	}
}