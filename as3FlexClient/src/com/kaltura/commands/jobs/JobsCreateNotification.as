package com.kaltura.commands.jobs
{
	import com.kaltura.vo.KalturaNotification;
	import com.kaltura.delegates.jobs.JobsCreateNotificationDelegate;
	import com.kaltura.net.KalturaCall;

	public class JobsCreateNotification extends KalturaCall
	{
		public var filterFields : String;
		public function JobsCreateNotification( notificationJob : KalturaNotification )
		{
			service= 'jobs';
			action= 'createNotification';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
 			keyValArr = kalturaObject2Arrays(notificationJob,'notificationJob');
			keyArr = keyArr.concat( keyValArr[0] );
			valueArr = valueArr.concat( keyValArr[1] );
			applySchema( keyArr , valueArr );
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields',filterFields);
			delegate = new JobsCreateNotificationDelegate( this , config );
		}
	}
}
