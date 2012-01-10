package com.blitzagency.ui {
	
	/*
	 * @author Patrick Matte
	 * @since 1.0 2008/03/13
	 * @version 1.0 2008/03/13
	*/
	
	import flash.display.MovieClip;
	
	public class UICheckBox extends UIButton {
		
		public function UICheckBox() {
			super();
			toggle = true;
		}
		
		public override function toString():String{
			return("[" + "UICheckBox" + ", name=" + name  + ", selected=" + selected + "]");
		}
		
	}
	
}