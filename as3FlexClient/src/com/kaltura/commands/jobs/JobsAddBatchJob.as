package com.kaltura.commands.jobs
{
	import com.kaltura.vo.KalturaBatchJob;
	import com.kaltura.delegates.jobs.JobsAddBatchJobDelegate;
	import com.kaltura.net.KalturaCall;

	public class JobsAddBatchJob extends KalturaCall
	{
		public var filterFields : String;
		public function JobsAddBatchJob( batchJob : KalturaBatchJob )
		{
			service= 'jobs';
			action= 'addBatchJob';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
 			keyValArr = kalturaObject2Arrays(batchJob,'batchJob');
			keyArr = keyArr.concat( keyValArr[0] );
			valueArr = valueArr.concat( keyValArr[1] );
			applySchema( keyArr , valueArr );
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields',filterFields);
			delegate = new JobsAddBatchJobDelegate( this , config );
		}
	}
}
