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

	import flash.media.Sound;
	import flash.media.SoundChannel;

	public class SoundPlayState implements ISoundState
	{
		private var context:SoundPlayerContext;

		public function SoundPlayState(context:SoundPlayerContext):void
		{
			this.context = context;
		}

		public function stop():void
		{
			context.sound.stop();
			context.importUrlVo.state.isPlaying = false;
			context.setState(context.getStopState());
		}

		public function play(importUrlVO:ImportURLVO):void
		{
			stop();
			context.playSound(importUrlVO);
		}

	}
}