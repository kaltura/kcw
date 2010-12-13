package com.kaltura.contributionWizard.events
{
	import com.bjorn.event.ChainEvent;

	public class ChangePermissionLevelEvent extends ChainEvent
	{
		public static const CHANGE_PERMISSION_LEVEL:String = "changePermissionLevel";
		public var permissionLevel:int;

		public function ChangePermissionLevelEvent(type:String, permissionLevel:int):void
		{
			super(type);
			this.permissionLevel = permissionLevel;
		}

	}
}