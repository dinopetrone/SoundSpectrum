package com.blitzagency.fabric.assets {
	
	/*
	 * @author Patrick Matte
	 * @since 1.0 02/18/2009
	 * @version 1.0 02/18/2009
	*/
	
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.net.URLRequest;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.events.IOErrorEvent;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.getTimer;
	
	/**
	* DownloadSpeedPreloader loads an external image file and calculates the speed in KB/s.<br/>
	*/
	public class DownloadSpeedPreloader extends Asset {
		
		public var name:String;
		public var target:String;
		public var url:String;
		public var checkPolicyFile:String;
		
		private var startTime:Number;
		private var loader:Loader;
		
		/**
		* Creates a new DownloadSpeedPreloader.
		* <p/>
		* You can use any asset to create the array objects.
		* <listing>
		* package {
		* 
		* 	import com.blitzagency.fabric.assets.DownloadSpeedPreloader;
		* 
		* 	public class Main {
		* 		
		* 		public var speed:Number;
		* 	
		* 		public function Main(){
		* 			var downloadSpeedPreloader:DownloadSpeedPreloader = new DownloadSpeedPreloader(this, "speed", "", "images/testSpeed.jpg");
		* 			downloadSpeedPreloader.addEventListener(Event.COMPLETE, speedCompleteHandler));
		* 			downloadSpeedPreloader.create();
		* 		}
		* 	
		* 		function speedCompleteHandler(event:Event):void {
		* 			trace(speed);
		* 			// outputs 80
		* 		}
		* 
		* 	}
		* 
		* }
		* </listing>
		* @param scope - The object from which the targetpaths and bindings are evaluated.
		* @param name - The name of the property.
		* @param url - The url to the image to load.
		*/
		public function DownloadSpeedPreloader(scope:Object, name:String, target:String, url:String, checkPolicyFile:String = "false" ) {
			super(scope);
			this.name = name;
			this.target = target;
			this.url = url;
			this.checkPolicyFile = checkPolicyFile;
			progressive = true;
		}
		
		/**
		* Parses an xml object into a DownloadSpeedPreloader object.<br/>
		* The xml object must be formatted like this:
		* <listing>
		* &lt;DownloadSpeed name="speed" target="" url="images/testSpeed.jpg" checkPolicyFile="false"/&gt;
		* </listing>
		* @param scope - The scope used to evaluate bindings.
		* @param xml - The xml object defining the DownloadSpeedPreloader.
		*/
		public static function fromXML(scope:Object, xml:XML):DownloadSpeedPreloader {
			return new DownloadSpeedPreloader(scope, xml.@name, xml.@target, xml.@url, xml.@checkPolicyFile);
		}
		
		public override function create():void {
			_progress = 0;
			var url:String = parseString(this.url);
			if (url.indexOf("http") != -1) {
				url += "?rnd=" + Math.round(Math.random() * 10000000000);
			}
			var context:LoaderContext = new LoaderContext(Boolean(parseString(checkPolicyFile) == "true"), ApplicationDomain.currentDomain);
			var urlRequest:URLRequest = new URLRequest(url);
			loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loaderComplete);
			loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, loaderProgress);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, loaderIOError);
			loader.load(urlRequest, context);
			startTime = getTimer();
		}
		
		protected function ioErrorEvent(event:IOErrorEvent):void {
			trace(event);
		}
		
		protected function loaderProgress(event:ProgressEvent):void {
			_progress = event.bytesLoaded / event.bytesTotal;
		}
		
		protected function loaderIOError(event:IOErrorEvent):void {
			trace("IOErrorEvent " + event);
		}
		
		protected function loaderComplete(event:Event):void {
			event.target.removeEventListener(ProgressEvent.PROGRESS, loaderProgress);
			event.target.removeEventListener(IOErrorEvent.IO_ERROR, loaderIOError);
			event.target.removeEventListener(Event.COMPLETE, loaderComplete);
			
			var contentLoaderInfo:LoaderInfo = event.target as LoaderInfo;
			var endTime:Number = getTimer();
			var totalTime:Number = (endTime - startTime) / 1000;
			var speed:Number = contentLoaderInfo.bytesTotal / 1024 / totalTime;
			
			var target:Object = findTarget(parseString(this.target));
			var name:String = parseString(this.name);
			target[name] = speed;
			
			loader.unload();
			loader = null;
			
			complete();
		}
		
		public override function toString():String {
			return "[BandwidthSpeedPreloader name=" + name + " target=" + target + "]";
		}
		
	}
	
}