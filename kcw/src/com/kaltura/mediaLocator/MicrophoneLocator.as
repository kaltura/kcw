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
package com.kaltura.mediaLocator
{
	import flash.events.ActivityEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.StatusEvent;
	import flash.media.Microphone;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.utils.Dictionary;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;

//	import mx.charts.renderers.CircleItemRenderer;

	public class MicrophoneLocator extends EventDispatcher
	{
		public static const INSPECTION_TIMEOUT:int = 3000;
		private static var _mostActiveMic:Microphone;
		private var _microphoneCount:int;
		private var _aMicrophoneDevices:Array = new Array();

		private var dct:Dictionary = new Dictionary();
		private var _dctTimeouts:Dictionary = new Dictionary();

		public function locateActiveDevice():void
		{
			trace("locateActiveDevice()");
			if (_mostActiveMic != null)
			{
				trace("locateActiveDevice() - microphone has been located before");
				dispatchEvent(new Event(Event.COMPLETE));
				return;
			}

			_mostActiveMic = Microphone.getMicrophone();

			var micNames:Array = Microphone.names;
			trace("introspecting microphones...");
			for (var i:int = 0; i < micNames.length; i++)
			{
				var tempNc:NetConnection = new NetConnection();
				tempNc.connect(null);
				var tempNs:NetStream = new NetStream(tempNc);
				var currentMic:Microphone = Microphone.getMicrophone(i);
				trace(currentMic.name);
				dct[tempNc] = tempNs;
				_aMicrophoneDevices.push( currentMic );
				currentMic.addEventListener(StatusEvent.STATUS, 	onMicStatus);
				currentMic.addEventListener(ActivityEvent.ACTIVITY, onMicActivity);
				//waitForMicActivity(currentMic);

				currentMic.setSilenceLevel(0);

				tempNs.attachAudio(currentMic);
			}
		}

		private function onMicStatus(evtStatus:StatusEvent):void
		{
			trace("onMicStatus()", evtStatus.target.name);

			var currentMic:Microphone = evtStatus.target as Microphone;

			//the ActivityEvent may never be dispatched if the microphone is not active, thus it should be count off
			var timeoutId:uint = setTimeout(removeMicActivityListener, INSPECTION_TIMEOUT, currentMic);
			_dctTimeouts[currentMic] = timeoutId;
			//trace(currentMic.activityLevel, MicrophoneLocator._mostActiveMic.activityLevel);
			//currentMic.removeEventListener(StatusEvent.STATUS, onMicStatus);
			if (evtStatus.code == "Microphone.Muted")
			{
				dispatchEvent(new MediaDisabledEvent(MediaDisabledEvent.MICROPHONE_DISABLED));
			}

		}
		/**
		 * Checks if microphone's activityLevel property is above -1, if so, the activityLevel is compared with MicrophoneLocator._mostActiveMic.activityLevel
		 * @param mic
		 * @return true if the passed Microphone object's activityLevel is above -1
		 *
		 */
		private function checkMicActivityLevel(mic:Microphone):void
		{
			trace("checkMicActivityLevel()", mic.name, mic.activityLevel);
			trace(_mostActiveMic.name, _mostActiveMic.activityLevel);
			if (mic.activityLevel > -1) //the mic is active
			{
				if (mic.activityLevel > _mostActiveMic.activityLevel) //the mic is more active than the most active mic
				{
					_mostActiveMic = mic;
				}

				countOffMic(mic); //the mic gave a signal, and it was compared to the most active mic, so it can be counted off
				//the mic transmits some signals and it can be used
			}
			// the mic is not active
		}

		private function countOffMic(mic:Microphone):void
		{
			var indexOfMic:int = _aMicrophoneDevices.indexOf(mic);
			if ( indexOfMic != -1)
			{
				_aMicrophoneDevices.splice(indexOfMic, 1);
				clearTimeout(_dctTimeouts[mic]);
			}

			if (_aMicrophoneDevices.length == 0)
			{
				trace("microphone locator done");
				dispatchEvent(new Event(Event.COMPLETE));
			}
		}

	/* 	private function waitForMicActivity(mic:Microphone):void
		{
			mic.addEventListener(ActivityEvent.ACTIVITY, onMicActivity);

			//the ActivityEvent may never be dispatched if the microphone is not active, thus it should be count off
			//setTimeout(removeMicActivityListener, MicrophoneLocator.INSPECTION_TIMEOUT, mic);
		} */
		private function removeMicActivityListener(mic:Microphone):void
		{
			mic.removeEventListener(ActivityEvent.ACTIVITY, onMicActivity);
			countOffMic(mic); //the mic is not responding, count it off
		}

		private function onMicActivity(evtActivity:ActivityEvent):void
		{
			var targetMic:Microphone = evtActivity.target as Microphone;
			//currentMic.removeEventListener(ActivityEvent.ACTIVITY, onMicActivity);
			checkMicActivityLevel(targetMic);
		}

		public function get mostActiveMic():Microphone
		{
			return _mostActiveMic;
		}
	}

}