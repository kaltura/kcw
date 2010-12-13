package com.kaltura.commands.baseEntry
{
	import com.kaltura.vo.KalturaEntryExtraDataParams;
	import com.kaltura.delegates.baseEntry.BaseEntryGetExtraDataDelegate;
	import com.kaltura.net.KalturaCall;

	public class BaseEntryGetExtraData extends KalturaCall
	{
		public var filterFields : String;
		public function BaseEntryGetExtraData( entryId : String,extraDataParams : KalturaEntryExtraDataParams )
		{
			service= 'baseEntry';
			action= 'getExtraData';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push( 'entryId' );
			valueArr.push( entryId );
 			keyValArr = kalturaObject2Arrays(extraDataParams,'extraDataParams');
			keyArr = keyArr.concat( keyValArr[0] );
			valueArr = valueArr.concat( keyValArr[1] );
			applySchema( keyArr , valueArr );
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields',filterFields);
			delegate = new BaseEntryGetExtraDataDelegate( this , config );
		}
	}
}
