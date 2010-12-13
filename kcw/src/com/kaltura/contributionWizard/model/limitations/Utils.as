package com.kaltura.contributionWizard.model.limitations
{
	import com.kaltura.contributionWizard.model.WizardModelLocator;
	import com.kaltura.contributionWizard.vo.limitations.ImportTypeLimitationsVO;
	
	import flash.utils.describeType;
	
	public class Utils
	{
		public function Utils()
		{
		}
		
		public static function setLimitationKey(key:String, value:*):Boolean
		{
			var model:WizardModelLocator = WizardModelLocator.getInstance();
			
			var ret:Boolean = false; 
			var aKeys:Array = key.split(".");
			if(aKeys.length == 4 && key.indexOf("limitations.") > -1)
			{
				var camelizedKey:String = aKeys[2].toLowerCase(); //toLowerCase -> Just in case it's not camelized. eg. from flashVars
				var vars:XMLList = flash.utils.describeType(ImportTypeLimitationsVO)..variable
				for(var i:int = 0; i < vars.length(); i++)
				{
					var camel:String = vars[i].@name;
					if(camel.toLowerCase() == camelizedKey)
					{
						try
						{
							model.limitationsVo[aKeys[1]][camel][aKeys[3]] = parseInt(value);
							ret = true;
						}
						catch(ex:Error){}
						break;
					}
				}
			}
			
			return ret;
		}

	}
}