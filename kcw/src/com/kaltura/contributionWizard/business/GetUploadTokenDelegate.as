package com.kaltura.contributionWizard.business
{
	import com.kaltura.commands.uploadToken.UploadTokenGet;
	import com.kaltura.contributionWizard.model.WizardModelLocator;
	import com.kaltura.events.KalturaEvent;
	import com.kaltura.vo.KalturaUploadToken;
	import com.kaltura.vo.importees.ImportFileVO;
	
	import mx.rpc.IResponder;
	
	/**
	 * This class handles uploadToken get calls
	 * @author Michal
	 * 
	 */
	public class GetUploadTokenDelegate implements IResponder
	{
		private var responder:IResponder;
		private var _model:WizardModelLocator = WizardModelLocator.getInstance();
		
		/**
		 * Constructs a new GetUploadTokenDelegate
		 * @param responder the responder that reponses will be forworded to.
		 * 
		 */		
		public function GetUploadTokenDelegate( responder : IResponder ):void
		{
			this.responder = responder;
		}
		
		/**
		 * Sends an uploadToken get request, with the current proccessed file's token id. 
		 * 
		 */		
		public function GetUploadToken() : void
		{
			var getUpload:UploadTokenGet = new UploadTokenGet(ImportFileVO(_model.importData.importCart.currentlyProcessedImportVo).token);
			getUpload.addEventListener(KalturaEvent.COMPLETE, result);
			getUpload.addEventListener(KalturaEvent.FAILED, fault);
			_model.context.kc.post(getUpload);
		}
		
		/**
		 * Handles a fault response 
		 * @param info is the data returned from the server
		 * 
		 */		
		public function fault(info:Object):void
		{
			trace("GetUploadedTokenDelegate==>fault:");
			if (info.error && info.error.errorMsg)
				trace (info.error.errorMsg);
		}
		
		/**
		 * Handles a result from server 
		 * @param data the data returned from the server
		 * 
		 */	
		public function result(data:Object):void
		{
			if (data.data)
				responder.result( data.data as KalturaUploadToken);		
		}
	}
}