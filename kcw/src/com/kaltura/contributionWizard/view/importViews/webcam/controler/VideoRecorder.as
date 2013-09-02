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
package com.kaltura.contributionWizard.view.importViews.webcam.controler {
	import com.kaltura.contributionWizard.model.WebcamModelLocator;
	import com.kaltura.contributionWizard.view.importViews.webcam.events.RecorderEvent;
	import com.kaltura.contributionWizard.view.importViews.webcam.view.VideoContainer;
	import com.kaltura.contributionWizard.view.resources.ResourceBundleNames;
	
	import flash.events.ActivityEvent;
	import flash.events.AsyncErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.StatusEvent;
	import flash.events.TimerEvent;
	import flash.media.Camera;
	import flash.media.Microphone;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.net.ObjectEncoding;
	import flash.utils.Timer;
	
	import mx.containers.VBox;
	import mx.controls.Alert;
	import mx.core.ScrollPolicy;

	public class VideoRecorder extends VBox {
		
		/**
		 * defines the value of the type property for the "updatePlayheadWebcam" event
		 */
		public static const UPDATE_PLAYHEAD_WEBCAM:String = "updatePlayheadWebcam";

		/**
		 * initial (small) buffer length, used to start playing the preview quickly
		 */
		public const START_BUFFER_LENGTH:int = 2;

		/**
		 * large buffer length, used to avoid network hickups in preview
		 */
		public const EXPANDED_BUFFER_LENGTH:int = 15;

		/**
		 * out-stream buffer length
		 */
		public const MAX_BUFFER_LENGTH:int = 40;
		
		/**
		 * video object used for both recording and playback 
		 */
		public var video:Video = new Video();
		
		/**
		 * url of the recording app, 
		 * i.e. "rtmp://www.kaltura.com/oflaDemo" 
		 */
		public var videoURL:String;
		
		/**
		 * name of the recorded stream 
		 */
		public var streamName:String;
		
		
		/**
		 * the NetConnection used for both in_stream and out_stream 
		 */
		private var _connection:NetConnection;
		
		/**
		 * recording netstream 
		 */
		private var _outStream:NetStream;
		
		/**
		 * preview netstream 
		 */
		private var _inStream:NetStream;

		/**
		 * microhone used to capture audio for recording.
		 */
		private var _mic:Microphone;
		
		/**
		 * camera used to capture video for recording 
		 */
		private var _cam:Camera;
		
		/**
		 * timer used to see all data in buffer is sent to server before closing connection 
		 */
		private var _outBufferCheckerTimer:Timer

		/**
		 * time recorded
		 */
		private var _recordTime:Number = 0.01;
		
		/**
		 * a flag indicating activity already detected on camera device 
		 */
		private var _cameraReady:Boolean = false;
		
		/**
		 * counter for detecting devices simoultaneusly (camera, microphone) 
		 * @see checkMediaLocatorsFinished()
		 */
		private var _devicesFound:int = 0;
		
		/**
		 * outStream.time when receiving "NetStream.Record.Start" 
		 */
		private var _startRecordDelta:Number;

		private var _videoContainer:VideoContainer = new VideoContainer();
		

		[Bindable]
		/**
		 * a timer that ticks every second since the actual record start ("NetStream.Record.Start")
		 */
		private var _viewTimer:Timer = new Timer(1000);

		
		public function VideoRecorder():void {
			
		}


		public function init():void {
			if (_connection)
				disconnect();
			NetConnection.defaultObjectEncoding = ObjectEncoding.AMF0;
			_connection = new NetConnection();

			_connection.client = new NetClient();

			// add connection listeners
			_connection.addEventListener(AsyncErrorEvent.ASYNC_ERROR, AsyncErrorHandler);
			_connection.addEventListener(IOErrorEvent.IO_ERROR, IOErrorHandler);
			_connection.addEventListener(SecurityErrorEvent.SECURITY_ERROR, SecurityErrorHandler);
			_connection.addEventListener(NetStatusEvent.NET_STATUS, onNCStatus);

			_connection.connect(videoURL);
			WebcamModelLocator.getInstance().detectingCamera = true;
		}


		override protected function createChildren():void {
			super.createChildren();
			addVideoChild();
		}


		private function addVideoChild():void {
			_videoContainer.viewTimer = _viewTimer;

			_videoContainer.verticalScrollPolicy = ScrollPolicy.OFF;
			_videoContainer.horizontalScrollPolicy = ScrollPolicy.OFF;

			_videoContainer.video = video;
			_videoContainer.percentWidth = 100;
			_videoContainer.percentHeight = 100;
			this.addChild(_videoContainer);
		}


		private function onNCStatus(event:NetStatusEvent):void {
			if (event.info.code == "NetConnection.Connect.Success") {
				_outBufferCheckerTimer = new Timer(50, 0);
				_outBufferCheckerTimer.addEventListener(TimerEvent.TIMER, timerHandler);

				//createNewOutNetStream();	// out stream is created every time we start recording, no need to create it here.
				createNewInNetStream();

				onMicLocatorComplete(null);
			}
			else if (event.info.code == "NetConnection.Connect.Closed") {
				var notFoundMsg:String = resourceManager.getString(ResourceBundleNames.WEBCAM_VIEW, "NO_CONNECTION");
				Alert.show(notFoundMsg);
			}
		}


		private function createNewOutNetStream():void {
			if (_outStream) {
				_outStream.removeEventListener(AsyncErrorEvent.ASYNC_ERROR, AsyncErrorHandler);
				_outStream.removeEventListener(IOErrorEvent.IO_ERROR, IOErrorHandler);
				_outStream.removeEventListener(NetStatusEvent.NET_STATUS, outStatusHandler);
			}

			//create the broadcasting stream
			_outStream = new NetStream(_connection);
			_outStream.client = new NetClient();
			_outStream.bufferTime = MAX_BUFFER_LENGTH;

			//add broadcasting stream event listeners
			_outStream.addEventListener(AsyncErrorEvent.ASYNC_ERROR, AsyncErrorHandler);
			_outStream.addEventListener(IOErrorEvent.IO_ERROR, IOErrorHandler);
			_outStream.addEventListener(NetStatusEvent.NET_STATUS, outStatusHandler);
		}


		private function createNewInNetStream():void {
			if (_inStream) {
				_inStream.removeEventListener(AsyncErrorEvent.ASYNC_ERROR, AsyncErrorHandler);
				_inStream.removeEventListener(IOErrorEvent.IO_ERROR, IOErrorHandler);
				_inStream.removeEventListener(NetStatusEvent.NET_STATUS, inStatusHandler);
			}

			//Create the playBack Stream
			_inStream = new NetStream(_connection);
			_inStream.client = new NetClient();

			_inStream.addEventListener(AsyncErrorEvent.ASYNC_ERROR, AsyncErrorHandler);
			_inStream.addEventListener(IOErrorEvent.IO_ERROR, IOErrorHandler);
			_inStream.addEventListener(NetStatusEvent.NET_STATUS, inStatusHandler);

			NetClient(_inStream.client).addEventListener(NetClient.ON_STREAM_END, playEndHandler);
		}


		private function timerHandler(event:TimerEvent):void {
			if (_outStream.bufferLength == 0) {
				dispatchEvent(new RecorderEvent(RecorderEvent.STREAMED_BUFFER_EMPTY, _recordTime, true));
				_outBufferCheckerTimer.stop();
				stopRecording();
			}
		}


		public function setCamera(camera:Camera):void {
			var webcamModel:WebcamModelLocator = WebcamModelLocator.getInstance();
			webcamModel.detectingCamera = false;
			_cam = camera;
			if (_cam == null) {
				var bodyText:String = resourceManager.getString(ResourceBundleNames.WEBCAM_VIEW, "WEB_CAM_NOT_FOUND_BODY")
				var titleText:String = resourceManager.getString(ResourceBundleNames.WEBCAM_VIEW, "WEB_CAM_NOT_FOUND_TITLE")
				Alert.show(bodyText, titleText);
				return;
			}

			_cam.addEventListener(ActivityEvent.ACTIVITY, cameraReadyHandler);
			_cam.addEventListener(StatusEvent.STATUS, cameraStatusHandler);

			//set the key frame interval
			_cam.setKeyFrameInterval(webcamModel.webcamParameters.keyFrameInterval || 5);

			// setting dimensions and framerate
			_cam.setMode(
				webcamModel.webcamParameters.width || 336,
				webcamModel.webcamParameters.height || 252,
				webcamModel.webcamParameters.framerate || 25,
				webcamModel.webcamParameters.favorArea || false
				);

			// set to max quality
			_cam.setQuality(
				webcamModel.webcamParameters.bandwidth || 0,
				webcamModel.webcamParameters.quality || 85
				);

			checkMediaLocatorsFinished();
			//attachMedia();
		}


		private function onMicLocatorComplete(evtComplete:Event):void {
			var webcamModel:WebcamModelLocator = WebcamModelLocator.getInstance();
			_mic = Microphone.getMicrophone();

			_mic.addEventListener(StatusEvent.STATUS, handleMicStatus);
			_mic.addEventListener(ActivityEvent.ACTIVITY, micActivityHandler);

			_mic.setSilenceLevel(webcamModel.webcamParameters.silenceLevel || 0,
				webcamModel.webcamParameters.silenceLevelTimeout || 10000);

			_mic.setUseEchoSuppression(webcamModel.webcamParameters.setUseEchoSuppression || true);
			// we set the gain to reduce the volume captured by the mic, to further eliminate bg noise.
			// play with this value to eliminate bg noise or raise the volume of recorded sounds to suite
			// your needs.
			_mic.gain = webcamModel.webcamParameters.gain || 50;
			//Nellymoser Asao codec is a proprietary single-channel (mono) format
			//optimized for low-bitrate transmission of audio. http://en.wikipedia.org/wiki/Nellymoser_Asao_Codec
			//we set the mic to capture 8Khz sounds (or 11Khz if 8Khz isn't available).
			_mic.rate = webcamModel.webcamParameters.rate || 8;

			checkMediaLocatorsFinished();
		}


		private function checkMediaLocatorsFinished():void {
			if (++_devicesFound >= 2) {
				attachMedia();
			}
		}


		private function attachMedia():void {
			if (_outStream) {
				//add mic & cam to out stream
				_outStream.attachCamera(_cam);
				_outStream.attachAudio(_mic);
			}
			
			//add camera to video
			video.attachNetStream(null);
			video.attachCamera(null);

			video = new Video();
			_videoContainer.video = video;
			video.attachCamera(_cam);
		}


		public function record():void {
			// create a new out stream every time we record, so outStream.time will be correct and the resulting video will not freeze
			createNewOutNetStream(); 
			attachMedia();
			_outStream.publish(streamName, "record");
		}


		public function stopRecordingAddWait():void {
			//trace("VideoRecorder: stopRecordingAddWait");
			_recordTime = _outStream.time - _startRecordDelta;
			_outStream.attachAudio(null);
			_outStream.attachCamera(null);
			_outBufferCheckerTimer.start();
			updateViewOnStop();
		}


		public function stopRecording():void {
			//trace("VideoRecorder: stopRecording");
			// check why out_stream get NetStream.Buffer.Empty if i don't close it again.
			_outStream.close();
		}


		public function stopPlayBack():void {
			_inStream.close();
			updateViewOnStop();
		}


		public function playBack(playFrom:Number, playTo:Number):void {
			//in_stream.play("my_recorded_stream_" + _videoPostfix, playFrom, playTo);
			video.attachNetStream(_inStream);
			_inStream.play(streamName); //, -2, -1, true);

		}


		private function handleMicStatus(event:StatusEvent):void {
			//trace("handleMicStatus()");
			// trace("handleMicStatus: " + event, event.target["activityLevel"]);
		}


		private function micActivityHandler(event:ActivityEvent):void {
			// trace("micActivityHandler: " + event, event.target["activityLevel"]);
			//trace("micActivityHandler()");
		}


		private function cameraStatusHandler(event:StatusEvent):void {
			dispatchEvent(new RecorderEvent(RecorderEvent.CAMERA_STATUS, _recordTime, true));
		}


		private function cameraReadyHandler(event:ActivityEvent):void {
			if (!_cameraReady && event.activating) {
				_cameraReady = true;
				dispatchEvent(new RecorderEvent(RecorderEvent.CAMERA_READY, _recordTime, true));
			}
		}



		public function dispose():void {
			_devicesFound = 0;

			if (_connection != null) {
				_connection.removeEventListener(AsyncErrorEvent.ASYNC_ERROR, AsyncErrorHandler);
				_connection.removeEventListener(IOErrorEvent.IO_ERROR, IOErrorHandler);
				_connection.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, SecurityErrorHandler);
				_connection.removeEventListener(NetStatusEvent.NET_STATUS, onNCStatus);
				_connection.close();
			}

			if (_outStream != null) {
				_outStream.removeEventListener(AsyncErrorEvent.ASYNC_ERROR, AsyncErrorHandler);
				_outStream.removeEventListener(IOErrorEvent.IO_ERROR, IOErrorHandler);
				_outStream.removeEventListener(NetStatusEvent.NET_STATUS, outStatusHandler);
				_outStream.close();
			}

			if (_inStream != null) {
				_inStream.removeEventListener(AsyncErrorEvent.ASYNC_ERROR, AsyncErrorHandler);
				_inStream.removeEventListener(IOErrorEvent.IO_ERROR, IOErrorHandler);
				_inStream.removeEventListener(NetStatusEvent.NET_STATUS, inStatusHandler);
				_inStream.close();
			}


			if (_outBufferCheckerTimer != null) {
				_outBufferCheckerTimer.removeEventListener(TimerEvent.TIMER, timerHandler);
				_outBufferCheckerTimer.stop();
			}

			if (video != null) {
				video.attachNetStream(null);
				video.clear();
			}

			_mic = null;
			_cam = null;
			_inStream = null;
			_outStream = null;
			_connection = null;
			_outBufferCheckerTimer = null;

			_videoContainer.dispose()

		}


		public function playEndHandler(event:Event):void {
			// trace("playEndHandler");
			_inStream.close();
			dispatchEvent(new RecorderEvent(RecorderEvent.PLAYBACK_STOP, _recordTime, true));
			updateViewOnStop();
		}


		public function outStatusHandler(event:NetStatusEvent):void {
			switch (event.info.code) {
				case "NetStream.Unpublish.Success":
					dispatchEvent(new RecorderEvent(RecorderEvent.RECORD_FINISH, _recordTime, true));
					break;

				case "NetStream.Publish.Start":
					dispatchEvent(new RecorderEvent(RecorderEvent.PUBLISH_START));
					break;

				case "NetStream.Record.Start":
					_startRecordDelta = _outStream.time;
					dispatchEvent(new RecorderEvent(RecorderEvent.RECORD_START, _recordTime, true));
					updateViewOnRecordStart();
					break;
				
//				case "NetStream.Buffer.Full":
//				case "NetStream.Record.Stop":
//					break;

//				case "NetStream.Buffer.Empty":
//					dispatchEvent(new RecorderEvent(RecorderEvent.STREAMED_BUFFER_EMPTY, _recordTime,true));
//					break;

//				case "NetStream.Record.Stop":
//					dispatchEvent(new RecorderEvent(RecorderEvent.STREAMED_BUFFER_EMPTY, _recordTime, true));
//					break;
			}
		}


		public function inStatusHandler(event:NetStatusEvent):void {
			switch (event.info.code) {
				case "NetStream.Play.InsufficientBW":
				case "NetStream.Buffer.Full":
					if ((event.target).bufferLength <= EXPANDED_BUFFER_LENGTH) {
						(event.target).bufferTime = 2 * EXPANDED_BUFFER_LENGTH;
					}
					else {
						(event.target).bufferTime = EXPANDED_BUFFER_LENGTH;
					}

					startViewTimer();
					dispatchEvent(new RecorderEvent(RecorderEvent.STREAMED_PLAYBACK_BUFFER_FULL));
					break;

				case "NetStream.Buffer.Empty":
					(event.target).bufferTime = START_BUFFER_LENGTH;

					pauseViewTimer();
					dispatchEvent(new RecorderEvent(RecorderEvent.STREAMED_PLAYBACK_BUFFER_EMPTY));
					break;

				case "NetStream.Play.Start":
					dispatchEvent(new RecorderEvent(RecorderEvent.PLAYBACK_START, _recordTime, true));
					updateViewOnPlayStart();

					break;

				case "NetStream.Play.Stop":
					dispatchEvent(new RecorderEvent(RecorderEvent.STREAMED_PLAYBACK_BUFFER_FULL));
					break;
			}
		}


		private function disconnect():void {
			_connection.removeEventListener(AsyncErrorEvent.ASYNC_ERROR, AsyncErrorHandler);
			_connection.removeEventListener(IOErrorEvent.IO_ERROR, IOErrorHandler);
			_connection.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, SecurityErrorHandler);
			_connection.removeEventListener(NetStatusEvent.NET_STATUS, onNCStatus);
			_connection.close();
			_connection = null;
		}


		private function AsyncErrorHandler(event:AsyncErrorEvent):void {
			Alert.show("error: " + event.error + " text: " + event.text);
		}


		private function IOErrorHandler(event:IOErrorEvent):void {
			Alert.show("error: " + event.text);
		}


		private function SecurityErrorHandler(event:SecurityErrorEvent):void {
			Alert.show("error: " + event.text);
		}


		//getters & setters
		////////////////////////////////////////////////////////////////////
		public function get recordQualty():Number {
			return _cam.quality;
		}


		public function set recordQualty(quality:Number):void {
			_cam.setQuality(0, quality);
		}


		private function updateViewOnPlayStart():void {
			_videoContainer.videoStatus = VideoContainer.PLAYING;
		}


		private function updateViewOnRecordStart():void {
			startViewTimer();
			_videoContainer.videoStatus = VideoContainer.RECORDING;
		}


		private function updateViewOnStop():void {
			stopViewTimer();
			_videoContainer.videoStatus = VideoContainer.STOP;
		}


		// view timer handling
		private function stopViewTimer():void {
			_viewTimer.reset();
			_viewTimer.removeEventListener(TimerEvent.TIMER, onTimer);
		}


		private function pauseViewTimer():void {
			_viewTimer.stop();
		}


		private function startViewTimer():void {
			if (!_viewTimer.running) {
				_viewTimer.start();
				_viewTimer.addEventListener(TimerEvent.TIMER, onTimer);
			}
		}


		private function onTimer(event:TimerEvent):void {
			dispatchEvent(new Event(UPDATE_PLAYHEAD_WEBCAM));
		}


		public function releaseWebcam():void {
			video.attachCamera(null);
		}
		
		
		/**
		 * time since actual recording started 
		 */
		public function get elapsedTime():uint {
			if (_videoContainer) {
				return _videoContainer.elapsedTime;
			}
			return 0;
		}
	}
}
