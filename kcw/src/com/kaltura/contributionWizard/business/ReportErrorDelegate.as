package com.kaltura.contributionWizard.business
{
	import com.adobe_cw.adobe.cairngorm.business.ServiceLocator;
	import com.kaltura.contributionWizard.vo.ErrorVO;
	
	import flash.net.URLVariables;
	
	import mx.rpc.AsyncToken;
	import mx.rpc.IResponder;
	import mx.rpc.http.HTTPService;

	public class ReportErrorDelegate implements IResponder
	{
		private var _responder:IResponder;
		private var _service:HTTPService;
		public function ReportErrorDelegate( responder : IResponder )
		{
			_responder = responder;
			_service = ServiceLocator.getInstance().getHTTPService( Services.REPORT_ERROR );
		}
			
		public function reportError( errorVo : ErrorVO ) : void	
		{
			var urlVars:URLVariables = new URLVariables();
			urlVars.reporting_obj	= errorVo.reportingObj;
			urlVars.error_code		= errorVo.errorCode;
			urlVars.error_description = errorVo.errorDescription; 
			
			var call : AsyncToken = _service.send( urlVars );
			call.addResponder( this );
		}
			
		public function result(data:Object):void
		{
			_responder.result( data );
		}
		
		public function fault(info:Object):void
		{
			_responder.fault(info);	
		}
	}
}