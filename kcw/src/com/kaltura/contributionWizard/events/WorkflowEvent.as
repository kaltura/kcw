/*
This file is part of the Kaltura Collaborative Media Suite which allows users
to do with audio, video, and animation what Wiki platfroms allow them to do with
text.

Copyright (C) 2006-2008  Kaltura Inc.

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as
published by the Free Software Foundation, either version 3 of the
License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Affero General Public License for more details.

You should have received a copy of the GNU Affero General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.

@ignore
*/
package com.kaltura.contributionWizard.events
{
	import com.bjorn.event.ChainEvent;

	import flash.events.Event;

	public class WorkflowEvent extends ChainEvent
	{
		public static const CHANGE_WORKFLOW:String = "changeWorkflow";

		public function set workflow(value:String):void
		{
			_workflow = value;
		}
		public function get workflow():String
		{
			return _workflow;
		}

		private var _workflow:String;

		public function WorkflowEvent(type:String, workflow:String, bubbles:Boolean = true, cancelable:Boolean = false):void
		{
			super(type, bubbles, cancelable);
			_workflow = workflow;
		}

		public override function clone():Event
		{
			var clone:WorkflowEvent = new WorkflowEvent(type, workflow, bubbles, cancelable);
			if (nextChainedEvent)
				clone.nextChainedEvent = ChainEvent(this.nextChainedEvent.clone());
			return clone;
		}
		public override function toString():String
		{
			return formatToString("type", "workflow", "bubbles", "cancelable", "eventPhase");
		}
	}
}