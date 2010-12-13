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
package com.hurlant.math
{
	use namespace bi_internal;
	/**
	 * A "null" reducer
	 */
	public class NullReduction implements IReduction
	{
		public function revert(x:BigInteger):BigInteger
		{
			return x;
		}
		
		public function mulTo(x:BigInteger, y:BigInteger, r:BigInteger):void
		{
			x.multiplyTo(y,r);
		}
		
		public function sqrTo(x:BigInteger, r:BigInteger):void
		{
			x.squareTo(r);
		}
		
		public function convert(x:BigInteger):BigInteger
		{
			return x;
		}
		
		public function reduce(x:BigInteger):void
		{
		}
		
	}
}