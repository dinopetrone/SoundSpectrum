package com.blitzagency.utils 
{
	/*
	 * @author Yosef Flomin
	*/
	import com.blitzagency.ui.EventDispatcherBase;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.net.URLRequestMethod;
	import flash.net.URLLoaderDataFormat;
	import flash.events.Event;

	public class SendAndLoad extends EventDispatcherBase
	{
		public static const REQUEST_POST	:String = URLRequestMethod.POST;
		public static const REQUEST_GET		:String = URLRequestMethod.GET;
		public static const DATA_TEXT		:String = URLLoaderDataFormat.TEXT;
		public static const DATA_BINARY		:String = URLLoaderDataFormat.BINARY;
		public static const DATA_VARIABLES	:String = URLLoaderDataFormat.VARIABLES;
		
		public var data				:Object;
		public var loader			:URLLoader;
		public var requestMethod	:String = URLRequestMethod.POST;
		public var dataFormat		:String = URLLoaderDataFormat.TEXT;
		public var dataToXML		:Boolean = true;
		
		private var url				:String;
		private var variables		:URLVariables;
		
		/*
		 * By Default the data will be parsed to XML unless dataToXML is set to false.
		 */
		public function SendAndLoad( url:String, variables:URLVariables = null ) 
		{
			this.url = url;
			this.variables = variables;
		}
		
		public function load():void
		{
			var myData:URLRequest = new URLRequest( url );
			myData.method = requestMethod;
			myData.data = variables;
			
			loader = new URLLoader();
			loader.dataFormat = dataFormat;
			loader.addEventListener( Event.COMPLETE, onDataLoad );
			loader.addEventListener( IOErrorEvent.IO_ERROR, onIOError );
			loader.addEventListener( SecurityErrorEvent.SECURITY_ERROR, onSecurityError );
			loader.load( myData );
		}
		
		private function onDataLoad( event:Event )
		{
			try	{
				if ( dataToXML && dataFormat == DATA_TEXT ) data = new XML( event.target.data );
				else data = event.target.data;
			}
			catch ( error:Error ){
				trace( "Problem Receiving Data. Maybe There Was None? [ Error " + error + " ] " )
			}
			
			dispatchEvent( new Event( Event.COMPLETE ) );
		}
		
		private function onSecurityError( event:SecurityErrorEvent ):void 
		{
			dispatchEvent( new IOErrorEvent( IOErrorEvent.IO_ERROR ) );
		}
		
		private function onIOError( event:IOErrorEvent ):void 
		{
			dispatchEvent( new SecurityErrorEvent( SecurityErrorEvent.SECURITY_ERROR ) );
		}
	}
}