package com.kaltura.contributionWizard.model
{
	import com.kaltura.contributionWizard.vo.providers.MediaProviderVO;

	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;

	public class MediaProviders extends EventDispatcher
	{
		/**
		 * Business object that represents the available media types and their matching media providers.
		 *
		 * @param mediaTypes The available media types to which MediaProvider objects can be matched.
		 * The media providers are matched to their qualifying media types by their MediaProvider.mediaInfo.mediaType property.
		 *
		 */
		public function MediaProviders(mediaTypes:Array):void
		{
			_mediaTypes = mediaTypes;
			dispatchEvent(new Event("mediaTypesChanged"));
		}

		[Bindable("mediaTypeChanged")]
		public function get visibleMediaProviders():Array
		{
			return _mediaProvidersMap[_activeMediaType];
		}

		[Bindable("mediaTypesChanged")]
		public function get mediaTypes():Array
		{
			return _mediaTypes;
		}

		[Bindable]
		public function get activeMediaProvider():MediaProviderVO
		{
			return _activeMediaProvider;
		}
		public function set activeMediaProvider(value:MediaProviderVO):void
		{
			_activeMediaProvider = value;
		}
		private var _mediaTypes:Array; /* of String */
		/**
		 *  @private
		 *  A map whose keys are media types strings like "video", "image" and "audio".
		 *  and whose values are array of MediaProvider objects.
		 */
		private var _mediaProvidersMap:Dictionary = new Dictionary();

		private var _activeMediaType:String;
		private var _activeMediaProvider:MediaProviderVO;

		public function addMediaProvider(mediaProviderVo:MediaProviderVO):void
		{
			var mediaType:String = mediaProviderVo.mediaInfo.mediaType;
			if (_mediaTypes.indexOf(mediaType) != -1)
			{
				_mediaProvidersMap[mediaType] = _mediaProvidersMap[mediaType] || [];
				var matchingProviders:Array = _mediaProvidersMap[mediaType];
				matchingProviders.push(mediaProviderVo);
			}
			else
			{
				throw new Error("Cannot add media provider. Media type " + mediaType + " doesn't exist");
			}
		}

		public function setActiveMediaType(mediaType:String):void
		{
			if (mediaType in _mediaProvidersMap)
			{
				var oldMediaType:String = _activeMediaType
				_activeMediaType = mediaType;
				if (oldMediaType != _activeMediaType)
					dispatchEvent(new Event("mediaTypeChanged"));
				activeMediaProvider = visibleMediaProviders[0];
			}
			else
			{
				throw new Error("Can not filter media providers by media type of type " + mediaType);
			}
		}

		public function getProviderVoByName(name:String):MediaProviderVO
		{
			var matchingProvider:Array = visibleMediaProviders.filter(
				function(mediaProviderVo:MediaProviderVO, i:int, list:Array):Boolean
				{
					return mediaProviderVo.providerName == name;
				}
			);

			if (matchingProvider.length > 0) //it should not be greater than single media provider per media type, e.g matchingProvider.length == 1
				return matchingProvider[0];
			else
				return null;
		}

		public function setProviderByName(providerName:String):void
		{
			var mediaProviderVo:MediaProviderVO = getProviderVoByName(providerName);
			if (mediaProviderVo)
			{
				activeMediaProvider = mediaProviderVo;
			}
		}
	}
}