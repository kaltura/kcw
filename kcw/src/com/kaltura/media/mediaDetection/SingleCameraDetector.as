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
package com.kaltura.media.mediaDetection
{
	import flash.events.ActivityEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.StatusEvent;
	import flash.media.Camera;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;

	[Event(type="flash.events.Event", name="complete")]
	public class SingleCameraDetector extends EventDispatcher
	{
		public var camera:Camera;
		public var timeout:Number = 8000;
		private var _timeoutId:uint;

		private var _camName:String;
		private var _nc:NetConnection;
		private var _ns:NetStream;

		public function SingleCameraDetector(cameraName:String):void
		{
			_camName = cameraName;
		}

		public function detectCamera():void
		{
			camera = Camera.getCamera(_camName);

			_nc = new NetConnection();
			_nc.connect(null);

			_ns = new NetStream(_nc);
			_ns.attachCamera(camera);

			camera.addEventListener(StatusEvent.STATUS, 	cameraStatusHandler);
			camera.addEventListener(ActivityEvent.ACTIVITY, cameraActivityHandler);
			_timeoutId = setTimeout(cancelCameraCheck, timeout);
		}

		/**
		 * The status listener is needed as the activity won't be dispatched if not listenening to StatusEvent.STATUS
		 * @param evtStatus
		 * @private
		 */
		private function cameraStatusHandler(evtStatus:StatusEvent):void
		{
			camera.removeEventListener(StatusEvent.STATUS, cameraStatusHandler);
		}

		private function cameraActivityHandler(evtActivity:ActivityEvent):void
		{
			clearTimeout(_timeoutId)
			camera.removeEventListener(ActivityEvent.ACTIVITY, cameraActivityHandler);
			//FIXME: the dispose should take place before dispatching the event
			dispatchEvent(new Event(Event.COMPLETE));
			dispose();
		}

		private function cancelCameraCheck():void
		{
			//TODO: dispatch fail event
			dispatchEvent(new Event(Event.COMPLETE));
			if (camera) camera.removeEventListener(ActivityEvent.ACTIVITY, cameraActivityHandler);
			//camera.removeEventListener(StatusEvent.STATUS, cameraStatusHandler);
		}

		private function dispose():void
		{
			if (_nc) _nc.close();
			if (_ns) _ns.attachCamera(null);

			_nc = null;
			_ns = null;
			camera = null;
		}
/* 		private function dispatchCameraMuted():void
		{
			dispatchEvent(new CameraDetectionEvent(CameraDetectionEvent.CAMERA_MUTED));
			dispose();
		} */
	}
}