package com.kaltura.contributionWizard.vo.providers
{
	public class WebcamParametersVO
	{
		public function WebcamParametersVO()
		{
		}
		
		public var keyFrameInterval:int;
		
		public var width:int;
		
		public var height:int;

		public var framerate:int;
		
		public var favorArea:Boolean;

		public var bandwidth:int;

		public var quality:int;
		
		public var setUseEchoSuppression:Boolean = true;
		
		public var gain:Number = 50;
		
		public var rate:int = 8;
		
		public var silenceLevel:Number = 0;
		
		public var silenceLevelTimeout:int = 10000;
	}
}