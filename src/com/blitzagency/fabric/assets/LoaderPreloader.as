package com.blitzagency.fabric.assets {
	
	/*
	 * @author Patrick Matte
	 * @since 1.0 02/18/2009
	 * @version 1.0 02/18/2009
	 * 
	 * @modified Yosef Flomin
	 * @revision 1.2 2010/04/30
	*/
	
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.system.SecurityDomain;
	
	/**
	* LoaderPreloader loads a Loader object.
	*/
	public class LoaderPreloader extends Asset {
		
		public var name:String;
		public var target:String;
		public var url:String;
		public var checkPolicyFile:String;
		public var securityDomain:String;
		
		protected var loader:Loader;
		
		/**
		* Creates a new LoaderPreloader.
		* <listing>
		* package {
		* 
		* 	import flash.display.MovieClip
		* 	import com.blitzagency.fabric.assets.LoaderPreloader;
		* 
		* 	public class Main extends MovieClip {
		* 		
		* 		public var myLoader:Loader;
		* 	
		* 		public function Main(){
		* 			var loaderPreloader:LoaderPreloader = new LoaderPreloader(this, "myLoader", "", "images/myImage.jpg", "false", "false");
		* 			loaderPreloader.addEventListener(Event.COMPLETE, loaderPreloaderCompleteHandler));
		* 			loaderPreloader.create();
		* 		}
		* 	
		* 		protected function loaderPreloaderCompleteHandler(event:Event):void {
		* 			trace(myLoader);
		* 			// outputs [Loader]
		* 		}
		* 
		* 	}
		* 
		* }
		* </listing>
		* @param scope - The object from which the targetpaths and bindings are evaluated.
		* @param name - The name of the property.
		* @param target - The path to the property container.
		* @param url - The url to the image or swf.
		* @param checkPolicyFile - A Boolean to check for a cross-domain policy file.
		* @param securityDomain - A Boolean to specify that you want to place the loaded SWF file placed into the same security domain as the loading SWF file.
		*/
		public function LoaderPreloader(scope:Object, name:String, target:String, url:String, checkPolicyFile:String = "false", securityDomain:String = "false", weight:int = 1) {
			super(scope);
			this.name = name;
			this.target = target;
			this.url = url;
			this.checkPolicyFile = checkPolicyFile;
			this.securityDomain = securityDomain;
			this.weight = weight ? weight : 1;
			progressive = true;
		} //@r1.2
		
		/**
		* Parses an xml object into a LoaderPreloader object.<br/>
		* The xml object must be formatted like this:
		* <listing>
		* &lt;Loader name="myLoader" target="" url="{assets}images/bandwidth.jpg" checkPolicyFile="false" securityDomain="false"/&gt;
		* </listing>
		* 
		* @param scope - The scope used to evaluate bindings.
		* @param xml - The xml object defining the LoaderPreloader.
		*/
		public static function fromXML(scope:Object, xml:XML):LoaderPreloader {
			return new LoaderPreloader(scope, xml.@name, xml.@target, xml.@url, xml.@checkPolicyFile, xml.@securityDomain, xml.@weight);
		} //r1.2
		
		public override function create():void {
			_progress = 0;
			
			loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loaderComplete);
			loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, loaderProgress);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, loaderIOError);
			
			var context:LoaderContext = new LoaderContext();
			context.checkPolicyFile = Boolean(parseString(checkPolicyFile) == "true");
			context.applicationDomain = ApplicationDomain.currentDomain;
			
			if (Boolean(parseString(securityDomain) == "true")) {
				context.securityDomain = SecurityDomain.currentDomain;
			}
			var urlRequest:URLRequest = new URLRequest(parseString(url));
			loader.load(urlRequest, context);
		}
		
		protected function loaderProgress(event:ProgressEvent):void {
			_progress = event.bytesLoaded / event.bytesTotal;
		}
		
		protected function loaderIOError(event:IOErrorEvent):void {
			trace(this + " " + event);
		}
		
		protected function loaderComplete(event:Event):void {
			var target:Object = findTarget(parseString(this.target));
			var name:String = parseString(this.name);
			target[name] = loader;
			
			loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, loaderProgress);
			loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, loaderIOError);
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, loaderComplete);
			loader = null;
			
			complete();
		}
		
		public override function toString():String {
			return "[LoaderPreloader name=" + name + " target=" + target + " url=" + url + "]";
		}
		
	}
	
}
