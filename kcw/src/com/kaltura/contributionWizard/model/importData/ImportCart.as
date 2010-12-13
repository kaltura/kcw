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
	import com.kaltura.vo.importees.BaseImportVO;
	import com.kaltura.vo.importees.ImportFileVO;
	import com.kaltura.vo.importees.UploadStatusTypes;
	
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import mx.collections.ArrayCollection;

	[Bindable]
	public class ImportCart
	{

		public var isAddingEntries:Boolean = false;

		public var importItemsArray:ArrayCollection = new ArrayCollection();
		/**
		* The import item that is currently being proccessed.
		* "Proccess" can be any kind of action that is being applied to any kind of BaseImportVO object.
		* This is a marker variables to enable the view to show information of the proccessed file (for example, the currently uploaded file)
		*/
		public var currentlyProcessedImportVo:BaseImportVO;

		public var isCartEmpty:Boolean = true;

		public var uploadStatus:String = UploadCartStatusTypes.NOT_READY;

		public var invalidItemVoList:Array = [];

		private var _lastItem:BaseImportVO;

		public function get isMetaDataValid():Boolean
		{
			return _isMetaDataValid;
		}
		public function set isMetaDataValid(value:Boolean):void
		{
			_isMetaDataValid = value;
		}
		private var _isMetaDataValid:Boolean = true;

		public function addImportItem(importItemVO:BaseImportVO):void
		{
			importItemsArray.addItem(importItemVO);
			checkCartEmpty();

			if (importItemVO is ImportFileVO)
				checkUploadStatus();
		}

		public function removeImportItem(importItemVO:BaseImportVO):void
		{
			var itemIndex:int = importItemsArray.getItemIndex(importItemVO);
			if (itemIndex == -1) throw new Error("Import item not found and cannot be removed");
			importItemVO.state.isSelected = false; //uses to notify binded components such as search results to unselect this file
			importItemsArray.removeItemAt( itemIndex );
			checkCartEmpty();

			if (importItemVO is ImportFileVO)
				checkUploadStatus();

			removeInvalidItem(importItemVO);
		}

		public function clearCart():void
		{
			importItemsArray.source = [];
			checkCartEmpty();
		}
		
		public function leaveLast():void{
			if(importItemsArray.length)
			{
				var lastItem:BaseImportVO = importItemsArray.getItemAt(importItemsArray.length - 1) as BaseImportVO;
				if (lastItem && lastItem is ImportFileVO)
				{
					importItemsArray.source.splice(0, importItemsArray.source.length - 1);
				}
				else
				{
					for each(var item:BaseImportVO in importItemsArray)
					{
						item.state.isSelected = false;
						//removeImportItem(item);
					}
					clearCart();
					lastItem.state.isSelected = true;
					addImportItem(lastItem);
				}
			}
			trace("importItemsArray.length: " + importItemsArray.length);
		}
		
		
		private function checkCartEmpty():void
		{
			isCartEmpty = importItemsArray.length == 0;
		}

		private function checkUploadStatus():void
		{
			for each( var importFileVo:BaseImportVO in importItemsArray)
			{
				if (importFileVo is ImportFileVO)
				//if (importFileVo && importFileVo.uploadStatus != UploadStatusTypes.UPLOAD_COMPLETE)
				{
					if ((importFileVo as ImportFileVO).uploadStatus != UploadStatusTypes.UPLOAD_COMPLETE) return;
				}
			}
			uploadStatus = UploadCartStatusTypes.COMPLETE;
		}


		public function addInvalidItem(importItemVo:BaseImportVO):void
		{
			invalidItemVoList.push(importItemVo);
			if (invalidItemVoList.length == 1)
				isMetaDataValid = false
		}

		public function removeInvalidItem(importItemVo:BaseImportVO):void
		{
			var itemIdx:int = invalidItemVoList.indexOf(importItemVo);
			if (itemIdx != -1)
			{
				invalidItemVoList.splice(itemIdx, 1);
				if (invalidItemVoList.length == 0)
					isMetaDataValid = true;
			}
		}

	}
}
