package com.kaltura.commands.jobs
{
	import com.kaltura.delegates.jobs.JobsGetExtractMediaStatusDelegate;
	import com.kaltura.net.KalturaCall;

	public class JobsGetExtractMediaStatus extends KalturaCall
	{
		public var filterFields : String;
		public function JobsGetExtractMediaStatus( job_id : int )
		{
			service= 'jobs';
			action= 'getExtractMediaStatus';

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
			delegate = new JobsGetExtractMediaStatusDelegate( this , config );
		}
	}
}
