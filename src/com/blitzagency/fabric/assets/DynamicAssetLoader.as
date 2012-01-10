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
	
	/**
	* DynamicAssetLoader can load any asset.
	*/
	public class DynamicAssetLoader extends Asset {
		
		public var name:String;
		public var target:String;
		
		private var asset:Asset;
		
		/**
		* Creates a new DynamicAssetLoader.
		* <p/>
		* This asset is meant to be used when you have to create a dynamic list of things.
		* <listing>
		* package {
		* 
		* 	import flash.display.MovieClip
		* 	import flash.text.StyleSheet;
		* 	import com.blitzagency.fabric.assets.DynamicAssetLoader;
		* 	import com.blitzagency.fabric.assets.LoaderPreloader;
		* 
		* 	public class Main extends MovieClip {
		* 		
		* 		public var myAsset:LoaderPreloader;
		* 		public var myLoader:Loader;
		* 	
		* 		public function Main(){
		* 			myAsset = new LoaderPreloader(this, "myLoader", "", "images/myImage.jpg", "false", "false");
		* 			var dynamicAssetLoader:DynamicAssetLoader = new DynamicAssetLoader(this, "myAsset", "", true);
		* 			dynamicAssetLoader.addEventListener(Event.COMPLETE, assetCompleteHandler));
		* 			dynamicAssetLoader.create();
		* 		}
		* 	
		* 		function assetCompleteHandler(event:Event):void {
		* 			trace(myLoader);
		* 			// outputs [Loader]
		* 		}
		* 
		* 	}
		* 
		* }
		* </listing>
		* 
		* @param scope - The object from which the targetpaths and bindings are evaluated.
		* @param name - The name of the property.
		* @param target - The part to the property container.
		*/
		public function DynamicAssetLoader(scope:Object, name:String, target:String, progressive:Boolean = false, weight:int = 1) {
			super(scope);
			this.name = name;
			this.target = target;
			this.progressive = progressive;
			this.weight = weight ? weight : 1;
		} //@r1.2
		
		/**
		* Parses an xml object into a DynamicAssetLoader object.
		* <p/>
		* The xml object must be formatted like this:
		* <listing>
		* &lt;DynamicAssetLoader name="myAsset" target="" progressive="true"/&gt;
		* </listing>
		* 
		* @param scope - The scope used to evaluate bindings.
		* @param xml - The xml object defining the DynamicAssetLoader.
		*/
		public static function fromXML(scope:Object, xml:XML):DynamicAssetLoader {
			return new DynamicAssetLoader(scope, xml.@name, xml.@target, true, xml.@weight);
		} //@r1.2
		
		override public function create():void {
			_progress = 0;
			var target:Object = findTarget(parseString(this.target));
			var name:String = parseString(this.name);
			asset = target[name];
			asset.addEventListener(Event.COMPLETE, assetComplete);
			asset.create();
		}
		
		override public function get progress():Number {
			if (asset) {
				_progress = asset.progress;
			}
			return _progress;
		}
		
		private function assetComplete(e:Event):void {
			asset.removeEventListener(Event.COMPLETE, assetComplete);
			asset = null;
			complete();
		}
		
		public override function toString():String {
			return "[DynamicAssetLoader name=" + name + " target=" + target + "]";
		}
		
	}
	
}