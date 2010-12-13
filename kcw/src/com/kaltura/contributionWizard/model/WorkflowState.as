 package com.kaltura.contributionWizard.model
{
	import com.adobe_cw.adobe.cairngorm.control.CairngormEvent;

	public class WorkflowState
	{
		public var name:String;

		public function get cairngormEvent():CairngormEvent
		{
			return CairngormEvent(_cairngormEvent.clone());
		}
		public function set cairngormEvent(value:CairngormEvent):void
		{
			_cairngormEvent = value;
		}

		private var _cairngormEvent:CairngormEvent;

		public function WorkflowState(name:String, cairngormEvent:CairngormEvent):void
		{
			this.name = name;
			this.cairngormEvent = cairngormEvent;
		}
	}
}