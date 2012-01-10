package com.blitzagency.ui {
	
	/*
	 * @author Patrick Matte
	 * @since 1.0 2008/03/13
	 * @version 1.0 2008/03/13
	*/
	
	import flash.display.Sprite;
	import flash.utils.getTimer;
	import flash.events.Event;
	import flash.text.TextField;
	
	public class UIFramesPerSecond extends UIBase {
		
		public var textField:TextField;
		private var lastTime:Number;
		private var count:Number = 0;
		
		public function UIFramesPerSecond() {
			textField = new TextField();
			addChild(textField);
			lastTime = getTimer();
			addEventListener(Event.ENTER_FRAME, onEnterFrameEvent);
		}
		
		function onEnterFrameEvent(event:Event):void {
			count++;
			if(count == 12){
				var fps:Number = 12/((getTimer()-lastTime) / 1000);
				textField.text = "fps = "+ Math.round(fps);
				count = 0;
				lastTime = getTimer();
			}
		}

	}
	
}