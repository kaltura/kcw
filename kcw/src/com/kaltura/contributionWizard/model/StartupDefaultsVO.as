package com.kaltura.contributionWizard.model
{
	import com.kaltura.contributionWizard.vo.ImportScreenVO;

	[Bindable]
	public class StartupDefaultsVO
	{
		public var defaultScreenVo:ImportScreenVO;
		public var singleContribution:Boolean 		= false

		public var enableTagging:Boolean 			= true;
		public var enableIntroScreen:Boolean 		= true;
		public var alwaysShowPermission:Boolean 	= false;
		public var autoTOUConfirmation:Boolean 		= false;
		public var enableTOU:Boolean				= false;
		public var defaultPermissionLevel:int		= -1;
		public var showCloseButton:Boolean			= true;
		public var showLogoImage:Boolean 			= true;
		
		public var showConfirmButtons:Boolean		= true;
		public var showCategories:Boolean 			= true;
		public var showDescription:Boolean 			= true;
		public var showTags:Boolean 				= true;
		
		//TODO: create single point to set the values both from flqshvars and from the config and avoid using such flags
		public var showCloseButtonFlashvars:Boolean	= false;
		public var showCategoriesFlashvar:Boolean 	= false;
		public var showDescriptionFlashvar:Boolean 	= false;
		public var showTagsFlashvar:Boolean = false;
	}

}