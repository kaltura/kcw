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
	import com.kaltura.vo.importees.BaseImportVO;
	import flash.net.URLVariables;
	import com.adobe.cairngorm.vo.IValueObject;

	/**
	 * This class is used for decoding media entry values to url variables that will be send to the server
	 * @author Michal
	 * 
	 */	
	public class BaseImportDecoder
	{
		/**
		 * This function decodes values from a given valueObject and adds the suitable urlVars according to the given index  
		 * @param valueObject the object containing values to decode
		 * @param index the index of the request of the current values to decode
		 * @param urlVars the urlVars that the new variables will be added to
		 * 
		 */		
		internal static function addUrlVars(valueObject:IValueObject, index:int, urlVars:URLVariables):void
		{
			var baseImportVO:BaseImportVO = valueObject as BaseImportVO;
			urlVars[index + ":mediaEntry:mediaType"]	= baseImportVO.mediaTypeCode;
			//urlVars["entry" + index + "_source"] 	= baseImportVO.mediaProviderCode;
			urlVars[index + ":searchResult:searchSource"] 	= baseImportVO.mediaProviderCode;
			//TODO: make a separate URLVarsDecoder for the MediaMetaData
			urlVars[index + ":mediaEntry:tags"]		= baseImportVO.metaData.tags;
			//The dispalyed name on the show, it doesn't have to be unique
			urlVars[index + ":mediaEntry:name"] 		= baseImportVO.metaData.title;
			if (baseImportVO.metaData.description && baseImportVO.metaData.description != "")
				urlVars[index + ":mediaEntry:description"] 	= baseImportVO.metaData.description;
			if (baseImportVO.metaData.category && baseImportVO.metaData.category != "")
				urlVars[index + ":mediaEntry:categories"] 	= baseImportVO.metaData.category;
			if (baseImportVO.metaData.partnerData && baseImportVO.metaData.partnerData != "")
				urlVars[index + ":mediaEntry:partnerData"] = baseImportVO.metaData.partnerData;
		}
	}
}