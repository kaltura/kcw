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
package com.kaltura.contributionWizard.business
{
	import com.adobe_cw.adobe.cairngorm.business.ServiceLocator;
	import com.kaltura.contributionWizard.business.factories.serialization.EntriesURLVarsFactory;
	import com.kaltura.contributionWizard.model.Context;
	import com.kaltura.contributionWizard.model.WizardModelLocator;
	import com.kaltura.contributionWizard.vo.CreditsVO;
	import com.kaltura.contributionWizard.vo.PartnerNotificationVO;
	import com.kaltura.net.TemplateURLVariables;
	import com.kaltura.utils.PathUtil;
	import com.kaltura.vo.importees.ImportFileVO;
	
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.net.sendToURL;
	
	import mx.collections.ArrayCollection;
	import mx.collections.XMLListCollection;
	import mx.rpc.AsyncToken;
	import mx.rpc.IResponder;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;
	import mx.utils.ObjectUtil;

	/**
	 * This class is responsible for sending the "add entries" request to the server 
	 * @author Michal
	 * 
	 */
	public class AddEntriesDelegate implements IResponder
	{
		private var responder : IResponder;
		private var service : HTTPService;
		private var _serviceName:String;

		private var _model:WizardModelLocator = WizardModelLocator.getInstance();
		private var _entriesURLVars:TemplateURLVariables = new TemplateURLVariables(_model.context.defaultUrlVars);
		private var _entriesToAdd:ArrayCollection = new ArrayCollection();

		/**
		 * Constructs a new AddEntriesDelegate 
		 * @param responder the responder that will be associated with calls that this class will preform
		 * 
		 */		
		public function AddEntriesDelegate(responder:IResponder):void
		{
			
		    //this.service = ServiceLocator.getInstance().getHTTPService( Services.ADD_ENTRIES_SERVICE );
		    this.service = ServiceLocator.getInstance().getHTTPService( Services.MULTIREQUEST );
		    _serviceName = Services.SERVICE_MEDIA;
		    this.responder = responder;
		}

		/**
		 * This function will send an "add entries" request to the server
		 * @param entriesToAdd the entries to add
		 * @param context the context of current session
		 * @param creditsVo 
		 * @return ServiceCanceller
		 * 
		 */	
		public function addEntries( entriesToAdd:ArrayCollection, context:Context, creditsVo:CreditsVO) : ServiceCanceller
		{
			_entriesToAdd = entriesToAdd;
	   	 	var entriesURLVars:URLVariables = getEntriesURLVariables( entriesToAdd, context, creditsVo );
	   		/*if (context.addToRoughCut)
	   			entriesURLVars["quick_edit"] = context.addToRoughCut;*/
		
			var call : AsyncToken = service.send( entriesURLVars );
			call.addResponder( this );
			return new ServiceCanceller(this.service);
		}

		/**
		 * This function will be called when the add entries request will return result
		 * @param data the data returned from the server
		 * 
		 */	
	   	public function result(data:Object):void
	   	{
	   		try
	   		{
		   		var resultEvent:ResultEvent = data as ResultEvent;
		   		var resultXml:XML = resultEvent.result as XML;
		   		var entriesXmlList:XMLList = resultXml.result.children();

		   		var entryIdListArray:Array = new Array();
		   		var notificationList:Array;
		   		var len:int = entriesXmlList.length() / 2
		   		for(var i:int = 0; i < len; i++)
		   		{
		   			//trace(item.mediaType[0].toString());
		   			var item:XML = entriesXmlList[i] as XML;
					var uploadedFile:ImportFileVO;
					if (_entriesToAdd.getItemAt(i) is ImportFileVO)
						uploadedFile = _entriesToAdd.getItemAt(i) as ImportFileVO;
					
		   			entryIdListArray.push(
		   									{
		   										entryId: (item.id && item.id[0]) ? item.id[0].toString() : "", 
		   										mediaType: (item.mediaType && item.mediaType[0]) ? item.mediaType[0].toString() : "",
												fileSize: uploadedFile ? uploadedFile.polledfileReference.fileReference.size : "",
												fileName: uploadedFile ? uploadedFile.polledfileReference.fileReference.name : ""
		   									}
		   								 );
		   		
		   			var notItem:XML = entriesXmlList[len + i];
		   			if(notItem && notItem.url[0] && notItem.url.indexOf("http") > -1 )
		   			{
		   				if(!notificationList) notificationList = new Array();
		   				notificationList.push( new PartnerNotificationVO(notItem.url, notItem.data) );
		   			}
		   		}
		   		
		   		var addEntriesResult:AddEntriesResult = new AddEntriesResult(entryIdListArray, null, notificationList);
		   		responder.result(addEntriesResult);
	   		}
	   		catch(e:Error)
	   		{
	   			fault(e);
	   		}
	   	}

		/**
		 * This function will be called on server fault 
		 * @param info the data returned from the server
		 * 
		 */	
		public function fault(info:Object):void
		{
			trace("error description: ", ObjectUtil.toString(info));
			var stackTrace:String = new Error().getStackTrace();
			trace(stackTrace);
			var urlVars:URLVariables = new URLVariables();

			urlVars.reporting_obj	= "kcw";
			urlVars.error_code		= "1";
			urlVars.error_description = "AddEntriesDelegate.fault() stack trace:\n\n" + stackTrace;
			var url:String = PathUtil.getAbsoluteUrl(_model.context.protocol + _model.context.hostName, "/index.php/partnerservices2/reporterror");
			var request:URLRequest = new URLRequest(url);
			request.data = urlVars;
			sendToURL(request)
			responder.fault(info);
		}
		private function getEntriesURLVariables(importItemsToAdd:ArrayCollection, context:Context, creditsVo:CreditsVO):URLVariables
		{
	   		var urlVars:URLVariables = EntriesURLVarsFactory.createURLVars(context, importItemsToAdd);
	   		
	   		for (var key:String in _model.context.injectedKVars)
	   		{
	   			urlVars[key] = _model.context.injectedKVars[key];
	   		}
	   		
	   		if (creditsVo)
	   		{
	   			urlVars["credits_screen_name"] 	= creditsVo.screenName;
	   			urlVars["credits_site_url"] 	= creditsVo.siteUrl;
	   		}

	   		return urlVars;
		}

		private function getNotificationsList(resultXml:XML):Array
		{
			var xmllNotification:XMLList = XML(resultXml.result.notifications[0]).children();
			var entriesCollection:XMLListCollection = new XMLListCollection(xmllNotification);
			var notificationList:Array	= entriesCollection.toArray().map(
				function(element:XML, index:int, arr:Array):PartnerNotificationVO
				{
					var url:String 			= element["url"].toString();
					var queryString:String	= element["params"].toString();
					return new PartnerNotificationVO(url, queryString)
				});

	   		return notificationList.length > 0 ? notificationList : null;
	 	}

	}
}