package com.kaltura.contributionWizard.business
{
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;

	import mx.rpc.IResponder;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.http.HTTPService;

	public class BaseDelegate implements IResponder
	{
		protected var service:HTTPService;
		protected var responder:IResponder;

		private var _timeout:int = -1;
		private var _timeoutId:uint;

		public function set timeout(value:int):void
		{
			_timeout = value;
		}

		public function result(data:Object):void
		{
			clearTimeout(_timeoutId);
		}

		public function fault(info:Object):void
		{
			clearTimeout(_timeoutId);
		}
		protected function startTimeout():void
		{
			if (_timeout != -1)
				_timeoutId = setTimeout(onTimeout, _timeout);
		}

		private function onTimeout():void
		{
			service.cancel();
			var faultEvent:FaultEvent = new FaultEvent(FaultEvent.FAULT);
			fault(faultEvent);
		}
	}
}