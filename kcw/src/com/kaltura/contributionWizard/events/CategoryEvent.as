package com.kaltura.contributionWizard.events
{
	import com.adobe_cw.adobe.cairngorm.control.CairngormEvent;
	
	/**
	 * This class represents is a Cairngorm event related to categories
	 * @author Michal
	 * 
	 */	
	public class CategoryEvent extends CairngormEvent
	{
		public static const LIST_CATEGORIES : String = "listCategories";
		public static const UPDATE_CATEGORY : String = "updateCategory";
		public static const DELETE_CATEGORY : String = "deleteCategory";
		public static const ADD_CATEGORY    : String = "addCategory";
		
		public function CategoryEvent( type:String , 
									   bubbles:Boolean=false,
									   cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}