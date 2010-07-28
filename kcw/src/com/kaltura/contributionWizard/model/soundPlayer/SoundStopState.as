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
package com.kaltura.contributionWizard.model.soundPlayer
{
	import com.kaltura.vo.importees.ImportURLVO;

	import flash.events.Event;
	import flash.events.IOErrorEvent;

	public class SoundStopState implements ISoundState
	{
		private var context:SoundPlayerContext;

		public function SoundStopState(context:SoundPlayerContext):void
		{
			this.context = context;
		}

		public function stop():void
		{
			//do nothing
		}

		public function play(importUrlVo:ImportURLVO):void
		{
			var soundUrl:String = importUrlVo.fileUrl;
			context.sound.url = soundUrl;
			context.sound.play(importUrlVo.flashPlaybackType);
			context.sound.addEventListener(IOErrorEvent.IO_ERROR, contextSound_ioErrorHandler);
			context.sound.addEventListener(Event.SOUND_COMPLETE, soundCompleteHandler);
			importUrlVo.state.isPlaying = true;

			context.setState(context.getPlayState());
		}

		private function contextSound_ioErrorHandler(evtIoError:IOErrorEvent):void
		{
			trace("Sound loading error");
		}

		private function soundCompleteHandler(soundComplete:Event):void
		{
			context.stopSound();
		}

	}
}