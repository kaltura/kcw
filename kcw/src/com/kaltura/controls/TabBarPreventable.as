package com.kaltura.controls
{
	import com.kaltura.events.ItemSelectionEvent;

	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.events.Event;
	import flash.events.MouseEvent;

	import mx.controls.Button;
	import mx.controls.TabBar;
	import mx.core.EventPriority;
	import mx.core.IFlexDisplayObject;
	import mx.core.mx_internal;

	use namespace mx_internal;

	[Event(name="itemPreSelection", type="com.kaltura.events.ItemSelectionEvent")]
	public class TabBarPreventable extends TabBar
	{

		override mx_internal function selectButton(index:int,
                                      updateFocusIndex:Boolean = false,
                                      trigger:Event = null):void
		{
			if (getChildIndex(DisplayObject(trigger.currentTarget)) == selectedIndex)
				return;

			var superSelectButton:Function = super.selectButton;

			this.addEventListener(ItemSelectionEvent.ITEM_PRE_SELECTION,
				//default handler
				function(e:Event):void
				{
					if (!e.isDefaultPrevented())
					{
						superSelectButton(index, updateFocusIndex, trigger);
					}
				},
				false, EventPriority.DEFAULT_HANDLER);

			var itemPreSelectionEvent:ItemSelectionEvent =
				new ItemSelectionEvent(ItemSelectionEvent.ITEM_PRE_SELECTION, false, true);
			itemPreSelectionEvent.label = Button(trigger.currentTarget).label;
			var index:int = getChildIndex(DisplayObject(trigger.currentTarget));
			itemPreSelectionEvent.index = index;
			itemPreSelectionEvent.relatedObject = InteractiveObject(trigger.currentTarget);
			itemPreSelectionEvent.item = dataProvider ?
							dataProvider.getItemAt(index) :
							null;

			dispatchEvent(itemPreSelectionEvent);
		}

		override protected function createNavItem(label:String, icon:Class=null):IFlexDisplayObject
		{
			var navItem:IFlexDisplayObject = super.createNavItem(label, icon);
			navItem.addEventListener(MouseEvent.CLICK, navItemClickHandler, false, int.MAX_VALUE);
			return navItem;
		}
		private function navItemClickHandler(mouseDownEvent:MouseEvent):void
		{
			//The tabbar switches tabs on mouse down, not on click. However, the TabBar take advantage of the mouse down event and dispatches a fake mouse event from the mouseDown handler
			if (!simulatedClickTriggerEvent)
			{
				mouseDownEvent.stopImmediatePropagation();
			}
		}
	}
}