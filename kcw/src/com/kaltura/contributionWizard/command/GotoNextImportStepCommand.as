package com.kaltura.contributionWizard.command
{
	import com.adobe_cw.adobe.cairngorm.control.CairngormEvent;
	import com.arc90.modular.ModuleSequenceCommand;
	import com.kaltura.contributionWizard.enums.KCWWorkflowState;
	import com.kaltura.contributionWizard.events.CategoryEvent;
	import com.kaltura.contributionWizard.events.GotoNextImportStepEvent;
	import com.kaltura.contributionWizard.events.ReportErrorEvent;
	import com.kaltura.contributionWizard.events.WorkflowEvent;
	import com.kaltura.contributionWizard.model.WizardModelLocator;
	import com.kaltura.contributionWizard.model.WorkflowState;
	import com.kaltura.contributionWizard.vo.ErrorVO;

	public class GotoNextImportStepCommand extends ModuleSequenceCommand
	{
		private var _model:WizardModelLocator = WizardModelLocator.getInstance();

		override public function execute(event:CairngormEvent):void
		{
			//collects categories info before going to tags view
			if (_model.workflowState == KCWWorkflowState.IMPORT_MEDIA) {
				var listCategories:CategoryEvent = new CategoryEvent(CategoryEvent.LIST_CATEGORIES);
				listCategories.dispatch();		
			}	
			
			var gotoNextStepEvent:GotoNextImportStepEvent  = GotoNextImportStepEvent(event);
			var currentStateName:String = _model.workflowState;

			var currentStateIndex:int;

			var currentWorkflowState:WorkflowState = _model.workflowStatesList.states.filter(
				function(importStep:WorkflowState, i:int, arr:Array):Boolean
				{
					if (importStep.name == currentStateName)
					{
						currentStateIndex = i;
						return true;
					}
					return false;
				}
			)[0];

			var direction:int = gotoNextStepEvent.backward ? -1 : 1;
			var nextStepIndex:int = currentStateIndex + direction;
			var nextStepEvent:CairngormEvent = WorkflowState(_model.workflowStatesList.states[nextStepIndex]).cairngormEvent;
			
			//REPORT TO KALTURA TO TRACE PROBLEMS WITH UPLOAD
			///////////////////////////////////////////////////
			var errorDescription : String = "currentState=" + _model.workflowStatesList.states[currentStateIndex].name;
			errorDescription += "&nextState=" + _model.workflowStatesList.states[nextStepIndex].name;
			var errorVo : ErrorVO = new ErrorVO();
			errorVo.reportingObj = "GotoNextImportStepCommand";
			errorVo.errorDescription = errorDescription;
			var errorEvent : ReportErrorEvent = new ReportErrorEvent( ReportErrorEvent.VIEW_STATE_CHANGE, errorVo);
			errorEvent.dispatch();
			///////////////////////////////////////////////////
			
			nextStepEvent.dispatch();
			/* if (gotoNextStepEvent.backward)
			{
				if (currentState == KCWWorkflowState.FINISH_SCREEN)
				{
					changeWorkflow(KCWWorkflowState.TAGGING);
				}
				else if (currentState == KCWWorkflowState.TAGGING)
				{
					changeWorkflow(KCWWorkflowState.IMPORT_MEDIA);
				}

			}
			else
			{
				if (currentState == KCWWorkflowState.IMPORT_MEDIA)
				{
					changeWorkflow(KCWWorkflowState.TAGGING);
				}
				else if (currentState == KCWWorkflowState.TAGGING)
				{
					var evtAddEntries:AddEntriesEvent = new AddEntriesEvent(AddEntriesEvent.ADD_ENTRIES);
					var clearState:ClearImportStateEvent = new ClearImportStateEvent(ClearImportStateEvent.CLEAR_IMPORT_STATE);

					var addEntriesAndClean:ChainEvent = EventChainFactory.chainEvents([evtAddEntries, clearState]);
					addEntriesAndClean.dispatch();
					//changeWorkflow(KCWWorkflowState.FINISH_SCREEN);
				}

			} */
		/* 	if (event.backward)
			{
				if (event.target == finishScreen)
				{
					changeWorkflow(KCWWorkflowState.TAGGING);
				}
				else if (event.target == taggingView)
				{
					changeWorkflow(KCWWorkflowState.IMPORT_MEDIA);
				}

			}
			else
			{
				if (event.target == importTypesView)
				{
					changeWorkflow(KCWWorkflowState.TAGGING);
				}
				else if (event.target == taggingView)
				{
					changeWorkflow(KCWWorkflowState.FINISH_SCREEN);
				}

			} */
		}

			private function changeWorkflow(state:String):void
			{
				var changeWorkflowEvent:WorkflowEvent = new WorkflowEvent(WorkflowEvent.CHANGE_WORKFLOW, state);
				changeWorkflowEvent.dispatch();
			}

	}
}