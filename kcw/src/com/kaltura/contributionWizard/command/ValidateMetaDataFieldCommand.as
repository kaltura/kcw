package com.kaltura.contributionWizard.command
{
	import com.adobe_cw.adobe.cairngorm.commands.SequenceCommand;
	import com.adobe_cw.adobe.cairngorm.control.CairngormEvent;
	import com.kaltura.contributionWizard.events.ValidateMetaDataEvent;
	import com.kaltura.contributionWizard.model.WizardModelLocator;
	import com.kaltura.contributionWizard.model.importData.ImportCart;
	import com.kaltura.vo.importees.BaseImportVO;
	
	import mx.events.ValidationResultEvent;
	import mx.validators.StringValidator;
	import mx.validators.ValidationResult;
	import mx.validators.Validator;

	public class ValidateMetaDataFieldCommand extends SequenceCommand
	{
		private var _model:WizardModelLocator = WizardModelLocator.getInstance();

		private var _invalidItems:Array = _model.importData.importCart.invalidItemVoList
		private var _titleValidator:Validator;
		private var _tagsValidator:Validator;
		private var _importVo:BaseImportVO;
		private var _importCart:ImportCart = _model.importData.importCart;

		override public function execute(event:CairngormEvent):void
		{
			var validationEvent:ValidateMetaDataEvent = event as ValidateMetaDataEvent;

			_titleValidator = validationEvent.titleValidator;
			_tagsValidator = validationEvent.tagsValidator;
			_importVo = validationEvent.importItemVo;

			if (event.type == ValidateMetaDataEvent.VALIDATE_TITLE)
			{
				if (validateSingleTitle(true) && validateSingleTags(false))
				{
					_importCart.removeInvalidItem(_importVo);
				}
				else if (!validateSingleTitle(true) && _invalidItems.indexOf(_importVo) == -1)
				{
					_importCart.addInvalidItem(_importVo);
				}
			}
			else
			{
				if (validateSingleTags(true) && validateSingleTitle(false))
				{
					_importCart.removeInvalidItem(_importVo);
				}
				else if (!validateSingleTags(true) && _invalidItems.indexOf(_importVo) == -1)
				{
					_importCart.addInvalidItem(_importVo);
				}
			}
			trace("isMetaDataValid: " + _model.importData.importCart.isMetaDataValid);
		}

		private function validateSingleTitle(highlight:Boolean):Boolean
		{
			var titleValidationResultEvent:ValidationResultEvent = _titleValidator.validate(_importVo.metaData.title || "");
			if (highlight)
			{
				_importVo.metaData.titleErrorString = titleValidationResultEvent.results ?
					ValidationResult(titleValidationResultEvent.results[0]).errorMessage : "";
				
				return titleValidationResultEvent.results == null;
			}
			else
			{
				return _importVo.metaData.titleErrorString.length == 0;
			}
		}
		
		private function validateSingleTags(highlight:Boolean):Boolean
		{
			var tagsValidationResultEvent:ValidationResultEvent = _tagsValidator.validate(_importVo.metaData.tags || "");
			if (highlight)
			{
				_importVo.metaData.tagsErrorString = tagsValidationResultEvent.results ?
					ValidationResult(tagsValidationResultEvent.results[0]).errorMessage : "";
				return tagsValidationResultEvent.results == null;
			}
			else
			{
				return _importVo.metaData.tagsErrorString.length == 0;
			}
		}

	}
}