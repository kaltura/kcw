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
	import com.kaltura.contributionWizard.vo.providers.MediaProviderVO;

	import flash.events.Event;

	public class MediaProviderEvent extends ChainEvent
	{
		public static const MEDIA_PROVIDER_CHANGE:String = "mediaProviderChange";

		/**
		 * The new selected data provider id.
		 * @param value
		 *
		 */
		public function set mediaProviderVO(mediaProviderVO:MediaProviderVO):void
		{
			_mediaProviderVO = mediaProviderVO;
		}
		public function get mediaProviderVO():MediaProviderVO
		{
			return _mediaProviderVO;
		}

		private var _mediaProviderVO:MediaProviderVO;

		public function MediaProviderEvent(type:String, mediaProviderVO:MediaProviderVO, bubbles:Boolean = true, cancelable:Boolean = false):void
		{
			super(type, bubbles, cancelable);
			_mediaProviderVO = mediaProviderVO;
		}

		public override function clone():Event
		{
			return new MediaProviderEvent(type, mediaProviderVO, bubbles, cancelable);
		}
		public override function toString():String
		{
			return formatToString("type", "mediaProviderVO", "bubbles", "cancelable", "eventPhase");
		}
	}
}