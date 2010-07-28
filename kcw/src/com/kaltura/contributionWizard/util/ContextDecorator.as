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
package com.kaltura.contributionWizard.util
{
	import com.kaltura.contributionWizard.model.Context;
	import com.kaltura.contributionWizard.model.WizardModelLocator;

	public class ContextDecorator
	{
		private static var _context:Context = WizardModelLocator.getInstance().context;
		private static const PROPERTY_SESSION:String 		= "ks";
		private static const PROPERTY_PARTNER_ID:String 	= "partnerId";
		//private static const PROPERTY_SUB_PARTNER_ID:String	= "subp_id";
		//private static const PROPERTY_PUSER_ID:String 		= "uid";
		//private static const PROPERTY_KSHOW_ID:String 		= "kshow_id";

		public static function addVariables(decoratedVars:Object):void
		{
			decoratedVars[PROPERTY_SESSION] 		= _context.sessionId;
			if(_context.hasPartnerId)
				decoratedVars[PROPERTY_PARTNER_ID]		= _context.partnerId;
			//decoratedVars[PROPERTY_SUB_PARTNER_ID] 	= _context.subPartnerId;
			//decoratedVars[PROPERTY_PUSER_ID] 		= _context.userId;
			//decoratedVars[PROPERTY_KSHOW_ID] 		= _context.kshowId;
		}

	}
}