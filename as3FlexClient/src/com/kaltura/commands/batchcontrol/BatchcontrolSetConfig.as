package com.kaltura.commands.batchcontrol
{
	import com.kaltura.delegates.batchcontrol.BatchcontrolSetConfigDelegate;
	import com.kaltura.net.KalturaCall;

	public class BatchcontrolSetConfig extends KalturaCall
	{
		public var filterFields : String;
		public function BatchcontrolSetConfig( schedulerId : int,schedulerName : String,adminId : int,adminName : String,configParam : String,configValue : String,configParamPart : String='',workerId : int=undefined,workerName : String='' )
		{
			service= 'batchcontrol';
			action= 'setConfig';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push( 'schedulerId' );
			valueArr.push( schedulerId );
			keyArr.push( 'schedulerName' );
			valueArr.push( schedulerName );
			keyArr.push( 'adminId' );
			valueArr.push( adminId );
			keyArr.push( 'adminName' );
			valueArr.push( adminName );
			keyArr.push( 'configParam' );
			valueArr.push( configParam );
			keyArr.push( 'configValue' );
			valueArr.push( configValue );
			keyArr.push( 'configParamPart' );
			valueArr.push( configParamPart );
			keyArr.push( 'workerId' );
			valueArr.push( workerId );
			keyArr.push( 'workerName' );
			valueArr.push( workerName );
			applySchema( keyArr , valueArr );
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields',filterFields);
			delegate = new BatchcontrolSetConfigDelegate( this , config );
		}
	}
}
