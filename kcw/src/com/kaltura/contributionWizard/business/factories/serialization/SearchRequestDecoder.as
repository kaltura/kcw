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
package com.kaltura.contributionWizard.business.factories.serialization
{
	import com.adobe.cairngorm.vo.IValueObject;
	import com.kaltura.contributionWizard.vo.SearchMediaRequestVO;

	import flash.net.URLVariables;

	import mx.utils.ObjectUtil;

	/**
	 * This class encodes the given values of a search request to suitable url varaibles that will be send
	 * to the server
	 * @author Michal
	 * 
	 */	
	public class SearchRequestDecoder
	{
		/**
		 * This function decodes the values from the given value object to url variables that suites a search request 
		 * @param valueObject the object contains the values to decode
		 * @param urlVars the url variables that the new variables will be added to
		 * 
		 */	
		public static function addUrlVars(valueObject:IValueObject, urlVars:URLVariables):void
		{
			var searchMediaRequestVO:SearchMediaRequestVO = valueObject as SearchMediaRequestVO;


			//add tokens
			var tokens:Object = searchMediaRequestVO.mediaProviderVo.tokens
			for (var property:String in tokens)
			{
				urlVars[property] = tokens[property]
			}

			urlVars["pager:pageIndex"]			= searchMediaRequestVO.pageNum;
			urlVars["pager:pageSize"] 	= searchMediaRequestVO.pageSize;
			urlVars["search:keyWords"]		= searchMediaRequestVO.searchTerms;

			urlVars["search:mediaType"] 	= searchMediaRequestVO.mediaProviderVo.mediaInfo.mediaCode;
			if (searchMediaRequestVO.mediaProviderVo.providerCode)
			{
				//when the server is not kaltura server, the media source is redundant
				urlVars["search:searchSource"] = searchMediaRequestVO.mediaProviderVo.providerCode;
			}
			var authData:String = searchMediaRequestVO.mediaProviderVo.authMethodList.activeMethod.key || searchMediaRequestVO.mediaProviderVo.authMethodList.activeMethod.externalAuthUrl;
			if (authData)
			{
				urlVars["auth_data"] = authData;
			}
		}
	}
}