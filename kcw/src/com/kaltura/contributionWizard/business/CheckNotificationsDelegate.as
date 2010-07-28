package com.kaltura.contributionWizard.business
{
	import com.adobe_cw.adobe.cairngorm.business.ServiceLocator;
	import com.kaltura.contributionWizard.model.WizardModelLocator;
	import com.kaltura.net.TemplateURLVariables;

	import flash.utils.clearInterval;
	import flash.utils.setTimeout;

	import mx.rpc.AsyncToken;
	import mx.rpc.IResponder;
	import mx.rpc.http.HTTPService;

	public class CheckNotificationsDelegate implements IResponder
	{
		private var _responder:IResponder;
		private var _service:HTTPService;

		private var _timeoutCount:int;
		private var _timeoutId:uint;

		public function CheckNotificationsDelegate(responder:IResponder)
		{
			_responder = responder;
			_service = ServiceLocator.getInstance().getHTTPService(Services.CHECK_ENTRIES_SERVICE);
		}

		public function checkNotifications(notificationsList:String, retriesCount:int):void
		{
			var templateUrlVars:TemplateURLVariables = new TemplateURLVariables(WizardModelLocator.getInstance().context.defaultUrlVars);

			templateUrlVars["notification_ids"] = notificationsList;
			templateUrlVars["retriesCount"] = retriesCount;

			var call:AsyncToken = _service.send(templateUrlVars);
			call.addResponder(this);
			_timeoutId = setTimeout(
									function():void
									{
										_service.cancel();
										fault(null);
									},
									30e3);
		}
		public function result(data:Object):void
		{
			clearInterval(_timeoutId);
			var xmlResult:XML = XML(data.result);
			var done:Boolean = xmlResult..done == "1";
			_responder.result(done);
		}

		public function fault(info:Object):void
		{
			clearInterval(_timeoutId);
			_responder.fault(info);
		}

	}
}