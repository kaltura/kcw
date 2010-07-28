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
package com.kaltura.contributionWizard.vo.providers
{
	import com.adobe.cairngorm.vo.IValueObject;
	import com.kaltura.contributionWizard.vo.UIConfigVO;

	[Bindable]
	public class MediaProviderVO implements IValueObject
	{
		/**
		 * Represents the media provider none-unique name, for example Kaltura-videos & Kaltura-images has the same name, "kaltura".
		 * This property is the textual name of the media provider, e.g "kaltura", "youtube", etc..
		 */
		public var providerName:String;

		/**
		 * Exactly the same as the providerName, however, the providerCode value has no textual meaning, if providerName's value is "kaltura" the providerCode is "20"
		 */
		public var providerCode:String;
		
		/**
		 * (3rd party content) If true addSeawrchEntry will be used and entries won't be physically copied to kaltura's server 
		 */
		public var addSearchResult:Boolean;
		/**
		 *This import module swf url.
		 */
		public var moduleUrl:String;
		/**
		 *This media provider name (e.g. "Youtube")
		 */
		//public var name:String;

		/**
		 *A MediaInfo object which aimed to store data related to the type of media supplied by this provider.
		 */
		public var mediaInfo:MediaInfo;// = new ServiceMediaInfo();

		/**
		 *Indicates if a public search is allowed for this media provider
		 */

		public var allowPublicSearch:Boolean = false;

		/**
		 *The available login types for this media provider (most likely public only or public and private)
		 */
		public var authMethodList:AuthenticationMethodList;

		/**
		 *Dynamic custom data for this media provider
		 */
		public var customData:Object;

		/**
		 *UI information such as style sheet module url and locale module url
		 */
		public var uiConfig:UIConfigVO;

		/**
		 *A list key-value defined when creating this MediaProviderVO object.
		 *This tokens list are simply sent back to the server.
		 */
		public var tokens:Object;
	}
}