package com.kaltura.commands.system
{
	import com.kaltura.delegates.system.SystemGetUserDelegate;
	import com.kaltura.net.KalturaCall;

	public class SystemGetUser extends KalturaCall
	{
		public var filterFields : String;
		public function SystemGetUser( userId : int )
		{
			service= 'system';
			action= 'getUser';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push( 'userId' );
			valueArr.push( userId );
			applySchema( keyArr , valueArr );
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields',filterFields);
			delegate = new SystemGetUserDelegate( this , config );
		}
	}
}
