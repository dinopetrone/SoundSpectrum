package com.blitzagency.fabric.assets {
	
	/*
	 * @author Patrick Matte
	 * @since 1.0 02/18/2009
	 * @version 1.0 02/18/2009
	*/
	
	import flash.events.Event;
	
	/**
	* ArrayPreloader creates an array of objects.
	*/
	public class ArrayPreloader extends Asset {
		
		public var name:String;
		public var target:String;
		public var asset:Asset;
		private var targetArray:Array;
		
		/**
		* Creates a new ArrayPreloader.
		* <listing>
		* package {
		* 
		* 	import flash.display.MovieClip;
		* 	import com.blitzagency.fabric.assets.ArrayPreloader;
		* 	import com.blitzagency.fabric.assets.SequentialAssetLoader;
		* 	import com.blitzagency.fabric.assets.LoaderPreloader;
		* 	import com.blitzagency.fabric.assets.StringProperty;
		* 
		* 	public class Main extends MovieClip {
		* 		
		* 		var myArray:Array;
		* 
		* 		public function Main(){
		* 			var arrayPreloader:ArrayPreloader = new ArrayPreloader(this, "myArray", "");
		* 			var arguments:SequentialAssetLoader = new SequentialAssetLoader();
		* 			arguments.push(new LoaderPreloader(arrayPreloader, "argument", "", "images/test.jpg"));
		* 			arguments.push(new StringProperty(arrayPreloader, "argument", "", "myString" ));
		* 			arrayPreloader.asset = arguments;
		* 			arrayPreloader.progressive = arguments.progressive;
		* 			arrayPreloader.addEventListener(Event.COMPLETE, arrayPreloaderCompleteHandler));
		* 			arrayPreloader.create();
		* 		}
		* 		
		* 		function arrayPreloaderCompleteHandler(event:Event):void {
		* 			trace(myArray);
		* 			// outputs [Loader], "myString"
		* 		}
		* 	
		* 	}
		* 
		* }
		* </listing>
		* If you need to use bindings for your properties, you have to target scope for the bindings.
		* <p/>
		* Example:
		* <listing>
		* arguments.push(new LoaderPreloader(arrayPreloader, "argument", "", "{scope.assets}images/test.jpg"));
		* </listing>
		* 
		* @param scope - The object from which the targetpaths and bindings are evaluated.
		* @param name - The name of the property.
		* @param target - The path to the property container.
		*/
		public function ArrayPreloader(scope:Object, name:String, target:String) {
			super(scope);
			this.name = name;
			this.target = target;
		}
		
		/**
		* Parses an xml object into a ArrayPreloader object.<br/>
		* The xml object must be formatted like this:
		* <listing>
		* &lt;Array name="testArray" target="circle1.content"&gt;
		* 	&lt;Number name="argument" target=""&gt;3&lt;/Number&gt;
		* 	&lt;Property name="argument" target=""&gt;scope.link&gt;/Property&gt;
		* &lt;/Array&gt;
		* </listing>
		* @param scope - The scope used to evaluate bindings.
		* @param xml - The xml object defining the ArrayPreloader.
		*/
		public static function fromXML(scope:Object, xml:XML):ArrayPreloader {
			var arrayPreloader:ArrayPreloader = new ArrayPreloader(scope, xml.@name, xml.@target);
			var assetLoader:AssetLoader = SequentialAssetLoader.fromXML(arrayPreloader, xml);
			arrayPreloader.asset = assetLoader;
			arrayPreloader.progressive = assetLoader.progressive
			return arrayPreloader;
		}
		
		override public function create():void {
			_progress = 0;
			targetArray = new Array();
			if (asset) {
				asset.addEventListener(Event.COMPLETE, assetComplete);
				asset.create();
			}else {
				complete();
			}
		}
		
		public function set argument(value:Object):void {
			targetArray.push(value);
		}
		
		override public function get progress():Number {
			if (asset) {
				_progress = asset.progress;
			}
			return _progress;
		}
		
		private function assetComplete(event:Event):void {
			event.target.removeEventListener(Event.COMPLETE, assetComplete);
			complete();
		}
		
		override protected function complete():void {
			var name:String = parseString(this.name);
			var target:Object = findTarget(parseString(this.target));
			target[name] = targetArray.slice();
			targetArray = null;
			super.complete();
		}
		
		public override function toString():String {
			return "[ArrayPreloader name=" + name + " target=" + target + "]";
		}
		
	}
	
}