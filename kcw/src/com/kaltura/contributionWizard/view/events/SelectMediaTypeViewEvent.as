package com.kaltura.contributionWizard.view.events
{
	import flash.events.Event;

	public class SelectMediaTypeViewEvent extends Event
	{
		public static const SELECT_MEDIA_TYPE:String = "selectMediaType";
		public var mediaType:String;
		public function SelectMediaTypeViewEvent(type:String, mediaType:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.mediaType = mediaType;
		}

		public override function clone():Event
		{
			var cloneEvent:SelectMediaTypeViewEvent = new SelectMediaTypeViewEvent(type, mediaType);
			return cloneEvent;
		}
	}

}