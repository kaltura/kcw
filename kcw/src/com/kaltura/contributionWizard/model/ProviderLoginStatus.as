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
package com.kaltura.contributionWizard.model
{
	import flash.events.EventDispatcher;

	import mx.binding.utils.ChangeWatcher;
	import mx.events.PropertyChangeEvent;

	[Bindable]
	public class ProviderLoginStatus extends EventDispatcher
	{
		public static const LOGIN_URL_AVAILABLE:String 	= "loginUrlAvailable";
		public static const LOGIN_SUCCESS:String 		= "loginSuccess";
		public static const LOGIN_FAILED:String 		= "loginFailed";
		public static const LOGIN_NOT_SENT:String 		= "loginNotSent";

		public var isPending:Boolean = false;

		public function ProviderLoginStatus():void
		{
			ChangeWatcher.watch(this, "loginStatus",
													function(e:PropertyChangeEvent):void
													{
														trace(e.oldValue, e.newValue);
													}
								);
		}

		public function set loginStatus(status:String):void
		{
			_loginStatus = status;
		}
		public function get loginStatus():String
		{
			return _loginStatus;
		}
		private var _loginStatus:String;
	}
}