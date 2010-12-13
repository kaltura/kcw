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

package com.kaltura.contributionWizard.view.importViews
{
	import com.kaltura.contributionWizard.vo.providers.MediaProviderVO;
	import com.kaltura.utils.IDisposable;
	
	import mx.collections.ArrayCollection;

	public interface IImportModule extends IDisposable, IImportStep
	{
		/**
		 *Called when the import view is being activated.
		 * Import view activation happens whenever the active media provider MediaProviderVO changes while the import view is selected.
		 * A sample use case: the user navigates from the upload view to the Kaltura search view.
		 * At this point the activate() method of the search view is invoked.
		 * Now, if the user selects another media provider with the same immport view (e.g. you tube search) the activate method is re-invoked
		 */
		function activate():void;

		function deactivate():void;
		function mediaProviderChange(mediaProviderVo:MediaProviderVO):void;

		function get importItems():ArrayCollection;
		function set importItems(value:ArrayCollection):void;

		//function get importType():String;
	}
}