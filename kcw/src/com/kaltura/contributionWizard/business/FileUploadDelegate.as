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
package com.kaltura.contributionWizard.business
{
	import com.adobe_cw.adobe.cairngorm.business.ServiceLocator;
	import com.kaltura.contributionWizard.events.CancelUploadEvent;
	import com.kaltura.contributionWizard.model.WizardModelLocator;
	import com.kaltura.contributionWizard.view.resources.ResourceBundleNames;
	import com.kaltura.net.TemplateURLVariables;
	import com.kaltura.vo.importees.ImportFileVO;
	import com.kaltura.vo.importees.UploadStatusTypes;
	
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.FileReference;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	
	import mx.controls.Alert;
	import mx.resources.ResourceManager;
	import mx.rpc.IResponder;
	import mx.rpc.events.ResultEvent;

	public class FileUploadDelegate
	{
		private var _responder:IResponder;
		/**
		* The URL request that is needed to upload the file.
		* Attached to this request are the model context vars & a unique filename.
		*/
		private var _serviceRequest:URLRequest;
		/**
		* The ImportFileVO whose file reference is being uploaded.
		* this is essential in order to inform the IResponder object, that receives data such as thumbURL, to which ImportFileVO object it should attach that
		* data.
		*/
		private var _importFileVO:ImportFileVO;

		private var _model:WizardModelLocator = WizardModelLocator.getInstance();

		public function FileUploadDelegate(responder:IResponder):void
		{
			_responder = responder;
			_serviceRequest = Services(ServiceLocator.getInstance()).uploadServiceRequest;
		}

		public function uploadFile(fileVO:ImportFileVO):void
		{
			_importFileVO = fileVO;
			setupFileListeners(fileVO.polledfileReference.fileReference);
			var urlVars:URLVariables = getURLVariables(fileVO);
			_serviceRequest.data = urlVars;
			fileVO.polledfileReference.fileReference.upload(_serviceRequest, "fileData");
		}

		private function setupFileListeners(file:FileReference):void
		{
			file.addEventListener(Event.COMPLETE, onFileComplete);
			_importFileVO.polledfileReference.addEventListener(DataEvent.UPLOAD_COMPLETE_DATA, onUploadCompleteData);
			file.addEventListener(IOErrorEvent.IO_ERROR, onIoError );
			file.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
			_importFileVO.polledfileReference.addEventListener(Event.CANCEL, polledFileReferenceCancelHandler);
			_importFileVO.polledfileReference.addEventListener(CancelUploadEvent.SKIP_CURRENT_UPLOAD, polledFileReferenceSkipHandler);
		}

		private function removeFileListeners():void
		{
			_importFileVO.polledfileReference.fileReference.removeEventListener(Event.COMPLETE, onFileComplete);
			_importFileVO.polledfileReference.removeEventListener(DataEvent.UPLOAD_COMPLETE_DATA, onUploadCompleteData);
			_importFileVO.polledfileReference.fileReference.removeEventListener(IOErrorEvent.IO_ERROR, onIoError );
			_importFileVO.polledfileReference.fileReference.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
			_importFileVO.polledfileReference.removeEventListener(Event.CANCEL, polledFileReferenceCancelHandler);
			_importFileVO.polledfileReference.removeEventListener(CancelUploadEvent.SKIP_CURRENT_UPLOAD, polledFileReferenceSkipHandler);
		}

		private function getURLVariables(fileVO:ImportFileVO):URLVariables
		{
			var uploadURLVariables:TemplateURLVariables = new TemplateURLVariables(_model.context.defaultUrlVars);
			uploadURLVariables["uploadTokenId"] = fileVO.token;
			uploadURLVariables["filename"] = fileVO.fileName;

			return uploadURLVariables;
		}
		private function onFileComplete(evtComplete:Event):void
		{
			//don't do anything without the DataEvent.UPLOAD_COMPLETE_DATA)
		}

		private function onUploadCompleteData(evtUploadCompleteData:DataEvent):void
		{
			if (evtUploadCompleteData) {
				var xmlResult:XML = new XML(evtUploadCompleteData.data);
				
				if (xmlResult && xmlResult.hasOwnProperty("result")) {

					if (xmlResult.result.error[0]) {
						_importFileVO.dataOnError = xmlResult.result.error[0].code.text();
					}
					//the only case for a valid result
					else {
						var thumbURL:String = null; //xmlResult..thumb_url[0];
						var token:String = xmlResult.result;
						var resultData:Object = {
													importFileVO	: _importFileVO,
													 thumbURL		: thumbURL,
													 token			: token
												 };
						var evtResult:ResultEvent = new ResultEvent(ResultEvent.RESULT, false, true, resultData);
						_responder.result(evtResult);
						removeFileListeners();
						
						return;
					}
				}		
			}

			_responder.fault(_importFileVO);
			removeFileListeners();				
		}

		private function onIoError(evtIoError:IOErrorEvent):void
		{
			_importFileVO.uploadStatus = UploadStatusTypes.UPLOAD_IO_ERROR;
			_responder.fault(_importFileVO);
			removeFileListeners();
		}

		private function onSecurityError(evtSecurityError:SecurityErrorEvent):void
		{
			_importFileVO.uploadStatus = UploadStatusTypes.UPLOAD_SECURITY_ERROR;
			_responder.fault(_importFileVO);
			removeFileListeners();
		}

		private function polledFileReferenceCancelHandler(evtCancel:Event):void
		{
			_importFileVO.uploadStatus = UploadStatusTypes.UPLOAD_CANCELED;
			_responder.fault(_importFileVO);
			removeFileListeners();
		}
		
		private function polledFileReferenceSkipHandler(evtSkip:Event):void
		{
			_importFileVO.uploadStatus = UploadStatusTypes.UPLOAD_SKIPPED;
			_responder.fault(_importFileVO);
			removeFileListeners();
		}
	}
}