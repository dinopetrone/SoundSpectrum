package com.blitzagency.fabric.assets {
	
	/*
	 * @author Patrick Matte
	 * @since 1.0 02/18/2009
	 * @version 1.0 02/18/2009
	*/
	
	import com.blitzagency.utils.XMLAlias;
	
	import flash.events.Event;
	
	/**
	* ParallelAssetLoader extends AssetLoader. It creates all the assets at the same time.
	*/
	public class ParallelAssetLoader extends AssetLoader {
		
		/**
		* Creates a new ParallelAssetLoader.
		* <p/>
		* Very useful to load a list of assets if the loading order is not important.
		* <listing>
		* package {
		* 
		* 	import flash.display.MovieClip;
		* 	import flash.display.Loader;
		* 	import com.blitzagency.fabric.assets.ParallelAssetLoader;
		* 	import com.blitzagency.fabric.assets.LoaderPreloader;
		* 	import com.blitzagency.fabric.assets.StringProperty;
		* 	import com.blitzagency.fabric.assets.XMLPreloader;
		* 
		* 	public class Main extends MovieClip {
		* 		
		* 		public var loader0:Loader;
		* 		public var loader1:Loader;
		* 		public var loader2:Loader;
		* 		public var loader3:Loader;
		* 		public var string:String;
		* 		public var xml:XML;
		* 		
		* 	
		* 		public function Main(){
		* 			var images:Array = [image0.jpg, image1.jpg, image2.jpg, image3.jpg];
		* 			var parallelAssetLoader:ParallelAssetLoader = new ParallelAssetLoader();
		* 			for (var i = 0; i < images.length; i++){
		* 				var source:String = images[i];
		* 				parallelAssetLoader.push(new LoaderPreloader(this, "loader" + i, "", source));
		* 			}
		* 			parallelAssetLoader.push(new StringProperty(this, "string", "", "test 1 2 3" ));
		* 			parallelAssetLoader.push(new XMLPreloader(this, "xml", "", "myData.xml"));
		* 			parallelAssetLoader.addEventListener(Event.COMPLETE, parallelAssetLoaderCompleteHandler));
		* 			parallelAssetLoader.create();
		* 		}
		* 		
		* 		function parallelAssetLoaderCompleteHandler(event:Event):void {
		* 		}
		* 	
		* 	}
		* 
		* }
		* </listing>
		*/
		public function ParallelAssetLoader() {
			super();
		}
		
		/**
		* Parse an xml node and creates a ParallelAssetLoader.
		* <p/>
		* The xml object must be formatted like this:
		* <listing>
		* &lt;Parallel&gt;
		* 	&lt;Loader name="loader0" target="" url="image0.jpg" checkPolicyFile="false" securityDomain="false"/&gt;
		* 	&lt;Loader name="loader1" target="" url="image1.jpg" checkPolicyFile="false" securityDomain="false"/&gt;
		* 	&lt;Loader name="loader2" target="" url="image2.jpg" checkPolicyFile="false" securityDomain="false"/&gt;
		* 	&lt;Loader name="loader3" target="" url="image3.jpg" checkPolicyFile="false" securityDomain="false"/&gt;
		* 	&lt;String name="string" target=""&gt;test 1 2 3&lt;/String&gt;
		* 	&lt;XMLLoader name="xml" target="" url="myData.xml"/&gt;
		* &lt;/Parallel&gt;
		* </listing>
		* 
		* @param scope - The object from which the targetpaths and bindings are evaluated.
		* @param xml - The xml node containing the list of asset.
		* @return A ParallelAssetLoader including all the assets in the xml children list.
		*/
		public static function fromXML(scope:Object, xml:XML):ParallelAssetLoader {
			var assetLoader:ParallelAssetLoader = new ParallelAssetLoader();
			var xmlList:XMLList = xml.elements();
			for (var i:int = 0; i < xmlList.length(); i++) {
				var classObject:Class = XMLAlias.getClassByAlias(xmlList[i].name());
				var asset:Asset = classObject.fromXML(scope, xmlList[i]);
				assetLoader.push(asset);
			}
			return assetLoader;
		}
		
		/**
		* Creates each asset in the array at the same time.
		*/
		override public function create():void {
			createdAssets = new Array();
			if (assets.length > 0) {
				for (var i:int = 0; i < assets.length; i++) {
					var asset:Asset = assets[i] as Asset;
					asset.addEventListener(Event.COMPLETE, assetComplete);
					asset.create();
				}
			} else {
				complete();
			}
		}
		
		/**
		* Calls complete when all asset have completed.
		*/
		protected function assetComplete(event:Event):void {
			var asset:Asset = event.target as Asset;
			asset.removeEventListener(Event.COMPLETE, assetComplete);
			createdAssets.push(asset);
			if (createdAssets.length == assets.length) {
				complete();
			}
		}
		
	}
	
}