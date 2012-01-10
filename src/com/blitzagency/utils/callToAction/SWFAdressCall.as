package com.blitzagency.utils.callToAction {
	
	import com.asual.swfaddress.SWFAddress;
	import flash.events.Event;
	
	public class SWFAdressCall implements CallToAction {
		
		public static const ALIAS:String = "internal";
		public var path:String;
		
		public function SWFAdressCall(path:String = null ) {
			this.path = path;
		}
		
		public function eventHandler(event:Event):void {
			SWFAddress.setValue(path);
		}
		
		public static function createFunction(path:String):Function{
			var a:Function = function(event:Event):void {
				SWFAddress.setValue(path);
			}
			return a;
		}
		
		public static function fromXML( xml:XML ):SWFAdressCall
		{
			var swfCall:SWFAdressCall = new SWFAdressCall( xml.path );
			return swfCall;
		}
	}
}