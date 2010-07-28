package com.kaltura.contributionWizard.events
{
	import com.bjorn.event.ChainEvent;

	import mx.validators.Validator;

	public class ValidateAllMetaDataEvent extends ChainEvent
	{
		public static const VALIDATE_ALL_META_DATA:String = "validateAllMetaData";

		public var titleValidator	:Validator;
		public var tagsValidatir	:Validator;

		public function ValidateAllMetaDataEvent(type:String, titleValidator:Validator, tagsValidatir:Validator, bubbles:Boolean = true, cancelable:Boolean = false):void
		{
			super(type, bubbles, cancelable);
			this.titleValidator = titleValidator;
			this.tagsValidatir = tagsValidatir;
		}
	}
}