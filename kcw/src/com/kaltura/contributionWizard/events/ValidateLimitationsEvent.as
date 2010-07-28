package com.kaltura.contributionWizard.events
{
	import com.bjorn.event.ChainEvent;
	
	public class ValidateLimitationsEvent extends ChainEvent
	{
		public static const VALIDATE:String = "validate";
		
		public function ValidateLimitationsEvent(type:String):void
		{
			super(type, false, false);
		}
	}
}