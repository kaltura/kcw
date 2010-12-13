package com.kaltura.contributionWizard.events
{
	import com.adobe_cw.adobe.cairngorm.control.CairngormEvent;
	import com.arc90.modular.ModuleSequenceCommand;
	import com.kaltura.contributionWizard.model.WizardModelLocator;

	import flash.ui.Mouse;

	public class NotifyAddEntriesCompleteCommand extends ModuleSequenceCommand
	{

		private var _model:WizardModelLocator = WizardModelLocator.getInstance();

		override public function execute(event:CairngormEvent):void
		{
			var entriesInfoList:Array = EntriesAddedEvent(event).entriesInfoList;
			notifyShell(entriesInfoList);
		}

		private function notifyShell(entriesInfoList:Array):void
		{
			notifyEntriesAdded(entriesInfoList);

			_model.importData.hasEntriesAddedPerLifetime = true;

			//If the wizard is configured to run only once, tell the shell we're done.
			if (_model.startupDefaults.singleContribution)
			{
				notifyWizardClose();
			}
			else
			{
				//indicates
				_model.importData.hasEntriesAddedPerSession = true;
				_model.pendingActions.isPending = false
			}
		}

		private function notifyEntriesAdded(entryIdList:Array):void
		{
			var event:NotifyShellEvent = new NotifyShellEvent(NotifyShellEvent.ADD_ENTRY_NOTIFICATION, entryIdList);
			event.dispatch();
		}

		private function notifyWizardClose():void
		{
			var event:NotifyShellEvent = new NotifyShellEvent(NotifyShellEvent.CLOSE_WIZARD_NOTIFICATION);
			event.dispatch();
		}
	}
}