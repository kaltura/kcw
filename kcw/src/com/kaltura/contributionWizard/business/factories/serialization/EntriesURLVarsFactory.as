/*
This file is part of the Kaltura Collaborative Media Suite which allows users
to do with audio, video, and animation what Wiki platfroms allow them to do with
text.

Copyright (C) 2006-2008  Kaltura Inc.

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as
published by the Free Software Foundation, either version 3 of the
License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Affero General Public License for more details.

You should have received a copy of the GNU Affero General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.

@ignore
*/
package com.kaltura.contributionWizard.business.factories.serialization
{
	import com.adobe.cairngorm.vo.IValueObject;
	import com.kaltura.contributionWizard.business.Services;
	import com.kaltura.contributionWizard.business.factories.serialization.importUrlVo.concrete.ImportFileDecoder;
	import com.kaltura.contributionWizard.business.factories.serialization.importUrlVo.concrete.ImportURLDecoder;
	import com.kaltura.contributionWizard.model.Context;
	import com.kaltura.net.TemplateURLVariables;
	import com.kaltura.vo.importees.ImportFileVO;
	import com.kaltura.vo.importees.ImportURLVO;
	
	import flash.net.URLVariables;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	import mx.collections.ArrayCollection;

	public class EntriesURLVarsFactory
	{
		public static function createURLVars(context:Context, importVOs:ArrayCollection):URLVariables
		{
			var urlVariables:TemplateURLVariables = new TemplateURLVariables(context.defaultUrlVars);
			for (var i:int = 0; i < importVOs.length; i++)
			{
				var importVo:IValueObject = importVOs[i];
				var index:int =  i + 1;

				/*if (context.permissions != -1)
					urlVariables[index + ":permissions"] = context.permissions;*/

				if (context.groupId)
					urlVariables[index + ":mediaEntry:groupId"] = context.groupId;

				if (context.partnerData)
					urlVariables[index + ":mediaEntry:partnerData"] = context.partnerData;
					
				createSingleURLVars(importVo, index, urlVariables);
				
				//notification
				var notificationIndex:int = importVOs.length + index;
				urlVariables[notificationIndex + ":service"] = Services.SERVICE_NOTIFICATION;
				urlVariables[notificationIndex + ":action"] = Services.ACTION_GET_CLIENT_NOTIFICATION;
				urlVariables[notificationIndex + ":type"] = "1";
				urlVariables[notificationIndex + ":entryId"] = "{" + index + ":result:id}";
			}
			
			
			return urlVariables;
		}

		public static function createSingleURLVars(valueObject:IValueObject, index:int, urlVars:URLVariables):void
		{
			switch (getDefinitionByName(getQualifiedClassName(valueObject)))
			{
				case ImportFileVO:
					ImportFileDecoder.addUrlVars(valueObject, index, urlVars);
				break;

				case ImportURLVO:
					ImportURLDecoder.addUrlVars(valueObject, index, urlVars);
				break;
			}
		}

	}
}