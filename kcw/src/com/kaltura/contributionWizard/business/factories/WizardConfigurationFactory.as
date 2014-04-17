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
package com.kaltura.contributionWizard.business.factories
{
	import com.kaltura.contributionWizard.model.MediaProviders;
	import com.kaltura.contributionWizard.model.StartupDefaultsVO;
	import com.kaltura.contributionWizard.model.WizardModelLocator;
	import com.kaltura.contributionWizard.model.importTypesConfiguration.ImportTypesConfig;
	import com.kaltura.contributionWizard.model.importTypesConfiguration.search.ModerationFilter;
	import com.kaltura.contributionWizard.model.importTypesConfiguration.search.SearchConfig;
	import com.kaltura.contributionWizard.model.importTypesConfiguration.tagging.TaggingConfig;
	import com.kaltura.contributionWizard.model.importTypesConfiguration.upload.UploadConfig;
	import com.kaltura.contributionWizard.vo.ImportScreenVO;
	import com.kaltura.contributionWizard.vo.UIConfigVO;
	import com.kaltura.contributionWizard.vo.limitations.*;
	import com.kaltura.contributionWizard.vo.providers.AuthenticationMethod;
	import com.kaltura.contributionWizard.vo.providers.AuthenticationMethodList;
	import com.kaltura.contributionWizard.vo.providers.MediaInfo;
	import com.kaltura.contributionWizard.vo.providers.MediaProviderVO;
	import com.kaltura.contributionWizard.vo.providers.WebcamParametersVO;
	import com.kaltura.utils.PathUtil;
	
	import flash.net.FileFilter;
	import flash.utils.Dictionary;
	
	import mx.collections.XMLListCollection;

	/**
	 * This class is used for translating given XML's to proper VO's 
	 * @author Michal
	 * 
	 */	
	public class WizardConfigurationFactory
	{
		/**
		 * This function recieves a config XML and returns the WebcamParametersVO that represents it 
		 * @param xmlRawConfig the XML to translate
		 * @return the WebcamParametersVO that represents this XML
		 * 
		 */		
		public static function getWebcamParameters(xmlRawConfig:XML):WebcamParametersVO
		{
			var xmlConfFile:XML = getConfigRoot(xmlRawConfig);
			if(!xmlConfFile) return null;
			
			var webcamParams:XML = xmlConfFile.webcamParams[0];
			var tempVO:WebcamParametersVO = new WebcamParametersVO();
			if(webcamParams)
			{				
				tempVO.bandwidth = parseInt(webcamParams.bandwidth);
				tempVO.favorArea = webcamParams.favorArea == "true";
				tempVO.framerate = parseInt(webcamParams.framerate);
				tempVO.width = parseInt(webcamParams.width);
				tempVO.height = parseInt(webcamParams.height);
				tempVO.keyFrameInterval = parseInt(webcamParams.keyFrameInterval);
				tempVO.quality = parseInt(webcamParams.quality);
				
				if (webcamParams.bufferTime) tempVO.bufferTime = parseInt(webcamParams.bufferTime);
				
				//audio
				/////////////////////////////////////////
				if(webcamParams.setUseEchoSuppression) tempVO.setUseEchoSuppression = webcamParams.setUseEchoSuppression != "false"; //the defualt is true
				if(webcamParams.gain) tempVO.gain = Number(webcamParams.gain);
				if(webcamParams.rate) tempVO.rate = parseInt(webcamParams.rate);
				if(webcamParams.silenceLevel) tempVO.silenceLevel = Number(webcamParams.silenceLevel);
				if(webcamParams.silenceLevelTimeout) tempVO.silenceLevelTimeout = parseInt(webcamParams.silenceLevel);
				/////////////////////////////////////////
			}
			return tempVO;
		}
		
		/**
		 * This function recieves a config XML and returns the LimitationsVO that represents it 
		 * @param xmlRawConfig the XML to translate
		 * @return the LimitationsVO that represents this XML
		 * 
		 */	
		public static function getLimitationsVo(xmlRawConfig:XML):LimitationsVO
		{
			var xmlConfFile:XML = getConfigRoot(xmlRawConfig);
			if(!xmlConfFile) return null;

			var limitation:XML = xmlConfFile.limitations[0];
			return getLimitationVoFromElement(limitation);	
		}
		
		/**
		 * This function recieves a linitation XML and returns the LimitationsVO that represents it 
		 * @param limitation the XML to translate
		 * @return the LimitationsVO that represents this XML
		 * 
		 */	
		public static function getLimitationVoFromElement(limitation:XML):LimitationsVO
		{
			var tempVO:LimitationsVO;
			if(limitation)
			{
				var uploadLimitationsVo:ImportTypeLimitationsVO = getImportTypeLimitations(limitation.upload[0]);
				var searchLimitationsVo:ImportTypeLimitationsVO = getImportTypeLimitations(limitation.search[0]);	
				tempVO = new LimitationsVO(searchLimitationsVo, uploadLimitationsVo);
			}
			return tempVO
		}
		
		private static function getImportTypeLimitations(xmlTypeLimitation:XML):ImportTypeLimitationsVO
		{
			var tempLimitationVo:ImportTypeLimitationsVO
			if(xmlTypeLimitation)
			{
				tempLimitationVo = new ImportTypeLimitationsVO();
				for each(var xmlRangeLimitation:XML in xmlTypeLimitation.children())
				{
					tempLimitationVo[xmlRangeLimitation.name().toString()] = new RangeLimitation(parseXMLInt(xmlRangeLimitation.@min), parseXMLInt(xmlRangeLimitation.@max));	 
				}
			}
			return tempLimitationVo;
		}
		
		private static function parseXMLInt(s:String):int
		{
			return s.length > 0 ? parseInt(s) : -1;
		}
		
		/**
		 * This function returns the uiconfigVO that suites the given params 
		 * @param xmlConfig the given XML
		 * @param wizardUrl 
		 * @return the suitable UIconfigVO
		 * 
		 */	
		public static function getWizardUiConfig(xmlConfig:XML, wizardUrl:String):UIConfigVO
		{
			var rootUrl:String = WizardModelLocator.getInstance().context.sourceUrl;
			var xmlContributionWizard:XML = getConfigRoot(xmlConfig);
			if(!xmlContributionWizard)return null;
		
			var xmlUiConf:XML = xmlContributionWizard..UIConfig.(child("target") == wizardUrl)[0];
			var wizardUiConfVo:UIConfigVO = createUiConfVo(xmlUiConf, rootUrl);
			return wizardUiConfVo;
		}
		
		/**
		 * This function creates the suitable StartupDefaultsVO according to the given config XML 
		 * @param xmlRawConfig the given XML config
		 * @return the StartupDefaultsVO that represnets the given XML 
		 * 
		 */	
		public static function getStartupDefaults(xmlRawConfig:XML):StartupDefaultsVO
		{
			var startupDefaults:StartupDefaultsVO = new StartupDefaultsVO();
			var xmlConfigRoot:XML = getConfigRoot(xmlRawConfig);
			if(!xmlConfigRoot) return null;

			startupDefaults.defaultScreenVo 	= getDefaultImportScreen(xmlConfigRoot);

			var xmlStartupDefaults:XML = xmlConfigRoot..StartupDefaults[0];
			var xmlNavigationProperties:XML = xmlStartupDefaults.NavigationProperties[0];

			if (xmlNavigationProperties)
			{
				startupDefaults.enableTagging		= xmlNavigationProperties.enableTagging 	== "true";
				startupDefaults.enableIntroScreen	= xmlNavigationProperties.enableIntroScreen == "true";
				startupDefaults.showCloseButton		= xmlNavigationProperties.showCloseButton[0] ? xmlNavigationProperties.showCloseButton[0] == "true" : startupDefaults.showCloseButton;
				
				//BOAZ ADDITION
				/////////////////////////////
				if(xmlNavigationProperties.showConfirmButtons)
					startupDefaults.showConfirmButtons = xmlNavigationProperties.showConfirmButtons[0] != "false";
				/////////////////////////////
					
			}
			if (xmlStartupDefaults.SingleContribution[0])
			{
				startupDefaults.singleContribution = xmlStartupDefaults.SingleContribution[0] == "true";
			}
			if(xmlStartupDefaults.ConfirmButtons[0])
			{
				
			}
			
			if(xmlStartupDefaults.showLogoImage[0])
			{
				startupDefaults.showLogoImage = xmlStartupDefaults.showLogoImage[0] == "true";
			}
			
			if(xmlStartupDefaults.showCategories[0])
			{
				startupDefaults.showCategories = xmlStartupDefaults.showCategories[0] == "true";
			}
			if(xmlStartupDefaults.showTags[0])
			{
				startupDefaults.showTags = xmlStartupDefaults.showTags[0] == "true";
			}
			if(xmlStartupDefaults.showDescription[0])
			{
				startupDefaults.showDescription = xmlStartupDefaults.showDescription[0] == "true";
			}


			if (xmlStartupDefaults.permissions[0])
			{
				if (xmlStartupDefaults..alwaysShowPermission[0])
					startupDefaults.alwaysShowPermission = xmlStartupDefaults..alwaysShowPermission[0] == "true";

				if (xmlStartupDefaults..defaultPermissionLevel[0])
					startupDefaults.defaultPermissionLevel = parseInt(xmlStartupDefaults..defaultPermissionLevel[0]);
			}

			if (xmlStartupDefaults.autoTOUConfirmation[0])
				startupDefaults.autoTOUConfirmation = xmlStartupDefaults.autoTOUConfirmation[0] == "true";

			if (xmlStartupDefaults.enableTOU[0])
				startupDefaults.enableTOU = xmlStartupDefaults.enableTOU[0] == "true";

			return startupDefaults
		}

		/**
		 * This function returns the suitable ImportTypesConfig according to the given config XML 
		 * @param xmlRawConfig the given config XML
		 * @return the suitable ImportTypesCofig
		 * 
		 */		
		public static function getImportTypesConfig(xmlRawConfig:XML):ImportTypesConfig
		{
			var xmlConfigRoot:XML = getConfigRoot(xmlRawConfig);
			if(!xmlConfigRoot) return null;
			
			var xmlImportTypesConfig:XML = xmlConfigRoot.ImportTypesConfig[0];
			var importTypesConfig:ImportTypesConfig = new ImportTypesConfig();
			if (xmlImportTypesConfig)
			{
				importTypesConfig.search 	= getSearchConfig(xmlImportTypesConfig.searchConfig[0]);
				importTypesConfig.tagging	= getTaggingConfig(xmlImportTypesConfig.taggingConfig[0]);

				var xmlUploadConfig:XML = xmlImportTypesConfig.uploadConfig[0];
				if (xmlUploadConfig)
					importTypesConfig.upload	= getUploadConfig(xmlUploadConfig);

			}

			return importTypesConfig;
		}

		private static function getSearchConfig(xmlSearch:XML):SearchConfig
		{
			var searchConfig:SearchConfig = new SearchConfig();
			if (xmlSearch)
			{
				if (xmlSearch.filter[0])
				{
					var xmlFilter:XML = xmlSearch.filter[0];
					var modFilter:ModerationFilter = new ModerationFilter();
					searchConfig.moderationFilter = modFilter;
					modFilter.url = xmlFilter.url;
					modFilter.timeout = xmlFilter.timeout;
				}
			}
			return searchConfig;
		}

		private static function getTaggingConfig(xmlTagging:XML):TaggingConfig
		{
			if (xmlTagging)
			{
				var taggingConfig:TaggingConfig = new TaggingConfig();

				var chooseValue:Function = function(defaultValue:int, newValue:String):int
				{
						var newValueInt:int = parseInt(newValue);
						return isFinite(newValueInt) ? newValueInt : defaultValue;
				}


				taggingConfig.minTitleLen	= chooseValue(taggingConfig.minTitleLen, 	xmlTagging.minTitleLen);
				taggingConfig.maxTitleLen	= chooseValue(taggingConfig.maxTitleLen, 	xmlTagging.maxTitleLen);
				taggingConfig.minTagsLen	= chooseValue(xmlTagging.minTagsLen, 		xmlTagging.minTagsLen);
				taggingConfig.maxTagsLen	= chooseValue(taggingConfig.maxTagsLen, 	xmlTagging.maxTagsLen);
			}
			return taggingConfig;
		}

		private static function getUploadConfig(xmlUploadView:XML):UploadConfig
		{
			var uploadConfig:UploadConfig = new UploadConfig();
			uploadConfig.singleClickUpload = getBoolFromXml(xmlUploadView.singleClickUpload, uploadConfig.singleClickUpload);
			return uploadConfig;
		}

		private static function getBoolFromXml(xmlValues:XMLList, defaultValue:*):*
		{
			return xmlValues[0] ? xmlValues[0] == "true" : defaultValue;
		}

		private static function getDefaultImportScreen(xmlConfig:XML):ImportScreenVO
		{
			var xmlGotoScreen:XML = xmlConfig..gotoScreen[0];
			if (xmlGotoScreen)
			{
				var defaultImportScreen:ImportScreenVO = new ImportScreenVO();
				defaultImportScreen.mediaProviderName = xmlGotoScreen.mediaProviderName;
				defaultImportScreen.mediaType 		= xmlGotoScreen.mediaType;
				return defaultImportScreen;
			}
			else
			{
				return null;
			}
		}


		private static function createUiConfVo(xmlUiConf:XML, rootUrl:String):UIConfigVO
		{
			if (!xmlUiConf) return null;
			var uiConfVo:UIConfigVO = new UIConfigVO();
			var rootUrl:String = WizardModelLocator.getInstance().context.sourceUrl;

			uiConfVo.styleUrl	= xmlUiConf.cssUrl[0] 		? 	PathUtil.getAbsoluteUrl(rootUrl, xmlUiConf.cssUrl) :
																null;
			uiConfVo.localeUrl	= xmlUiConf.localeUrl[0] 	? 	PathUtil.getAbsoluteUrl(rootUrl, xmlUiConf.localeUrl) :
																null;
			if(xmlUiConf && !uiConfVo.uiconfXml)
				uiConfVo.uiconfXml = xmlUiConf; 
			
			return uiConfVo;

		}

		/**
		 *Returns the getuiconf's confFile node parsed as XML
		 * @param rawXml
		 * @return
		 *
		 */
		private static function getConfigRoot(rawXml:XML):XML
		{
			var xmlConfig:XML = null;
			if(rawXml && rawXml.result && rawXml.result.confFile && rawXml.result.confFile[0])
				xmlConfig = rawXml.result.confFile[0];
			else 
				return null;

			var txtContributionWizard:String = unescape(xmlConfig.text()[0]);
			txtContributionWizard = replaceEnvironmentalVars(txtContributionWizard);
			var xmlContributionWizard:XML = new XML(txtContributionWizard);
			
			
			return xmlContributionWizard;
		}

		private static var _model:WizardModelLocator = WizardModelLocator.getInstance();

		private static function replaceEnvironmentalVars(value:String):String
		{
			var replacedString:String;
			replacedString = value.replace(/{HOST_NAME}/g, _model.context.hostName);
			return replacedString;
		}

		/**
		 * This function recieves a config XML and returns the suitable MediaProviders object 
		 * @param xmlConfig the given XML cofig file
		 * @return the MediaProviders object that represents the media providers that were
		 * given in the given XML
		 * 
		 */		
		public static function createMediaProviders(xmlConfig:XML):MediaProviders
		{
			var xmlContributionWizard:XML = getConfigRoot(xmlConfig);
			if(!xmlContributionWizard) return null;
			
			var uiConfMap:Dictionary = getUiConfMap(xmlContributionWizard.UIConfigList[0]);
			var mediaProvidersMap:Dictionary;

			var xmllMediaTypes:XMLListCollection = new XMLListCollection(XMLList(xmlContributionWizard.mediaTypes.media.@type));
			var mediaTypes:Array = xmllMediaTypes.toArray().map(function(item:Object, i:int, list:Array):String
																{
																	return item.toString();
																}
															);

			var mediaProviders:MediaProviders = new MediaProviders(mediaTypes);

			for each (var xmlProvider:XML in xmlContributionWizard.mediaTypes..provider)
			{
				var mediaType:String = xmlProvider.parent().@type;
				var mediaProviderVo:MediaProviderVO = createMediaProvider(xmlProvider, mediaType, uiConfMap);
				mediaProviders.addMediaProvider(mediaProviderVo);
				//handle the 4 types conversion profile if it exist
				if(xmlProvider.attribute('conversionProfileId').length())
					setConversionProfileId(xmlProvider,mediaType);
			}
			//handle global if exist
			if(xmlContributionWizard.mediaTypes.attribute('defaultConversionProfileId').length())
			{
				setConversionProfileId(xmlContributionWizard.mediaTypes[0] , 'global');
			}
			return mediaProviders;
		}

		private static function setConversionProfileId(xmlProvider:XML , mediaType:String):void
		{
			var wizardModleLocator:WizardModelLocator = WizardModelLocator.getInstance();
			switch (mediaType)
			{
				case 'video':
					wizardModleLocator.uiConfigVo.videoConversionProfile = xmlProvider.attribute('conversionProfileId')[0] ;
				break;
				case 'audio':
					wizardModleLocator.uiConfigVo.audioConversionProfile = xmlProvider.attribute('conversionProfileId')[0] ;
				break;
				case 'swf':
					wizardModleLocator.uiConfigVo.swfConversionProfile = xmlProvider.attribute('conversionProfileId')[0] ;
				break;
				case 'image':
					wizardModleLocator.uiConfigVo.imageConversionProfile = xmlProvider.attribute('conversionProfileId')[0] ;
				break;
				case 'global':
					wizardModleLocator.uiConfigVo.globalConversionProfile = xmlProvider.attribute('defaultConversionProfileId')[0] ;
				break;
			}
		}
		
		
		
		private static function getUiConfMap(xmlUiConfigList:XML):Dictionary
		{
			var rootUrl:String = WizardModelLocator.getInstance().context.sourceUrl;
			var uiConfMap:Dictionary = new Dictionary();
			for each (var xmlUiConfig:XML in xmlUiConfigList.children())
			{
				var uiConfVo:UIConfigVO = createUiConfVo(xmlUiConfig, rootUrl);
				var target:String = xmlUiConfig.target;
				uiConfMap[target] = uiConfVo;
			}

			return uiConfMap
		}

		private static function createMediaProvider(xmlProvider:XML, mediaType:String, uiConfMap:Dictionary):MediaProviderVO
		{
			//the total number of services is determined by the <media /> element count, whose direct parent is <service />
			var sourceUrl:String = WizardModelLocator.getInstance().context.sourceUrl;

			var mediaProvider:MediaProviderVO = new MediaProviderVO();

			var providerName:String = xmlProvider.@name;
			var providerCode:String = xmlProvider.@code;
			var addSearchResult:Boolean = xmlProvider.@addsearch == "true";
			var rawModuleUrl:String = xmlProvider.moduleUrl;
			var rootUrl:String = WizardModelLocator.getInstance().context.sourceUrl;
			//trace("createMediaProvider", rootUrl, rawModuleUrl);
			var absModuleUrl:String = PathUtil.getAbsoluteUrl(rootUrl, rawModuleUrl); //URLUtil.getFullURL(sourceUrl, rawModuleUrl);//
			//trace("absModuleUrl", absModuleUrl);

			var authMethodList:AuthenticationMethodList = createAuthMethodList(xmlProvider.authMethodList[0]);
			var allowPublicSearch:Boolean 				= int(xmlProvider.allowPublicSearch.text()) == 1;
			//var name:String 							= providerName;//xmlService.name.text() != "" ? xmlService.name.text() : "No name supplied";



			var allowedTypesString:String = xmlProvider..allowedTypes;
			if (allowedTypesString)
				var allowedFilesTypes:Array				= getFileFilterList(allowedTypesString, mediaType );
			var mediaInfo:MediaInfo 					= new MediaInfo(mediaType, allowedFilesTypes);
			var customData:Object 						= createCustomData(xmlProvider.customData[0]);
			var tokens:Object 							= xmlProvider.tokens[0] ?
																				getTokens(xmlProvider.tokens.token) : null;
			mediaProvider.providerName 		= providerName;
			mediaProvider.providerCode		= providerCode;
			mediaProvider.addSearchResult 	= addSearchResult;
			mediaProvider.moduleUrl			= absModuleUrl;
			mediaProvider.authMethodList 	= authMethodList;
			mediaProvider.allowPublicSearch = allowPublicSearch;
			mediaProvider.mediaInfo			= mediaInfo;
			mediaProvider.customData		= customData;
			mediaProvider.tokens			= tokens;

			var inlineUiConfigVo:UIConfigVO = createUiConfVo(xmlProvider.UIConfig[0], sourceUrl);
			//if the media provider (service) includes an inline UI configuration it overrides the corresponding UI configuration for this specific media provider definition
			var uiConfVo:UIConfigVO = inlineUiConfigVo ?
														inlineUiConfigVo :
														uiConfMap[rawModuleUrl];
			mediaProvider.uiConfig	=  uiConfVo;

			 return mediaProvider;
		}


		private static function getFileFilterList(fileTypes:String, mediaType:String):Array
		{
			var fileTypesArray:Array = fileTypes.split(",");;
			for (var i:int = 0; i < fileTypesArray.length; i++)
			{
				fileTypesArray[i] = '*.' + fileTypesArray[i] + ';';
			}
			var formattedFileTypes:String = fileTypesArray.join("");
			var description:String = mediaType + " (" + formattedFileTypes + ")";
			var fileFilter:FileFilter = new FileFilter(description, formattedFileTypes);
			return [fileFilter];
		}
		private static function replaceAll(string:String, originalString:String, replaceWith:String):String
		{
			var array:Array = string.split(originalString);
			return array.join(replaceWith);
		}

		private static function createAuthMethodList(xmlAuthMethodList:XML):AuthenticationMethodList
		{
			var authMethodList:AuthenticationMethodList = new AuthenticationMethodList();
			var xmlListAuthMethod:XMLList = xmlAuthMethodList["authMethod"];
			var authMethodArray:Array = new Array();
			for each (var xmlAuthMethod:XML in xmlListAuthMethod)
			{
				var authMethod:AuthenticationMethod = new AuthenticationMethod( parseInt( xmlAuthMethod.@type ) );
				if (xmlAuthMethod.@searchable[0])
				{
					var searchable:Boolean = xmlAuthMethod.@searchable == "true";
					authMethod.searchable = searchable;
				}

				authMethodArray.push(authMethod);
			}
			authMethodList.setAuthMethodList(authMethodArray);
			return authMethodList;
		}

		private static function getMediaNodesList(servicesConfiguration:XML):XMLList
		{
			return servicesConfiguration..media;
		}
		private static function createCustomData(xmlCustomData:XML):Object
		{
			var customDataObject:Object = {};
			if (!xmlCustomData) return customDataObject;

			for each (var xmlChild:XML in xmlCustomData.children())
			{
				var propertyName:String = xmlChild.name();
				var value:String = xmlChild.text().toString();

				customDataObject[propertyName] = value;
			}
			return customDataObject
		}

		private static function getTokens(xmllTokens:XMLList):Object
		{
			var tokensObj:Object = {};
			for each(var token:XML in xmllTokens)
			{
				tokensObj[token.name.toString()] = token.value.toString();
			}

			return tokensObj;
		}

	}
}