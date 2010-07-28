package com.kaltura.commands.system
{
	import com.kaltura.delegates.system.SystemLoginDelegate;
	import com.kaltura.net.KalturaCall;

	public class SystemLogin extends KalturaCall
	{
		public var filterFields : String;
		public function SystemLogin( email : String,password : String )
		{
			service= 'system';
			action= 'login';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push( 'email' );
			valueArr.push( email );
			keyArr.push( 'password' );
			valueArr.push( password );
			applySchema( keyArr , valueArr );
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields',filterFields);
			delegate = new SystemLoginDelegate( this , config );
		}
	}
}
