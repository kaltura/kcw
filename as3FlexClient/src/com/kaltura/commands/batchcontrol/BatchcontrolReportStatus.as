package com.kaltura.commands.batchcontrol
{
	import com.kaltura.delegates.batchcontrol.BatchcontrolReportStatusDelegate;
	import com.kaltura.net.KalturaCall;

	public class BatchcontrolReportStatus extends KalturaCall
	{
		public var filterFields : String;
		public function BatchcontrolReportStatus( schedulerConfigId : int,schedulerName : String,schedulerStatuses : Array )
		{
			service= 'batchcontrol';
			action= 'reportStatus';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push( 'schedulerConfigId' );
			valueArr.push( schedulerConfigId );
			keyArr.push( 'schedulerName' );
			valueArr.push( schedulerName );
 			keyValArr = extractArray(schedulerStatuses,'schedulerStatuses');
			keyArr = keyArr.concat( keyValArr[0] );
			valueArr = valueArr.concat( keyValArr[1] );
			applySchema( keyArr , valueArr );
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields',filterFields);
			delegate = new BatchcontrolReportStatusDelegate( this , config );
		}
	}
}
