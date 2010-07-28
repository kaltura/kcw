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

	public class NotifyShellEvent extends ChainEvent
	{
		public static const CLOSE_WIZARD_NOTIFICATION:String 	= "com.adobe_cw.adobe.cairngorm.control.CairngormEvent.NotifyShellEvent.closeWizardNotification";
		public static const ADD_ENTRY_NOTIFICATION:String 		= "com.adobe_cw.adobe.cairngorm.control.CairngormEvent.NotifyShellEvent.addEntryNotification";
		public static const WIZARD_READY_NOTIFICATION:String 	= "com.adobe_cw.adobe.cairngorm.control.CairngormEvent.NotifyShellEvent.wizardReadyNotification";
		public static const PENDING:String 						= "com.adobe_cw.adobe.cairngorm.control.CairngormEvent.NotifyShellEvent.pending";

		public var entryIdList:Array;

		public function NotifyShellEvent(type:String, entryIdList:Array = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			this.entryIdList = entryIdList;
			super(type, bubbles, cancelable);
		}
	}
}