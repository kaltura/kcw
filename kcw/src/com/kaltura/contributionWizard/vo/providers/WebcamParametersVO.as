package com.kaltura.contributionWizard.vo.providers
{
	/**
	 * Definitions for webcam recording
	 */
	public class WebcamParametersVO
	{
		/* ===========================================================
				VIDEO
			=========================================================== */
		
		/**
		 * recorded stream's keyframe interval
		 */
		public var keyFrameInterval:int;
		
		/**
		 * recorded stream's width
		 */
		public var width:int;
		
		/**
		 * recorded stream's height
		 */
		public var height:int;

		/**
		 * recorded stream's required framerate 
		 */
		public var framerate:int;
		
		public var favorArea:Boolean;

		/**
		 * bandwidth used for recoding 
		 */
		public var bandwidth:int;

		/**
		 * recording required quality 
		 */
		public var quality:int;
		
		/**
		 * recording stream's buffrer time 
		 */
		public var bufferTime:int;
		
		/* ===========================================================
				AUDIO
		   =========================================================== */
		
		/**
		 * use microphone with echo suppression
		 */
		public var setUseEchoSuppression:Boolean = true;
		
		/**
		 * microphone gain 
		 */
		public var gain:Number = 50;
		
		/**
		 * audio data rate  
		 */
		public var rate:int = 11;
		
		/**
		 * microphone silence level  
		 */
		public var silenceLevel:Number = 0;
		
		/**
		 * microiphone silence level timeout
		 */
		public var silenceLevelTimeout:int = 10000;
	}
}