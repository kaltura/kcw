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
package com.kaltura.contributionWizard.business.factories.serialization.importUrlVo.concrete
{
	import com.adobe.cairngorm.vo.IValueObject;
	import com.kaltura.contributionWizard.business.Services;
	import com.kaltura.vo.importees.ImportFileVO;
	
	import flash.net.URLVariables;
	
	/**
	 * This class is used for decoding import files values to url variables that will be send to the server 
	 * @author Michal
	 * 
	 */	
	public class ImportFileDecoder 
	{
		/**
		 * 
		 * This function decodes values from a given valueObject and adds the suitable urlVars according to the given index  
		 * @param valueObject the object containing values to decode
		 * @param index the index of the request of the current values to decode
		 * @param urlVars the urlVars that the new variables will be added to
		 * 
		 */	
		public static function addUrlVars(valueObject:IValueObject, index:int, urlVars:URLVariables):void
		{
			
			var importFileVO:ImportFileVO = valueObject as ImportFileVO;
			var mediaType:int = importFileVO.mediaTypeCode;
			
			if(mediaType == 1 || mediaType == 2 || mediaType == 5) //Video, Audio, Image
			{
				BaseImportDecoder.addUrlVars(valueObject, index, urlVars);
				urlVars[index + ":service"] = Services.SERVICE_MEDIA;
			}
			else
			{
				BaseImportEnrtyDecoder.addUrlVars(valueObject, index, urlVars);
				urlVars[index + ":service"] = Services.SERVICE_BASE_ENTRY;
				
				//Overriding baseVO mediaEntry
				var deleteKeys:Array = [];
				for(var key:String in urlVars)
				{
					if(key.indexOf("mediaEntry") > -1)
					{
						var value:String = urlVars[key];
						deleteKeys.push(key);
						var newKey:String = key.replace("mediaEntry", "entry");
						urlVars[newKey] = value;
					}
				} 
				
				for(var i:int = 0; i < deleteKeys.length; i++)
				{
					delete urlVars[deleteKeys[i]];
				}
			}
			
			if(importFileVO.mediaProviderCode != "2") 
			{
				urlVars[index + ":action"] 					= Services.ACTION_ADD_FROM_UPLOADED_FILE;
				urlVars[index + ":uploadTokenId"]			= importFileVO.token;
				/*urlVars["entry" + index + "_filename"]		= importFileVO.fileName;
				urlVars["entry" + index + "_realFilename"] 	= importFileVO.fileExtension;*/
			}
			else //Webcam
			{
				urlVars[index + ":action"] 					= Services.ACTION_ADD_FROM_RECORDED_WEBCAM;
				urlVars[index + ":webcamTokenId"]			= importFileVO.fileName;
			}
			
		}
	}
}