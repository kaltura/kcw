package com.kaltura.contributionWizard.command
{
	import com.adobe_cw.adobe.cairngorm.commands.SequenceCommand;
	import com.adobe_cw.adobe.cairngorm.control.CairngormEvent;
	import com.kaltura.contributionWizard.business.AddEntriesResult;
	import com.kaltura.contributionWizard.business.CheckNotificationsDelegate;
	import com.kaltura.contributionWizard.events.PartnerNotificationsEvent;
	import com.kaltura.contributionWizard.events.EntriesAddedEvent;
	import com.kaltura.contributionWizard.model.WizardModelLocator;

	import flash.events.TimerEvent;
	import flash.utils.Timer;

	import mx.controls.Alert;
	import mx.rpc.IResponder;

	public class CheckPartnerNotificationCommand extends SequenceCommand implements IResponder
	{
		private var _pollsRetriesCount:int 			= 0;
		private static var _pollsTotalRetries:int 	= 5;
		private static var _pollDelay:int 			= 6e3;

		private var _pendingRequest:Boolean = false;

		private var _notifications:String;
		private var _entriesInfoList:Array;

		private var _pollTimer:Timer;

		private var _model:WizardModelLocator = WizardModelLocator.getInstance();

		override public function execute(event:CairngormEvent):void
		{
			var checkNotificationEvent:PartnerNotificationsEvent = event as PartnerNotificationsEvent;
			var addEntriesResult:AddEntriesResult = checkNotificationEvent.addEntriesResult;
			_notifications	= addEntriesResult.notificationsIds;
			_entriesInfoList	= addEntriesResult.entriesInfoList

			setupTimer();
			_pollTimer.start();
			//make a first call immediately, so the user won't have to wait the minimum time of timer delay
			pollNotificationsFromService();

		}

		public function result(data:Object):void
		{
			_pendingRequest = false;
			var done:Boolean = Boolean(data);
			if (done)
			{
				notificationsComplete();
			}
			else if (_pollsRetriesCount == _pollsTotalRetries)
			{
				fault(null);
			}
 		}

		private function notificationsComplete():void
		{
			_model.importData.importCart.clearCart();
			notifyShell();
			if (_pollTimer) _pollTimer.stop();
		}
		public function fault(info:Object):void
		{
			_pollTimer.stop();
			_model.pendingActions.isPending = false;
			//FIXME: move it to the view (localized string already exist)
			Alert.show("Add entries call failed.");
		}

		private function setupTimer():void
		{
			_pollTimer = new Timer(_pollDelay);
			_pollTimer.addEventListener(TimerEvent.TIMER, 			pollTimerHandler);
			//_pollTimer.addEventListener(TimerEvent.TIMER_COMPLETE, 	pollTimerCompleteHandler);//, 	false, 0, true);

		}
		private function notifyShell():void
		{
			var entriesAddedEvent:EntriesAddedEvent = new EntriesAddedEvent(EntriesAddedEvent.NOTIFY_ADD_ENTRIES_COMPLETE, _entriesInfoList);
			entriesAddedEvent.dispatch();
		}
		private function pollTimerHandler(timerEvent:TimerEvent):void
		{
			if (!_pendingRequest)
			{
				pollNotificationsFromService();
			}
		}

		private function pollNotificationsFromService():void
		{
			var delegate:CheckNotificationsDelegate = new CheckNotificationsDelegate(this);
			_pollsRetriesCount++
			delegate.checkNotifications(_notifications, _pollsRetriesCount);
			_pendingRequest = true;
		}
	}
}