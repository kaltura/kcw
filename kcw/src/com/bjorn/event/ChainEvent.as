/*
Copyright
*/
package com.bjorn.event
{

	import com.adobe_cw.adobe.cairngorm.control.CairngormEvent;

	public class ChainEvent extends CairngormEvent
	{
		public function ChainEvent(type:String, bubbles:Boolean = true, cancelable:Boolean = false):void
		{
			super(type, bubbles, cancelable);
		}

		public var nextChainedEvent:ChainEvent;
	}

}