package com.kaltura.vo
{
	import com.kaltura.vo.KalturaBatchJob;

	import com.kaltura.vo.BaseFlexVo;
	public dynamic class KalturaBatchJobResponse extends BaseFlexVo
	{
		public var batchJob : KalturaBatchJob;
		public var childBatchJobs : Array = new Array();
		override protected function setupPropertyList():void
		{
			super.setupPropertyList();
			propertyList.push('batchJob');
			propertyList.push('childBatchJobs');
		}
		public function getParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			arr.push('batchJob');
			arr.push('childBatchJobs');
			return arr;
		}

		public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			arr.push('batchJob');
			arr.push('childBatchJobs');
			return arr;
		}

	}
}
