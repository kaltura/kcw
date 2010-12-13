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
package com.kaltura.contributionWizard.command
{
	import com.adobe_cw.adobe.cairngorm.commands.ICommand;
	import com.adobe_cw.adobe.cairngorm.control.CairngormEvent;
	import com.kaltura.contributionWizard.events.ImportEvent;
	import com.kaltura.contributionWizard.events.ValidateLimitationsEvent;
	import com.kaltura.contributionWizard.model.WizardModelLocator;
	import com.kaltura.vo.importees.BaseImportVO;
	import com.kaltura.vo.importees.ImportFileVO;

	public class AddToImportCartCommand implements ICommand
	{
		private var _model:WizardModelLocator = WizardModelLocator.getInstance();
		
		
		public function execute(event:CairngormEvent):void
		{
			//_model.importData.isPending = true;
			var evtAddResult:ImportEvent =  event as ImportEvent;
			var importItemVO:BaseImportVO = evtAddResult.importItem;
			importItemVO.state.isSelected = true;
			
			_model.importData.importCart.addImportItem(importItemVO);
			onlyOne(importItemVO);
			
			validateLimitations();
		}
		
		private function onlyOne(item:BaseImportVO):void
		{
			var max:int;
			var isSearch:Boolean = item is ImportFileVO;
			if(!isSearch)
			{
				max = _model.limitationsVo.search.numFiles.max;
			}
			else
			{
				max = _model.limitationsVo.upload.numFiles.max;
			}
			
			if(max && max == 1)
			{
				_model.importData.importCart.leaveLast();
				//_model.importData.importCart.clearCart();
			}
		}
		
		private function validateLimitations():void
		{
			var validateEvent:ValidateLimitationsEvent = new ValidateLimitationsEvent(ValidateLimitationsEvent.VALIDATE);
			validateEvent.dispatch();
		}
		
	}
}