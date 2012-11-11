package com.kaltura.contributionWizard.command
{
	import com.adobe_cw.adobe.cairngorm.control.CairngormEvent;
	import com.arc90.modular.ModuleSequenceCommand;
	import com.kaltura.contributionWizard.business.AddEntriesResult;
	import com.kaltura.contributionWizard.events.EntriesAddedEvent;
	import com.kaltura.contributionWizard.events.PartnerNotificationsEvent;
	import com.kaltura.contributionWizard.model.WizardModelLocator;
	import com.kaltura.contributionWizard.vo.PartnerNotificationVO;
	
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;

	public class SendPartnerNotificationsCommand extends ModuleSequenceCommand
	{
		private static const TIMEOUT:int = 30e3;

		private var _model:WizardModelLocator;

		private var _requestsLeft:int;

		private var _addEntryResult:AddEntriesResult;

		private var _timeoutId:uint;

		override public function execute(event:CairngormEvent):void
		{
			_addEntryResult = PartnerNotificationsEvent(event).addEntriesResult;

			var notificationsList:Array = _addEntryResult.notificationsList;
			_requestsLeft = notificationsList.length;
			notificationsList.forEach(sendNotification);
			_timeoutId = setTimeout(sendNotificationsComplete, TIMEOUT);
		}

		private function sendNotification(partnerNotificationVo:PartnerNotificationVO, index:int, list:Array):void
		{
			var urlLoader:URLLoader = new URLLoader();
			var requestData:URLVariables = new URLVariables(partnerNotificationVo.queryString);
			var request:URLRequest = new URLRequest(partnerNotificationVo.url);
			request.data = requestData;
			request.method = URLRequestMethod.POST;
			urlLoader.addEventListener(Event.COMPLETE, 			loaderCompleteHandler);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR,	ioErrorHandler);
			urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,	ioErrorHandler);
			urlLoader.load(request);
		}

		private function loaderCompleteHandler(completeEvent:Event):void
		{
			notificationSent();
		}


		private function ioErrorHandler(errorEvent:Event):void
		{
			var s:String = "send notifications failed: " + errorEvent.type;
			if (errorEvent is ErrorEvent) {
				s += " : " + (errorEvent as ErrorEvent).text; 
			}
			trace(s);
			notificationSent();	
		}

		private function dispose():void
		{
			clearTimeout(_timeoutId);
		}

		private function notificationSent():void
		{
			if (--_requestsLeft == 0)
			{
				sendNotificationsComplete();
				clearTimeout(_timeoutId);
			}
		}

		private function sendNotificationsComplete():void
		{
			var addEntriesCompleteEvent:EntriesAddedEvent = new EntriesAddedEvent(EntriesAddedEvent.NOTIFY_ADD_ENTRIES_COMPLETE, _addEntryResult.entriesInfoList);
			addEntriesCompleteEvent.dispatch();
			dispose();
		}
	}
}