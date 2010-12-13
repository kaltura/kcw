package com.kaltura.contributionWizard.view.importViews.soundRecorder.view
{
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.ActivityEvent;
	import flash.events.StatusEvent;
	import flash.events.TimerEvent;
	import flash.media.Microphone;
	import flash.media.SoundTransform;
	import flash.system.Security;
	import flash.system.SecurityPanel;
	import flash.utils.Timer;
	
	import mx.core.UIComponent;
	
	public class MicSpectrum extends UIComponent
	{
		// stores how far we are
		private var xInc:int = 0;
		// how fast we move across
		private var xSpeed:int = 2;
		private var mic:Microphone;
		private var canvas:Sprite;
		private var g:Graphics;
		private var timer:Timer;
		
		public function MicSpectrum()
		{
			super();
			init();	
		}
		
		private function init():void{
			initMic(); 
			initCanvas();
			initTimer();
		}
		
		private function initCanvas():void{
			canvas = new Sprite();
			addChild(canvas);
			g = canvas.graphics;
			resetCanvas();
 		}
 		
	    private function resetCanvas():void{
	    	trace("resetCanvas");
		  	g.clear();
		  	g.lineStyle(0, 0);
		  	g.moveTo(0, 50);
		}
		
		private function initTimer():void{
			timer = new Timer(50);
			timer.addEventListener(TimerEvent.TIMER, timerHandler);
			timer.start();
		}
		
		private function timerHandler(e:TimerEvent):void{
 			g.lineTo(xInc, 50 - (mic.activityLevel / 6));
  			if(xInc > 200){
   				xInc=0;
   				resetCanvas();
  			}else{
   				xInc += xSpeed;
 			}
 			
 			trace("xInc: " + xInc);
		}
		
		private function initMic():void{
            mic = Microphone.getMicrophone();
            //Security.showSettings(SecurityPanel.MICROPHONE);
            if (mic != null) {
            	mic.setLoopBack(true);
            	mic.setUseEchoSuppression(true);
            	mic.setSilenceLevel(90, 1000);
            	mic.soundTransform = new SoundTransform(0, 0);
                mic.addEventListener(ActivityEvent.ACTIVITY, activityHandler);
                mic.addEventListener(StatusEvent.STATUS, statusHandler);
            }
        }

        private function activityHandler(event:ActivityEvent):void {
            trace("activityHandler: " + event);
        }

        private function statusHandler(event:StatusEvent):void {
            trace("statusHandler: " + event);
            
        }
	}
}