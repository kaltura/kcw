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

	public class RecorderEvent extends Event
	{
		// Define static constant.
        public static const RECORD_START:String = "recordStart";
        public static const RECORD_STOP:String = "recordStop";
        public static const PLAYBACK_START:String = "playbackStart";
        public static const PLAYBACK_STOP:String = "playbackStop";
        public static const STREAM_END:String = "streamEnd";
		public static const RECORDER_READY:String = "recorderReady";
		public static const CAMERA_STATUS:String = "cameraStatus";
		public static const CAMERA_READY:String = "cameraReady";
		public static const PLAYBACK_END:String = "playbackEnd";
		public static const STREAMED_BUFFER_EMPTY:String = "streamedBufferEmpty";
		public static const STREAMED_PLAYBACK_BUFFER_FULL:String = "streamedPlaybackBufferFull";
		public static const STREAMED_PLAYBACK_BUFFER_EMPTY:String = "streamedPlaybackBufferEmpty";
		public static const RECORD_FINISH:String = "recordFinish";
		public static const PUBLISH_START:String = "publishStart";

		//define the time is started or stoped
		private var _time:Number = 0;

		//constructor
		public function RecorderEvent(type:String ,time:Number=0 ,bubbles:Boolean=false, cancelable:Boolean=false)
		{
			_time = time;
			super(type, bubbles, cancelable);
		}

		// Override the inherited clone() method.
        override public function clone():Event
        {
            return new RecorderEvent(type,_time,bubbles,cancelable);
        }

        public function get time():Number
        {
        	return _time;
        }

	}
}