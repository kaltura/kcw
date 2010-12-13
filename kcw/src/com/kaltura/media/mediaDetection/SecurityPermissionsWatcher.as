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
	import flash.events.EventDispatcher;
	import flash.events.StatusEvent;
	import flash.media.Camera;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.system.Security;
	import flash.system.SecurityPanel;

	[Event(type="com.kaltura.com.media.mediaDetection.CameraDetectionEvent", name="cameraMuted")]
	[Event(type="com.kaltura.com.media.mediaDetection.CameraDetectionEvent", name="cameraUnmuted")]
	public class SecurityPermissionsWatcher extends EventDispatcher
	{
		private static var _instance:SecurityPermissionsWatcher = new SecurityPermissionsWatcher();

		private var _cam:Camera;
		private var _ns:NetStream;
		private var _nc:NetConnection;
		private var _cameraCaptured:Boolean;

		public static function getInstance():SecurityPermissionsWatcher
		{
			return _instance;
		}

		public function SecurityPermissionsWatcher()
		{
			if (_instance)
			{
				throw new Error("SecurityPermissionsWatcher is a singleton and cannot be created more than once");
			}

		}
		private function initCameraInspection():void
		{
			_cam = Camera.getCamera();
			if (!_cam) 
			{
				dispatchCameraMuted();
				return;
			}
			
			_cam.addEventListener(StatusEvent.STATUS, cameraStatusHandler, false, 0, true);
			_nc = new NetConnection();
			_nc.connect(null);
			_ns = new NetStream(_nc);
			_ns.attachCamera(_cam);
		}

		public function inspectCameraSecurity():void
		{
			Security.showSettings(SecurityPanel.PRIVACY);
			initCameraInspection();
		}

		private function cameraStatusHandler(evtStatus:StatusEvent):void
		{
			//dispose before dispatching event so that cameras list iterating won't cause player illegal operation errors
			if (!_cameraCaptured) dispose();

			if (evtStatus.code == "Camera.Unmuted")
			{
				dispatchEvent(new CameraDetectionEvent(CameraDetectionEvent.CAMERA_UNMUTED));
			}
			else
			{
				dispatchCameraMuted();
			}

			_cameraCaptured = true;
		}

		private function dispose():void
		{
			_nc.close();
			_ns.attachCamera(null);
			_nc = null;
			_ns = null;
		}

		private function dispatchCameraMuted():void
		{
			dispatchEvent(new CameraDetectionEvent(CameraDetectionEvent.CAMERA_MUTED));
		}

	}
}