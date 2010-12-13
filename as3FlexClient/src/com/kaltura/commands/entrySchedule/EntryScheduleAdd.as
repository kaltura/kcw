package com.kaltura.commands.entrySchedule
{
	import com.kaltura.vo.KalturaEntrySchedule;
	import com.kaltura.delegates.entrySchedule.EntryScheduleAddDelegate;
	import com.kaltura.net.KalturaCall;

	public class EntryScheduleAdd extends KalturaCall
	{
		public var filterFields : String;
		public function EntryScheduleAdd( entrySchedule : KalturaEntrySchedule )
		{
			service= 'entrySchedule';
			action= 'add';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
 			keyValArr = kalturaObject2Arrays(entrySchedule,'entrySchedule');
			keyArr = keyArr.concat( keyValArr[0] );
			valueArr = valueArr.concat( keyValArr[1] );
			applySchema( keyArr , valueArr );
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields',filterFields);
			delegate = new EntryScheduleAddDelegate( this , config );
		}
	}
}
