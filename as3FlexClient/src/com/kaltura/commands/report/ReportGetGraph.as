package com.kaltura.commands.report
{
	import com.kaltura.delegates.report.ReportGetGraphDelegate;
	import com.kaltura.net.KalturaCall;

	public class ReportGetGraph extends KalturaCall
	{
		public var filterFields : String;
		public function ReportGetGraph(  )
		{
			service= 'report';
			action= 'getGraph';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			applySchema( keyArr , valueArr );
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields',filterFields);
			delegate = new ReportGetGraphDelegate( this , config );
		}
	}
}
