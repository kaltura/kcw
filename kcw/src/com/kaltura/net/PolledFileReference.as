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
package com.kaltura.net
{
	import com.kaltura.contributionWizard.business.GetUploadTokenDelegate;
	import com.kaltura.contributionWizard.events.ReportErrorEvent;
	import com.kaltura.contributionWizard.model.WizardModelLocator;
	import com.kaltura.contributionWizard.vo.ErrorVO;
	import com.kaltura.types.KalturaUploadTokenStatus;
	import com.kaltura.vo.KalturaUploadToken;
	import com.kaltura.vo.importees.ImportFileVO;
	
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.ProgressEvent;
	import flash.events.TimerEvent;
	import flash.net.FileReference;
	import flash.utils.Timer;
	
	import mx.rpc.IResponder;

	/**
	* A fileReference object wrapper that holds its bytesLoaded and bytesTotal as members.
	* This is useful when a recycled item renderer needs to know the loading state.
	*/

	[Event(name="uploadCompleteData", type="flash.events.DataEvent")]
	[Event(name="cancel", type="flash.events.Event")]
	[Bindable]
	public class PolledFileReference extends EventDispatcher implements IResponder
	{
		public var fileReference:FileReference;

		/**
		* inidicates if the FileReference object has been opened, means that the upload/download has begun.
		* This is useful if the fileReference needs to be used as data source for itemRenderer in a component that recycles iotem renderers, which forces
		* them to be fully data driven. that means that it can't rely on Event.OPEN because the item renderer data is populated with
		* different FileReference objects.
		*/
		public var hasBeenOpened:Boolean = false;
		public var hasComplete:Boolean = false;
		
		public var bytesTotal:uint = 0;
		public var bytesLoaded:uint = 0;
		private var _oldBytesLoaded : uint = 0;
		
		private var _timer:Timer;
		private var _reportErrorTimer : Timer;
		private var _updateProgress:Boolean = true;

		public function PolledFileReference(fileReference:FileReference):void
		{
			this.fileReference = fileReference
			this.fileReference.addEventListener(ProgressEvent.PROGRESS, onProgress);
			this.fileReference.addEventListener(Event.OPEN, onFileReferenceOpen);
			//this.fileReference.addEventListener(Event.COMPLETE, onFileReferenceComplete)
			this.fileReference.addEventListener(DataEvent.UPLOAD_COMPLETE_DATA , onFileReferenceComplete)
			try
			{
				//avoid zero byte file error
				bytesTotal = fileReference.size;
			}
			catch(e:Error){}
			
			_timer = new Timer(1000);
			_timer.addEventListener(TimerEvent.TIMER, checkProgress );
			_timer.start();
			
			_reportErrorTimer = new Timer(10000);
			_reportErrorTimer.addEventListener(TimerEvent.TIMER, onReportProgressError );
			_reportErrorTimer.start();
		}
		
		private function checkProgress( event : TimerEvent ):void
		{
			if( ! this.fileReference.hasEventListener(ProgressEvent.PROGRESS) )
				this.fileReference.addEventListener(ProgressEvent.PROGRESS, onProgress);
		}
		
		private function onReportProgressError( event : TimerEvent ) : void
		{
			//if we are loading right now and 
			if(!hasComplete && hasBeenOpened)
			{
				//REPORT TO KALTURA TO TRACE PROBLEMS WITH UPLOAD
				///////////////////////////////////////////////////
				var errorVo : ErrorVO = new ErrorVO();
				errorVo.reportingObj = "PolledFileReference";
				errorVo.errorDescription = "uploadId="+this.fileReference.name + "&bytesLoaded="+bytesLoaded+"&bytesTotal="+bytesTotal;
				var reportErrorEvent : ReportErrorEvent = new ReportErrorEvent(ReportErrorEvent.UPLOAD_PROGRESS , errorVo );
				reportErrorEvent.dispatch();
				///////////////////////////////////////////////////
				
				//if there's a suspicion that the kcw stucks on upload.
				if(bytesLoaded == bytesTotal || bytesLoaded == _oldBytesLoaded || 1)
				{
					var getUploadToken : GetUploadTokenDelegate = new GetUploadTokenDelegate(this);
					getUploadToken.GetUploadToken();
				}
				
				_oldBytesLoaded = bytesLoaded;
			}
		}
		
		/**
		 * This function will be called when there's a suspicion that the kcw stucks on upload.
		 * In this case an uploadTokenGet request is sent to the server, to know the status of the
		 * current upload.
		 * @param data the data returned from the server
		 * */
		public function result(data:Object):void
		{
			var res: KalturaUploadToken = data as KalturaUploadToken;
			if(res && (res.status==KalturaUploadTokenStatus.FULL_UPLOAD))
			{
				var uploadTokenId : String = res.id;
				
				var dataEvent : DataEvent = new DataEvent( DataEvent.UPLOAD_COMPLETE_DATA , 
															false,
															false,
															new XML("<xml><result>"+ uploadTokenId +"</result></xml>")									   
															)
				onFileReferenceComplete( dataEvent );				
			}
		}
		
		public function fault(info:Object):void
		{
			trace("PolledFileReference==>fault");
		}

		public function cancel():void
		{
			this.fileReference.cancel();
			hasBeenOpened=false;
			dispatchEvent(new Event(Event.CANCEL));
		}
		
		private function onProgress(evtProgress:ProgressEvent):void
		{
			trace("_updateProgress: " + _updateProgress);
			this.fileReference.removeEventListener(ProgressEvent.PROGRESS, onProgress);
			bytesLoaded = evtProgress.bytesLoaded;
			bytesTotal = evtProgress.bytesTotal;
		}

		private function onFileReferenceOpen(evtOpen:Event):void
		{
			hasBeenOpened = true;
		}

		private function onFileReferenceComplete(evtComplete:Event = null):void
		{	
			bytesLoaded = 1;
			bytesTotal = 1;
			hasBeenOpened = true;
			hasComplete = true;
			
			if (_timer) {
				_timer.stop();				
				_timer.removeEventListener(TimerEvent.TIMER,checkProgress);
				_timer = null;
			}
			
			if (_reportErrorTimer) {
				_reportErrorTimer.stop();
				_reportErrorTimer.removeEventListener(TimerEvent.TIMER, onReportProgressError );
				_reportErrorTimer = null;
			}
			
			if(evtComplete)
				dispatchEvent(evtComplete);
		}
	}
}