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
package com.kaltura.contributionWizard.model
{
	import flash.events.Event;
	import flash.events.EventDispatcher;

	/**
	 * Holds the startup loading info.
	 *
	 */
	 //TODO: This method for checking startup completion can be replaced by chain of commands
	[Event(name="complete", type="flash.events.Event")]
	[Bindable]
	public class LoadingState extends EventDispatcher
	{
		//config file, styles and locale
		private static const TOTAL_STARTUP_ITEMS:uint = 3;
		private static var _loadedItems:uint = 0;
		private var _loadingComplete:Boolean

		public function loaded():void
		{
			if (!_loadingComplete && ++_loadedItems == TOTAL_STARTUP_ITEMS)
			{
				loadingComplete = true;
				dispatchEvent(new Event(Event.COMPLETE));
			}
		}

		public function set loadingComplete(value:Boolean):void
		{
			_loadingComplete = value;
		}
		public function get loadingComplete():Boolean
		{
			return _loadingComplete;
		}
	}
}