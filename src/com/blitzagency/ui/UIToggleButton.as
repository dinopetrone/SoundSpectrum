package com.blitzagency.ui {
	
	/*
	 * @author Patrick Matte
	 * @since 1.0 2008/03/13
	 * @version 1.0 2008/03/13
	*/
	
	public class UIToggleButton extends UIButton {
		
		public function UIToggleButton() {
			super();
			toggle = true;
		}
		
		override public function toString():String{
			return "[UIToggleButton]";
		}
	}
	
}