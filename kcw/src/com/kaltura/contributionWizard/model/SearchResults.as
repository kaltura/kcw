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
	import com.kaltura.utils.pager.Pager;

	[Bindable]
	public class SearchResults
	{

		public function SearchResults():void
		{
			resultsFound = true;
		}
		public function get resultsFound():Boolean
		{
			return _resultsFound;
		}
		public function set resultsFound(value:Boolean):void
		{
			_resultsFound = value;
		}

		public var isMediaInfoNeeded:Boolean = false;
		public var pager:Pager = new Pager();

		private var _resultsFound:Boolean = false;
	}
}