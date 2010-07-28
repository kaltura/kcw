package com.kaltura.contributionWizard.business
{
	import com.adobe_cw.adobe.cairngorm.business.ServiceLocator;

	import mx.controls.List;
	import mx.rpc.AsyncToken;
	import mx.rpc.IResponder;
	import mx.rpc.events.ResultEvent;

	public class ModerateSearchTermsDelegate extends BaseDelegate
	{
		public function ModerateSearchTermsDelegate(responder:IResponder)
		{
			this.responder = responder;
			this.service = ServiceLocator.getInstance().getHTTPService("moderateSearchTerms");
		}

		public function send(searchTerm:String):void
		{
			startTimeout();
			var token:AsyncToken = service.send	( {check: searchTerm} );
			token.addResponder(this);
		}

		override public function result(data:Object):void
		{
			super.result(data);

			var resultXml:XML  = (data as ResultEvent).result as XML;
			var approved:Boolean = resultXml.result[0] == "ok";
			if (!approved)
				var errorMsg:String = resultXml.message;
			responder.result( {approved: approved, errorMsg: errorMsg} );
		}

		override public function fault(info:Object):void
		{
			super.fault(info);
			responder.fault(info);
		}
	}
}