package com.kaltura.contributionWizard.view.importViews.browser
{
	[Bindable]
	public class NavigationButtonsMode
	{
		public function NavigationButtonsMode(nextEnabled:Boolean = false, nextExists:Boolean = true, nextText:String = "Next",
			prevEnabled:Boolean = false, prevExists:Boolean = false, prevText:String = "Back"):void
		{
			this.nextEnabled = nextEnabled;
			this.nextExists = nextExists;
			this.nextText = nextText;

			this.prevEnabled = prevEnabled;
			this.prevExists = prevExists;
			this.prevText = prevText;
		}

		public var nextEnabled:Boolean;
		public var nextExists:Boolean;
		public var nextText:String;

		public var prevEnabled:Boolean;
		public var prevExists:Boolean;
		public var prevText:String;
	}
}