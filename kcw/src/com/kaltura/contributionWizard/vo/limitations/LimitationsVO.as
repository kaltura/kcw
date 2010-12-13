package com.kaltura.contributionWizard.vo.limitations
{
	import com.adobe.cairngorm.vo.IValueObject;

	public class LimitationsVO implements IValueObject
	{
		public var search:ImportTypeLimitationsVO
		public var upload:ImportTypeLimitationsVO
		
		public function LimitationsVO(search:ImportTypeLimitationsVO, upload:ImportTypeLimitationsVO):void
		{
			this.search = search;
			this.upload = upload;
		}
	}
}