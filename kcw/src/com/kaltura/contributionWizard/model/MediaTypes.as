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
	/**
	 * Defiens the available media types that can be imported.
	 * Each one of the listed constants, can be retrieved by different import types like
	 * "search", "record", etc.
	 *
	 */
	public class MediaTypes
	{
		public static const IMAGE:String 	= "image";
		public static const VIDEO:String 	= "video";
		public static const AUDIO:String 	= "audio";
		public static const DRAWING:String	= "drawing"
		public static const SWF:String		= "swf";
	}
}