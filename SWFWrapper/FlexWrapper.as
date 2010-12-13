package {
	import com.kaltura.wrapper.IFlexWrapper;

	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.system.Security;
	import mx.core.mx_internal;
	public class FlexWrapper extends Sprite implements IFlexWrapper
	{
		private static var _firstTime:Boolean = true;

		private var _loader:Loader = new Loader;
		private var _systemManager:MovieClip;
		private var _classUiComponent:Class;

		use namespace mx_internal;

		public function FlexWrapper()
		{
			Security.allowDomain("*");
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		}

		private function addedToStageHandler():void
		{
			setLayout();
			loadContent();
		}

		private function setLayout():void
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
		}

		private function loadContent():void
		{
			_loader.contentLoaderInfo.addEventListener(Event.INIT, 	loaderInitHandler, false, -100);
			var contentUrl:String = loaderInfo.parameters.contentUrl;
			trace("contentUrl: ", contentUrl);
			_loader.load(new URLRequest(contentUrl));
			this.addChild(_loader);
		}

		private function loaderInitHandler(completeEvent:Event):void
		{
			_systemManager = _loader.content as MovieClip;
			_systemManager.addFrameScript(1, docFrameHandler);
		}

		private function docFrameHandler(e:Event = null):void
		{
			_classUiComponent = _systemManager.loaderInfo.applicationDomain.getDefinition("mx.core.UIComponent") as Class;
			_classUiComponent.mx_internal::["dispatchEventHook"] = myEventHook;
			_systemManager.mx_internal::["docFrameHandler"]();
		}

		private function myEventHook(event:Event, uic:Object):void
		{
			if (event.type == "preinitialize" && _firstTime)
			{
				_firstTime = false;
				var appParameters:Object =  _systemManager["application"]["parameters"];
				copyObjProperties(appParameters, loaderInfo.parameters)
			}
		}

		private function copyObjProperties(targetObj:Object, sourceObj:Object):void
		{
			for (var propertyName:String in sourceObj)
			{
				targetObj[propertyName] = sourceObj[propertyName];
			}
		}
	}
}
