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
package com.kaltura.contributionWizard.util
{
	import com.kaltura.vo.importees.BaseImportVO;


	public class MediaSourceDataInjector
	{
		/**
		 * Injects the service info into each of the BaseImportVO objects on the Array.
		 * That enabled the BaseImportVO objects to be associated with the media provider which delivered them,
		 * which is an information that is essential upon adding them as entries.
		 * @param searchResults
		 *
		 */
		public static function injectToList(importItemsList:Array, mediaProviderCode:String, mediaTypeCode:int):void
		{
			for each(var importItemVO:BaseImportVO in importItemsList)
			{
				//if (!importItemVO.mediaProviderCode) //if the media provider code wasn't received by the search service
					injectToSingleItem(importItemVO, mediaProviderCode, mediaTypeCode);
			}
		}

		public static function injectToSingleItem(importItemVO:BaseImportVO, mediaProviderCode:String, mediaTypeCode:int):void
		{
			importItemVO.mediaProviderCode = mediaProviderCode;
			importItemVO.mediaTypeCode = mediaTypeCode;
		}
	}
}