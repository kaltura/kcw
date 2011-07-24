package com.kaltura.contributionWizard.command
{
	import com.adobe_cw.adobe.cairngorm.commands.ICommand;
	import com.adobe_cw.adobe.cairngorm.commands.SequenceCommand;
	import com.adobe_cw.adobe.cairngorm.control.CairngormEvent;
	import com.kaltura.contributionWizard.events.SaveInjectedDataEvent;
	import com.kaltura.contributionWizard.model.WizardModelLocator;
	import com.kaltura.contributionWizard.util.ContextDecorator;
	import com.kaltura.contributionWizard.vo.ImportScreenVO;
	import com.kaltura.utils.KConfigUtil;
	import com.kaltura.utils.KUtils;
	import com.kaltura.utils.ObjectHelpers;
	import com.kaltura.utils.PathUtil;
	
	import mx.utils.ObjectUtil;
	import mx.utils.URLUtil;

	public class SaveInjectedDataCommand extends SequenceCommand implements ICommand
	{

		private var _model:WizardModelLocator = WizardModelLocator.getInstance();
		//parameter object, either from flashvars or loading swf injection
		private var _parameters:Object;

		override public function execute(event:CairngormEvent):void
		{
			var evtGetContext:SaveInjectedDataEvent = event as SaveInjectedDataEvent;
			nextEvent = evtGetContext.nextChainedEvent;
			trace(ObjectUtil.toString(evtGetContext.parameters))
			_parameters =  ObjectHelpers.lowerNoUnderscore(evtGetContext.parameters);

			/*if (_parameters.sessionid || _parameters.ks)
			{
				trace("SaveInjectedDataCommand has sessionId");
				setContext();
			}
			else
			{
				//if the parameters object is empty
				trace("SaveInjectedDataCommand doesn't have sessionId");
			}*/
			
			setContext();
			
		}

		private function setContext():void
		{
			_model.context.protocol     = _parameters["protocol"];
 			_model.context.userId		= _parameters["uid"] || _parameters["userid"];//the latter is for backward compatibility
			_model.context.isAnonymous	= _parameters["isanonymous"] == "true";
			_model.context.partnerId	= parseInt( _parameters["partnerid"] ); // if null it'll become 0, needed for the preloader
			_model.context.hasPartnerId = Boolean(_parameters["partnerid"]);
			//_model.context.subPartnerId	= parseInt( _parameters["subpartnerid"] ) ||  parseInt( _parameters["subpid"] );//the latter is for backward compatibility
			_model.context.sessionId	= _parameters["ks"] || _parameters["sessionid"] || "";//the latter is for backward compatibility
			_model.context.kshowId		= String(_parameters["kshowid"]);
			var hostCode:String 		= _parameters["host"];

			_model.externalUrls.termsOfUseUrl 						= 	KConfigUtil.getDefaultValue(_parameters["termsofuse"], _model.externalUrls.termsOfUseUrl);
			_model.externalFunctions.addEntryFunction 				= 	_parameters["afteraddentry"];
			_model.externalFunctions.onWizardFinishFunction 		= 	_parameters["close"];
			_model.externalFunctions.wizardReadyFunction	 		= 	_parameters["wizardreadyhandler"];

			_model.context.permissions								=	_parameters["permissions"];	

			_model.externalUrls.servicesUrl							= 	_model.context.protocol + KUtils.hostFromCode(hostCode);

			var fullUrl:String 										= 	_parameters["url"];
			_model.context.sourceUrl 								=	PathUtil.getSourceUrl(fullUrl);
			_model.context.cdnHost									=	_parameters.cdnhost;
			_model.context.hostName									= 	URLUtil.getServerName(_model.externalUrls.servicesUrl);
			_model.context.fileName									=	PathUtil.getFileName(fullUrl);

			_model.context.groupId									= _parameters["groupid"];
			_model.context.partnerData								= _parameters["partnerdata"];
			_model.context.fileSystemMode							= _parameters["filesystemmode"] == "true" ? true : false; 
			_model.context.uiConfigId 								= _parameters["uiconfid"] || _model.context.uiConfigId;
			setUploadUrl();

			//_model.startupDefaults.showCloseButton = KConfigUtil.getDefaultValue2(_parameters["showclosebutton"], _model.startupDefaults, "showCloseButton")
			
			if (_parameters["showclosebutton"])
			{
				_model.startupDefaults.showCloseButton = _parameters["showclosebutton"] == "true";
				_model.startupDefaults.showCloseButtonFlashvars = true;
			}
			if (_parameters["showcategories"])
			{
				_model.startupDefaults.showCategories = _parameters["showcategories"] == "true";
				_model.startupDefaults.showCategoriesFlashvar = true;
			}
			if (_parameters["showdescription"])
			{
				_model.startupDefaults.showDescription = _parameters["showdescription"] == "true";
				_model.startupDefaults.showDescriptionFlashvar = true;
			}
			if (_parameters["showtags"])
			{
				_model.startupDefaults.showTags = _parameters["showtags"] == "true";
				_model.startupDefaults.showTagsFlashvar = true;
			}
			if (_parameters["loadthumbnailwithks"])
			{
				_model.loadThumbsWithKS = _parameters["loadthumbnailwithks"] == "true";
			}

			//Default media type to show at startup
			_model.externalUrls.startupPreloaderUrl = getPreloaderUrl();
			_model.context.addToRoughCut = _parameters["quickedit"];

			_model.context.defaultUrlVars = getDefaultUrlVars();
			setDefaultScreenVo();			

			saveGenericVars();
			
			//setLimitation();
			
			executeNextCommand();
		}

		private function getPreloaderUrl():String
		{
			var path:String = "/p/" + _model.context.partnerId + "/sp/" + _model.context.subPartnerId + "/kpreloader/ui_conf_id/" + _model.context.uiConfigId;
			//var url:String = PathUtil.getAbsoluteUrl(_model.context.sourceUrl, path);
			var host:String = _model.context.cdnHost ? _model.context.cdnHost : "cdn.kaltura.com";
			var url:String = _model.context.protocol + host + path;
			return url;
		}

		private function getDefaultUrlVars():Object
		{
			var defaultUrlVars:Object = new Object();
			ContextDecorator.addVariables(defaultUrlVars);
			return defaultUrlVars;
		}

		private function setDefaultScreenVo():void
		{
			var providerName:String = _parameters["defaultmediaprovidername"];
			var mediaType:String 	= _parameters["defaultmediatype"];
			if (mediaType)
			{
				_model.startupDefaults.defaultScreenVo = new ImportScreenVO();
				_model.startupDefaults.defaultScreenVo.mediaProviderName = 	providerName;
				_model.startupDefaults.defaultScreenVo.mediaType		 = 	mediaType;
			}
		}

		private function saveGenericVars():void
		{
			var kVars:Object = {};
			for (var key:String in _parameters)
			{
				if (key.substr(0, 4) == "kvar")
				{
					kVars[key.substr(4)] = _parameters[key];
				}
			}
			_model.context.injectedKVars = kVars;
		}

		private function setUploadUrl():void
		{
			if (_parameters["uploadurl"])
				_model.externalUrls.uploadUrl = _parameters["uploadurl"];
			else
				//_model.externalUrls.uploadUrl = _model.externalUrls.servicesUrl + "/index.php/partnerservices2/upload";
				//_model.externalUrls.uploadUrl = _model.externalUrls.servicesUrl + "/api_v3/index.php?service=media&action=upload";
				_model.externalUrls.uploadUrl = _model.externalUrls.servicesUrl + "/api_v3/index.php?service=uploadtoken&action=upload";
		}
		
		/*private function setLimitation():void
		{
			for(var key:String in _parameters)
			{
				Utils.setLimitationKey(key, _parameters[key]);
			}
		}*/
	}
}