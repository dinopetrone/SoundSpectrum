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
	
	/**
	* AssetLoaderPreloader sequentially loads an xml file containing a list of assets.
	*/
	public class AssetLoaderPreloader extends Asset {
		
		public var target:String; 
		public var url:String;
		
		private var urlLoader:URLLoader = new URLLoader();
		private var assetLoader:SequentialAssetLoader;
		
		/**
		* Creates a new AssetLoaderPreloader.
		* <p/>
		* An external xml file named assetList.xml contains:
		* <listing>
		* <xml>
		* 	<Number name="myNumber" target="">3</Number>
		* 	<Property name="myLink" target="">www.blitzagency.com</Property>
		* </xml>
		* 
		* package {
		* 	
		* 	import flash.display.MovieClip
		* 	import com.blitzagency.fabric.assets.AssetLoaderPreloader;
		* 
		* 	public class Main extends MovieClip {
		* 		
		*		var myNumber:Number;
		* 		var myLink:String;
		* 
		* 		public function Main(){
		* 			var assetLoaderPreloader:AssetLoaderPreloader = new AssetLoaderPreloader(this, "", "assetList.xml");
		* 			assetLoaderPreloader.addEventListener(Event.COMPLETE, assetLoaderPreloaderCompleteHandler));
		* 			assetLoaderPreloader.create();
		* 		}
		* 		
		* 		function assetLoaderPreloaderCompleteHandler(event:Event):void {
		* 			trace(myNumber);
		* 			// outputs 3
		* 			trace(myLink);
		* 			// www.blitzagency.com
		* 		}
		* 
		* 	}
		* 
		* }
		* </listing>
		* 
		* @param scope - The object from which the targetpaths and bindings are evaluated.
		* @param target - The path to the object container.
		* @param url - The url of the xml file.
		*/
		public function AssetLoaderPreloader(scope:Object, target:String = "", url:String = "", weight:int = 1) {
			super(scope);
			this.target = target;
			this.url = url;
			this.weight = weight ? weight : 1;
			progressive = true;
		} //@r1.2
		
		/**
		* Parses an xml object into a AssetLoaderPreloader object.
		* <p/>
		* The xml object must be formatted like this:
		* <listing>
		* &lt;AssetLoaderPreloader target="" url="{assets}xml/assetList.xml"/&gt;
		* </listing>
		* @param scope - The scope used to evaluate bindings.
		* @param xml - The xml object defining the AssetLoaderPreloader.
		*/
		public static function fromXML(scope:Object, xml:XML):AssetLoaderPreloader {
			return new AssetLoaderPreloader(scope, xml.@target, xml.@url, xml.@weight);
		} //@r1.2
		
		public override function create():void {
			_progress = 0;
			var url:String = parseString(this.url);
			urlLoader = new URLLoader();
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, urlLoaderIOError);
			urlLoader.addEventListener(Event.COMPLETE, urlLoaderComplete);
			urlLoader.load(new URLRequest(url));
		}
		
		protected function urlLoaderIOError(event:IOErrorEvent):void {
			trace(event);
		}
		
		protected function urlLoaderComplete(event:Event):void {
			urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, urlLoaderIOError);
			urlLoader.removeEventListener(Event.COMPLETE, urlLoaderComplete);
			var assetsXML:XML = XML(urlLoader.data);
			urlLoader = null;
			var target:Object = findTarget(parseString(this.target));
			assetLoader = SequentialAssetLoader.fromXML(target, assetsXML);
			assetLoader.addEventListener(Event.COMPLETE, assetLoaderComplete);
			assetLoader.create();
		}
		
		override public function get progress():Number {
			if (assetLoader) {
				_progress = assetLoader.progress;
			}
			return _progress;
		}
		
		private function assetLoaderComplete(event:Event):void {
			event.target.removeEventListener(Event.COMPLETE, assetLoaderComplete);
			assetLoader = null;
			complete();
		}
		
		public override function toString():String {
			return "[AssetLoaderPreloader target=" + this.target + " url=" + url + "]";
		}
		
	}
	
}