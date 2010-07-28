package com.kaltura.contributionWizard.business.factories.serialization.importUrlVo.concrete
{
	public class BaseImportEnrtyDecoder
	{
		import com.kaltura.vo.importees.BaseImportVO;
		import flash.net.URLVariables;
		import com.adobe.cairngorm.vo.IValueObject;
		
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
		}

	}
}