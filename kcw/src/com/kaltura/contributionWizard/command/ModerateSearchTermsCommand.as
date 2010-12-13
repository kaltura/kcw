package com.kaltura.contributionWizard.command
{
	import com.adobe_cw.adobe.cairngorm.control.CairngormEvent;
	import com.arc90.modular.ModuleSequenceCommand;
	import com.bjorn.event.ChainEvent;
	import com.kaltura.contributionWizard.business.ModerateSearchTermsDelegate;
	import com.kaltura.contributionWizard.model.WizardModelLocator;
	import com.kaltura.contributionWizard.model.importTypesConfiguration.search.ModerationFilter;
	import com.kaltura.contributionWizard.view.resources.ResourceBundleNames;

	import mx.controls.Alert;
	import mx.resources.ResourceManager;
	import mx.rpc.IResponder;

	public class ModerateSearchTermsCommand extends ModuleSequenceCommand implements IResponder
	{
		private var _model:WizardModelLocator = WizardModelLocator.getInstance();

		override public function execute(event:CairngormEvent):void
		{
			nextEvent = (event as ChainEvent).nextChainedEvent;
			var modFilter:ModerationFilter = _model.importTypesConfiguration.search.moderationFilter;
			if (!modFilter.url)
			{
				executeNextCommand();
				return;
			}
			var enteredSearchTerms:String = _model.searchData.searchTerms;
			var delegate:ModerateSearchTermsDelegate = new ModerateSearchTermsDelegate(this);
			delegate.timeout = modFilter.timeout;
			delegate.send(enteredSearchTerms);
			_model.pendingActions.isPending = true;
		}

		public function result(data:Object):void
		{
			_model.pendingActions.isPending = false;
			var approved:Boolean = data.approved;
			if (approved)
			{
				executeNextCommand();
			}
			else
			{
				var errorMsgBody:String = data.errorMsg;
				showErrorMessage(errorMsgBody);
			}
		}

		public function fault(info:Object):void
		{
			showErrorMessage();
			_model.pendingActions.isPending = false;
		}

		//TODO: move the error handling to the view
		private function showErrorMessage(errorMsgBody:String = null):void
		{
			var errorMessageTitle:String 	= ResourceManager.getInstance().getString(ResourceBundleNames.SEARCH_IMPORT_VIEW, "FORBIDDEN_SEARCH_TERMS_TITLE")
			if (!errorMsgBody)
				errorMsgBody = ResourceManager.getInstance().getString(ResourceBundleNames.SEARCH_IMPORT_VIEW, "FORBIDDEN_SEARCH_TERMS_BODY");
			Alert.show(errorMsgBody, errorMessageTitle);
		}
	}
}