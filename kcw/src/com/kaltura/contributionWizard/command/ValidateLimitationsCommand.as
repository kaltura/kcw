package com.kaltura.contributionWizard.command
{
	import com.adobe_cw.adobe.cairngorm.commands.SequenceCommand;
	import com.adobe_cw.adobe.cairngorm.control.CairngormEvent;
	import com.kaltura.contributionWizard.enums.LimitationErrorType;
	import com.kaltura.contributionWizard.model.WizardModelLocator;
	import com.kaltura.contributionWizard.view.resources.ResourceBundleNames;
	import com.kaltura.contributionWizard.vo.limitations.ImportTypeLimitationsVO;
	import com.kaltura.contributionWizard.vo.limitations.LimitationError;
	import com.kaltura.contributionWizard.vo.limitations.RangeLimitation;
	import com.kaltura.vo.importees.ImportFileVO;
	import com.kaltura.vo.importees.UploadStatusTypes;
	
	import mx.controls.Alert;
	import mx.resources.ResourceManager;
	

	public class ValidateLimitationsCommand extends SequenceCommand
	{
		private var _model:WizardModelLocator = WizardModelLocator.getInstance();
		private var _importCartItems:Array;
		private var _lastError:LimitationError;
		private const MEGABYTE:int = 1048576;
		
		private var _isSearch:Boolean;
		private var _errorSuffix:String;
		
		override public function execute(event:CairngormEvent):void
		{
			//_model.mediaProviders.activeMediaProvider.mediaInfo
			//_model.importData.importCart.leaveLast();
			_importCartItems = _model.importData.importCart.importItemsArray.source;
			
			/*
			if(1 == max){
				_model.importData.importCart.leaveLast();	
			}else if(_model.importData.importCart.importItemsArray.length > max){
				// show error
			}*/
			
			_lastError = new LimitationError(LimitationErrorType.OK);
			
			var activeModuleUrl:String = _model.mediaProviders.activeMediaProvider.moduleUrl.toLowerCase();
			if (activeModuleUrl.indexOf("searchview.swf") != -1)
			{
				_isSearch = true;
				_errorSuffix = "SEARCH";
				validateLimitations(_model.limitationsVo.search);
			}
			else if (activeModuleUrl.indexOf("uploadview.swf") != -1)
			{
				_isSearch = false;
				_errorSuffix = "UPLOAD";
				validateLimitations(_model.limitationsVo.upload);
			}
			
			_model.limitationError = _lastError;
			_model.limitationIsValid = _lastError.type == LimitationErrorType.OK;
			
			/*if(!validationResult){
				Alert.show("lastError: " + _lastError, "ERROR");
			}*/
			 
		}
		
		private function validateLimitations(limit:ImportTypeLimitationsVO):void
		{
			
			_lastError =  validateNumFiles(limit.numFiles); 
			
			if(_lastError.type == LimitationErrorType.OK){
				_lastError = validateFileSize(limit.singleFileSize);
			}
			
			if(_lastError.type == LimitationErrorType.OK){
				_lastError = validateTotalSize(limit.totalFileSize);
			}
			
			_model.limitationMinimumIsValid = _lastError.min;
		}
		
		private function validateNumFiles(numFilesLimit:RangeLimitation):LimitationError
		{
			var max:int;
			if(_isSearch)
			{
				max = _model.limitationsVo.search.numFiles.max;
			}
			else
			{
				max = _model.limitationsVo.upload.numFiles.max;
			}
			
			if(max && max == 1)
			{
				//_model.importData.importCart.leaveLast(); done from AddToImportCartCommand
				return new LimitationError(LimitationErrorType.OK);
			}
			
			
			var ret:LimitationError = new LimitationError(LimitationErrorType.OK);
			if(numFilesLimit){
				if(numFilesLimit.min != -1 && _importCartItems.length < numFilesLimit.min){
					ret.min = false;
					ret.type = LimitationErrorType.MIN_NUM_FILES;
					ret.message = ResourceManager.getInstance().getString( ResourceBundleNames.ERRORS, "MIN_NUM_FILES", [numFilesLimit.min.toString()]);
				}
				if(numFilesLimit.max != -1 && _importCartItems.length > numFilesLimit.max){
					ret.max = false;
					ret.type = LimitationErrorType.MAX_NUM_FILES;
					ret.message = ResourceManager.getInstance().getString( ResourceBundleNames.ERRORS, "MAX_NUM_FILES_" + _errorSuffix, [numFilesLimit.max.toString()]);
				}
			}
			
			return ret;
		}
		
		private function validateFileSize(maxFileSizeLimit:RangeLimitation):LimitationError
		{
			var ret:LimitationError = new LimitationError(LimitationErrorType.OK);
			//var min:Boolean, max:Boolean = true;
			
			if (maxFileSizeLimit && _importCartItems[0] is ImportFileVO)
			{
				for each(var file:ImportFileVO in _importCartItems){
					if(file.uploadStatus != UploadStatusTypes.UPLOAD_COMPLETE)
					{
						if(maxFileSizeLimit.min != -1 && file.polledfileReference.bytesTotal < maxFileSizeLimit.min ){
							ret.min = false;
							ret.type = LimitationErrorType.UNDERSIZED_FILE;
							ret.message = ResourceManager.getInstance().getString( ResourceBundleNames.ERRORS, "UNDERSIZED_FILE", [Number(maxFileSizeLimit.min / MEGABYTE).toFixed(1), file.polledfileReference.fileReference.name]);
							Alert.show(ret.message);
							//file.polledfileReference.fileReference.name; //file name
						}
						
						if(maxFileSizeLimit.max != -1 && file.polledfileReference.bytesTotal > maxFileSizeLimit.max){
							ret.max = false;
							ret.type = LimitationErrorType.OVERSIZED_FILE;
							ret.message = ResourceManager.getInstance().getString( ResourceBundleNames.ERRORS, "OVERSIZED_FILE", [Number(maxFileSizeLimit.max / MEGABYTE).toFixed(1), file.polledfileReference.fileReference.name]);
							Alert.show(ret.message);
						}
					}
				}
			}

			return ret;
		}
		
		private function validateTotalSize(totalSizeLimit:RangeLimitation):LimitationError
		{
			var totalSize:int;
			var ret:LimitationError = new LimitationError(LimitationErrorType.OK);
			if (totalSizeLimit && _importCartItems[0] is ImportFileVO)
			{
				for each(var file:ImportFileVO in _importCartItems){
					totalSize += file.polledfileReference.bytesTotal;
				}
				
				//ret = (totalSizeLimit.max == -1 || totalSize <= totalSizeLimit.max)
				   //&& (totalSizeLimit.min == -1 || totalSize >= totalSizeLimit.min);
				if(totalSizeLimit.min != -1 && totalSize < totalSizeLimit.min){
					ret.min = false;
					ret.type = LimitationErrorType.UNDERSIZED_TOTAL;
					ret.message = ResourceManager.getInstance().getString( ResourceBundleNames.ERRORS, "UNDERSIZED_TOTAL", [Number(totalSizeLimit.min / MEGABYTE).toFixed(1)]);
				}
				if(totalSizeLimit.max != -1 && totalSize > totalSizeLimit.max){
					ret.max = false;
					ret.type = LimitationErrorType.OVERSIZED_TOTAL;
					ret.message = ResourceManager.getInstance().getString( ResourceBundleNames.ERRORS, "OVERSIZED_TOTAL", [Number(totalSizeLimit.max / MEGABYTE).toFixed(1)]);
					Alert.show(ret.message);
				}
			}
			
			return ret;
		}
		
	}
}