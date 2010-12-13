package
{
	import com.kaltura.base.types.TimelineTypes;
	import com.kaltura.events.WrapperEvent;
	import com.kaltura.wrapper.IFlexWrapper;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.net.URLRequest;
	import flash.sampler.NewObjectSample;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.system.Security;
	import flash.system.SecurityDomain;
	import flash.utils.Timer;
	import flash.utils.setTimeout;
	
	import mx.core.Application;
	import mx.events.FlexEvent;

	public class SimpleFlexWrapper extends Sprite implements IFlexWrapper
	{
		/**
		* A mean for the KApplication to know if it's loaded by a wrapper
		*/
		public const NAME:String = "flexWrapper";
		public const VERSION:String = "1.2";

		private var _loader:Loader = new Loader;
		private var _systemManager:MovieClip;

		/**
		 *Storage for the width property
		 */
		private var _width:Number;
		/**
		 *Storage for the height property
		 */
		private var _height:Number;
		private var _timer:Timer;

		public function SimpleFlexWrapper()
		{
			init();
		}

		override public function get width():Number
		{
			return _width;
		}
		override public function set width(value:Number):void
		{
			_width = value;
		}

		override public function get height():Number
		{
			return _height;
		}
		override public function set height(value:Number):void
		{
			_height = value;
		}

		public function get systemManager():MovieClip
		{
			return _systemManager;
		}

		private function init():void
		{
			trace ("FlexWrapper version: "+ VERSION);
			
			Security.allowDomain("*");
			_width = super.width;
			_height = super.height;

			addEventListener(Event.ADDED_TO_STAGE, 						addedToStageHandler);
			//We wait to the securityPermissionsAllowed event, which is when the loaded swf calls the Security.allowDomain() to allow us to cross-script it even if iut's loaded from different domain.
			addEventListener(WrapperEvent.SECURITY_PERMISSIONS_ALLOWED,	securityPermissionsAllwoedHandler);
		}

		private function addedToStageHandler(event:Event):void
		{
			setLayout();
			loadContent();
		}

		private function setLayout():void
		{
			try
			{
				stage.scaleMode = StageScaleMode.NO_SCALE;
				stage.align = StageAlign.TOP_LEFT;
				
				if (this.width == 0 || this.height == 0)
				{
					this.width 	= stage.stageWidth;
					this.height = stage.stageHeight;
				}
			}
			catch(e:Error)
			{
				//swf is loaded into another swf whose security settings disallow us to access the stage
			}
		}

		private function loadContent():void
		{
			var contentUrl:String = loaderInfo.parameters.contentUrl;
			var request:URLRequest = new URLRequest(contentUrl);
			var context:LoaderContext = new LoaderContext(true,ApplicationDomain.currentDomain,SecurityDomain.currentDomain);
			_loader.contentLoaderInfo.addEventListener(Event.INIT, onContentInit);
			_loader.load(request, context);
		}
		

		/**
		 * When content is loaded, will set a timer to adjust the application to the loader size 
		 * @param event
		 * 
		 */		
		private function onContentInit(event:Event):void {
			this.addChild(_loader);
			
			//will wait until application is loaded
			_timer = new Timer(100);
			_timer.addEventListener(TimerEvent.TIMER, onTimer);
			_timer.start();
		}
		
		/**
		 * Only after application is complete we can change its size 
		 * 
		 */		
		private function onApplicationComplete(event:Event) : void
		{
			_loader.content["application"].removeEventListener (FlexEvent.APPLICATION_COMPLETE, onApplicationComplete);
			_loader.content["application"].width = stage.stageWidth;
			_loader.content["application"].height = stage.stageHeight;
		}
		
		/**
		 * when application is ready, will scale her to the stage bounderies 
		 * @param event
		 * 
		 */		
		private function onTimer(event:Event) : void
		{
			if (_loader.content["application"]) {
				_loader.content["application"].addEventListener (FlexEvent.APPLICATION_COMPLETE, onApplicationComplete);
				_timer.removeEventListener(TimerEvent.TIMER, onTimer);
				_timer.stop();
			}
		}
		
		/**
		 * This is the point where we can start cross-scripting the loaded swf even if it's loaded from different domain
		 * @private
		 * @param securityPermissionsAllwoedEvent
		 *
		 */
		private function securityPermissionsAllwoedHandler(securityPermissionsAllwoedEvent:Event):void
		{
			_systemManager = _loader.content as MovieClip;
			_systemManager.addEventListener("applicationComplete", applicationCompleteHandler);
		}

		private function applicationCompleteHandler(applicationCompleteEvent:Event):void
		{
			var event:Event = applicationCompleteEvent.clone();
			dispatchEvent(event);
		}
	}
}