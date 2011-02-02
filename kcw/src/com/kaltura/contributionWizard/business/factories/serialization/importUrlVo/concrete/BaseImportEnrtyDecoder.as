package com.kaltura.contributionWizard.business.factories.serialization.importUrlVo.concrete
{
	/**
	 * This class is used for decoding entry values to url variables that will be send to the server 
	 * @author Michal
	 * 
	 */	
	public class BaseImportEnrtyDecoder
	{
		import com.kaltura.vo.importees.BaseImportVO;
		import flash.net.URLVariables;
		import com.adobe.cairngorm.vo.IValueObject;
		
		/**
		 *  
		 * This function decodes values from a given valueObject and adds the suitable urlVars according to the given index  
		 * @param valueObject the object containing values to decode
		 * @param index the index of the request of the current values to decode
		 * @param urlVars the urlVars that the new variables will be added to
		 * 
		 */	
		internal static function addUrlVars(valueObject:IValueObject, index:int, urlVars:URLVariables):void
		{
			var baseImportVO:BaseImportVO = valueObject as BaseImportVO;
			urlVars[index + ":entry:mediaType"]	= baseImportVO.mediaTypeCode;
			//urlVars["entry" + index + "_source"] 	= baseImportVO.mediaProviderCode;
			urlVars[index + ":searchResult:searchSource"] 	= baseImportVO.mediaProviderCode;
			//TODO: make a separate URLVarsDecoder for the MediaMetaData
			urlVars[index + ":entry:tags"]		= baseImportVO.metaData.tags;
			//The dispalyed name on the show, it doesn't have to be unique
			urlVars[index + ":entry:name"] 		= baseImportVO.metaData.title;
			//Eitan add the description and the category
			urlVars[index + ":entry:category"] 		= baseImportVO.metaData.category;
			urlVars[index + ":entry:description"] 		= baseImportVO.metaData.description;
			
		}

	}
}