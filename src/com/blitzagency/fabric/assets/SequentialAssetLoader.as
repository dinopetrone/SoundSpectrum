package com.blitzagency.fabric.assets {
	
	/*
	 * @author Patrick Matte
	 * @since 1.0 02/18/2009
	 * @version 1.0 02/18/2009
	*/
	
	import com.blitzagency.utils.XMLAlias;
	import flash.events.Event;
	
	/**
	* SequentialAssetLoader extends AssetLoader. It creates all the assets one after another.
	*/
	public class SequentialAssetLoader extends AssetLoader {
		
		/**
		* Creates a new SequentialAssetLoader.
		* <p/>
		* Very Useful when you want to create an asset in another one that just completed or<br/>
		* if you want to push some asset in a array in the correct order.
		* <listing>
		* package {
		* 
		* 	import flash.display.MovieClip;
		* 	import flash.display.Loader;
		* 	import com.blitzagency.fabric.assets.SequentialAssetLoader;
		* 	import com.blitzagency.fabric.assets.LoaderPreloader;
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
		* 			var sequentialAssetLoader:SequentialAssetLoader = new SequentialAssetLoader();
		* 			for (var i = 0; i < images.length; i++){
		* 				var source:String = images[i];
		* 				sequentialAssetLoader.push(new LoaderPreloader(this, "loader" + i, "", source));
		* 			}
		* 			sequentialAssetLoader.push(new StringProperty(this, "string", "", "test 1 2 3" ));
		* 			sequentialAssetLoader.push(new XMLPreloader(this, "xml", "", "myData.xml"));
		* 			sequentialAssetLoader.addEventListener(Event.COMPLETE, sequentialAssetLoaderCompleteHandler));
		* 			sequentialAssetLoader.create();
		* 		}
		* 		
		* 		function sequentialAssetLoaderCompleteHandler(event:Event):void {
		* 		}
		* 	
		* 	}
		* 
		* }
		* </listing>
		*/
		public function SequentialAssetLoader() {
			super();
		}
		
		/**
		* Parse an xml node and creates a SequentialAssetLoader.
		* <p/> 
		* The xml object must be formatted like this:
		* <listing>
		* &lt;Sequential&gt;
		* 	&lt;Loader name="loader0" target="" url="image0.jpg" checkPolicyFile="false" securityDomain="false"/&gt;
		* 	&lt;Loader name="loader1" target="" url="image1.jpg" checkPolicyFile="false" securityDomain="false"/&gt;
		* 	&lt;Loader name="loader2" target="" url="image2.jpg" checkPolicyFile="false" securityDomain="false"/&gt;
		* 	&lt;Loader name="loader3" target="" url="image3.jpg" checkPolicyFile="false" securityDomain="false"/&gt;
		* 	&lt;String name="string" target=""&gt;test 1 2 3&lt;/String&gt;
		* 	&lt;XMLLoader name="xml" target="" url="myData.xml"/&gt;
		* &lt;/Sequential&gt;
		* </listing>
		* 
		* @param scope - The object from which the targetpaths and bindings are evaluated.
		* @param xml - The xml node containing the list of asset.
		* @return A SequentialAssetLoader including all the assets in the xml children list.
		*/
		public static function fromXML(scope:Object, xml:XML):SequentialAssetLoader {
			var assetLoader:SequentialAssetLoader = new SequentialAssetLoader();
			var xmlList:XMLList = xml.elements();
			for (var i:int = 0; i < xmlList.length(); i++) {
				var classObject:Class = XMLAlias.getClassByAlias(xmlList[i].name());
				var asset:Asset = classObject.fromXML(scope, xmlList[i]);
				assetLoader.push(asset);
			}
			return assetLoader;
		}
		
		/**
		* Creates the first asset in the array.
		*/
		override public function create():void {
			createdAssets = new Array();
			if (assets.length > 0) {
				createAsset();
			} else {
				complete();
			}
		}
		
		/**
		* Creates the asset in the array specified at the current index.
		*/
		private function createAsset():void {
			var index:Number = createdAssets.length;
			var asset:Asset = assets[index] as Asset;
			asset.addEventListener(Event.COMPLETE, assetComplete);
			asset.create();
		}
		
		/**
		* Creates the next asset in the array after the previous one is completed. Also calls complete() when all asset have completed.
		*/
		protected function assetComplete(event:Event):void {
			var asset:Asset = event.target as Asset;
			asset.removeEventListener(Event.COMPLETE, assetComplete);
			createdAssets.push(asset);
			if (createdAssets.length == assets.length) {
				complete();
			} else {
				createAsset();
			}
		}
		
	}
	
}