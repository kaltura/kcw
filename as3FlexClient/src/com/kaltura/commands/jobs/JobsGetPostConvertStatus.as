package com.kaltura.commands.jobs
{
	import com.kaltura.delegates.jobs.JobsGetPostConvertStatusDelegate;
	import com.kaltura.net.KalturaCall;

	public class JobsGetPostConvertStatus extends KalturaCall
	{
		public var filterFields : String;
		public function JobsGetPostConvertStatus( job_id : int )
		{
			service= 'jobs';
			action= 'getPostConvertStatus';

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
			delegate = new JobsGetPostConvertStatusDelegate( this , config );
		}
	}
}
