package com.kaltura.contributionWizard.vo
{
	import com.adobe.cairngorm.vo.IValueObject;

	public class PartnerNotificationVO implements IValueObject
	{
		public var url:String;
		public var queryString:String

		public function PartnerNotificationVO(url:String, queryString:String)
		{
			this.url = url;
			this.queryString = queryString;
		}
	}
}