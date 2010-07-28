package com.kaltura.contributionWizard.events
{
	import com.bjorn.event.ChainEvent;
	import com.kaltura.contributionWizard.business.AddEntriesResult;

	import flash.events.Event;

	public class PartnerNotificationsEvent extends ChainEvent
	{
		public static const CHECK_NOTIFICATIONS:String 	= "checkNotifications";
		public static const SEND_NOTIFICATIONS:String 	= "sendNotifications";

		public var addEntriesResult:AddEntriesResult;

		public function PartnerNotificationsEvent(type:String, addEntriesResult:AddEntriesResult)
		{
			super(type);
			this.addEntriesResult = addEntriesResult;
		}

		override public function clone():Event
		{
			return new PartnerNotificationsEvent(type, addEntriesResult);
		}

	}
}