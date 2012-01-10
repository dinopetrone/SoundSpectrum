package com.blitzagency.utils.callToAction 
{
	import flash.events.Event;
	import flash.external.ExternalInterface;

	public class ExternalInterfaceCall implements CallToAction
	{
		public static const ALIAS:String = "externalInterface";
		public var args:Array = new Array();
		
		public function ExternalInterfaceCall( functionName:String, ...args:Array ) 
		{
			this.args.push( functionName );
			for each( var arg:* in args ) {
				if ( arg[1] ) {
					for each( var subArg:* in arg ) {
						this.args.push( String( subArg ) );
					}
				} else {
					this.args.push( String( arg ) );
				}
			}
		}
		
		public function eventHandler( event:Event ):void
		{		
			try{
				ExternalInterface.call.apply( this, args );
			} catch (e:Error){
				//Yum!
			}
		}
		
		public static function createFunction( functionName:String, ...args:Array ):Function {
			var functionArgs:Array = new Array()
			functionArgs.push( functionName );
			for each( var arg:* in args ) {
				functionArgs.push( String( arg ) );
			}
			
			var a:Function = function(event:Event):void {
				try{
					ExternalInterface.call.apply( this, args );
				} catch (e:Error){
					//Yum!
				}
			}
			return a;
		}
		
		public static function fromXML( xml:XML ):ExternalInterfaceCall
		{
			var args:Array = new Array();
			for each ( var argument:Object in xml.argument ){
				args.push( argument );
			}
			var externalCall:ExternalInterfaceCall = new ExternalInterfaceCall( xml.method, args );
			return externalCall;
		}
		
		public function toString():String 
		{
			return "[ExternalInterfaceCall" + " args=" + args + "]";
		}
	}
}