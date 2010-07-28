package com.kaltura.contributionWizard.events
{
	import com.bjorn.event.ChainEvent;
	
	import flash.events.Event;

	public class AddSearchEntriesEvent extends ChainEvent
	{
		public static const ADD_SEARCH_ENTRIES:String = "addSearchEntriesEvent";
		
		public function AddSearchEntriesEvent(type:String, bubbles:Boolean = true, cancelable:Boolean = false):void
		{
			super(type, bubbles, cancelable);
		}
		public override function clone():Event
		{
			var clone:AddSearchEntriesEvent = new AddSearchEntriesEvent(type, bubbles, cancelable);
			if (nextChainedEvent)
				clone.nextChainedEvent = ChainEvent(nextChainedEvent.clone());
			return clone;
		}
		
	}
}