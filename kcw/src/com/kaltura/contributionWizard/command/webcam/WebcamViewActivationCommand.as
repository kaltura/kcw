package com.kaltura.contributionWizard.command.webcam
{
	import com.adobe_cw.adobe.cairngorm.control.CairngormEvent;
	import com.arc90.modular.ModuleSequenceCommand;
	import com.kaltura.contributionWizard.model.WebcamModelLocator;
	
	import flash.net.SharedObject;

	public class WebcamViewActivationCommand extends ModuleSequenceCommand
	{
		private var _webcamModel:WebcamModelLocator = WebcamModelLocator.getInstance();
		
		override public function execute(event:CairngormEvent):void
		{
			_webcamModel.savedCameraName = getSavedCameraName(); 
		}
		
		private function getSavedCameraName():void
		{
			var lsoCamera:SharedObject 
		}
		
	}
}