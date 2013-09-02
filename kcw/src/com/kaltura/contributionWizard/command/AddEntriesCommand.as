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
	import com.kaltura.contributionWizard.business.AddEntriesDelegate;
	import com.kaltura.contributionWizard.business.AddEntriesResult;
	import com.kaltura.contributionWizard.events.CloseWizardEvent;
	import com.kaltura.contributionWizard.events.EntriesAddedEvent;
	import com.kaltura.contributionWizard.events.PartnerNotificationsEvent;
	import com.kaltura.contributionWizard.model.PendingActions;
	import com.kaltura.contributionWizard.model.WizardModelLocator;
	import com.kaltura.contributionWizard.view.resources.ResourceBundleNames;
	import com.kaltura.vo.importees.ImportURLVO;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.resources.ResourceManager;
	import mx.rpc.IResponder;

	public class AddEntriesCommand extends SequenceCommand implements IResponder
	{
		private var _model:WizardModelLocator = WizardModelLocator.getInstance();

		override public function execute(event:CairngormEvent):void
		{
			var addSearch:Boolean = _model.mediaProviders.activeMediaProvider.addSearchResult;
	     	var importList:ArrayCollection;
	     	
	     	nextEvent = (event as ChainEvent).nextChainedEvent;

	     	if(addSearch)
	     	{
		     	var searchEntries:Array = new Array();
		     	importList = _model.importData.importCart.importItemsArray;
		     	for each(var item:ImportURLVO in importList)
		     	{
		     		searchEntries.push
		     						(
		     							{
		     								uniqueID: 	item.uniqueID ? item.uniqueID.toString() : "",
		     								sourceLink: item.sourceLink ? item.sourceLink.toString() : "",
											thumbURL: 	item.thumbURL ? item.thumbURL.toString() : "",
											mediaType: 	item.mediaTypeCode ? item.mediaTypeCode.toString() : ""
		     							}
		     						)
		     	}
		     	notifyAddEntriesComplete(searchEntries);
		     	executeNextCommand();
	     	}
	     	else
	     	{
				_model.pendingActions.setPendingAction(PendingActions.ADDING_ENTRIES);
				var delegate:AddEntriesDelegate = new AddEntriesDelegate(this);
				importList = _model.importData.importCart.importItemsArray;
	
				_model.pendingActions.setPendingAction(PendingActions.ADDING_ENTRIES, null);
				delegate.addEntries(importList, _model.context, _model.importData.creditsVo);
	     	}
		}

		public function result(data:Object):void
		{
			var addEntriesResult:AddEntriesResult = data as AddEntriesResult;

			setNewKshowId(addEntriesResult.entriesInfoList[0].kshowId);

			if (addEntriesResult.notificationsIds)
			{
				var checkNotificationsEvent:PartnerNotificationsEvent = new PartnerNotificationsEvent(PartnerNotificationsEvent.CHECK_NOTIFICATIONS, addEntriesResult);
				checkNotificationsEvent.dispatch();
			}
			else if (addEntriesResult.notificationsList)
			{
				var sendNotificationsEvent:PartnerNotificationsEvent = new PartnerNotificationsEvent(PartnerNotificationsEvent.SEND_NOTIFICATIONS, addEntriesResult);
				sendNotificationsEvent.dispatch();
			}
			else
			{
				notifyAddEntriesComplete(addEntriesResult.entriesInfoList);
			}
			
			_model.wereEntriesAdded = true;
			_model.wereEntriesAdded = false;
			executeNextCommand();
		}

		public function fault(info:Object):void
		{
			//TODO: move it to the view (localized string already exist)
			trace("Add entry call failed");
			var msg:String = ResourceManager.getInstance().getString(ResourceBundleNames.ERRORS, "ADD_ENTRIES_FAILED");
			Alert.show(msg ? msg : "Add entry failed");
			
			var close:CloseWizardEvent = new CloseWizardEvent(CloseWizardEvent.CLOSE_WIZARD);
			close.dispatch();

		}

		private function setNewKshowId(newKshowId:String):void
		{
			_model.context.kshowId = newKshowId;
		}

		private function notifyAddEntriesComplete(entriesInfoList:Array):void
		{
			var addEntriesCompleteEvent:EntriesAddedEvent = new EntriesAddedEvent(EntriesAddedEvent.NOTIFY_ADD_ENTRIES_COMPLETE, entriesInfoList);
			addEntriesCompleteEvent.dispatch();
		}
	}
}