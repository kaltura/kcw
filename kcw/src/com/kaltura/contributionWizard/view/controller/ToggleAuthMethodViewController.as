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
package com.kaltura.contributionWizard.view.controller
{
   import flash.events.Event;
   import com.kaltura.contributionWizard.events.ViewControllerEvent;

   [Event(name="showAuthenticationScreen" ,type="flash.events.Event")]
   
	public class ToggleAuthMethodViewController extends ViewController
	{
		public static const SHOW_AUTHENTICATION_SCREEN:String = "showAuthenticationScreen";
		
      	public function ToggleAuthMethodViewController():void
      	{
			addListener(ViewControllerEvent.NOT_LOGGED_IN, notLoggedHandler);
		}
		
		private function notLoggedHandler(evtNotLogged:ViewControllerEvent):void 
		{
			var event:Event = new Event(SHOW_AUTHENTICATION_SCREEN)
			dispatchEvent(event);
		}
	}
}