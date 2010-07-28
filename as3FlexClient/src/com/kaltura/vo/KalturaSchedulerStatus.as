package com.kaltura.vo
{
	import com.kaltura.vo.BaseFlexVo;
	public dynamic class KalturaSchedulerStatus extends BaseFlexVo
	{
		public var id : int = int.MIN_VALUE;
		public var createdAt : int = int.MIN_VALUE;
		public var createdBy : String;
		public var updatedAt : int = int.MIN_VALUE;
		public var updatedBy : String;
		public var schedulerId : int = int.MIN_VALUE;
		public var schedulerConfiguredId : int = int.MIN_VALUE;
		public var workerId : int = int.MIN_VALUE;
		public var workerConfiguredId : int = int.MIN_VALUE;
		public var workerType : int = int.MIN_VALUE;
		public var type : int = int.MIN_VALUE;
		public var value : int = int.MIN_VALUE;
		override protected function setupPropertyList():void
		{
			super.setupPropertyList();
			propertyList.push('id');
			propertyList.push('createdAt');
			propertyList.push('createdBy');
			propertyList.push('updatedAt');
			propertyList.push('updatedBy');
			propertyList.push('schedulerId');
			propertyList.push('schedulerConfiguredId');
			propertyList.push('workerId');
			propertyList.push('workerConfiguredId');
			propertyList.push('workerType');
			propertyList.push('type');
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
			arr.push('schedulerId');
			arr.push('schedulerConfiguredId');
			arr.push('workerId');
			arr.push('workerConfiguredId');
			arr.push('workerType');
			arr.push('type');
			arr.push('value');
			return arr;
		}

		public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			arr.push('createdBy');
			arr.push('updatedBy');
			arr.push('schedulerId');
			arr.push('schedulerConfiguredId');
			arr.push('workerId');
			arr.push('workerConfiguredId');
			arr.push('workerType');
			arr.push('type');
			arr.push('value');
			return arr;
		}

	}
}
