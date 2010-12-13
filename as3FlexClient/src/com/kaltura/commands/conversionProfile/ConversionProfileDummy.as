package com.kaltura.commands.conversionProfile
{
	import com.kaltura.vo.KalturaFlavorAsset;
	import com.kaltura.vo.KalturaFlavorParams;
	import com.kaltura.delegates.conversionProfile.ConversionProfileDummyDelegate;
	import com.kaltura.net.KalturaCall;

	public class ConversionProfileDummy extends KalturaCall
	{
		public var filterFields : String;
		public function ConversionProfileDummy( a : KalturaFlavorAsset,b : KalturaFlavorParams )
		{
			service= 'conversionProfile';
			action= 'dummy';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
 			keyValArr = kalturaObject2Arrays(a,'a');
			keyArr = keyArr.concat( keyValArr[0] );
			valueArr = valueArr.concat( keyValArr[1] );
 			keyValArr = kalturaObject2Arrays(b,'b');
			keyArr = keyArr.concat( keyValArr[0] );
			valueArr = valueArr.concat( keyValArr[1] );
			applySchema( keyArr , valueArr );
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields',filterFields);
			delegate = new ConversionProfileDummyDelegate( this , config );
		}
	}
}
