package com.blitzagency.ui {
	
	/*
	 * @author Patrick Matte
	 * @since 1.0 2008/03/13
	 * @version 1.0 2008/03/13
	*/
	
	import flash.display.*;
	import flash.events.*;
	
	public class UIScrollBarWithButtons extends UIScrollBar {
		
		public var topArrow:UIButton;
		public var bottomArrow:UIButton;
		
		public function UIScrollBarWithButtons() {
			super();
			topArrow.addEventListener(UIButton.BUTTON_DOWN, addScrollFactor);
			topArrow.autoRepeat = true;
			bottomArrow.addEventListener(UIButton.BUTTON_DOWN, addScrollFactor);
			bottomArrow.autoRepeat = true;
		}
		
		private function addScrollFactor(event:Event):void {
			var scrollFactor:Number;
			switch(event.target) {
				case topArrow:
					scrollFactor = -1;
				break;
				case bottomArrow:
					scrollFactor = 1;
				break;
			}
			scroll = scrollTarget + scrollFactor * scrollUnit;
		}
		
		public override function set height(value:Number):void {
			
			track.height = Math.max(0, value - topArrow.height - bottomArrow.height);
			track.y = topArrow.y + topArrow.height;
			bottomArrow.y = track.y + track.height + bottomArrow.height;
			changeElevatorHeight();
		}
		
		public override function get height():Number{
			return track.height + topArrow.height + bottomArrow.height;
		}
		
	}
	
}