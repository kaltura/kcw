package com.kaltura.vo
{
	import com.kaltura.vo.BaseFlexVo;
	public dynamic class KalturaSchedulerConfig extends BaseFlexVo
	{
		public var id : int = int.MIN_VALUE;
		public var createdAt : int = int.MIN_VALUE;
		public var createdBy : String;
		public var updatedAt : int = int.MIN_VALUE;
		public var updatedBy : String;
		public var commandId : String;
		public var commandStatus : String;
		public var schedulerId : int = int.MIN_VALUE;
		public var schedulerConfiguredId : int = int.MIN_VALUE;
		public var schedulerName : String;
		public var workerId : int = int.MIN_VALUE;
		public var workerConfiguredId : int = int.MIN_VALUE;
		public var workerName : String;
		public var variable : String;
		public var variablePart : String;
		public var value : String;
		override protected function setupPropertyList():void
		{
			super.setupPropertyList();
			propertyList.push('id');
			propertyList.push('createdAt');
			propertyList.push('createdBy');
			propertyList.push('updatedAt');
			propertyList.push('updatedBy');
			propertyList.push('commandId');
			propertyList.push('commandStatus');
			propertyList.push('schedulerId');
			propertyList.push('schedulerConfiguredId');
			propertyList.push('schedulerName');
			propertyList.push('workerId');
			propertyList.push('workerConfiguredId');
			propertyList.push('workerName');
			propertyList.push('variable');
			propertyList.push('variablePart');
			propertyList.push('value');
		}
		public function getParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			arr.push('id');
			arr.push('createdAt');
			arr.push('createdBy');
			arr.push('updatedAt');
			arr.push('updatedBy');
			arr.push('commandId');
			arr.push('commandStatus');
			arr.push('schedulerId');
			arr.push('schedulerConfiguredId');
			arr.push('schedulerName');
			arr.push('workerId');
			arr.push('workerConfiguredId');
			arr.push('workerName');
			arr.push('variable');
			arr.push('variablePart');
			arr.push('value');
			return arr;
		}

		public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			arr.push('createdBy');
			arr.push('updatedBy');
			arr.push('commandId');
			arr.push('commandStatus');
			arr.push('schedulerId');
			arr.push('schedulerConfiguredId');
			arr.push('schedulerName');
			arr.push('workerId');
			arr.push('workerConfiguredId');
			arr.push('workerName');
			arr.push('variable');
			arr.push('variablePart');
			arr.push('value');
			return arr;
		}

	}
}
