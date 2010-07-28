package com.kaltura.contributionWizard.vo.limitations
{
	import com.kaltura.contributionWizard.enums.LimitationErrorType;
	
	public class LimitationError
	{
		public var type:String; //LmitationErrorType
		public var message:String;
		
		[Bindable]
		public var _min:Boolean = true;
		public var max:Boolean = true;
		
		public function LimitationError(type:String) //, message:String, min:Boolean, max:Boolean)
		{
			this.type = type;
			/*this.message = message;
			this.min = min;
			this.max = max;*/
		}
		
		public function set min(value:Boolean):void
		{
			_min = min;	
		}
		public function get min():Boolean
		{
			return _min;	
		}
	
	}
}