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
	import com.kaltura.media.SoundPlayer;

	import flash.events.Event;

	public class SoundPlayerContext
	{
		internal var sound:SoundPlayer = new SoundPlayer();
		internal var importUrlVo:ImportURLVO;

		private var currentState:ISoundState;
		private var playState:ISoundState;
		private var stopState:ISoundState;

		public function SoundPlayerContext():void
		{
			playState = new SoundPlayState ( this );
			stopState = new SoundStopState ( this );
			currentState = stopState;
		}


		public function playSound(importUrlVo:ImportURLVO):void
		{
			currentState.play(importUrlVo);
			this.importUrlVo = importUrlVo;
		}

		public function stopSound():void
		{
			currentState.stop();
		}

		internal function getPlayState():ISoundState
		{
			return playState;
		}

		internal function getStopState():ISoundState
		{
			return stopState;
		}

		internal function setState(state:ISoundState):void
		{
			this.currentState = state;
		}

	}
}