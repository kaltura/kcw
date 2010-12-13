package com.kaltura.contributionWizard.vo
{
	import com.adobe.cairngorm.vo.IValueObject;
	
	public class ErrorVO implements IValueObject
	{
		public var reportingObj : String; //reporting_obj
		public var errorCode : String; //error_code
		public var errorDescription : String; //error_description
	}
}