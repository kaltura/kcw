package com.kaltura.vo
{
	import com.kaltura.vo.KalturaFilter;

	[Bindable]
	public dynamic class KalturaFlavorAssetFilter extends KalturaFilter
	{
		public var idEqual : String;
		public var idIn : String;
		public var entryIdEqual : String;
		public var entryIdIn : String;
		public var statusEqual : int = int.MIN_VALUE;
		public var statusNotEqual : int = int.MIN_VALUE;
		public var statusIn : String;
		public var statusNotIn : int = int.MIN_VALUE;
		override protected function setupPropertyList():void
		{
			super.setupPropertyList();
			propertyList.push('idEqual');
			propertyList.push('idIn');
			propertyList.push('entryIdEqual');
			propertyList.push('entryIdIn');
			propertyList.push('statusEqual');
			propertyList.push('statusNotEqual');
			propertyList.push('statusIn');
			propertyList.push('statusNotIn');
		}
		override public function getParamKeys():Array
		{
			var arr : Array;
			arr = super.getParamKeys();
			arr.push('idEqual');
			arr.push('idIn');
			arr.push('entryIdEqual');
			arr.push('entryIdIn');
			arr.push('statusEqual');
			arr.push('statusNotEqual');
			arr.push('statusIn');
			arr.push('statusNotIn');
			return arr;
		}

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('idEqual');
			arr.push('idIn');
			arr.push('entryIdEqual');
			arr.push('entryIdIn');
			arr.push('statusEqual');
			arr.push('statusNotEqual');
			arr.push('statusIn');
			arr.push('statusNotIn');
			return arr;
		}

	}
}
