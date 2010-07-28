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
package com.kaltura.contributionWizard.events
{
	import com.adobe_cw.adobe.cairngorm.control.CairngormEvent;
	import flash.events.Event;
	import com.kaltura.vo.importees.BaseImportVO;
	import com.kaltura.vo.importees.ImportURLVO;

	public class SoundToggleEvent extends CairngormEvent
	{
		public static const PLAY_SOUND:String = "playSound";
		public static const STOP_SOUND:String	= "stopSound";

		public var importVo:ImportURLVO;

		public function SoundToggleEvent(type:String, importVo:ImportURLVO = null,
				bubbles:Boolean = true, cancelable:Boolean = false):void
		{
			super(type, bubbles, cancelable);
			this.importVo = importVo;

		}

		public override function clone():Event
		{
			return new SoundToggleEvent(type, importVo, bubbles, cancelable);
		}

		public override function toString():String
		{
			return formatToString("type", "importVo", "bubbles", "cancelable", "eventPhase");
		}
	}
}