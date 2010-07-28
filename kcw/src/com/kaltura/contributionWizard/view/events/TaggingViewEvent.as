package com.kaltura.contributionWizard.view.events
{
	import com.kaltura.vo.MediaMetaDataVO;
	
	import flash.events.Event;

	public class TaggingViewEvent extends Event
	{
		public static const TITLE_CHANGED:String 	= 		"titleChanged";
		public static const TAGS_CHANGED:String 	= 		"tagsChanged";
		public static const CATEGORY_CHANGED:String = 		"categoryChanged";
		public static const DESCRIPTION_CHANGED:String =	"descriptionChanged"; 
		public static const ADDITIONAL_CHANGED:String =		"additionalChanged";

		public var oldMetaDataVo:MediaMetaDataVO;
		public var newMetaDataVo:MediaMetaDataVO;

		public function TaggingViewEvent(type:String, oldMetaDataVo:MediaMetaDataVO, newMetaData:MediaMetaDataVO):void
		{
			super(type, false, false);

			this.oldMetaDataVo = oldMetaDataVo;
			this.newMetaDataVo = newMetaData;
		}
	}
}