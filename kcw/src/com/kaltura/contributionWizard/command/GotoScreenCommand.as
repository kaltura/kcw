package com.kaltura.contributionWizard.command
{
	import com.adobe_cw.adobe.cairngorm.commands.SequenceCommand;
	import com.adobe_cw.adobe.cairngorm.control.CairngormEvent;
	import com.bjorn.event.ChainEvent;
	import com.kaltura.contributionWizard.enums.KCWWorkflowState;
	import com.kaltura.contributionWizard.events.ClearImportStateEvent;
	import com.kaltura.contributionWizard.events.GotoScreenEvent;
	import com.kaltura.contributionWizard.events.WorkflowEvent;
	import com.kaltura.contributionWizard.model.WizardModelLocator;
	import com.kaltura.contributionWizard.vo.ImportScreenVO;
	/**
	 * Navigates a specific media provider described in the GotoScreenEvent.importScreenVo
	 * The valid values of the ImportScreenVO object are:
	 * ImportScreenVO = null							The default media provider is selected
	 * mediaType: null, 	mediaProvider: null			The default media provider is selected
	 * mediaType: "video", 	mediaProvider: null			The first provider in the video section is selected
	 * mediaType: "video", 	mediaProvider: "kaltura"	Kaltura-video is selected
	 *
	 * Invalid values:
	 * ImportScreenVO = [null, youtube] 				The media type must be defined, otherwise the mediaProvider might not be fully qualified
	 * @author user
	 *
	 */
	public class GotoScreenCommand extends SequenceCommand
	{
		private var _model:WizardModelLocator = WizardModelLocator.getInstance();

		public override function execute(event:CairngormEvent):void
		{
			var gotoScreenEvent:GotoScreenEvent = event as GotoScreenEvent;
			validateScreenVo(gotoScreenEvent.importScreenVo);
			var screenVo:ImportScreenVO = getScreenVo(gotoScreenEvent.importScreenVo) ;

			if (!screenVo || !screenVo.mediaType)
			{
				var defaultScreenVo:ImportScreenVO = _model.startupDefaults.defaultScreenVo;
				changeWorkflow(KCWWorkflowState.INTRO_SCREEN);
			}
			else
			{
				_model.mediaProviders.setActiveMediaType(screenVo.mediaType);
				_model.mediaProviders.setProviderByName(screenVo.mediaProviderName);
				changeWorkflow(KCWWorkflowState.IMPORT_MEDIA);
			}
			clearState();
			nextEvent = gotoScreenEvent.nextChainedEvent;
			executeNextCommand();
		}

		private function clearState():void
		{
			nextEvent = new ClearImportStateEvent(ClearImportStateEvent.CLEAR_IMPORT_STATE);
			executeNextCommand();
		}

		private function changeWorkflow(workflowState:String):void
		{
			var event:ChainEvent = new WorkflowEvent(WorkflowEvent.CHANGE_WORKFLOW, workflowState);
			event.dispatch()
		}

		private function validateScreenVo(screenVo:ImportScreenVO):void
		{
			if (!screenVo) return;
			//if (screenVo.mediaProviderName && !_model.mediaProviders.getProviderVoByName(screenVo.mediaProviderName))
				//throw new Error("GotoScreenCommand: Media provider with name \"" +screenVo.mediaProviderName + "\"doesn't exist");
			if (screenVo.mediaProviderName && !screenVo.mediaType) //chekc if only media provider id was specified;
				throw new Error("GotoScreenCommand: only media provider id was specified");
		}

		private function getScreenVo(screenVo:ImportScreenVO):ImportScreenVO
		{
			if (!screenVo || !screenVo.mediaType)
				return _model.startupDefaults.defaultScreenVo;
			else
				return screenVo;
		}

	}
}