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
package com.kaltura.contributionWizard.events
{
	import com.bjorn.event.ChainEvent;

	import flash.events.Event;

	public class SearchMediaEvent extends ChainEvent
	{
		public static const SEARCH_MEDIA:String 			= "searchMedia";
		public static const SET_SEARCH_TERMS:String			= "setSearchTerms";
		public static const MODERATE_SEARCH_TERMS:String	= "moderateSearchTerms";

		public function set searchTerms(terms:String):void
		{
			_searchTerms = terms;
		}
		public function get searchTerms():String
		{
			return _searchTerms;
		}

		public function set pagingDirection(direction:int):void
		{
			_pagingDirection = direction;
		}
		public function get pagingDirection():int
		{
			return _pagingDirection;
		}

		public function set token(value:Object):void
		{
			_token = value;
		}
		public function get token():Object
		{
			return _token;
		}

		private var _searchTerms:String;
		private var _pagingDirection:int;
		private var _token:Object;

		public function SearchMediaEvent(type:String, pagingDirection:int = 0, searchTerms:String = null, token:Object = null,
				bubbles:Boolean = true, cancelable:Boolean = false):void
		{
			super(type, bubbles, cancelable);
			_searchTerms = searchTerms;
			_pagingDirection = pagingDirection;
			_token = token;

		}

		public override function clone():Event
		{
			return new SearchMediaEvent(type, _pagingDirection, _searchTerms, _token, bubbles, cancelable);
		}

		public override function toString():String
		{
			return formatToString("type", "searchTerms", "pagingDirection", "bubbles", "cancelable", "eventPhase");
		}
	}
}