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
	import com.kaltura.contributionWizard.vo.ProviderLoginVO;
	
	/**
	 * This class is used for decoding provider login values to url variables that will be send to the server
	 * @author Michal
	 * 
	 */	
	public class ProviderLoginVoDecoder 
	{
		/**
		 * This function decodes values from a given valueObject and adds the suitable urlVars 
		 * @param valueObject the object containing values to decode
		 * @param urlVars the urlVars that the new variables will be added to
		 * 
		 */	
		public static function addUrlVars(providerLoginVo:ProviderLoginVO, urlVars:URLVariables):void
		{
			urlVars["media_source"]	= providerLoginVo.providerCode;
			urlVars["username"]		= providerLoginVo.username;
			urlVars["password"]		= providerLoginVo.password;
		}
	}
}