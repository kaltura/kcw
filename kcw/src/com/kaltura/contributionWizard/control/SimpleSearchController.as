package com.kaltura.contributionWizard.control
{
	import com.kaltura.contributionWizard.command.GetMediaInfoCommand;
	import com.kaltura.contributionWizard.command.LoginToProviderCommand;
	import com.kaltura.contributionWizard.command.ModerateSearchTermsCommand;
	import com.kaltura.contributionWizard.command.SearchMediaCommand;
	import com.kaltura.contributionWizard.command.ToggleAuthMethodCommand;
	import com.kaltura.contributionWizard.events.AuthMethodEvent;
	import com.kaltura.contributionWizard.events.LoginEvent;
	import com.kaltura.contributionWizard.events.MediaInfoEvent;
	import com.kaltura.contributionWizard.events.SearchMediaEvent;

	public class SimpleSearchController extends BaseSearchController
	{
		protected override function initializeCommands():void
		{
			super.initializeCommands()

			addCommand( AuthMethodEvent.TOGGLE_AUTH_METHOD,				ToggleAuthMethodCommand );
			addCommand( LoginEvent.PROVIDER_LOGIN, 						LoginToProviderCommand );
			addCommand( MediaInfoEvent.GET_MEDIA_INFO, 					GetMediaInfoCommand );
			addCommand( SearchMediaEvent.SEARCH_MEDIA, 					SearchMediaCommand );
		}
	}
}