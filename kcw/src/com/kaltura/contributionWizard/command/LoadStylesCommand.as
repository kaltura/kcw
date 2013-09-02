package com.kaltura.contributionWizard.command
{
	import com.adobe_cw.adobe.cairngorm.commands.SequenceCommand;
	import com.adobe_cw.adobe.cairngorm.control.CairngormEvent;
	import com.bjorn.event.ChainEvent;
	import com.kaltura.contributionWizard.events.LoadUIEvent;
	import com.kaltura.contributionWizard.model.WizardModelLocator;
	import com.kaltura.contributionWizard.vo.UIConfigVO;
	
	import flash.events.IEventDispatcher;
	import flash.system.ApplicationDomain;
	
	import mx.core.Application;
	import mx.events.StyleEvent;
	import mx.managers.SystemManager;
	import mx.styles.StyleManager;

	public class LoadStylesCommand extends SequenceCommand
	{
		private var _model:WizardModelLocator = WizardModelLocator.getInstance();
		private	var _styleLoader:IEventDispatcher;

		public override function execute(event:CairngormEvent):void
		{
			/*debug 	_model.loadState.loaded();*/
			nextEvent = ChainEvent(event).nextChainedEvent;

			var loadUiEvent:LoadUIEvent = event as LoadUIEvent;
			var uiConfigVo:UIConfigVO = loadUiEvent.uiConfigVo;
			var appDomain:ApplicationDomain = new ApplicationDomain(ApplicationDomain.currentDomain);
			if (uiConfigVo && uiConfigVo.styleUrl)
			{
				var styleUrl : String = uiConfigVo.styleUrl;
				
				//if we want to test the kcw in file system mode
				if(_model.context.fileSystemMode)
				{ 
					styleUrl = "assets/style.swf";
					if(_model.context.localStyle)
						styleUrl =_model.context.localStyle;
				}
				
				_styleLoader = StyleManager.loadStyleDeclarations(styleUrl, true, false, appDomain);
				_styleLoader.addEventListener(StyleEvent.COMPLETE , styleCompleteHandler);
				_styleLoader.addEventListener(StyleEvent.ERROR , styleErrorHandler);
			}
			executeNextCommand()
		}

		private function styleCompleteHandler(styleComplete:StyleEvent):void
		{
			_model.loadState.loaded();
			//workaround for the bug that prevents setting the application gradient colors at runtime
			var gradColors:Array = StyleManager.getStyleDeclaration("Application").getStyle("backgroundGradientColors");
			var application:Application = SystemManager(SystemManager.getSWFRoot(this)).application as Application;
			application.setStyle("backgroundGradientColors", gradColors);
		}

		private function styleErrorHandler(styleError:StyleEvent):void
		{
		}

	}
}