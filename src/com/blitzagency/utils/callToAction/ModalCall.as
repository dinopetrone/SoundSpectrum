package com.blitzagency.utils.callToAction
{
	import com.blitzagency.fabric.Navigation;
	import com.blitzagency.utils.callToAction.CallToAction;
	import flash.events.EventDispatcher;
	import flash.events.Event;
	import flash.external.ExternalInterface;
	
	public class ModalCall implements CallToAction
	{
		public static const ALIAS	 :String = "externalModal";
		public static var navigation :Navigation;
		public var path				 :String;
		
		public function ModalCall( path:String ) 
		{
			this.path = path;
		}
		
		public function eventHandler( event:Event ):void 
		{
			if ( !navigation ) {
				throwNoNavError();
			}
			ExternalInterface.call( "scrollTop" );
			navigation.location = path;
		}
		
		public static function createFunction( navigation:Navigation, path:String ):Function 
		{
			if ( !navigation ) {
				throwNoNavError();
			}
			
			var a:Function = function( event:Event ):void {
				navigation.location = path
			}
			return a;
		}
		
		public static function fromXML( xml:XML ):ModalCall
		{
			if ( !navigation ) {
				throwNoNavError();
			}
			
			var modalCall:ModalCall = new ModalCall( xml.path );
			return modalCall;
		}
		
		private static function throwNoNavError():void {
			throw new Error( "You must first set the static var ModalCall.navigation before using the ModalCall" );
		}
	}
}