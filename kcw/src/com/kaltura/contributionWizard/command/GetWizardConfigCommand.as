/*
This file is part of the Kaltura Collaborative Media Suite which allows users
to do with audio, video, and animation what Wiki platfroms allow them to do with
text.

Copyright (C) 2006-2008  Kaltura Inc.

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as
published by the Free Software Foundation, either version 3 of the
License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Affero General Public License for more details.

You should have received a copy of the GNU Affero General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.

@ignore
*/
package com.kaltura.contributionWizard.command
{
	import com.adobe_cw.adobe.cairngorm.commands.SequenceCommand;
	import com.adobe_cw.adobe.cairngorm.control.CairngormEvent;
	import com.bjorn.event.ChainEvent;
	import com.kaltura.contributionWizard.business.ServiceCanceller;
	import com.kaltura.contributionWizard.business.WizardConfigDelegate;
	import com.kaltura.contributionWizard.model.StartupDefaultsVO;
	import com.kaltura.contributionWizard.model.WebcamModelLocator;
	import com.kaltura.contributionWizard.model.WizardModelLocator;
	import com.kaltura.contributionWizard.model.WorkflowStatesList;
	import com.kaltura.contributionWizard.model.limitations.Utils;
	import com.kaltura.contributionWizard.vo.UIConfigVO;
	
	import mx.controls.Alert;
	import mx.core.Application;
	import mx.rpc.IResponder;

	public class GetWizardConfigCommand extends SequenceCommand implements IResponder
	{
		private var _model:WizardModelLocator = WizardModelLocator.getInstance();
		private var _webcamModel:WebcamModelLocator = WebcamModelLocator.getInstance();
		public override function execute( event : CairngormEvent ): void
		{
			trace("GetWizardConfigCommand()");
			nextEvent = (event as ChainEvent).nextChainedEvent;
			var delegate : WizardConfigDelegate = new WizardConfigDelegate( this );
			var uiConfigId:String = _model.context.uiConfigId;
			var serviceCanceller:ServiceCanceller = delegate.getWizardConfiguration(uiConfigId);
		}

		public function result(data:Object):void
		{
			var uiConfVo:UIConfigVO = data.wizardUiConfig as UIConfigVO;
			var startupDefaultsVo:StartupDefaultsVO = data.startupDefaultsVo;

			setWizardUiConfigVo(uiConfVo);
			_model.mediaProviders = data.mediaProviders;

			if (!_model.startupDefaults.defaultScreenVo)
			{
				_model.startupDefaults.defaultScreenVo = startupDefaultsVo.defaultScreenVo;
			}
			//FIXME: There should be a single point to set both definitions from flashvars and service that the flashvars can override
			_model.startupDefaults.enableIntroScreen	= startupDefaultsVo.enableIntroScreen;
			_model.startupDefaults.enableTagging		= startupDefaultsVo.enableTagging;
			_model.startupDefaults.singleContribution 	= startupDefaultsVo.singleContribution;
			_model.startupDefaults.alwaysShowPermission	= startupDefaultsVo.alwaysShowPermission;
			_model.startupDefaults.autoTOUConfirmation = startupDefaultsVo.autoTOUConfirmation;
			_model.startupDefaults.enableTOU = startupDefaultsVo.enableTOU;			
			_model.startupDefaults.defaultPermissionLevel = startupDefaultsVo.defaultPermissionLevel;
			_model.startupDefaults.showLogoImage = startupDefaultsVo.showLogoImage;
			
			//Boaz
			/////////////////////
			_model.startupDefaults.showConfirmButtons = startupDefaultsVo.showConfirmButtons;
			/////////////////////
			
			if (!_model.startupDefaults.showCloseButtonFlashvars)
			{
				_model.startupDefaults.showCloseButton = startupDefaultsVo.showCloseButton;
			}
			if (!_model.startupDefaults.showCategoriesFlashvar)
			{
				_model.startupDefaults.showCategories = startupDefaultsVo.showCategories;
			}
			if (!_model.startupDefaults.showDescriptionFlashvar)
			{
				_model.startupDefaults.showDescription = startupDefaultsVo.showDescription;
			}
			if (!_model.startupDefaults.showTagsFlashvar)
			{
				_model.startupDefaults.showTags = startupDefaultsVo.showTags;
			}

			_model.userCertified = _model.startupDefaults.autoTOUConfirmation;
			//_model.navigationProperties = data.navigationPropertiesVo;
			_model.importTypesConfiguration = data.importTypesConfig;
			_model.workflowStatesList = new WorkflowStatesList(startupDefaultsVo.enableIntroScreen, startupDefaultsVo.enableTagging, !startupDefaultsVo.singleContribution);
			
			//set limitations from uiconf
			if(data.limitationsVo)
			{
				if(data.limitationsVo.upload)
				{
					_model.limitationsVo.upload = data.limitationsVo.upload;
				}
				if(data.limitationsVo.search)
				{
					_model.limitationsVo.search = data.limitationsVo.search;
				}
			}
			
			//set limitation from flashVars
			var flashVars:Object = Application.application.parameters;
			for(var key:String in flashVars)
			{
				Utils.setLimitationKey(key, flashVars[key]);
			}
			_model.flashvars = flashVars;
			_webcamModel.webcamParameters = data.webcamParametersVo;
			
			_model.loadState.loaded();
			executeNextCommand();
		}

		public function fault(info:Object):void
		{
			Alert.show( "Services configuration could not been retrieved!" );
		}


		private function setWizardUiConfigVo(uiConfigVo:UIConfigVO):void
		{
			//I used copying values instead of setting the VO directly, because it is referenced at the wizard creation complete when chaining the startup events;
			//TODO: implement UIConfigVO.overrideProperties() method
			_model.uiConfigVo.localeUrl = uiConfigVo.localeUrl;
			_model.uiConfigVo.styleUrl = uiConfigVo.styleUrl;			
		}
	}
}