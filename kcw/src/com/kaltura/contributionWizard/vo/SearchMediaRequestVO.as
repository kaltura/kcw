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
package com.kaltura.contributionWizard.vo
{
	import com.adobe.cairngorm.vo.IValueObject;
	import com.kaltura.contributionWizard.vo.providers.MediaProviderVO;

	/**
	 * Describes a search media request value object.
	 * The SearchMediRequestVO object defines a search information required for a search request.
	 *
	 */

	[Bindable]
	dynamic public class SearchMediaRequestVO implements IValueObject
	{

		public var searchTerms:String;
		public var authenticationKey:String;

		public var pageNum:int;

		public var mediaProviderVo:MediaProviderVO;

		public function SearchMediaRequestVO(searchTerms:String, pageNum:int, pageSize:int, mediaProviderVo:MediaProviderVO)
		{
			this.pageNum = pageNum;
			this.searchTerms = searchTerms;
			this.pageSize = pageSize;
			this.mediaProviderVo = mediaProviderVo;
		}

	}
}