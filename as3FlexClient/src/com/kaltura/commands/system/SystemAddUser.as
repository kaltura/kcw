package com.kaltura.commands.system
{
	import com.kaltura.vo.KalturaSystemUser;
	import com.kaltura.delegates.system.SystemAddUserDelegate;
	import com.kaltura.net.KalturaCall;

	public class SystemAddUser extends KalturaCall
	{
		public var filterFields : String;
		public function SystemAddUser( systemUser : KalturaSystemUser )
		{
			service= 'system';
			action= 'addUser';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
 			keyValArr = kalturaObject2Arrays(systemUser,'systemUser');
			keyArr = keyArr.concat( keyValArr[0] );
			valueArr = valueArr.concat( keyValArr[1] );
			applySchema( keyArr , valueArr );
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields',filterFields);
			delegate = new SystemAddUserDelegate( this , config );
		}
	}
}
