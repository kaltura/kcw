package com.kaltura.contributionWizard.business
{
	import com.kaltura.vo.importees.ImportURLVO;
	
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import mx.rpc.IResponder;

	public class GetRedirectedPathDelegate implements IResponder
	{
		
		private var responder : IResponder;
	   	private var service : URLLoader;
		
		public function GetRedirectedPathDelegate(responder:IResponder)
		{
			this.responder = responder;
			service = new URLLoader();
			addListeners();
		}
		
		public function getRedirectedPath(importVO:ImportURLVO):void
		{
			var url:String = importVO.fileUrl;
			service.load(new URLRequest(url));
		}
		
		private function addListeners():void
		{
			service.addEventListener(Event.COMPLETE, result);
			service.addEventListener(ErrorEvent.ERROR, fault);
		}
		
		private function removeListeners():void
		{
			service.removeEventListener(Event.COMPLETE, result);
			service.removeEventListener(ErrorEvent.ERROR, fault);
		}

		public function result(data:Object):void
		{
			trace(data);
			responder.result(data);
		}
		
		public function fault(info:Object):void
		{
			trace(info);
			responder.fault(info);
		}
		
	}
}