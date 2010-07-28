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
	import com.adobe_cw.adobe.cairngorm.model.IModelLocator;
	import com.kaltura.contributionWizard.view.resources.ResourceBundleNames;
	import com.kaltura.contributionWizard.vo.providers.WebcamParametersVO;
	import com.kaltura.utils.LSOHandler;
	
	import flash.media.Camera;
	import flash.media.Microphone;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	
	import mx.resources.ResourceManager;

	[Bindable]
	public class WebcamModelLocator implements IModelLocator
	{
		private static var _instance:WebcamModelLocator = new WebcamModelLocator();
		public function WebcamModelLocator()
		{
			var errorText:String = ResourceManager.getInstance().getString( ResourceBundleNames.ERRORS, "SINGLETON_ERROR", ["WebcamModelLocator"]);
			if (_instance) throw new Error(errorText);
		}

		public static function getInstance():WebcamModelLocator
		{
			return _instance;
		}

		public var connection:NetConnection;

		public var inStream:NetStream;
		public var outStream:NetStream;

		public var streamName:String;

		public var camera:Camera;
		public var mic:Microphone;

		public var detectingCamera:Boolean = true;

		public var savedCameraNameLso:LSOHandler = new LSOHandler("cameraName");
		public var savedCameraName:String = "  Live! Cam Notebook Pro (VFW)";
		
		public var webcamParameters:WebcamParametersVO			= new WebcamParametersVO();
	}
}