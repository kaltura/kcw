package com.kaltura.contributionWizard.business
{
	public class AddEntriesResult
	{
		public var entriesInfoList:Array;
		public var notificationsList:Array
		public var notificationsIds:String;
	
		public function AddEntriesResult(entriesInfoList:Array, notificationsIds:String, notificationsList:Array):void
		{
			this.entriesInfoList = entriesInfoList;
			this.notificationsIds = notificationsIds;
			this.notificationsList = notificationsList;
		}
	}
}