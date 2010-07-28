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
	import de.polygonal.ds.LinkedQueue;

	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.media.Camera;

	[Event(type="com.kaltura.com.media.mediaDetection.CameraDetectionEvent", name="cameraMuted")]
	[Event(type="flash.events.Event", name="complete")]
	public class CameraDetection extends EventDispatcher
	{

		public var mostActiveCamera:Camera = new Camera();
		public var stopAtFirstDetection:Boolean = false;

		private static var _instance:CameraDetection = new CameraDetection();

		private var _permissionsWatcher:SecurityPermissionsWatcher = SecurityPermissionsWatcher.getInstance();
		private var _cameraQueue:LinkedQueue = new LinkedQueue();
		private var _cameraDetected:Boolean = false;

		public function CameraDetection()
		{
			if (_instance)
			{
				throw new Error("CameraDetection is a singleton and only one instance can be created");
			}

		}

		public static function getInstance():CameraDetection
		{
			return _instance;
		}

		public function detect():void
		{
			if (_cameraDetected)
			{
				detectionComplete();
				return;
			}
			else
			{
				inspectUserPermissions();
			}

		}

		private function inspectUserPermissions():void
		{
			_permissionsWatcher.addEventListener(CameraDetectionEvent.CAMERA_UNMUTED, 	permissionsCameraUnmutedHandler);
			_permissionsWatcher.addEventListener(CameraDetectionEvent.CAMERA_MUTED, 	permissionsCameraMutedHandler);
			_permissionsWatcher.inspectCameraSecurity();

		}
		private function permissionsCameraUnmutedHandler(evtCameraUnmuted:CameraDetectionEvent):void
		{

			//notify the client that the user allowed use of his devices
			dispatchEvent(evtCameraUnmuted.clone());
			startIteratingCameras();
		}
		private function permissionsCameraMutedHandler(evtCameraMuted:CameraDetectionEvent):void
		{
			//notify the client that the user banned any use of his devices
			dispatchEvent(evtCameraMuted.clone());

		}

		private function startIteratingCameras():void
		{
			createQueue();
			detectNextCamera();
		}

		private function detectNextCamera():void
		{

			var detector:SingleCameraDetector = _cameraQueue.peek();
			detector.addEventListener(Event.COMPLETE, singleDetectorCompleteHandler);
			detector.detectCamera();

		}

		private function createQueue():void
		{
			var names:Array = Camera.names;
			for (var i:int = 0; i < names.length; i++)
			{
				var detector:SingleCameraDetector = new SingleCameraDetector(i.toString());
				_cameraQueue.enqueue(detector);
			}
		}

		private function singleDetectorCompleteHandler(evtComplete:Event):void
		{
			var detector:SingleCameraDetector = _cameraQueue.dequeue();
			var camera:Camera = detector.camera;
			if (camera)
			{
				var success:Boolean = camera.activityLevel > mostActiveCamera.activityLevel;
			}
			else
			{
				success = false;
			}
			if (success)
			{
				_cameraDetected = true;
				mostActiveCamera = camera
			}
			continueDetections();
		}

		private function detectionCameraMutedHandler(evtCameraMuted:CameraDetectionEvent):void
		{
			_cameraQueue.clear();
			dispatchEvent(evtCameraMuted.clone());
		}

		private function continueDetections():void
		{
			//if last camera reached or stopAtFirstDetection parameter set to true and first camera detected
			if (_cameraQueue.size == 0 || stopAtFirstDetection && _cameraDetected)
			{
				detectionComplete();
			}
			else
			{
				detectNextCamera();
			}
		}

		private function detectionComplete():void
		{
			dispatchEvent(new Event(Event.COMPLETE));
		}
	}
}