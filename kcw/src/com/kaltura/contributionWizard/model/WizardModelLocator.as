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
package com.kaltura.contributionWizard.model
{
	import com.adobe_cw.adobe.cairngorm.model.IModelLocator;
	import com.kaltura.contributionWizard.business.factories.WizardConfigurationFactory;
	import com.kaltura.contributionWizard.enums.KCWWorkflowState;
	import com.kaltura.contributionWizard.model.importData.ImportData;
	import com.kaltura.contributionWizard.model.importTypesConfiguration.ImportTypesConfig;
	import com.kaltura.contributionWizard.model.soundPlayer.SoundPlayerContext;
	import com.kaltura.contributionWizard.vo.UIConfigVO;
	import com.kaltura.contributionWizard.vo.limitations.LimitationError;
	import com.kaltura.contributionWizard.vo.limitations.LimitationsVO;
	import com.kaltura.dataStructures.HashMap;
	
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayCollection;
	import mx.managers.SystemManager;

   [Bindable]
	public class WizardModelLocator implements IModelLocator
	{

		public var workflowState:String = KCWWorkflowState.PRELOADING;

		public var context:Context;

		public var searchData:SearchData;

		public var mediaProviders:MediaProviders;// 				= new MediaProviders();
		public var providerLoginStatus:ProviderLoginStatus 		= new ProviderLoginStatus();
		public var importData:ImportData 						= new ImportData();
		public var pendingActions:PendingActions				= new PendingActions();
		public var soundPlayer:SoundPlayerContext 				= new SoundPlayerContext();
		public var externalUrls:ExternalUrls 					= new ExternalUrls();
		public var externalFunctions:ExternalFunctionIds 		= new ExternalFunctionIds();
		public var uiConfigVo:UIConfigVO;
		
		//TODO: get rid of this class
		public var loadState:LoadingState 						= new LoadingState();
		public var systemManager:SystemManager;
		public var startupDefaults:StartupDefaultsVO 			= new StartupDefaultsVO();

		public var importTypesConfiguration:ImportTypesConfig;
		public var userCertified:Boolean 						= false;

		public var workflowStatesList:WorkflowStatesList;
		public var limitationsVo:LimitationsVO;
		public var limitationIsValid:Boolean					= true;
		public var limitationMinimumIsValid:Boolean				= true;
		
		public var limitationError:LimitationError;
		public var limitationFLashVars:Dictionary;
		private var _limitationXML:XML;
		
		public var categories : Object = null;
		public var categoriesFromRoot : ArrayCollection = new ArrayCollection;
		public var categoriesMap : HashMap = new HashMap();
		public var categoriesFullNameList : ArrayCollection  = new ArrayCollection();
		public var categoriesRootId : int = 0;
		public var categoriesPrefix:String = "";
		public var loadingFlag : Boolean = false;
		public var flashvars : Object;
		public var additionalField:String = "";
		
		/**
		 * indicates whether the "list categories" action was sent to server at least once already 
		 */
		public var categoriesUploaded:Boolean = false;
		
		public var wereEntriesAdded:Boolean = false;
		/**
		 * Whether to load thumbnails with KS or not 
		 */		
		public var loadThumbsWithKS:Boolean = false;
		
		//-----------------------------Singleton implementation----------------------------- //
		private static var _modelLocator : WizardModelLocator;

		public static function getInstance() : WizardModelLocator
		{
			if ( _modelLocator == null )
			{
				_modelLocator = new WizardModelLocator();
			}

			return _modelLocator;
		}

		public function WizardModelLocator()
		{
			if ( _modelLocator != null )
			{
				throw new Error( "Only one WizardModelLocator instance should be instantiated" );
			}
			_modelLocator = this;

			context = new Context();
			searchData = new SearchData();
			uiConfigVo = new UIConfigVO();
			importTypesConfiguration = new ImportTypesConfig();
			limitationsVo = WizardConfigurationFactory.getLimitationVoFromElement(limitationXML);
		}

		
		private function get limitationXML():XML
		{
			if(!_limitationXML) _limitationXML = <limitations>
													<upload>
														<singleFileSize min="-1" max="-1" />
														<numFiles min="-1" max="-1" />
														<totalFileSize min="-1" max="-1" />
													</upload>
													<search>
														<numFiles min="-1" max="-1" />
													</search>
												</limitations>
			return _limitationXML;
		}
		
		private function set limitationXML(value:XML):void
		{
			_limitationXML = value;
		}
		
	}
}