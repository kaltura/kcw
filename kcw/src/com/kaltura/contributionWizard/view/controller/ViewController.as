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
package com.kaltura.contributionWizard.view.controller
{
	import com.adobe_cw.adobe.cairngorm.control.CairngormEventDispatcher;
	import com.kaltura.contributionWizard.events.ViewControllerEvent;
	
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;

	public class ViewController extends EventDispatcher
	{
		public var token:Object;
		
		private var _dispatcher:CairngormEventDispatcher = CairngormEventDispatcher.getInstance();
		
		private var _eventToFunctionDictionary:Dictionary = new Dictionary(true);
		
		protected function addListener(eventName:String, func:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void 
		{
			//register the event to the tokenValidator first so it will have the chance to stop the event processing
			_dispatcher.addEventListener(eventName, tokenValidator, useCapture, priority, useWeakReference); 
			//_dispatcher.addEventListener(eventName, func, useCapture, priority, useWeakReference);
			
			_eventToFunctionDictionary[eventName] = func;
		}
		
		private function tokenValidator(event:ViewControllerEvent):void
		{
			if (event.token == this.token)
			{
				var handler:Function = _eventToFunctionDictionary[event.type];
				handler(event);
			}
		}
	}
}