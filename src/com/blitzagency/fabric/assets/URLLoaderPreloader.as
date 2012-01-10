package com.blitzagency.fabric.assets {
	
	/*
	 * @author Patrick Matte
	 * @since 1.0 02/18/2009
	 * @version 1.0 02/18/2009
	 * 
	 * @modified Yosef Flomin
	 * @revision 1.2 2010/04/30
	*/
	
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;

	/**
	* URLLoaderPreloader loads a external file with URLLoader.
	*/
	public class URLLoaderPreloader extends Asset {
		
		public var name:String;
		public var target:String;
		public var url:String;
		public var dataFormat:String;
		
		protected var urlLoader:URLLoader;
		
		/**
		* Creates a new URLLoaderPreloader.
		* <listing>
		* package {
		* 
		* 	import flash.display.MovieClip;
		* 	import com.blitzagency.fabric.assets.URLLoaderPreloader;
		* 
		* 	public class Main extends MovieClip {
		* 		
		* 		var myString:String;
		* 
		* 		public function Main(){
		* 			var urlLoaderPreloader:URLLoaderPreloader = new URLLoaderPreloader(this, "myString", "", "myData.txt", URLLoaderDataFormat.TEXT);
		* 			urlLoaderPreloader.addEventListener(Event.COMPLETE, urlLoaderPreloaderCompleteHandler));
		* 			urlLoaderPreloader.create();
		* 		}
		* 		
		* 		function urlLoaderPreloaderCompleteHandler(event:Event):void {
		* 			trace(myString);
		* 			// outputs the string from the external .txt file
		* 		}
		* 	
		* 	}
		* 
		* }
		* </listing>
		* 
		* @param scope - The object from which the targetpaths and bindings are evaluated.
		* @param name - The name of the property.
		* @param target - The path to the property container.
		* @param url - The url to the external file.
		* @param dataFormat - The dataFormat for the urlLoader data
		*/
		public function URLLoaderPreloader(scope:Object, name:String, target:String, url:String, dataFormat:String = "text", weight:int = 1) {
			super(scope);
			this.name = name;
			this.target = target;
			this.url = url;
			this.dataFormat = dataFormat;
			this.weight = weight ? weight : 1;
			progressive = true;
		} //@r1.2
		
		/**
		* Parses an xml object into an ObjectPreloader.
		* <p/>
		* The xml object must be formatted like this:
		* <listing>
		* &lt;URLLoader name="testObject" target="circle1.content" url="myData.xml" dataFormat="text"/&gt;
		* </listing>
		* 
		* @param scope - The scope used to evaluate bindings.
		* @param xml - The xml object defining the URLLoaderPreloader.
		*/
		public static function fromXML(scope:Object, xml:XML):URLLoaderPreloader {
			return new URLLoaderPreloader(scope, xml.@name, xml.@target, xml.@url, xml.@dataFormat, xml.@weight);;
		} //@r1.2
		
		public override function create():void{
			_progress = 0;
			var request:URLRequest = new URLRequest(parseString(this.url));
			urlLoader = new URLLoader();
			urlLoader.dataFormat = dataFormat;
			urlLoader.addEventListener(ProgressEvent.PROGRESS, urlLoaderProgress);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, urlLoaderIOError);
			urlLoader.addEventListener(Event.COMPLETE, urlLoaderComplete);
			urlLoader.load(request);
		}
		
		protected function urlLoaderProgress(event:ProgressEvent):void {
           _progress = event.bytesLoaded / event.bytesTotal;
        }
		
		protected function urlLoaderIOError(event:IOErrorEvent):void {
			trace("URLLoaderPreloader urlLoaderIOError " + event);
		}
		
		protected function urlLoaderComplete(event:Event):void {
			urlLoader.removeEventListener(ProgressEvent.PROGRESS, urlLoaderProgress);
			urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, urlLoaderIOError);
			urlLoader.removeEventListener(Event.COMPLETE, urlLoaderComplete);
			setProperty();
			complete();
		}
		
		protected function setProperty():void {
			var name:String = parseString(this.name);
			var target:Object = findTarget(parseString(this.target));
			target[name] = urlLoader.data;
		}
		
		public override function toString():String {
			return "[URLLoaderPreloader name=" + name + " target=" + target + " url=" + url + "]";
		}
		
	}
	
}