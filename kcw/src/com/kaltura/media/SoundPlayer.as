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
package com.kaltura.media
{
	import com.kaltura.contributionWizard.enums.FlashPlaybackType;

	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundLoaderContext;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.net.URLRequest;

	[Event(name="soundComplete", 	type="flash.events.Event")]
	[Event(name="ioError", 			type="flash.events.IOErrorEvent")]

	public class SoundPlayer extends EventDispatcher
	{
//		private var _sound:Sound;

		private var _ns:NetStream;
		private var _nc:NetConnection;

//		private var _soundChannel:SoundChannel;

//		private var _playerType:String = FlashPlaybackType.AUDIO;

		private var _url:String;

		private var _isPlaying:Boolean = false;

		public function set url(url:String):void
		{
			_url = url;

		}
		public function get url():String
		{
			return _url;
		}

		public function SoundPlayer(url:String = null, context:SoundLoaderContext = null)
		{
			_url = url;
//			if (url) setPlayerType(url);
			createNetStream();
		}

		public function play(flashPlaybackType:String = null):void
		{
			if (_isPlaying) stop();

//			setPlayerType(_url, flashPlaybackType);
//			switch (_playerType)
//			{
//				case FlashPlaybackType.VIDEO:
//				case FlashPlaybackType.AUDIO:
			playFlv();
//				break;
//					playSound();
//				break;
//			}
			_isPlaying = true;
		}

		public function stop():void
		{
//			switch (_playerType)
//			{
//				case FlashPlaybackType.VIDEO:
			stopFlv();
//				break;

//				case FlashPlaybackType.AUDIO:
//					stopSound();
//				break;
//			}
			_isPlaying = false;

		}

		private function playFlv():void
		{
			_ns.play(_url);
			_ns.addEventListener(NetStatusEvent.NET_STATUS, netStreamStatusHandler);
		}


//		private function playSound():void
//		{
//			_sound = new Sound(new URLRequest(_url));
//			_soundChannel = _sound.play();
//			_soundChannel.addEventListener(Event.SOUND_COMPLETE, soundCompleteHandler);
//			_sound.addEventListener(IOErrorEvent.IO_ERROR, soundIoErrorHandler);
//		}

		private function createNetStream():void
		{
			var client:Object = new Object();
			_nc = new NetConnection();
			_nc.connect(null);
			_ns = new NetStream(_nc);
			client.nsMetaDataCallback = function(metaData:Object):void {};
			_ns.client = client;
		}



		private function stopFlv():void
		{
			_ns.close();
			_ns.removeEventListener(NetStatusEvent.NET_STATUS, netStreamStatusHandler);
		}

//		private function stopSound():void
//		{
//			_soundChannel.stop();
//			//check if there is a pending sound that is still being loaded
//			if (_sound.isBuffering || _sound.bytesLoaded < _sound.bytesTotal)
//			{
//				try
//				{
//					_sound.close();
//				}
//				catch(e:Error)
//				{
//					//the sound throws error "Error #2029: This URLStream object does not have a stream opened."
//				}
//			}
//			_soundChannel.removeEventListener(Event.SOUND_COMPLETE, soundCompleteHandler);
//		}

//		private function setPlayerType(url:String, flashPlaybackType:String = null):void
//		{
//			var fileType:String; //flc, mov, mp3, etc.
//			if (flashPlaybackType == null)
//				flashPlaybackType = getPlayerTypeByUrl(url);
//
//			_playerType = flashPlaybackType ||  FlashPlaybackType.AUDIO;
//		}

//		private function getPlayerTypeByUrl(url:String):String
//		{
//			if (!url) return null;
//			var last3Chars:String = url.substr(url.lastIndexOf('.')+1);
//			var playerType:String = last3Chars == "flv" || last3Chars == "mp4" || url.indexOf("extservices/youtubeRedirect?") > -1 ? 
//						 			FlashPlaybackType.VIDEO :
//						 			FlashPlaybackType.AUDIO;
//
//			return playerType;
//		}
		private function netStreamStatusHandler(netStatusEvent:NetStatusEvent):void
		{
			switch (netStatusEvent.info.code)
			{
				case "NetStream.Play.Stop":
					soundComplete();
				break;

				case "NetStream.Play.StreamNotFound":
					dispatchIoError();
				break;
			}
		}

		private function soundIoErrorHandler(evioError:IOErrorEvent):void
		{
			dispatchIoError();
		}

		private function soundCompleteHandler(evtSoundComplete:Event):void
		{
//			soundComplete();
		}

		private function soundComplete():void
		{
			_isPlaying = false;
			dispatchEvent(new Event(Event.SOUND_COMPLETE));
		}

		private function dispatchIoError():void
		{
			dispatchEvent(new IOErrorEvent(IOErrorEvent.IO_ERROR));
		}

	}
}