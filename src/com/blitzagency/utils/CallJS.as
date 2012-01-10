package com.blitzagency.utils
{
	import flash.events.TimerEvent;
	import flash.external.ExternalInterface;
	import flash.utils.Timer;
	
	public class CallJS 
	{
		// The Queue implementation is to overcome a flash bug that 
		// prevents calling 2 or more javascript methods simultaneously
		
		public static var queue:Array = [];
		
		private static var queueTimer:Timer;
		
		public static function method( functionName:String, ...args:Array ):void
		{
			if ( !queueTimer ) {
				queueTimer = new Timer( 10 );
				queueTimer.addEventListener( TimerEvent.TIMER, executeQueueCommand );
			}
			
			if ( ExternalInterface.available ) {
				if ( args ) {
					var arguments:Array = [ functionName ];
					for each ( var arg:String in args ) {
						arguments.push( arg );
					}
					queue.push( arguments );
					runQueue();
				} else {
					queue.push( functionName );
					runQueue();
				}
			}
		}
		
		private static function runQueue():void
		{
			if ( !queueTimer.running ) {
				queueTimer.start();
			}
		}
		
		private static function executeQueueCommand( event:TimerEvent ):void 
		{
			var obj:Object = queue.shift();
			
			if ( obj is String ) {
				ExternalInterface.call( obj as String );
			} else {
				ExternalInterface.call.apply( null, obj as Array );
			}
			
			if ( queue.length == 0 ) {
				queueTimer.stop();
			}
		}
		
		public static function callBack( functionName:String, closure:Function ):void
		{
			if ( ExternalInterface.available ) {
				ExternalInterface.addCallback( functionName, closure );
			}
		}
	}
}