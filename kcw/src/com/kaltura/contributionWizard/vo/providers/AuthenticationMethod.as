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
package com.kaltura.contributionWizard.vo.providers
{
	import com.adobe.cairngorm.vo.IValueObject;

	[Bindable]
	public class AuthenticationMethod implements IValueObject
	{
		public var searchable:Boolean = true;

		public var isPublic:Boolean;

		public var externalAuthUrl:String;

		public function set methodType(methodType:int):void
		{
			_methodType = methodType
			isPublic = _methodType == AuthentcationMethodTypes.AUTH_METHOD_PUBLIC;
		}
		public function get methodType():int
		{
			return _methodType;
		}

		public function get key():String
		{
			return _key;
		}
		public function set key(value:String):void
		{
			_key = value
		}

		public function AuthenticationMethod(methodType:int = -1):void
		{
			this.methodType = methodType;
		}

		private var _methodType:int;

		private var _key:String = null;

	}
}