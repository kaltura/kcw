package com.kaltura.events
{
	import flash.display.InteractiveObject;
	
	import mx.events.ItemClickEvent;

	public class ItemSelectionEvent extends ItemClickEvent
	{
		public static const ITEM_PRE_SELECTION:String = "itemPreSelection";

		public function ItemSelectionEvent(type:String, bubbles:Boolean = false,
								   cancelable:Boolean = false,
								   label:String = null, index:int = -1,
								   relatedObject:InteractiveObject = null,
								   item:Object = null)
		{

			super(type, bubbles, cancelable, label, index, relatedObject, item);

		}

	}
}