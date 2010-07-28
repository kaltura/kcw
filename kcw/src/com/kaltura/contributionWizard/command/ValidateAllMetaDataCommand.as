package com.kaltura.contributionWizard.command
{
	import com.adobe_cw.adobe.cairngorm.commands.SequenceCommand;
	import com.adobe_cw.adobe.cairngorm.control.CairngormEvent;
	import com.kaltura.contributionWizard.events.ValidateAllMetaDataEvent;
	import com.kaltura.contributionWizard.events.ValidateMetaDataEvent;
	import com.kaltura.contributionWizard.model.WizardModelLocator;
	import com.kaltura.vo.importees.BaseImportVO;

	import mx.validators.Validator;

	public class ValidateAllMetaDataCommand extends SequenceCommand
	{
		private var _model:WizardModelLocator = WizardModelLocator.getInstance();

		private var _titleValidator:Validator;
		private var _tagsValidator:Validator;

		override public function execute(event:CairngormEvent):void
		{
			var validateAllEvent:ValidateAllMetaDataEvent = ValidateAllMetaDataEvent(event);
			_titleValidator = validateAllEvent.titleValidator;
			_tagsValidator = validateAllEvent.tagsValidatir;

			_model.importData.importCart.importItemsArray.source.forEach(validateMetaData);
		}

		private function validateMetaData(importItemVo:BaseImportVO, ...rest):void
		{
			var validateTitleEvent:ValidateMetaDataEvent	= new ValidateMetaDataEvent(ValidateMetaDataEvent.VALIDATE_TITLE, importItemVo, _titleValidator, _tagsValidator);
			validateTitleEvent.dispatch()
			var validateTagsEvent:ValidateMetaDataEvent		= new ValidateMetaDataEvent(ValidateMetaDataEvent.VALIDATE_TAGS, importItemVo, _titleValidator, _tagsValidator);
			validateTagsEvent.dispatch()
		}
	}
}