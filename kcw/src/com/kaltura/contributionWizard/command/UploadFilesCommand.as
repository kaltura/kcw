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
	import com.kaltura.commands.uploadToken.UploadTokenAdd;
	import com.kaltura.contributionWizard.business.FileUploadDelegate;
	import com.kaltura.contributionWizard.events.ReportErrorEvent;
	import com.kaltura.contributionWizard.model.UploadModelLocator;
	import com.kaltura.contributionWizard.model.WizardModelLocator;
	import com.kaltura.contributionWizard.model.importData.UploadCartStatusTypes;
	import com.kaltura.contributionWizard.view.resources.ResourceBundleNames;
	import com.kaltura.contributionWizard.vo.ErrorVO;
	import com.kaltura.events.KalturaEvent;
	import com.kaltura.vo.KalturaUploadToken;
	import com.kaltura.vo.importees.ImportFileVO;
	import com.kaltura.vo.importees.UploadStatusTypes;
	
	import de.polygonal.ds.ArrayedQueue;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.managers.CursorManager;
	import mx.resources.ResourceManager;
	import mx.rpc.IResponder;
	import mx.rpc.events.ResultEvent;

	public class UploadFilesCommand implements ICommand, IResponder
	{
		private var _model:WizardModelLocator = WizardModelLocator.getInstance();
		private var _uploadModel:UploadModelLocator = UploadModelLocator.getInstance();

		private var _importFileVoList:ArrayCollection;
		private var _queue:ArrayedQueue;
		private var _currentFileToUpload:ImportFileVO;
		
		public function execute(event:CairngormEvent):void
		{
			CursorManager.setBusyCursor();
			_uploadModel.isUploading = true;

			_importFileVoList = _model.importData.importCart.importItemsArray;
			setupQueue();
			uploadNextFile();
		}

		public function result(data:Object):void
		{

			trace("UploadFiles|Command_result_data: " + data);
			var result:Object = (data as ResultEvent).result;
			//builds the thumbURL, temporary solution to display thumb after "upload"
			result.thumbURL = _model.context.protocol + _model.context.hostName + "/p/"+_model.context.partnerId+"/sp/"+ _model.context.subPartnerId+ "/thumbnail/upload_token_id/"+result.importFileVO.token;		
			if (_model.loadThumbsWithKS) {
				result.thumbURL += "/ks/"+_model.context.kc.ks;
			}
			var targetImportFileVO:ImportFileVO = result.importFileVO as ImportFileVO;
			targetImportFileVO.token = result.importFileVO.token;
			//add a thumbnail url to the importFileVo
			targetImportFileVO.thumbURL = result.thumbURL;

			targetImportFileVO.uploadStatus = UploadStatusTypes.UPLOAD_COMPLETE;
			
			//REPORT TO KALTURA TO TRACE PROBLEMS WITH UPLOAD
			///////////////////////////////////////////////////
			var errorVo : ErrorVO = new ErrorVO();
			errorVo.reportingObj = "UploadFilesCommand";
			errorVo.errorDescription = "uploadId="+targetImportFileVO.fileName;
			if (_queue.peek())
				errorVo.errorDescription += "&uploadNext=true";
			else
				errorVo.errorDescription += "&uploadNext=false";
			
			errorVo.errorDescription +="&data="+targetImportFileVO.token;
			var reportErrorEvent : ReportErrorEvent = new ReportErrorEvent( ReportErrorEvent.AFTER_UPLOAD_FILE , errorVo);
			reportErrorEvent.dispatch();
			///////////////////////////////////////////////////
			
			if (_queue.peek())
			{
				uploadNextFile();
			}
			else
			{
				uploadComplete();
			}
		}

		public function fault(info:Object):void
		{
			trace("UploadFilesCommand.fault()");
			
			var errorMsg:String;
			//gets the message that suites the current status
			switch (ImportFileVO(info).uploadStatus) {
				case UploadStatusTypes.UPLOAD_CANCELED:
					errorMsg = "UPLOAD_CANCELED_ALERT_BODY";
				break;
				case UploadStatusTypes.UPLOAD_SKIPPED:
					errorMsg = "UPLOAD_SKIPPED_ALERT_BODY";
					break;
				
				case UploadStatusTypes.UPLOAD_IO_ERROR:
					errorMsg = "UPLOAD_IOERROR_ALERT_BODY";
				break;
				
				case UploadStatusTypes.UPLOAD_SECURITY_ERROR:
					errorMsg = "UPLOAD_SEC_ERROR_ALERT_BODY";
				break;
				
				default:
					errorMsg = "UPLOAD_ERROR";
					ImportFileVO(info).uploadStatus = UploadStatusTypes.UPLOAD_FAILED;
				break;
			}
			
			if (errorMsg)
				Alert.show(ResourceManager.getInstance().getString(ResourceBundleNames.UPLOAD_IMPORT_VIEW, errorMsg) , ResourceManager.getInstance().getString(ResourceBundleNames.UPLOAD_IMPORT_VIEW, "UPLOAD_ERROR_TITLE"));
			
			//REPORT TO KALTURA TO TRACE PROBLEMS WITH UPLOAD
			///////////////////////////////////////////////////
			var errorDescription : String = "uploadId="+ImportFileVO(info).fileName+", uploadStatus=" +ImportFileVO(info).uploadStatus +
				", dataOnError="+ImportFileVO(info).dataOnError;
			var errorVo : ErrorVO = new ErrorVO();
			errorVo.reportingObj =  "UploadFilesCommand";
			errorVo.errorDescription = errorDescription;
			var errorEvent : ReportErrorEvent = new ReportErrorEvent( ReportErrorEvent.UPLOAD_FAILED, errorVo);
			errorEvent.dispatch();
			///////////////////////////////////////////////////
			
		//	var targetImportFileVO:ImportFileVO = info as ImportFileVO;
		//	targetImportFileVO.uploadStatus = UploadStatusTypes.UPLOAD_FAILED;
			if (_queue.peek())
			{
				uploadNextFile();
			}
			else
			{
				uploadComplete();
			}
		}

		private function setupQueue():void
		{
			_model.importData.uploadQueue = new ArrayedQueue(_importFileVoList.length);
			_queue = _model.importData.uploadQueue;
			for each (var importFileVo:ImportFileVO in _importFileVoList)
			{
				if (importFileVo.uploadStatus != UploadStatusTypes.UPLOAD_COMPLETE)
					_queue.enqueue(importFileVo);
			}
		}

		private function uploadNextFile():void
		{
			var importFileVo:ImportFileVO = _queue.dequeue() as ImportFileVO;
			_queue.dispose();

			_model.importData.importCart.currentlyProcessedImportVo = importFileVo;
			
			//REPORT TO KALTURA TO TRACE PROBLEMS WITH UPLOAD
			///////////////////////////////////////////////////
			var errorVo : ErrorVO = new ErrorVO();
			errorVo.reportingObj = "UploadFilesCommand";
			errorVo.errorDescription = "uploadId="+importFileVo.fileName;
			var reportErrorEvent : ReportErrorEvent = new ReportErrorEvent( ReportErrorEvent.BEFORE_UPLOAD_FILE , errorVo);
			reportErrorEvent.dispatch();
			////////////////////////////////////////////////////
			
			uploadSingleFile(importFileVo);
		}

		/**
		 *	responsible for uploading a single file, first sends a call to "uploadTokenAdd" to get the file token 
		 * @param importFileVo the file to upload
		 * 
		 */
		private function uploadSingleFile(importFileVo:ImportFileVO):void
		{
			var fileToken:KalturaUploadToken = new KalturaUploadToken();
			fileToken.fileName = importFileVo.polledfileReference.fileReference.name;
			fileToken.fileSize = importFileVo.polledfileReference.bytesTotal;
			var uploadToken:UploadTokenAdd = new UploadTokenAdd(fileToken);
			uploadToken.addEventListener(KalturaEvent.COMPLETE, uploadTokenHandler);
			_currentFileToUpload = importFileVo;
			//sends a request to get the file's token
			_model.context.kc.post(uploadToken);
		}
		
		/**
		 *	after token returned from the server, will call the uploadTokenUpload call, using delegate 
		 * @param event 
		 * 
		 */		
		private function uploadTokenHandler(event:KalturaEvent):void {
			
			var tokenId:String = KalturaUploadToken(event.data).id;
			_currentFileToUpload.token = tokenId;
			var delegate:FileUploadDelegate = new FileUploadDelegate(this);
			delegate.uploadFile(_currentFileToUpload);
		}

		private function uploadComplete():void
		{
			CursorManager.removeBusyCursor();
			_model.importData.importCart.currentlyProcessedImportVo = null;
			_uploadModel.isUploading = false;

			if (uploadsLeft())
			{
				_model.importData.importCart.uploadStatus = UploadCartStatusTypes.READY_TO_UPLOAD;
			}
			else
			{
				_model.importData.importCart.uploadStatus = UploadCartStatusTypes.COMPLETE;

			}
		}

		private function uploadsLeft():Boolean
		{
			for each (var importFileVo:ImportFileVO in _importFileVoList)
			{
				if (importFileVo.uploadStatus != UploadStatusTypes.UPLOAD_COMPLETE)
				{
					return true;
				}
			}
			return false;
		}
	}
}