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
package com.kaltura.contributionWizard.business.factories
{
	import com.kaltura.contributionWizard.enums.FlashPlaybackType;
	import com.kaltura.vo.importees.ImportURLVO;


	public class SearchResultsFactory
	{
		public static function buildSearchResultsArray(xmllSearchResults:XMLList):Array
		{
			var searchResultsArray:Array = new Array();
			for each (var xmlSingleResult:XML in xmllSearchResults)
			{
				var importUrlVo:ImportURLVO;// = new BaseImportVO();
				importUrlVo = buildSingleimportUrlVo(xmlSingleResult, importUrlVo);
				searchResultsArray.push(importUrlVo);
			}
			return searchResultsArray;

		}

		public static function buildSingleimportUrlVo(xmlSearchResult:XML, importUrlVo:ImportURLVO):ImportURLVO
		{
			var importUrlVo:ImportURLVO = new ImportURLVO();

			if (xmlSearchResult.thumbUrl.toString() != "")
				importUrlVo.thumbURL = xmlSearchResult.thumbUrl;

			if (xmlSearchResult.url.toString() != "")
				importUrlVo.fileUrl = xmlSearchResult.url;

			if (xmlSearchResult.sourceLink.toString() != "")
				importUrlVo.sourceLink = xmlSearchResult.sourceLink;

			if (xmlSearchResult.id.toString() != "")
				importUrlVo.uniqueID	= xmlSearchResult.id;

			if (xmlSearchResult.title.toString() != "")
				importUrlVo.metaData.title = xmlSearchResult.title;

			if (xmlSearchResult.description.toString() != "")
				importUrlVo.metaData.description = xmlSearchResult.description;

			if (xmlSearchResult.tags.toString() != "")
				importUrlVo.metaData.tags = xmlSearchResult.tags;

			if (xmlSearchResult.credit.toString() != "")
				importUrlVo.credit = xmlSearchResult.credit;

			if (xmlSearchResult.licenseType.toString() != "")
				importUrlVo.license = xmlSearchResult.licenseType;

			if (xmlSearchResult.searchSource.toString() != "")
				importUrlVo.mediaProviderCode = xmlSearchResult.searchSource;

 			if (xmlSearchResult.flash_playback_type.toString() != "")
				importUrlVo.flashPlaybackType = xmlSearchResult.flashPlaybackType;

			return importUrlVo;
		}
	}
}