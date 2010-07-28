package com.kaltura.vo
{
	import com.kaltura.vo.BaseFlexVo;
	public dynamic class KalturaSchedulerStatusResponse extends BaseFlexVo
	{
		public var queuesStatus : Array = new Array();
		public var controlPanelCommands : Array = new Array();
		public var schedulerConfigs : Array = new Array();
		override protected function setupPropertyList():void
		{
			super.setupPropertyList();
			propertyList.push('queuesStatus');
			propertyList.push('controlPanelCommands');
			propertyList.push('schedulerConfigs');
		}
		public function getParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			arr.push('queuesStatus');
			arr.push('controlPanelCommands');
			arr.push('schedulerConfigs');
			return arr;
		}

		public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			arr.push('queuesStatus');
			arr.push('controlPanelCommands');
			arr.push('schedulerConfigs');
			return arr;
		}

	}
}
