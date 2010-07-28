package com.kaltura.contributionWizard.events.webcam
{
	import com.arc90.modular.AbstractModuleEvent;

	public class SavedCameraNameEvent extends AbstractModuleEvent
	{
		public static const SAVE_CAMERA_NAME:String = "saveCameraName";
		public function SavedCameraNameEvent(type:String, nextSequenceEvent:AbstractModuleEvent=null)
		{
			super(type, nextSequenceEvent);
		}
		
	}
}