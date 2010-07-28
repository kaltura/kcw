package com.kaltura.contributionWizard.command.webcam
{
	import com.adobe_cw.adobe.cairngorm.control.CairngormEvent;
	import com.arc90.modular.ModuleSequenceCommand;
	import com.kaltura.contributionWizard.model.WebcamModelLocator;

	public class SaveCameraNameCommand extends ModuleSequenceCommand
	{
		private var _model:WebcamModelLocator = WebcamModelLocator.getInstance();
		
		override public function execute(event:CairngormEvent):void
		{
			var cameraName:String = (event as sac
			var lsoData:Object = _model.savedCameraNameLso.getData();
			lsoData["webcamName"] = 
		}
		
	}
}