package com.kaltura.commands.jobs
{
	import com.kaltura.vo.KalturaBatchJob;
	import com.kaltura.vo.KalturaImportJobData;
	import com.kaltura.delegates.jobs.JobsAddImportJobDelegate;
	import com.kaltura.net.KalturaCall;

	public class JobsAddImportJob extends KalturaCall
	{
		public var filterFields : String;
		public function JobsAddImportJob( job : KalturaBatchJob,data : KalturaImportJobData )
		{
			service= 'jobs';
			action= 'addImportJob';

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
			delegate = new JobsAddImportJobDelegate( this , config );
		}
	}
}
