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
package com.kaltura.contributionWizard.view.importViews.webcam.events
{
	import flash.events.Event;

	public class RecorderControlEvent extends Event
	{
		// Define static constant.
        public static const START_RECORD:String = "startRecord";
        public static const STOP_RECORD:String = "stopRecord";
        public static const PLAY_START:String = "playStart";
        public static const PLAY_STOP:String = "playStop";
        public static const SAVE_RECORD:String = "saveRecord";
        public static const CANCEL_RECORD:String = "cancelRecord";
        public static const QUALTY_CHANGED:String = "qualtyChanged";
        public static const SEEK_TARGET:String = "seekTarget";
        
		
		private var _newQualty:Number = 85;
		private var _minTime:Number = 0;
		private var _maxTime:Number = 0.01;
		
		public function RecorderControlEvent(type:String, newQualty:Number=85, minTime:Number=0, maxTime:Number=0.01,bubbles:Boolean=false, cancelable:Boolean=false):void
		{
			super(type,bubbles, cancelable);
			_newQualty = newQualty;
			_minTime = minTime;
			_maxTime = maxTime;
		}
		
		public function get newQualty():Number
		{
			return _newQualty;
		}
		
		public function get minTime():Number
		{
			return _minTime;
		}
		
		public function get maxTime():Number
		{
			return _maxTime;
		}
	}
}