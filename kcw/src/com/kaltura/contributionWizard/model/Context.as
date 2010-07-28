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
package com.kaltura.contributionWizard.model
{
	import com.kaltura.KalturaClient;
	
	import mx.utils.UIDUtil;
	
  [Bindable]
  public class Context
  {
    public static const DEFAULT_UI_CONFIG_ID:String = "2";
    
    public var kcwSessionId : String = UIDUtil.createUID(); 
    public var userId:String;
    public var isAnonymous:Boolean;
    /**
     * Indicates if the contributions are auto added to the roughcut.
     * true by default
     */
    public var addToRoughCut:String;
    public var partnerId:int;
    public var hasPartnerId:Boolean;
    public var subPartnerId:int;
    public var sessionId:String;
    public var kshowId:String;
    public var uiConfigId:String = DEFAULT_UI_CONFIG_ID;
	public var fileSystemMode:Boolean = false;
	/**
	 *	 when filesystem mode is true you will be able to pass the localSytle via flashvar
	 */	
	public var localStyle:String;
	/**
	 *	when filesystem mode is true you will be able to pass the localLocale via flashvar 
	 */	
	public var localLocale:String;
	
    /**
    * This url from which this swf came from, omitting the [filename.swf]
    * e.g: swf that came from http://www.yourdomain.com/dir/file.swf will have "http://www.yourdomain.com/dir/" as its source url
    */
    public var sourceUrl:String;

    /**
     *The hosting server name, e.g. "kaltura.com"
     */
    public var hostName:String;
    
    /**
     *The protocol of the application (http:// or https://) 
    */ 
    public var protocol:String;

    public var cdnHost:String;

    /**
     *The main swf file name (e.g "ContributionWizard.swf")
     */
    public var fileName:String
    
    /**
	 * The PS3 - new flex client API
	 * 
	 */
	public var kc:KalturaClient;

    public var defaultUrlVars:Object;

    public var permissions:int = -1;

    /**
     * A parameter that's being injected through flashvars and passed with the addentry call [currently, it's not used in the kcw except for passing it]
     */
    public var groupId:String;

    public var partnerData:String;

    public var reportNavigationMode:Boolean = true;

    public var injectedKVars:Object;


  }
}