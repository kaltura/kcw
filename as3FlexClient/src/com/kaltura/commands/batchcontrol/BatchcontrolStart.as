package com.kaltura.commands.batchcontrol
{
	import com.kaltura.delegates.batchcontrol.BatchcontrolStartDelegate;
	import com.kaltura.net.KalturaCall;

	public class BatchcontrolStart extends KalturaCall
	{
		public var filterFields : String;
		public function BatchcontrolStart( schedulerId : int,schedulerName : String,targetType : int,adminId : int,adminName : String,workerId : int,workerName : String,cause : String='' )
		{
			service= 'batchcontrol';
			action= 'start';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push( 'schedulerId' );
			valueArr.push( schedulerId );
			keyArr.push( 'schedulerName' );
			valueArr.push( schedulerName );
			keyArr.push( 'targetType' );
			valueArr.push( targetType );
			keyArr.push( 'adminId' );
			valueArr.push( adminId );
			keyArr.push( 'adminName' );
			valueArr.push( adminName );
			keyArr.push( 'workerId' );
			valueArr.push( workerId );
			keyArr.push( 'workerName' );
			valueArr.push( workerName );
			keyArr.push( 'cause' );
			valueArr.push( cause );
			applySchema( keyArr , valueArr );
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields',filterFields);
			delegate = new BatchcontrolStartDelegate( this , config );
		}
	}
}
