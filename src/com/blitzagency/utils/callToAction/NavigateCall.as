package com.blitzagency.utils.callToAction {
	
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import flash.events.Event;
	
	public class NavigateCall implements CallToAction {
		
		public static const ALIAS:String = "external";
		public var url:String;
		public var target:String;
		
		public function NavigateCall(url:String = null, target:String = null) {
			this.url = url;
			this.target = target;
		}
		
		public function eventHandler(event:Event):void {
			navigateToURL(new URLRequest(url), target);
		}
		
		public static function createFunction(url:String, target:String = "_blank"):Function {
			var a:Function = function(event:Event):void {
				navigateToURL(new URLRequest(url), target);
			}
			return a;
		}
		
		public static function fromXML( xml:XML ):NavigateCall
		{
			var target:String = String( xml.path.@target ) ? xml.path.@target : "_blank";
			var navigateCall:NavigateCall = new NavigateCall( xml.path, target );
			return navigateCall;
		}
	}
}