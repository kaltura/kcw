package com.kaltura.contributionWizard.view.importViews
{
	import com.kaltura.contributionWizard.view.importViews.browser.NavigationButtonsMode;
	import com.kaltura.contributionWizard.view.resources.ResourceBundleNames;
	import com.kaltura.contributionWizard.vo.providers.MediaProviderVO;

	import flash.events.Event;

	import mx.collections.ArrayCollection;
	import mx.modules.Module;

	public class ImportModule extends Module implements IImportModule
	{
		private var _importItems:ArrayCollection /* of BaseImportVO */

		[Bindable]
		public function get importItems():ArrayCollection
		{
			return _importItems;
		}
		public function set importItems(value:ArrayCollection):void
		{
			_importItems = value;
			dispatchEvent(new Event("importItemsChange"));
		}


		public function goNextStep():void
		{

		}

		public function goPrevStep():void
		{
		}

		[Bindable("importItemsChange")]
		public function get navigationButtonsMode():NavigationButtonsMode
		{
			var nextText:String = resourceManager.getString(ResourceBundleNames.IMPORT_BROWSER, "NEXT");
			var prevtText:String = resourceManager.getString(ResourceBundleNames.IMPORT_BROWSER, "BACK");

			if (_importItems && _importItems.length > 0)
			{
				return new NavigationButtonsMode(true,	true, 	nextText,
												 false, false, 	prevtText);
			}
			else
			{
				return new NavigationButtonsMode(false, true, 	nextText,
												 false, false, 	prevtText);
			}
		}

		public function dispose():void
		{
		}

		public function activate():void
		{
		}

		public function deactivate():void
		{
		}

		public function mediaProviderChange(mediaProviderVo:MediaProviderVO):void
		{

		}
	}
}