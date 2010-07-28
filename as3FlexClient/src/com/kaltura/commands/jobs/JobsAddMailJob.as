package com.kaltura.commands.jobs
{
	import com.kaltura.vo.KalturaMailJob;
	import com.kaltura.delegates.jobs.JobsAddMailJobDelegate;
	import com.kaltura.net.KalturaCall;

	public class JobsAddMailJob extends KalturaCall
	{
		public var filterFields : String;
		public function JobsAddMailJob( mailJob : KalturaMailJob )
		{
			service= 'jobs';
			action= 'addMailJob';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
 			keyValArr = kalturaObject2Arrays(mailJob,'mailJob');
			keyArr = keyArr.concat( keyValArr[0] );
			valueArr = valueArr.concat( keyValArr[1] );
			applySchema( keyArr , valueArr );
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields',filterFields);
			delegate = new JobsAddMailJobDelegate( this , config );
		}
	}
}
