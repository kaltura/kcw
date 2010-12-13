package com.kaltura.commands.system
{
	import com.kaltura.vo.KalturaSystemUser;
	import com.kaltura.delegates.system.SystemUpdateUserDelegate;
	import com.kaltura.net.KalturaCall;

	public class SystemUpdateUser extends KalturaCall
	{
		public var filterFields : String;
		public function SystemUpdateUser( userId : int,systemUser : KalturaSystemUser )
		{
			service= 'system';
			action= 'updateUser';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push( 'userId' );
			valueArr.push( userId );
 			keyValArr = kalturaObject2Arrays(systemUser,'systemUser');
			keyArr = keyArr.concat( keyValArr[0] );
			valueArr = valueArr.concat( keyValArr[1] );
			applySchema( keyArr , valueArr );
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields',filterFields);
			delegate = new SystemUpdateUserDelegate( this , config );
		}
	}
}
