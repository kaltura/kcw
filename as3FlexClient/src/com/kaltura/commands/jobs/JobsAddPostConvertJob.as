package com.kaltura.commands.jobs
{
	import com.kaltura.vo.KalturaBatchJob;
	import com.kaltura.vo.KalturaPostConvertJobData;
	import com.kaltura.delegates.jobs.JobsAddPostConvertJobDelegate;
	import com.kaltura.net.KalturaCall;

	public class JobsAddPostConvertJob extends KalturaCall
	{
		public var filterFields : String;
		public function JobsAddPostConvertJob( job : KalturaBatchJob,data : KalturaPostConvertJobData )
		{
			service= 'jobs';
			action= 'addPostConvertJob';

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
			delegate = new JobsAddPostConvertJobDelegate( this , config );
		}
	}
}
