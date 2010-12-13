package com.kaltura.commands.system
{
	import com.kaltura.delegates.system.SystemGetUserByEmailDelegate;
	import com.kaltura.net.KalturaCall;

	public class SystemGetUserByEmail extends KalturaCall
	{
		public var filterFields : String;
		public function SystemGetUserByEmail( email : String )
		{
			service= 'system';
			action= 'getUserByEmail';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push( 'email' );
			valueArr.push( email );
			applySchema( keyArr , valueArr );
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields',filterFields);
			delegate = new SystemGetUserByEmailDelegate( this , config );
		}
	}
}
