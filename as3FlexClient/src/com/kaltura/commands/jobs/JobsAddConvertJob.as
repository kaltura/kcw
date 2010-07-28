package com.kaltura.commands.jobs
{
	import com.kaltura.vo.KalturaBatchJob;
	import com.kaltura.vo.KalturaConvertProfileJobData;
	import com.kaltura.delegates.jobs.JobsAddConvertJobDelegate;
	import com.kaltura.net.KalturaCall;

	public class JobsAddConvertJob extends KalturaCall
	{
		public var filterFields : String;
		public function JobsAddConvertJob( job : KalturaBatchJob,data : KalturaConvertProfileJobData )
		{
			service= 'jobs';
			action= 'addConvertJob';

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
			delegate = new JobsAddConvertJobDelegate( this , config );
		}
	}
}
