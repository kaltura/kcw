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
package com.kaltura.contributionWizard.command
{
	import com.adobe_cw.adobe.cairngorm.commands.ICommand;
	import com.adobe_cw.adobe.cairngorm.control.CairngormEvent;
	import com.kaltura.contributionWizard.events.ExternalInterfaceEvent;

	import flash.external.ExternalInterface;

	import mx.managers.SystemManager;

	public class CallExternalInterfaceCommand implements ICommand
	{
		public function execute(event:CairngormEvent):void
		{
			var evtCallExternalInterface:ExternalInterfaceEvent = event as ExternalInterfaceEvent;
			var functionName:String = evtCallExternalInterface.functionName;
			var args:Array = evtCallExternalInterface.arguments;
			if (ExternalInterface.available)
			{
				trace("External interface - calling '" + functionName + "()' \n arguments: " + args );
				if (args)
				{
					ExternalInterface.call(functionName, args);
				}
				else
				{
					ExternalInterface.call(functionName);
				}

			}
			else
			{
				trace("External interface is not available");
			}
		}
	}
}