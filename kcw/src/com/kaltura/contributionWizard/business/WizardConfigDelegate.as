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
package com.kaltura.contributionWizard.business
{
	import com.adobe_cw.adobe.cairngorm.business.ServiceLocator;
	import com.kaltura.contributionWizard.business.factories.WizardConfigurationFactory;
	import com.kaltura.contributionWizard.model.MediaProviders;
	import com.kaltura.contributionWizard.model.StartupDefaultsVO;
	import com.kaltura.contributionWizard.model.WizardModelLocator;
	import com.kaltura.contributionWizard.model.importTypesConfiguration.ImportTypesConfig;
	import com.kaltura.contributionWizard.view.resources.ResourceBundleNames;
	import com.kaltura.contributionWizard.vo.UIConfigVO;
	import com.kaltura.contributionWizard.vo.limitations.LimitationsVO;
	import com.kaltura.contributionWizard.vo.providers.WebcamParametersVO;
	import com.kaltura.net.TemplateURLVariables;
	
	import flash.net.URLVariables;
	
	import mx.controls.Alert;
	import mx.resources.ResourceManager;
	import mx.rpc.AsyncToken;
	import mx.rpc.IResponder;
	import mx.rpc.http.HTTPService;

	public class WizardConfigDelegate implements IResponder
	{
	   public function WizardConfigDelegate( responder : IResponder )
	   {
	      this.service = ServiceLocator.getInstance().getHTTPService( Services.WIZARD_CONFIG_SERVICE );
	      this.responder = responder;
	   }

	   public function getWizardConfiguration( uiConfigId:String) : ServiceCanceller
	   {
	   		var urlVars:URLVariables = getConfigURLVars(uiConfigId);
	   		
	   		//WORKAROUNG FOR THE EXTRA CALLS WITHOUT PARAMS WHEN LOADED FROM THE KSE 
	   		if(!urlVars.ks && !urlVars.partnerId) return null;
	   		
			var call : AsyncToken = service.send( urlVars );
			call.addResponder( this );

			return new ServiceCanceller( this.service );
	   }

	  /*  private function timeoutMock():void
	   {
			this.result( {result:_xmlWizardDummyConfig} );
	   } */
	   private var responder : IResponder;
	   private var service : HTTPService;

	   private var _model:WizardModelLocator = WizardModelLocator.getInstance();
	   //---------Server simulator---------
	   //[Embed(source="mockups/wizardConfigMockup.xml", mimeType="application/octet-stream")]
	   //private var WizardDummyConfig:Class;
	   //private var _xmlWizardDummyConfig:XML = new XML((new WizardDummyConfig() as ByteArray).toString());

		private function getConfigURLVars(uiConfigId:String):URLVariables
		{
	   		var urlVars:URLVariables = new TemplateURLVariables(_model.context.defaultUrlVars);
	   		//urlVars["ui_conf_id"] = uiConfigId;
	   		urlVars["id"] = uiConfigId;
	   		return urlVars;
		}

		public function result(data:Object):void
		{
			var xmlServicesConfiguration:XML;
			
			if(data.result && data.result.result && data.result.result.error[0] )
			{
				Alert.show(data.result.result.error[0].code.text(),ResourceManager.getInstance().getString( ResourceBundleNames.ERRORS, "SERVER_CONNECTION_ERROR_TITLE"));
			    return;
			}  
			else if(data && data.result)
				xmlServicesConfiguration = data.result as XML;
			else
			{
				trace("no config result");
				return;
			}
			
			var mediaProviders:MediaProviders 				= WizardConfigurationFactory.createMediaProviders	(xmlServicesConfiguration);//getMediaProviders(servicesList);
			var wizardUiConfig:UIConfigVO 					= WizardConfigurationFactory.getWizardUiConfig		(xmlServicesConfiguration, _model.context.fileName);
			var startupDefaults:StartupDefaultsVO			= WizardConfigurationFactory.getStartupDefaults		(xmlServicesConfiguration);
			var importTypesConfig:ImportTypesConfig			= WizardConfigurationFactory.getImportTypesConfig	(xmlServicesConfiguration);
			var limitations:LimitationsVO				 	= WizardConfigurationFactory.getLimitationsVo	  	(xmlServicesConfiguration);
			var webcamParametersVO:WebcamParametersVO  		= WizardConfigurationFactory.getWebcamParameters	(xmlServicesConfiguration);
			//TODO: this definitely doesn't belong here
			_model.context.permissions = startupDefaults.defaultPermissionLevel;

			var resultObj:Object =
									{
										mediaProviders			:	mediaProviders,
										wizardUiConfig			:	wizardUiConfig,
										startupDefaultsVo		:	startupDefaults,
										importTypesConfig		:	importTypesConfig,
										limitationsVo			:	limitations,
										webcamParametersVo		:   webcamParametersVO
									};

			responder.result(resultObj);
		}

		public function fault(info:Object):void
		{
			responder.fault(info);
		}
	}
}
