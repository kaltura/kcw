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
	import com.kaltura.vo.importees.ImportURLVO;
	
	import flash.net.URLVariables;
	
	/**
	 * This class is used for decoding import url values to url variables that will be send to the server
	 * @author Michal
	 * 
	 */	
	public class ImportURLDecoder
	{
		/**
		 * This function decodes values from a given valueObject and adds the suitable urlVars according to the given index  
		 * @param valueObject the object containing values to decode
		 * @param index the index of the request of the current values to decode
		 * @param urlVars the urlVars that the new variables will be added to
		 * 
		 */	
		public static function addUrlVars(valueObject:IValueObject, index:int, urlVars:URLVariables):void
		{
			BaseImportDecoder.addUrlVars(valueObject, index, urlVars);
			var importURLVO:ImportURLVO = valueObject as ImportURLVO;
			
			urlVars[index + ":service"] 				= Services.SERVICE_MEDIA;
			urlVars[index + ":action"] 					= Services.ACTION_ADD_FROM_SEARCH_RESULT;
			urlVars[index + ":searchResult:url"] 		= importURLVO.fileUrl;
			urlVars[index + ":searchResult:thumbUrl"]	= importURLVO.thumbURL;
			urlVars[index + ":searchResult:sourceLink"]	= importURLVO.sourceLink;
			urlVars[index + ":searchResult:credit"]		= importURLVO.credit;
			urlVars[index + ":searchResult:id"]			= importURLVO.uniqueID;
		}
	}
}