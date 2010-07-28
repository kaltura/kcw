/*
Copyright
*/
package com.adobe.ac
{
	import mx.core.Application;
	import mx.core.UIComponent;
   
	public class Observer 
	{
		protected var isHandlerInitialized : Boolean = false;
		protected var isSourceInitialized : Boolean = false;
		
		public function get handler() : Function
		{
			return null;
		}
  
		public function get source() : Object
		{
			return null;
		}
		
		public function execute( method : Function, ...params : Array ) : Object
		{
			var returnValue : Object;
			try
			{
				returnValue = method.apply( null, params );
			}
			catch( e : Error )
			{
				delay( e );
			}
			return returnValue;
		}
			
		protected function callHandler() : void
		{
			try
			{
				handler.call( null, source );
			}
			catch( e : Error )
			{
				delay( e );
			}
		}
   
		protected function delay( e : Error ) : void
		{
			UIComponent( Application.application ).callLater( throwException, [ e ] );
		}
   
		private function throwException( e : Error ) : void
		{
			throw e;
		}
	}
}