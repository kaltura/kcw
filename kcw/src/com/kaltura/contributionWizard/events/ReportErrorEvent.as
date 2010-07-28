package com.kaltura.contributionWizard.events
{
	import com.adobe_cw.adobe.cairngorm.control.CairngormEvent;
	import com.kaltura.contributionWizard.vo.ErrorVO;

	public class ReportErrorEvent extends CairngormEvent
	{
		public static const BEFORE_UPLOAD_FILE : String = "beforeUploadFile"; //when starting file reference upload
		public static const AFTER_UPLOAD_FILE : String = "afterUploadFile"; //when reference upload is done
		public static const UPLOAD_PROGRESS : String = "uploadProgress"; //Each 10 seconds
		public static const CANCEL_UPLOAD : String = "cancelUpload"; //when uplaod is stoped
		public static const VIEW_STATE_CHANGE : String = "viewStateChange"; // when clicking on next, report the path of currentState to the Next
		public static const UPLOAD_FAILED : String = "uploadFaild"; // when upload failed
		public static const UPLOAD_SKIP : String = "skipFile"; // when file is skipped
		
		public var errorVo : ErrorVO; //create for uploaded file – can use the current guid
		
		public function ReportErrorEvent(type:String, errorVo:ErrorVO=null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.errorVo = errorVo;
		}
	}
}