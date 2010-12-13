package com.kaltura.commands.jobs
{
	import com.kaltura.vo.KalturaBatchJob;
	import com.kaltura.vo.KalturaExtractMediaJobData;
	import com.kaltura.delegates.jobs.JobsAddExtractMediaJobDelegate;
	import com.kaltura.net.KalturaCall;

	public class JobsAddExtractMediaJob extends KalturaCall
	{
		public var filterFields : String;
		public function JobsAddExtractMediaJob( job : KalturaBatchJob,extractMediaType : int,data : KalturaExtractMediaJobData )
		{
			service= 'jobs';
			action= 'addExtractMediaJob';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
 			keyValArr = kalturaObject2Arrays(job,'job');
			keyArr = keyArr.concat( keyValArr[0] );
			valueArr = valueArr.concat( keyValArr[1] );
			keyArr.push( 'extractMediaType' );
			valueArr.push( extractMediaType );
 			keyValArr = kalturaObject2Arrays(data,'data');
			keyArr = keyArr.concat( keyValArr[0] );
			valueArr = valueArr.concat( keyValArr[1] );
			applySchema( keyArr , valueArr );
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields',filterFields);
			delegate = new JobsAddExtractMediaJobDelegate( this , config );
		}
	}
}
