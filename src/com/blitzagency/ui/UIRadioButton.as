package com.blitzagency.ui{
	
	/*
	 * @author Patrick Matte
	 * @since 1.0 2008/03/13
	 * @version 1.0 2008/03/13
	*/
	
	public class UIRadioButton extends UICheckBox {
		
		public var value:Object;
		
		public function UIRadioButton(){
			super();
			value = name;
			deselectable = false;
		}
		
		public override function toString():String{
			return("[" + "UICheckBox" + ", name=" + name  + ", value=" + value   + ", selected=" + selected + "]");
		}
		
	}
	
}