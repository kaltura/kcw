package com.kaltura.vo
{
	import com.kaltura.vo.BaseFlexVo;
	public dynamic class KalturaControlPanelCommand extends BaseFlexVo
	{
		public var id : int = int.MIN_VALUE;
		public var createdAt : int = int.MIN_VALUE;
		public var createdBy : String;
		public var updatedAt : int = int.MIN_VALUE;
		public var updatedBy : String;
		public var createdById : int = int.MIN_VALUE;
		public var schedulerId : int = int.MIN_VALUE;
		public var workerId : int = int.MIN_VALUE;
		public var workerName : int = int.MIN_VALUE;
		public var type : int = int.MIN_VALUE;
		public var targetType : int = int.MIN_VALUE;
		public var status : int = int.MIN_VALUE;
		public var cause : String;
		public var description : String;
		public var errorDescription : String;
		override protected function setupPropertyList():void
		{
			super.setupPropertyList();
			propertyList.push('id');
			propertyList.push('createdAt');
			propertyList.push('createdBy');
			propertyList.push('updatedAt');
			propertyList.push('updatedBy');
			propertyList.push('createdById');
			propertyList.push('schedulerId');
			propertyList.push('workerId');
			propertyList.push('workerName');
			propertyList.push('type');
			propertyList.push('targetType');
			propertyList.push('status');
			propertyList.push('cause');
			propertyList.push('description');
			propertyList.push('errorDescription');
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
			arr.push('createdById');
			arr.push('schedulerId');
			arr.push('workerId');
			arr.push('workerName');
			arr.push('type');
			arr.push('targetType');
			arr.push('status');
			arr.push('cause');
			arr.push('description');
			arr.push('errorDescription');
			return arr;
		}

		public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			arr.push('createdBy');
			arr.push('updatedBy');
			arr.push('createdById');
			arr.push('schedulerId');
			arr.push('workerId');
			arr.push('workerName');
			arr.push('type');
			arr.push('targetType');
			arr.push('status');
			arr.push('cause');
			arr.push('description');
			arr.push('errorDescription');
			return arr;
		}

	}
}
