package com.kaltura.contributionWizard.model.importTypesConfiguration.tagging
{
	import de.polygonal.ds.sort.compare.compareStringCaseInSensitive;

	[Bindable]
	public class TaggingConfig
	{
		public var minTitleLen:int 	= 1;
		public var maxTitleLen:int 	= 60;

		public var minTagsLen:int	= 0;
		public var maxTagsLen:int	= 4096;
	}
}