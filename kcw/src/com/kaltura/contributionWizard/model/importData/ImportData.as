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
package com.kaltura.contributionWizard.model.importData
{
	import com.kaltura.contributionWizard.vo.CreditsVO;

	import de.polygonal.ds.ArrayedQueue;

	[Bindable]
	public class ImportData
	{
		public var importCart:ImportCart = new ImportCart();

		/**
		 *Indicates of any entries has been added for the current contribution cycle.
		 * The wizard may be configured for a multiple or single contributions. single contribution is where the suer can only add entries once.
		 * When the wizard is configured for single contribution, the hasEntriesAddedPerSession will remain false forever.
		 */
		public var hasEntriesAddedPerSession:Boolean;
		public var hasEntriesAddedPerLifetime:Boolean;
		public var creditsVo:CreditsVO;

		public function set uploadQueue(queue:ArrayedQueue):void
		{
			_uploadQueue = queue;
		}
		public function get uploadQueue():ArrayedQueue
		{
			return _uploadQueue;
		}

		//The reason why I didn't choose to call it isMediaInfoReceived is because media info is not always needed and that might be confusing
		public var isMediaInfoExist:Boolean = false;

		public var userAgreedToTerms:Boolean = false;
		private var _uploadQueue:ArrayedQueue;

	}
}