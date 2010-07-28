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

	import mx.resources.ResourceManager;

	[Bindable]
	//TODO: move all upload logic from the wizard model locator to this class
	public class UploadModelLocator implements IModelLocator
	{

		private static var _instance:UploadModelLocator = new UploadModelLocator();
		public function UploadModelLocator()
		{
			var errorText:String = ResourceManager.getInstance().getString( ResourceBundleNames.ERRORS, "SINGLETON_ERROR", ["UploadModelLocator"]);
			if (_instance) throw new Error(errorText);
		}

		public static function getInstance():UploadModelLocator
		{
			return _instance;
		}

		//public var uploadAddFileErrors:UploadErrors = new UploadErrors();
		public var addFileErrorType:String;
		//public var uploadAddFileErrors:Array = new Array();
		public var isUploading:Boolean;
		public var maxFileSize:Number = 1000; //in MB
	}
}