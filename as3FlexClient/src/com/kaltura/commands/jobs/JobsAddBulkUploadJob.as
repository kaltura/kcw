package com.kaltura.commands.jobs
{
	import com.kaltura.vo.KalturaBatchJob;
	import com.kaltura.vo.KalturaBulkUploadJobData;
	import com.kaltura.vo.File;
	import com.kaltura.delegates.jobs.JobsAddBulkUploadJobDelegate;
	import com.kaltura.net.KalturaCall;

	public class JobsAddBulkUploadJob extends KalturaCall
	{
		public var filterFields : String;
		public function JobsAddBulkUploadJob( job : KalturaBatchJob,data : KalturaBulkUploadJobData,csvFileData : file )
		{
			service= 'jobs';
			action= 'addBulkUploadJob';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
 			keyValArr = kalturaObject2Arrays(job,'job');
			keyArr = keyArr.concat( keyValArr[0] );
			valueArr = valueArr.concat( keyValArr[1] );
 			keyValArr = kalturaObject2Arrays(data,'data');
			keyArr = keyArr.concat( keyValArr[0] );
			valueArr = valueArr.concat( keyValArr[1] );
 			keyValArr = kalturaObject2Arrays(csvFileData,'csvFileData');
			keyArr = keyArr.concat( keyValArr[0] );
			valueArr = valueArr.concat( keyValArr[1] );
			applySchema( keyArr , valueArr );
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields',filterFields);
			delegate = new JobsAddBulkUploadJobDelegate( this , config );
		}
	}
}
