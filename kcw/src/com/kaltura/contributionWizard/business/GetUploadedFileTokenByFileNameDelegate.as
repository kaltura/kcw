package com.kaltura.contributionWizard.business
{
	import com.adobe_cw.adobe.cairngorm.business.ServiceLocator;
	
	import mx.rpc.AsyncToken;
	import mx.rpc.IResponder;
	import mx.rpc.http.HTTPService;

	public class GetUploadedFileTokenByFileNameDelegate implements IResponder
	{
		private var responder:IResponder;
		private var service:HTTPService;
		public function GetUploadedFileTokenByFileNameDelegate( responder : IResponder ):void
		{
			this.responder = responder;
			this.service = ServiceLocator.getInstance().getHTTPService(Services.GET_UPLOADED_FILETOKEN_BY_FILENAME);
		}
		
		public function getUploadedFileTokenByFileName( params : Object ) : void
		{
			var call:AsyncToken = service.send( params );
			call.addResponder(this);
		}
		
		public function result(data:Object):void
		{
			responder.result( data );
		}
		
		public function fault(info:Object):void
		{
			trace("GetUploadedFileTokenByFileNameDelegate==>fault");
		}
	}
}