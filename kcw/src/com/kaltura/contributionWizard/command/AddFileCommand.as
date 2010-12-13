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
	import com.kaltura.contributionWizard.events.FileReferenceEvent;
	import com.kaltura.contributionWizard.events.ImportEvent;
	import com.kaltura.contributionWizard.model.UploadErrorsTypes;
	import com.kaltura.contributionWizard.model.UploadModelLocator;
	import com.kaltura.contributionWizard.model.WizardModelLocator;
	import com.kaltura.contributionWizard.model.importData.ImportCart;
	import com.kaltura.contributionWizard.model.importData.UploadCartStatusTypes;
	import com.kaltura.contributionWizard.util.MediaSourceDataInjector;
	import com.kaltura.net.PolledFileReference;
	import com.kaltura.vo.importees.ImportFileVO;
	
	import flash.net.FileFilter;
	import flash.net.FileReference;
	
	import mx.utils.UIDUtil;

	public class AddFileCommand implements ICommand
	{
		private var _wizardModel:WizardModelLocator = WizardModelLocator.getInstance();
		private var _uploadModel:UploadModelLocator = UploadModelLocator.getInstance();

		public function execute(event:CairngormEvent):void
		{
 			var evtFilesAdd:FileReferenceEvent = event as FileReferenceEvent;
			var filesList:Array = evtFilesAdd.fileReferenceList;
			addFiles(filesList);
		}

		/**
		 * Creates ImportFileVO objects and adds each of them a given FileReference object and finally adds the ImportFileVO objects to the model's import list.
		 * @param filesList contains FileReference objects
		 *
		 */
		private function addFiles(filesList:Array):void
		{
			var importFileVO:ImportFileVO;
			var importCart:ImportCart = _wizardModel.importData.importCart;
			var filesAdded:Boolean = false;

			//var zeroByteFile:Boolean 	= false;
			//var wrongFileTypes:Boolean 	= false;
			//var fileTooLarge:Boolean 	= false;

			var addFileError:String;

			for each (var fileReference:FileReference in filesList)
			{
				//Start file errors check
				if (isZeroByteFile(fileReference))
				{
					addFileError = UploadErrorsTypes.ZERO_BYTE_FILE;
					continue;
				}
				/*else if (fileSizeExceeds(fileReference))
				{
					addFileError = UploadErrorsTypes.FILE_TOO_LARGE;
					continue;
				}*/

				var fileFilter:FileFilter = _wizardModel.mediaProviders.activeMediaProvider.mediaInfo.allowedFileTypes[0] as FileFilter;
				var fileTypesString:String = fileFilter.extension;

				if (fileTypesString.indexOf(getFileExtension(fileReference) + ";") == -1)
				{
					addFileError = UploadErrorsTypes.WRONG_FILE_TYPE;
					continue;
				}
				//End file errors check

				importFileVO = new ImportFileVO();
				importFileVO.polledfileReference = new PolledFileReference(fileReference);

				importFileVO.fileExtension = "fileExtension." + getFileExtension(fileReference);
				importFileVO.fileName = "file" + UIDUtil.createUID(); //generates a unique name
				importFileVO.metaData.title = fileReference.name;
				injectMediaInfo(importFileVO);
				//importCart.addImportItem(importFileVO);
				
				addToCart(importFileVO);

				filesAdded = true;
			}

			if (filesAdded) _wizardModel.importData.importCart.uploadStatus = UploadCartStatusTypes.READY_TO_UPLOAD;


/* 			if (zeroByteFile)
			{
				addFileError = UploadErrorsTypes.ZERO_BYTE_FILE;
				//_uploadModel.uploadAddFileErrors.addError(UploadErrorsTypes.ZERO_BYTE_FILE);
			}
			else if (fileTooLarge)
			{
				addFileError = UploadErrorsTypes.FILE_TOO_LARGE;
			}

			if (wrongFileTypes)
			{
				addFileError = UploadErrorsTypes.WRONG_FILE_TYPE;
			} */

			if (addFileError)
			{
				_uploadModel.addFileErrorType = addFileError;
				_uploadModel.addFileErrorType = null;
			}
			
		}
		
		private function addToCart(importFileVO:ImportFileVO):void{
			var addEvent:ImportEvent = new ImportEvent(ImportEvent.ADD_IMPORT_ITEM, importFileVO);
			addEvent.dispatch();
		}
		
		private function isZeroByteFile(fileReference:FileReference):Boolean
		{
			try
			{
				var b:Boolean = fileReference.size == 0;
				return b;
			}
			catch (e:Error)
			{
				return true;
			}
			return false;
		}
		/*
		// outdated function
		private function fileSizeExceeds(file:FileReference):Boolean
		{
			return true;
			 
 			try
			{
				var maxFileSizeBytes:Number = _uploadModel.maxFileSize * 1e6;
				if (file.size >= maxFileSizeBytes)
				{
					return true;
				}
			}
			catch (e:Error)
			{
				return true;
			}

			return false;
		}*/

		/**
		 * The reason for using this funciton and not the FileReference.type is that the type property is null under mac OS
		 * @param fileReference
		 * @return
		 *
		 */
		private function getFileExtension(fileReference:FileReference):String
		{
			var splittedName:Array = fileReference.name.split(".");
			var lastDotPosition:int = splittedName.length - 1
			var fileType:String = (splittedName[lastDotPosition] as String).toLowerCase();
			return fileType;
		}
		private function injectMediaInfo(importFileVO:ImportFileVO):void
		{
			MediaSourceDataInjector.injectToSingleItem(importFileVO, _wizardModel.mediaProviders.activeMediaProvider.providerCode,
					_wizardModel.mediaProviders.activeMediaProvider.mediaInfo.mediaCode);
		}

	}
}