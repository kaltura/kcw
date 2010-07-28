package com.kaltura.commands.jobs
{
	import com.kaltura.vo.KalturaBatchJob;
	import com.kaltura.vo.KalturaPullJobData;
	import com.kaltura.delegates.jobs.JobsAddPullJobDelegate;
	import com.kaltura.net.KalturaCall;

	public class JobsAddPullJob extends KalturaCall
	{
		public var filterFields : String;
		public function JobsAddPullJob( job : KalturaBatchJob,data : KalturaPullJobData )
		{
			service= 'jobs';
			action= 'addPullJob';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
 			keyValArr = kalturaObject2Arrays(job,'job');
			keyArr = keyArr.concat( keyValArr[0] );
			valueArr = valueArr.concat( keyValArr[1] );
 			keyValArr = kalturaObject2Arrays(data,'data');
			keyArr = keyArr.concat( keyValArr[0] );
			valueArr = valueArr.concat( keyValArr[1] );
			applySchema( keyArr , valueArr );
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields',filterFields);
			delegate = new JobsAddPullJobDelegate( this , config );
		}
	}
}
