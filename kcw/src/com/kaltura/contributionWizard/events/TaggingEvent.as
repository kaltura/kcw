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
	import com.bjorn.event.ChainEvent;
	import com.kaltura.vo.MediaMetaDataVO;

	import flash.events.Event;

	public class TaggingEvent extends ChainEvent
	{
		public static const SET_MEDIA_META_DATA:String 		= "setMediaMetaData";
		public static const VALIDATE_ALL_META_DATA:String 	= "validateAllMetaData";
		public static const VALIDATE_TITLE:String 			= "validateTitle";
		public static const VALIDATE_TAGS:String 			= "validateTags";

		public var newMetaDataVo:MediaMetaDataVO;
		public var oldMetaDataVo:MediaMetaDataVO;

		public function TaggingEvent(type:String, newMetaDataVo:MediaMetaDataVO = null, oldMetaDataVo:MediaMetaDataVO = null, bubbles:Boolean = true, cancelable:Boolean = false):void
		{
			super(type, bubbles, cancelable);

			this.newMetaDataVo = newMetaDataVo;
			this.oldMetaDataVo = oldMetaDataVo;
		}

		public override function clone():Event
		{
			return new TaggingEvent(type, newMetaDataVo, oldMetaDataVo, bubbles, cancelable);
		}
		public override function toString():String
		{
			return formatToString("type", "newMetaDataVo", "oldMetaDataVo", "bubbles", "cancelable", "eventPhase");
		}
	}
}