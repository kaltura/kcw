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
	public class AuthenticationMethodList implements IValueObject
	{
		private var methodArray:Array = new Array();
		
		public var activeMethod:AuthenticationMethod;
		public var privateMethod:AuthenticationMethod;
		public var publicMethod:AuthenticationMethod;
		public var numMethods:int;
		
		public function setAuthMethodList(list:Array):void
		{
			for each (var authMethod:AuthenticationMethod in list)
			{
				if (authMethod.isPublic)
				{
					publicMethod = authMethod;
				}
				else
				{
					privateMethod = authMethod
				}
				numMethods++;
			}
			activeMethod = list[0] as AuthenticationMethod;
			
		}
		
		public function addMethod(method:AuthenticationMethod):void
		{
			methodArray.push(method);
			activeMethod = methodArray[0];
		}
		
	}
}