package com.blitzagency.ui 
{
	import com.blitzagency.ui.UIMovieClip;
	import flash.events.HTTPStatusEvent;
	import flash.events.SecurityErrorEvent;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.system.Security;
	
	public class UIMovieClipWithCopyDeck extends UIMovieClip
	{
		private var _copyDeckURL :String;
		private var _copyDeck    :XML;
		
		public function UIMovieClipWithCopyDeck() 
		{
			super();
			addEventListener( Event.ADDED_TO_STAGE, checkForCopyDeck );
		}
		
		private function checkForCopyDeck( event:Event ):void 
		{
			if ( !copyDeck && copyDeckURL ) 
			{
				Security.allowDomain("*");
				
				var copyDeckLoader:URLLoader = new URLLoader();
				copyDeckLoader.addEventListener ( IOErrorEvent.IO_ERROR, couldNotLoadCopyDeck );
				
				var request:URLRequest = new URLRequest( copyDeckURL );
				copyDeckLoader.load( request );
				copyDeckLoader.addEventListener( Event.COMPLETE, copyDeckWasLoaded );			
			}
		}
		
		private function couldNotLoadCopyDeck(event:Event):void{
			trace(event);
			throw new Error( "Apparently copyDeck wasn't set on [" + this + "] before it was added to the stage." );	
		}
		
		private function copyDeckWasLoaded( event:Event ):void 
		{
			copyDeck = new XML( event.target.data );
			transitionIn();
		}
		
		public function get copyDeck():XML { return _copyDeck; }
		
		public function get copyDeckURL():String { return _copyDeckURL; }
		
		public function set copyDeckURL( value:String ):void 
		{
			_copyDeckURL = value;
		}
		
		public function set copyDeck( value:XML ):void 
		{
			_copyDeck = value;
		}
	}
}