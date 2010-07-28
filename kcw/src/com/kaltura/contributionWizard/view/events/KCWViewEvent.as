package com.kaltura.contributionWizard.view.events
{
	import flash.events.Event;

	public class KCWViewEvent extends Event
	{
		public static const CLOSE_WIZARD:String 		= "closeWizard";

		public function KCWViewEvent(type:String, bubbles:Boolean = true, cancelable:Boolean = false):void
		{
			super(type, bubbles, cancelable);
		}

		override public function clone():Event
		{
			return new KCWViewEvent(type, bubbles, cancelable);
		}
	}
}