package com.kaltura.contributionWizard.view.importViews
{
	import com.kaltura.contributionWizard.view.importViews.browser.NavigationButtonsMode;

	public interface IImportStep
	{
		function goNextStep():void;
		function goPrevStep():void;
		function get navigationButtonsMode():NavigationButtonsMode;
	}
}