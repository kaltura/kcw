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
package com.kaltura.contributionWizard.command
{
	import com.adobe_cw.adobe.cairngorm.commands.ICommand;
	import com.adobe_cw.adobe.cairngorm.control.CairngormEvent;
	import com.kaltura.contributionWizard.events.TaggingEvent;
	import com.kaltura.contributionWizard.model.WizardModelLocator;
	import com.kaltura.vo.MediaMetaDataVO;

	public class SetMetaDataCommand implements ICommand
	{
		private var _model:WizardModelLocator = WizardModelLocator.getInstance();

		public function execute(event:CairngormEvent):void
		{
			var evtSetMetaData:TaggingEvent = event as TaggingEvent;
			//var metaDataDic:Dictionary = evtSetMetaData.metaDataDictionary;
			var newMetaDataVo:MediaMetaDataVO = evtSetMetaData.newMetaDataVo;
			var oldMetaDataVo:MediaMetaDataVO = evtSetMetaData.oldMetaDataVo;
			oldMetaDataVo.mergeWith(newMetaDataVo);
		}

		/*
		Receives a metadata tags dictionary that consist of old MediaMetaData (which are the meta data of the WizardModelLocator's items to import)
		and new MediaMetaData objects.
		Where the old object is the key and the new object is the value.
		The function then merges the new MediaMetaData object into the old MediaMetaData object.
		*/
/* 		private function mergeMetaData(metaDataDictionary:Dictionary):void
		{
			for (var oldMetaDataIterator:Object in metaDataDictionary)
			{
				var oldMetaData:MediaMetaDataVO = oldMetaDataIterator as MediaMetaDataVO;
				var newMetaData:MediaMetaDataVO = metaDataDictionary[oldMetaData];

				oldMetaData.mergeWith(newMetaData);
			}
		} */

	}
}