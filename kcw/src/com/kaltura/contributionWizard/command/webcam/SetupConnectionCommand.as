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
	import com.kaltura.contributionWizard.model.WebcamModelLocator;
	import com.kaltura.contributionWizard.model.WizardModelLocator;
	import com.kaltura.contributionWizard.view.importViews.webcam.controler.NetClient;
	
	import flash.events.AsyncErrorEvent;
	import flash.events.IOErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.NetConnection;
	import flash.net.ObjectEncoding;
	
	import mx.controls.Alert;

	public class SetupConnectionCommand extends ModuleSequenceCommand
	{
		[Bindable]
		private var _wizardModel:WizardModelLocator = WizardModelLocator.getInstance();
		[Bindable]
		private var _webcamModel:WebcamModelLocator = WebcamModelLocator.getInstance();
		
		private var _connection:NetConnection = new NetConnection();
		
		public override function execute(event:CairngormEvent):void
		{
			nextEvent = (event as AbstractModuleEvent).nextSequenceEvent;
			NetConnection.defaultObjectEncoding = ObjectEncoding.AMF0;
			_webcamModel.connection = _connection;
			var rtmpServerUrl:String = _wizardModel.mediaProviders.activeMediaProvider.customData.serverUrl;
			
			_connection.addEventListener(NetStatusEvent.NET_STATUS,			connectionNetStatusHandler);
			_connection.addEventListener(AsyncErrorEvent.ASYNC_ERROR,		connectionAsyncErrorHandler);
			_connection.addEventListener(IOErrorEvent.IO_ERROR,				connectionIoErrorHandler);
			_connection.addEventListener(SecurityErrorEvent.SECURITY_ERROR,	connectionSecurityErrorHandler);
			_connection.client = new NetClient();
			_connection.connect(rtmpServerUrl);
			
		}
		
		private function connectionNetStatusHandler(event:NetStatusEvent):void
		{
			if(event.info.code == "NetConnection.Connect.Success") 
			{
					executeNextCommand();
					//_outBufferCheckerTimer = new Timer(50,0);
					//_outBufferCheckerTimer.addEventListener(TimerEvent.TIMER,timerHandler);
					 
					//createNewOutNetStream();
					//createNewInNetStream();
						
				   	/* _camLocator.addEventListener(Event.COMPLETE, onCamLocatorComplete);
					_camLocator.locateActiveDevice();
					_micLocator.addEventListener(Event.COMPLETE, onMicLocatorComplete);
					_micLocator.locateActiveDevice(); */
			}
		}
		
		private function connectionAsyncErrorHandler(event:AsyncErrorEvent):void
		{
			Alert.show("asynch error: " + event.error + " text: " + event.text);
		}
		
		private function connectionIoErrorHandler(event:IOErrorEvent):void
		{
			Alert.show("io error: " +event.text);
		}
		
		private function connectionSecurityErrorHandler(event:SecurityErrorEvent):void
		{
			Alert.show("security error: " + event.text);
		}
	}
}