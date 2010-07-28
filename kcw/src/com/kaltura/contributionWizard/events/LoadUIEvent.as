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
	import com.kaltura.contributionWizard.vo.UIConfigVO;

	public class LoadUIEvent extends ChainEvent
	{
		public static const LOAD_LOCALE:String = "loadLocale";
		public static const LOAD_STYLE:String = "loadStyle";
		private var _uiConfigVo:UIConfigVO;
		
		public function set uiConfigVo(uiConfigVo:UIConfigVO):void
		{
			_uiConfigVo = uiConfigVo;
		} 
		
		public function get uiConfigVo():UIConfigVO
		{
			return _uiConfigVo;
		}
		
		public function LoadUIEvent(type:String, uiConfigVo:UIConfigVO, bubbles:Boolean = true, cancelable:Boolean = false):void
		{
			super(type, bubbles, cancelable);
			_uiConfigVo = uiConfigVo;
		}
	}
}