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
package com.kaltura.contributionWizard.command.webcam
{
	import com.adobe_cw.adobe.cairngorm.control.CairngormEvent;
	import com.arc90.modular.AbstractModuleEvent;
	import com.arc90.modular.ModuleSequenceCommand;
	import com.kaltura.mediaLocator.MicrophoneLocator;

	import flash.events.Event;
	import flash.media.Camera;
	import flash.media.Microphone;

	public class LocateMediaCommand extends ModuleSequenceCommand
	{

		//private var _cam:Camera;
		//private var _mic:Microphone;


		//private var _micLocator:MicrophoneLocator = new MicrophoneLocator();
		//private var _camLocator:CameraLocator = new CameraLocator();

		public override function execute(event:CairngormEvent):void
		{
			/* nextEvent = (event as AbstractModuleEvent).nextSequenceEvent;

			_camLocator.addEventListener(Event.COMPLETE, onCamLocatorComplete);
			_camLocator.locateActiveDevice();
			_micLocator.addEventListener(Event.COMPLETE, onMicLocatorComplete);
			_micLocator.locateActiveDevice(); */
		}


		private function onCamLocatorComplete(event:Event):void
		{
/* 			_cam = _camLocator.mostActiveDevice;
			checkComplete(); */
		}

		private function onMicLocatorComplete(event:Event):void
		{
		/* 	_mic = _micLocator.mostActiveMic;
			checkComplete(); */
		}

		private function checkComplete():void
		{/*
			if (_cam && _mic)
			{
				executeNextCommand();
			} */
		}

	}
}