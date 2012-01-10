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
	
	/**
	* AssetLoader is an abstract class used to create a list of assets.
	* <p/>
	* It extends Asset so AssetLoaders can be used into one another.<br/>
	* There is two kind of assetloaders, sequential or parallel.<br/>
	* You can mix them up together.
	* <p/>
	* In this example, the sequential assetloader first loads a Loader then<br/>
	* loads a parallel assetloader that loads four Loaders in the first Loader's content.
	* <listing>
	* package {
	* 
	* 	import flash.display.MovieClip;
	* 	import flash.display.Loader;
	* 	import com.blitzagency.fabric.assets.SequentialAssetLoader;
	* 	import com.blitzagency.fabric.assets.ParallelAssetLoader;
	* 	import com.blitzagency.fabric.assets.LoaderPreloader;
	* 
	* 	public class Main extends MovieClip {
	* 		
	* 		public var loader:Loader;
	* 	
	* 		public function Main(){
	* 			var sequentialAssetLoader:SequentialAssetLoader = new SequentialAssetLoader();
	* 			sequentialAssetLoader.push(new LoaderPreloader(this, "loader", "", source));
	* 			
	* 			var images:Array = [image0.jpg, image1.jpg, image2.jpg, image3.jpg];
	* 			var parallelAssetLoader:ParallelAssetLoader = new ParallelAssetLoader();
	* 			for (var i = 0; i < images.length; i++){
	* 				var source:String = images[i];
	* 				parallelAssetLoader.push(new LoaderPreloader(this, "loader" + i, "loader.content", source));
	* 			}
	* 			sequentialAssetLoader.push(parallelAssetLoader);
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
	public class AssetLoader extends Asset implements IAssetLoader {
		
		/**
		* Stores the list of asset.
		*/
		protected var assets:Array = new Array();
		
		/**
		* Used to calculate te progress of the assetLoader.
		*/
		protected var progressiveAssets:Array = new Array();
		
		/**
		* Used to calculate how many assets are created.
		*/
		protected var createdAssets:Array = new Array();
		
		
		/**
		* AssetLoader is an abstract class used to create a list of assets.
		*/
		public function AssetLoader() {
			super(null);
		}
		
		/**
		* Parse an xml node and creates an AssetLoader.
		* 
		* @param scope - The object from which the targetpaths and bindings are evaluated.
		* @param xml - The xml node containing the list of asset. The type parameter of the xml node determines what type of assetLoader is returned.
		* @return An AssetLoader including all the assets in the xml children list.
		*/
		public static function fromXML(scope:Object, xml:XML):IAssetLoader {
			var assetLoader:AssetLoader;
			switch(xml.@type) {
				case "parallel":
					assetLoader = ParallelAssetLoader.fromXML(scope, xml);
				break;
				default:
					assetLoader = SequentialAssetLoader.fromXML(scope, xml);
				break;
			}
			return assetLoader;
		}
		
		/**
		* Adds an asset to the asset list. 
		* @param asset - A class extending Asset or implementing IAsset.
		*/
		public function push(asset:IAsset):void {
			assets.push(asset);
			if (asset.progressive) {
				progressiveAssets.push(asset);
				progressive = true;
			}
		}
		
		/**
		* Returns the progress of the assetLoader. 
		* @return A Number from 0 to 1.
		*/
		public override function get progress():Number {
			var loaded:Number = 0;
			var totalWeight:int = 0; //@r1.2
			for (var i:int = 0; i < progressiveAssets.length; i++ ) {
				var asset:Asset = progressiveAssets[i] as Asset;
				loaded += asset.progress * asset.weight; //@r1.2
				totalWeight += asset.weight; //@r1.2
			}
			var totalProgress:Number = loaded / totalWeight; //@r1.2
			return totalProgress;
		}
		
		/**
		* Resets the asset and the list of assets included in the assetloader
		*/
		public override function destroy():void {
			for (var i:int = createdAssets.length - 1; i > -1; i--) {
				var asset:Asset = createdAssets[i] as Asset;
				asset.destroy();
			}
			super.destroy();
		}
		
	}
	
}