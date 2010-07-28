package com.kaltura.commands.jobs
{
	import com.kaltura.delegates.jobs.JobsGetBulkUploadStatusDelegate;
	import com.kaltura.net.KalturaCall;

	public class JobsGetBulkUploadStatus extends KalturaCall
	{
		public var filterFields : String;
		public function JobsGetBulkUploadStatus( job_id : int )
		{
			service= 'jobs';
			action= 'getBulkUploadStatus';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push( 'job_id' );
			valueArr.push( job_id );
			applySchema( keyArr , valueArr );
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields',filterFields);
			delegate = new JobsGetBulkUploadStatusDelegate( this , config );
		}
	}
}
