package com.kaltura.contributionWizard.events
{
	import com.bjorn.event.ChainEvent;

	public class GotoNextImportStepEvent extends ChainEvent
	{
		public static const GOTO_NEXT_IMPORT_STEP:String = "gotoNextImportStep";

		public var backward:Boolean;

		public function GotoNextImportStepEvent(type:String, backward:Boolean = false):void
		{
			super(type, true, false);
			this.backward = backward;
		}

	}
}