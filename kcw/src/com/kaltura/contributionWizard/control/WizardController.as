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
package com.kaltura.contributionWizard.control
{
  import com.adobe_cw.adobe.cairngorm.control.FrontController;
  import com.kaltura.contributionWizard.command.AddBatchTagsCommand;
  import com.kaltura.contributionWizard.command.AddCreditsCommand;
  import com.kaltura.contributionWizard.command.AddEntriesCommand;
  import com.kaltura.contributionWizard.command.AddToImportCartCommand;
  import com.kaltura.contributionWizard.command.CallExternalInterfaceCommand;
  import com.kaltura.contributionWizard.command.CancelPendingRequestCommand;
  import com.kaltura.contributionWizard.command.ChangeMediaProviderCommand;
  import com.kaltura.contributionWizard.command.ChangePermissionLevelCommand;
  import com.kaltura.contributionWizard.command.ChangeWorkflowCommand;
  import com.kaltura.contributionWizard.command.CheckPartnerNotificationCommand;
  import com.kaltura.contributionWizard.command.ClearImportStateCommand;
  import com.kaltura.contributionWizard.command.CloseWizardCommand;
  import com.kaltura.contributionWizard.command.GetWizardConfigCommand;
  import com.kaltura.contributionWizard.command.GotoNextImportStepCommand;
  import com.kaltura.contributionWizard.command.GotoScreenCommand;
  import com.kaltura.contributionWizard.command.ListCategoriesCommand;
  import com.kaltura.contributionWizard.command.LoadLocaleCommand;
  import com.kaltura.contributionWizard.command.LoadStylesCommand;
  import com.kaltura.contributionWizard.command.NotifyShellCommand;
  import com.kaltura.contributionWizard.command.RemoveFromImportCartCommand;
  import com.kaltura.contributionWizard.command.ReportErrorCommand;
  import com.kaltura.contributionWizard.command.SaveInjectedDataCommand;
  import com.kaltura.contributionWizard.command.SelectMediaTypeCommand;
  import com.kaltura.contributionWizard.command.SendPartnerNotificationsCommand;
  import com.kaltura.contributionWizard.command.SetDefaultScreenCommand;
  import com.kaltura.contributionWizard.command.SetMetaDataCommand;
  import com.kaltura.contributionWizard.command.ValidateAllMetaDataCommand;
  import com.kaltura.contributionWizard.command.ValidateLimitationsCommand;
  import com.kaltura.contributionWizard.command.ValidateMetaDataFieldCommand;
  import com.kaltura.contributionWizard.events.AddEntriesEvent;
  import com.kaltura.contributionWizard.events.BatchMetaDataEvent;
  import com.kaltura.contributionWizard.events.CategoryEvent;
  import com.kaltura.contributionWizard.events.ChangePermissionLevelEvent;
  import com.kaltura.contributionWizard.events.ClearImportStateEvent;
  import com.kaltura.contributionWizard.events.CloseWizardEvent;
  import com.kaltura.contributionWizard.events.CreditsEvent;
  import com.kaltura.contributionWizard.events.EntriesAddedEvent;
  import com.kaltura.contributionWizard.events.ExternalInterfaceEvent;
  import com.kaltura.contributionWizard.events.GotoNextImportStepEvent;
  import com.kaltura.contributionWizard.events.GotoScreenEvent;
  import com.kaltura.contributionWizard.events.ImportEvent;
  import com.kaltura.contributionWizard.events.LoadUIEvent;
  import com.kaltura.contributionWizard.events.MediaProviderEvent;
  import com.kaltura.contributionWizard.events.MediaTypeSelectionEvent;
  import com.kaltura.contributionWizard.events.NotifyAddEntriesCompleteCommand;
  import com.kaltura.contributionWizard.events.NotifyShellEvent;
  import com.kaltura.contributionWizard.events.PartnerNotificationsEvent;
  import com.kaltura.contributionWizard.events.PendingActionEvent;
  import com.kaltura.contributionWizard.events.ReportErrorEvent;
  import com.kaltura.contributionWizard.events.SaveInjectedDataEvent;
  import com.kaltura.contributionWizard.events.SetDefaultScreenEvent;
  import com.kaltura.contributionWizard.events.TaggingEvent;
  import com.kaltura.contributionWizard.events.ValidateAllMetaDataEvent;
  import com.kaltura.contributionWizard.events.ValidateLimitationsEvent;
  import com.kaltura.contributionWizard.events.ValidateMetaDataEvent;
  import com.kaltura.contributionWizard.events.WizardConfigEvent;
  import com.kaltura.contributionWizard.events.WorkflowEvent;

  public class WizardController extends FrontController
  {
    public function WizardController():void
    {
      initializeCommands();
    }

    public function initializeCommands() : void
    {   
      addCommand( SaveInjectedDataEvent.SAVE_INJECTED_DATA, 			SaveInjectedDataCommand );
      addCommand( WizardConfigEvent.GET_WIZARD_CONFIG, 					GetWizardConfigCommand );
      addCommand( MediaTypeSelectionEvent.MEDIA_TYPE_SELECT, 			SelectMediaTypeCommand)
      addCommand( MediaProviderEvent.MEDIA_PROVIDER_CHANGE,	 			ChangeMediaProviderCommand );
      addCommand( WorkflowEvent.CHANGE_WORKFLOW, 						ChangeWorkflowCommand );
      addCommand( ImportEvent.ADD_IMPORT_ITEM, 							AddToImportCartCommand );
      addCommand( ImportEvent.REMOVE_IMPORT_ITEM, 						RemoveFromImportCartCommand );
      addCommand( TaggingEvent.SET_MEDIA_META_DATA,	 					SetMetaDataCommand );
      addCommand( ValidateMetaDataEvent.VALIDATE_TAGS,	 				ValidateMetaDataFieldCommand);
      addCommand( ValidateMetaDataEvent.VALIDATE_TITLE,	 				ValidateMetaDataFieldCommand);
      addCommand( ValidateAllMetaDataEvent.VALIDATE_ALL_META_DATA,	 	ValidateAllMetaDataCommand);

      addCommand( BatchMetaDataEvent.ADD_BATCH_TAG,						AddBatchTagsCommand);
      addCommand( AddEntriesEvent.ADD_ENTRIES, 							AddEntriesCommand );
      addCommand( EntriesAddedEvent.NOTIFY_ADD_ENTRIES_COMPLETE,		NotifyAddEntriesCompleteCommand);

      addCommand( ExternalInterfaceEvent.CALL_EXTERNAL_INTERFACE,		CallExternalInterfaceCommand );
      addCommand( ClearImportStateEvent.CLEAR_IMPORT_STATE, 			ClearImportStateCommand );

      addCommand( PendingActionEvent.CANCEL_PENDING_ACTION,				CancelPendingRequestCommand );
      addCommand( NotifyShellEvent.ADD_ENTRY_NOTIFICATION,				NotifyShellCommand);
      addCommand( NotifyShellEvent.CLOSE_WIZARD_NOTIFICATION,			NotifyShellCommand);
      addCommand( NotifyShellEvent.WIZARD_READY_NOTIFICATION,			NotifyShellCommand);
      addCommand( NotifyShellEvent.PENDING,								NotifyShellCommand);

      addCommand( CreditsEvent.ADD_CREDITS,								AddCreditsCommand);

      addCommand( SetDefaultScreenEvent.SET_DEFAULT_SCREEN,				SetDefaultScreenCommand);
      addCommand( GotoScreenEvent.GOTO_SCREEN, 							GotoScreenCommand);
      addCommand( LoadUIEvent.LOAD_STYLE,								LoadStylesCommand);
      addCommand( LoadUIEvent.LOAD_LOCALE,								LoadLocaleCommand);
      addCommand( CloseWizardEvent.CLOSE_WIZARD,						CloseWizardCommand);
      addCommand( ChangePermissionLevelEvent.CHANGE_PERMISSION_LEVEL, 	ChangePermissionLevelCommand);

      addCommand(PartnerNotificationsEvent.CHECK_NOTIFICATIONS,			CheckPartnerNotificationCommand);
      addCommand(PartnerNotificationsEvent.SEND_NOTIFICATIONS,			SendPartnerNotificationsCommand);

	  // Categories Event
	  trace(1);
	  addCommand(CategoryEvent.LIST_CATEGORIES, 						ListCategoriesCommand );
      addCommand(GotoNextImportStepEvent.GOTO_NEXT_IMPORT_STEP,			GotoNextImportStepCommand);
      addCommand(ValidateLimitationsEvent.VALIDATE,						ValidateLimitationsCommand);
      
      //listen to Error Report Events
      addCommand(ReportErrorEvent.CANCEL_UPLOAD,						ReportErrorCommand);
      addCommand(ReportErrorEvent.VIEW_STATE_CHANGE,					ReportErrorCommand);
      addCommand(ReportErrorEvent.UPLOAD_SKIP,							ReportErrorCommand);
      addCommand(ReportErrorEvent.BEFORE_UPLOAD_FILE,					ReportErrorCommand);
      addCommand(ReportErrorEvent.AFTER_UPLOAD_FILE,					ReportErrorCommand);
      addCommand(ReportErrorEvent.UPLOAD_FAILED,						ReportErrorCommand);
      addCommand(ReportErrorEvent.UPLOAD_PROGRESS,						ReportErrorCommand);

    }
  }
}