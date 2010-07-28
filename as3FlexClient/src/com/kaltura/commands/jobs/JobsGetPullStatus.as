package com.kaltura.commands.jobs
{
	import com.kaltura.delegates.jobs.JobsGetPullStatusDelegate;
	import com.kaltura.net.KalturaCall;

	public class JobsGetPullStatus extends KalturaCall
	{
		public var filterFields : String;
		public function JobsGetPullStatus( job_id : int )
		{
			service= 'jobs';
			action= 'getPullStatus';

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
			delegate = new JobsGetPullStatusDelegate( this , config );
		}
	}
}
