package com.blitzagency.utils.callToAction {
	
	import flash.events.EventDispatcher;
	import flash.events.Event;
	
	public class MethodCall implements CallToAction {
		
		public var method:Function;
		public var args:Array;
		
		public function MethodCall(method:Function = null, args:Array=null) {
			this.method = method;
			this.args = args;
		}
		
		public function eventHandler(event:Event):void {
			method.apply(null, args);
		}
		
		public static function createFunction(method:Function = null, args:Array=null):Function {
			var a:Function = function(event:Event):void {
				method.apply(null, args);
			}
			return a;
		}
	}
}