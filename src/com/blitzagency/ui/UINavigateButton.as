package com.blitzagency.ui 
{
	import com.blitzagency.ui.UIButton;
	import flash.events.MouseEvent;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	
	public class UINavigateButton extends UIButton
	{
		public var navigateTarget :String = "_self";
		private var _navigateURL  :String;
		
		public function UINavigateButton() 
		{
			super();
		}
		
		public function get navigateURL():String { return _navigateURL; }
		
		public function set navigateURL( value:String ):void 
		{
			if ( !_navigateURL ) {
				addEventListener( MouseEvent.CLICK, navigate );
			}
			
			_navigateURL = value;
		}
		
		protected function navigate( event:MouseEvent ):void 
		{
			navigateToURL( new URLRequest( navigateURL ), navigateTarget );
		}
	}
}