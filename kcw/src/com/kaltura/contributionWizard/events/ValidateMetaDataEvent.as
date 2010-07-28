package com.kaltura.contributionWizard.events
{
	import com.bjorn.event.ChainEvent;
	import com.kaltura.vo.importees.BaseImportVO;

	import mx.validators.Validator;

	public class ValidateMetaDataEvent extends ChainEvent
	{
		public static const VALIDATE_TITLE:String 		= "validateTitle";
		public static const VALIDATE_TAGS:String 		= "validateTags";

		public var importItemVo:BaseImportVO;

		public var titleValidator	:Validator;
		public var tagsValidator	:Validator;

		public function ValidateMetaDataEvent(type:String, importItemVo:BaseImportVO, titleValidator:Validator, tagsValidator:Validator, bubbles:Boolean = true, cancelable:Boolean = false):void
		{
			super(type, bubbles, cancelable);

			this.importItemVo = importItemVo;
			this.titleValidator = titleValidator
			this.tagsValidator = tagsValidator;
		}

	}
}