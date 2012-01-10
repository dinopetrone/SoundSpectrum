package com.blitzagency.fabric.tracking {
	
	/*
	 * @author Patrick Matte
	 * @since 1.0 02/18/2009
	 * @version 1.0 02/18/2009
	*/
	
	import flash.external.ExternalInterface;
	
	/**
	* JSTrackingCall is a tracking call that calls a javascript function with arguments.
	*/
	public class JSTrackingCall extends TrackingCall {
		
		public var method:String;
		public var args:Array;
		
		/**
		* Creates a new JSTrackingCall.
		* 
		* @param name - The name of the tracking call.
		* @param method - The name of the javascript method to call.
		* @param args - The arry of arguments to pass to the javascript method.
		*/
		public function JSTrackingCall(name:String = null, method:String = null, args:Array = null) {
			super(name);
			this.method = method;
			this.args = args;
		}
		
		/**
		* Parses an xml object into an JSTrackingCall.
		* <p/>
		* The xml object must be formatted like this:
		* <listing>
		* <JSCall name="testClick" method="track">
		* 	<argument>testClick %replace%</argument>
		* </JSCall>
		* </listing>
		* 
		* @param xml - The xml object defining the JSTrackingCall.
		*/
		public static function fromXML(xml:XML):JSTrackingCall {
			var name:String = xml.@name;
			var method:String = xml.@method;
			var args:Array = new Array();
			for (var j = 0; j < xml.argument.length(); j++) {
				args.push(xml.argument[j].toString());
			}
			var call:JSTrackingCall = new JSTrackingCall(name, method, args);
			return call;
		}
		
		override public function create(replace:String = ""):void {
			var arguments:Array = new Array();
			
			for (var j = 0; j < args.length; j++) {
				var argument:String = args[j] as String;
				var replaceIndex:Number = argument.indexOf("%replace%");
				
				if ( replaceIndex != -1) {
					var argArray:Array = argument.split("%replace%");
					argArray.splice(1, 0, replace);
					argument = argArray.join("");
				}
				arguments.push( argument );
			}
			
			if (ExternalInterface.available) {
				var args:Array = new Array();
				args.push( method );
				
				for ( var k:int = 0; k < arguments.length; k++ ) {
					args.push( arguments[k] );
				}
				
				//trace( "args : " + args );
				ExternalInterface.call.apply( this, args );
			}
		}
		
		public function toString():String {
			return "[JSTrackingEvent name=" + name + " method=" + method + " arguments=" + args + "]";
		}
		
	}

}