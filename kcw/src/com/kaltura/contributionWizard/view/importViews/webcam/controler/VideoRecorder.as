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
package com.kaltura.contributionWizard.view.importViews.webcam.controler
{
	import com.kaltura.contributionWizard.model.WebcamModelLocator;
	import com.kaltura.contributionWizard.view.importViews.webcam.events.RecorderEvent;
	import com.kaltura.contributionWizard.view.importViews.webcam.view.VideoContainer;
	import com.kaltura.contributionWizard.view.resources.ResourceBundleNames;
	import com.kaltura.media.mediaDetection.CameraDetection;
	import com.kaltura.mediaLocator.MicrophoneLocator;
	
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

	public class VideoRecorder extends VBox
	{
		//consts
		///////////////////////////////////////////////
		public const START_BUFFER_LENGTH:int = 2;
        public const EXPANDED_BUFFER_LENGTH:int = 15;
        public const MAX_BUFFER_LENGTH:int = 40;

        public const MEDIA_READY:String = "mediaReady";
        ///////////////////////////////////////////////

        //private vars
        ////////////////////////////////////////////////
        public var video:Video = new Video();
		[Bindable]
        public var videoWidth:Number;
		[Bindable]
   		public var videoHeight:Number;

		public var videoURL:String;
		public var streamName:String;

		private var connection:NetConnection;
        private var out_stream:NetStream;
        private var in_stream:NetStream;

		private var mic:Microphone;
        private var cam:Camera;
        private var _outBufferCheckerTimer:Timer

        private var _nsTimeSamplerId:uint;

        private var recordTime:Number = 0.01;
        private var cameraReady:Boolean = false;
		private var _devicesFound:int = 0;
		private var _checkBufferFullToStartPlay:Boolean = false;
		private var _startRecordDelta:Number;
		private var numCams:int;
		private var numMics:int;

		private var _videoContainer:VideoContainer = new VideoContainer();

		[Bindable]
		private var _viewTimer:Timer = new Timer(1000);
		//private var _elapsedViewTime:uint = 0;
		////////////////////////////////////////////////

		public function VideoRecorder():void
		{
			//addEventListener(FlexEvent.CREATION_COMPLETE, thisCreationCompleteHandler);
		}

		/* private function thisCreationCompleteHandler(evtCreationComplete:FlexEvent):void
		{
			init();
		} */

		public function init():void
		{
			if(connection)
				disconnect();
			NetConnection.defaultObjectEncoding = ObjectEncoding.AMF0;
			connection = new NetConnection();

			connection.client = new NetClient();

			//Add connection listeners
			connection.addEventListener(AsyncErrorEvent.ASYNC_ERROR,		AsyncErrorHandler);
			connection.addEventListener(IOErrorEvent.IO_ERROR,				IOErrorHandler);
			connection.addEventListener(SecurityErrorEvent.SECURITY_ERROR,	SecurityErrorHandler);
			connection.addEventListener(NetStatusEvent.NET_STATUS,			onNCStatus);

	        connection.connect(videoURL);
			WebcamModelLocator.getInstance().detectingCamera = true;
	        //video = new Video();
		}

		private var _micLocator:MicrophoneLocator = new MicrophoneLocator();
		private var _camLocator:CameraDetection = CameraDetection.getInstance();

		override protected function createChildren():void
		{
			super.createChildren();
			addVideoChild();
		}

		private function addVideoChild():void
		{
			_videoContainer.viewTimer = _viewTimer;
			//_videoContainer.setStyle("backgroundColor", 0x000000);
			_videoContainer.verticalScrollPolicy = ScrollPolicy.OFF;
			_videoContainer.horizontalScrollPolicy = ScrollPolicy.OFF;

			//if (!_videoContainer.contains(video)) _videoContainer.video = video;
			_videoContainer.video = video;
			_videoContainer.percentWidth = 100;
			_videoContainer.percentHeight = 100;
			this.addChild(_videoContainer);
		}

		private function onNCStatus(event:NetStatusEvent):void
        {
			   if(event.info.code == "NetConnection.Connect.Success")
			   {
			   	 	_outBufferCheckerTimer = new Timer(50,0);
			   	    _outBufferCheckerTimer.addEventListener(TimerEvent.TIMER,timerHandler);

					createNewOutNetStream();
					createNewInNetStream();


				   	//_camLocator.addEventListener(Event.COMPLETE, onCamLocatorComplete);
				   	_camLocator.stopAtFirstDetection = true;

				   	//TODO: this shouldn't be set by the view


				   	//_camLocator.detect();


					//_micLocator.addEventListener(Event.COMPLETE, onMicLocatorComplete);
					//_micLocator.locateActiveDevice();
					onMicLocatorComplete(null);
			   }
			   else if (event.info.code == "NetConnection.Connect.Closed")
			   {
			   		var notFoundMsg:String = resourceManager.getString(ResourceBundleNames.WEBCAM_VIEW, "NO_CONNECTION");
			   		Alert.show(notFoundMsg);
			   }
			   else
			   {
			   	    // trace(event.info.code);
			   }
		}

		private function createNewOutNetStream():void
		{
			if(out_stream)
			{
				 out_stream.removeEventListener(AsyncErrorEvent.ASYNC_ERROR,AsyncErrorHandler);
			     out_stream.removeEventListener(IOErrorEvent.IO_ERROR,IOErrorHandler);
				 out_stream.removeEventListener(NetStatusEvent.NET_STATUS,outStatusHandler);
			}

			 //create the broadcasting stream
		     out_stream = new NetStream(connection);
		     out_stream.client = new NetClient();
          	 out_stream.bufferTime = MAX_BUFFER_LENGTH;

		     //add broadcasting stream event listeners
		     out_stream.addEventListener(AsyncErrorEvent.ASYNC_ERROR,	AsyncErrorHandler);
		     out_stream.addEventListener(IOErrorEvent.IO_ERROR,			IOErrorHandler);
			 out_stream.addEventListener(NetStatusEvent.NET_STATUS,		outStatusHandler);
		}

		private function createNewInNetStream():void
		{
			if(in_stream)
			{
				in_stream.removeEventListener(AsyncErrorEvent.ASYNC_ERROR,	AsyncErrorHandler);
			    in_stream.removeEventListener(IOErrorEvent.IO_ERROR,		IOErrorHandler);
			    in_stream.removeEventListener(NetStatusEvent.NET_STATUS, 	inStatusHandler);
			}

			//Create the playBack Stream
	   	    in_stream = new NetStream(connection);
			in_stream.client = new NetClient();

		    in_stream.addEventListener(AsyncErrorEvent.ASYNC_ERROR,	AsyncErrorHandler);
		    in_stream.addEventListener(IOErrorEvent.IO_ERROR,		IOErrorHandler);
		    in_stream.addEventListener(NetStatusEvent.NET_STATUS, 	inStatusHandler);

		    NetClient(in_stream.client).addEventListener(NetClient.ON_STREAM_END, playEndHandler);
		}

		private function timerHandler(event:TimerEvent):void
		{
			//trace("out_stream.bufferLength: " + out_stream.bufferLength);

			if(out_stream.bufferLength == 0)
			{
				dispatchEvent(new RecorderEvent(RecorderEvent.STREAMED_BUFFER_EMPTY, recordTime, true));
				_outBufferCheckerTimer.stop();
				stopRecording();
			}
		}

		public function setCamera(camera:Camera):void
		{
			var webcamModel:WebcamModelLocator = WebcamModelLocator.getInstance();
			webcamModel.detectingCamera = false;
			cam = camera;
			if(cam == null)
			{
				var bodyText:String = resourceManager.getString(ResourceBundleNames.WEBCAM_VIEW, "WEB_CAM_NOT_FOUND_BODY")
				var titleText:String = resourceManager.getString(ResourceBundleNames.WEBCAM_VIEW, "WEB_CAM_NOT_FOUND_TITLE")
				Alert.show(bodyText, titleText);
				return;
			}

			cam.addEventListener(ActivityEvent.ACTIVITY,	cameraReadyHandler);
			cam.addEventListener(StatusEvent.STATUS,		cameraStatusHandler);

			//set the key frame interval
			cam.setKeyFrameInterval(webcamModel.webcamParameters.keyFrameInterval || 5);

			// setting dimensions and framerate
			cam.setMode(
						webcamModel.webcamParameters.width || 336, 
						webcamModel.webcamParameters.height || 252, 
						webcamModel.webcamParameters.framerate || 25, 
						webcamModel.webcamParameters.favorArea || false
						);

			// set to max quality
			cam.setQuality(
							webcamModel.webcamParameters.bandwidth || 0,
							webcamModel.webcamParameters.quality ||  85
							);

			checkMediaLocatorsFinished();
			//attachMedia();
		}

		private function onMicLocatorComplete(evtComplete:Event):void
		{
			//mic = _micLocator.mostActiveMic;
			var webcamModel:WebcamModelLocator = WebcamModelLocator.getInstance();
			mic = Microphone.getMicrophone();

			mic.addEventListener(StatusEvent.STATUS, 		handleMicStatus);
			mic.addEventListener(ActivityEvent.ACTIVITY, 	micActivityHandler);
			
			//BOAZ
			//////////////////////////////
			
			mic.setSilenceLevel( webcamModel.webcamParameters.silenceLevel || 0, 
								 webcamModel.webcamParameters.silenceLevelTimeout || 10000);

			mic.setUseEchoSuppression(webcamModel.webcamParameters.setUseEchoSuppression || true);
			// we set the gain to reduce the volume captured by the mic, to further eliminate bg noise.
			// play with this value to eliminate bg noise or raise the volume of recorded sounds to suite
			// your needs.
			mic.gain = webcamModel.webcamParameters.gain || 50;
			//Nellymoser Asao codec is a proprietary single-channel (mono) format
			//optimized for low-bitrate transmission of audio. http://en.wikipedia.org/wiki/Nellymoser_Asao_Codec
			//we set the mic to capture 8Khz sounds (or 11Khz if 8Khz isn't available).
			mic.rate = webcamModel.webcamParameters.rate || 8;

			//trace("configuring microphone");
			//trace(mic.name);

			//////////////////////////////
			
			// trace("onMicLocatorComplete()", "Selected : " + mic.name);
			checkMediaLocatorsFinished();
		}

		private function checkMediaLocatorsFinished():void
		{
			if (++_devicesFound >= 2)
			{
				attachMedia();
				//addVideoChild();
			}
		}

		private function attachMedia():void
		{
			//add mic & cam to out stream
		    out_stream.attachCamera(cam);
		    out_stream.attachAudio(mic);
		    //add camera to video
			video.attachNetStream(null);
			video.attachCamera(null);

			video = new Video();
			_videoContainer.video = video;
			video.attachCamera(cam);
			//add video to display list
			/* if (!_videoContainer.contains(video)) _videoContainer.addChild(video);
			if (!this.contains(_videoContainer)) this.addChild(_videoContainer); */
		}

		public function record():void
		{
			attachMedia();
			out_stream.publish(streamName, "record");
		}

		public function stopRecordingAddWait():void
		{
			//trace("VideoRecorder: stopRecordingAddWait");
			recordTime = out_stream.time - _startRecordDelta;
			out_stream.attachAudio(null);
			out_stream.attachCamera(null);
			//video.attachNetStream(in_stream);
			_outBufferCheckerTimer.start();
			updateViewOnStop();
		}

		public function stopRecording():void
		{
			// trace("VideoRecorder: stopRecording");

			// check why out_stream get NetStream.Buffer.Empty if i don't close it again.
			out_stream.close();
		}

		public function stopPlayBack():void
		{
			// trace("VideoRecorder: stopPlayBack");
			in_stream.close();
			updateViewOnStop();
		}

/* 		public function loadOutStream():void
		{
			// trace("VideoRecorder: loadOutStream");
			out_stream.attachCamera(cam);
			out_stream.attachAudio(mic);
			video.attachCamera(cam);
			dispatchEvent(new RecorderEvent(RecorderEvent.RECORDER_READY,recordTime,true));
		} */

		public function playBack(playFrom:Number,playTo:Number):void
		{
			// trace("VideoRecorder: playBack");
			//in_stream.play("my_recorded_stream_" + _videoPostfix, playFrom, playTo);
			video.attachNetStream(in_stream);
			//trace("video.attachNetStream(in_stream)");
			in_stream.play(streamName);//, -2, -1, true);

		}


        private function handleMicStatus(event:StatusEvent):void {
            //trace("handleMicStatus()");
            // trace("handleMicStatus: " + event, event.target["activityLevel"]);
        }

        private function micActivityHandler(event:ActivityEvent):void {
            // trace("micActivityHandler: " + event, event.target["activityLevel"]);
            //trace("micActivityHandler()");
        }

		private function cameraStatusHandler(event:StatusEvent):void
		{
			dispatchEvent(new RecorderEvent(RecorderEvent.CAMERA_STATUS,recordTime,true));
		}

		private function cameraReadyHandler(event:ActivityEvent):void
		{
			if(!cameraReady && event.activating)
			{
				cameraReady = true;
				dispatchEvent(new RecorderEvent(RecorderEvent.CAMERA_READY,recordTime,true));
			}
		}


		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);

/*

			var videoWidth:Number;
			var videoHeight:Number;

			if (height > width)
			{
				videoWidth = this.width;
				videoHeight = videoWidth * 0.75;
			}
			else
			{
				videoHeight = this.height
				videoWidth = videoHeight * 1.333;
			}
			video.width = videoWidth;
			video.height = videoHeight;

			_videoContainer.width = videoWidth;
			_videoContainer.height = videoHeight; */

		}

		public function dispose():void
		{
			_devicesFound = 0;


			//_micLocator.removeEventListener(Event.COMPLETE, onMicLocatorComplete);
			//_camLocator.removeEventListener(Event.COMPLETE, onCamLocatorComplete);

			if(connection != null)
			{
				connection.removeEventListener(AsyncErrorEvent.ASYNC_ERROR,AsyncErrorHandler);
				connection.removeEventListener(IOErrorEvent.IO_ERROR,IOErrorHandler);
				connection.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,SecurityErrorHandler);
				connection.removeEventListener(NetStatusEvent.NET_STATUS,onNCStatus);
				connection.close();
			}

			if(out_stream != null)
			{
				out_stream.removeEventListener(AsyncErrorEvent.ASYNC_ERROR,AsyncErrorHandler);
		    	out_stream.removeEventListener(IOErrorEvent.IO_ERROR,IOErrorHandler);
				out_stream.removeEventListener(NetStatusEvent.NET_STATUS,outStatusHandler);
				out_stream.close();
			}

			if(in_stream != null)
			{
				in_stream.removeEventListener(AsyncErrorEvent.ASYNC_ERROR,AsyncErrorHandler);
		    	in_stream.removeEventListener(IOErrorEvent.IO_ERROR,IOErrorHandler);
		    	in_stream.removeEventListener(NetStatusEvent.NET_STATUS,inStatusHandler);
		    	in_stream.close();
			}


		    if(_outBufferCheckerTimer != null)
		    {
		    	_outBufferCheckerTimer.removeEventListener(TimerEvent.TIMER,timerHandler);
		    	_outBufferCheckerTimer.stop();
		    }

		    if(video != null)
		    {
			    video.attachNetStream(null);
				video.clear();
		    }

			mic = null;
			cam = null;
			in_stream = null;
			out_stream = null;
			connection = null;
			_outBufferCheckerTimer = null;

			_videoContainer.dispose()

			//video = null;
		}

		public function playEndHandler(event:Event):void
		{
			// trace("playEndHandler");
			in_stream.close();
			dispatchEvent(new RecorderEvent(RecorderEvent.PLAYBACK_STOP,recordTime,true));
			updateViewOnStop();
		}

		public function outStatusHandler(event:NetStatusEvent):void
		{
			switch(event.info.code)
			{
				case "NetStream.Unpublish.Success":
					dispatchEvent(new RecorderEvent(RecorderEvent.RECORD_FINISH, recordTime,true));
					//Alert.show("NetStream.Unpublish.Success");
				break;

				case "NetStream.Buffer.Full":

				break;

				case "NetStream.Buffer.Empty":
					//dispatchEvent(new RecorderEvent(RecorderEvent.STREAMED_BUFFER_EMPTY, recordTime,true));
				break;

				case "NetStream.Record.Stop":
					//Alert.show("NetStream.Record.Stop");
				break;

				case "NetStream.Publish.Start":
					dispatchEvent(new RecorderEvent(RecorderEvent.PUBLISH_START));
				break;

				case "NetStream.Record.Start":
					_startRecordDelta = out_stream.time;
					dispatchEvent(new RecorderEvent(RecorderEvent.RECORD_START,recordTime,true));
					updateViewOnRecordStart();
				break;

				case "NetStream.Record.Stop":
					//dispatchEvent(new RecorderEvent(RecorderEvent.STREAMED_BUFFER_EMPTY, recordTime, true));
				break;
			}
		}

		public function inStatusHandler(event:NetStatusEvent):void
		{
			//trace("in_stream:" + event.info.code);
			switch(event.info.code)
			{
				case "NetStream.Play.InsufficientBW":
				case "NetStream.Buffer.Full":
						if((event.target).bufferLength <= EXPANDED_BUFFER_LENGTH)
							(event.target).bufferTime = 2 * EXPANDED_BUFFER_LENGTH;
						else
							(event.target).bufferTime = EXPANDED_BUFFER_LENGTH;
					/*if(_checkBufferFullToStartPlay)
					{
						_checkBufferFullToStartPlay = false;
						dispatchEvent(new RecorderEvent(RecorderEvent.STREAMED_PLAYBACK_BUFFER_FULL));
					}
					else
					{
						if((event.target).bufferLength < EXPANDED_BUFFER_LENGTH)
							(event.target).bufferTime = 2 * EXPANDED_BUFFER_LENGTH;
						else
							(event.target).bufferTime = EXPANDED_BUFFER_LENGTH;
					}*/
				break;

				case "NetStream.Buffer.Empty":
					(event.target).bufferTime = START_BUFFER_LENGTH;
				break;

				case "NetStream.Play.Start":

					_checkBufferFullToStartPlay = true;
					dispatchEvent(new RecorderEvent(RecorderEvent.PLAYBACK_START, recordTime, true));
					updateViewOnPlayStart();

				break;

				case "NetStream.Play.Stop":
					//stopViewTimer();
				break;
			}
		}

		private function disconnect():void
		{
			connection.removeEventListener(AsyncErrorEvent.ASYNC_ERROR,		AsyncErrorHandler);
			connection.removeEventListener(IOErrorEvent.IO_ERROR,				IOErrorHandler);
			connection.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,	SecurityErrorHandler);
			connection.removeEventListener(NetStatusEvent.NET_STATUS,			onNCStatus);
			connection.close();
			connection = null;
		}

		private function AsyncErrorHandler(event:AsyncErrorEvent):void
		{
			Alert.show("error: " + event.error + " text: " + event.text);
		}

		private function IOErrorHandler(event:IOErrorEvent):void
		{
			Alert.show("error: " +event.text);
		}

		private function SecurityErrorHandler(event:SecurityErrorEvent):void
		{
			Alert.show("error: " + event.text);
		}

		//getters & setters
		////////////////////////////////////////////////////////////////////
		public function get recordQualty():Number
		{
			return cam.quality;
		}

		public function set recordQualty(quality:Number):void
		{
			cam.setQuality(0, quality);
		}

		private function updateViewOnPlayStart():void
		{
			startViewTimer();
			_videoContainer.videoStatus = VideoContainer.PLAYING;
			//startSampleTime(in_stream);
		}

		private function updateViewOnRecordStart():void
		{
			startViewTimer();
			_videoContainer.videoStatus = VideoContainer.RECORDING;
			//startSampleTime(out_stream);
		}

		private function updateViewOnStop():void
		{
			//stopSampleTime()
			stopViewTimer();
			_videoContainer.videoStatus = VideoContainer.STOP;
		}

/* 		private function startSampleTime(ns:NetStream):void
		{
			_nsTimeSamplerId = setInterval(
										function():void
										{
											trace("buffer: ", in_stream.bufferLength);
											_videoContainer.videoTime = ns.time;
										}
										, 500);
		}
		private function stopSampleTime():void
		{
			clearInterval(_nsTimeSamplerId);
		}
		*/
		//view timer handling
		private function stopViewTimer():void
		{
			_viewTimer.reset();
		}

		private function startViewTimer():void
		{
			_viewTimer.start();
		}
	}
}
