package com.kaltura.contributionWizard.vo
{
	import com.adobe.cairngorm.vo.IValueObject;

	public class ImportScreenVO implements IValueObject
	{
		private var _mediaType:String;
		private var _mediaProviderName:String;

		public function ImportScreenVO(mediaType:String = null, mediaProviderName:String = null):void
		{
			this.mediaType = mediaType;
			this.mediaProviderName = mediaProviderName;

		}
		public function get mediaProviderName():String
		{
			return _mediaProviderName;
		}
		public function set mediaProviderName(value:String):void
		{
			_mediaProviderName = value;
		}

		public function get mediaType():String
		{
			return _mediaType
		}
		public function set mediaType(value:String):void
		{
			_mediaType = value;
		}
	}
}