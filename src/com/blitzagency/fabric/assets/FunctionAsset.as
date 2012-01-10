package com.blitzagency.fabric.assets {
	
	/*
	 * @author Patrick Matte
	 * @since 1.0 02/18/2009
	 * @version 1.0 02/18/2009
	*/
	
	import flash.events.Event;
	
	/**
	* FunctionAsset calls a method with objects as arguments.
	*/
	public class FunctionAsset extends Asset {
		
		public var name:String;
		public var target:String;
		public var asset:Asset;
		private var targetArray:Array;
		
		/**
		* Creates a new FunctionAsset.
		* <p/>
		* You can use any asset to create the method arguments.
		* <listing>
		* package {
		* 
		* 	import flash.display.MovieClip
		* 	import com.blitzagency.fabric.assets.FunctionAsset;
		* 	import com.blitzagency.fabric.assets.SequentialAssetLoader;
		* 	import com.blitzagency.fabric.assets.LoaderPreloader;
		* 	import com.blitzagency.fabric.assets.StringProperty;
		* 
		* 	public class Main extends MovieClip {
		* 		
		* 		public var myLoader:Loader;
		* 		public var myString:String;
		* 	
		* 		public function Main(){
		* 			var functionAsset:FunctionAsset = new FunctionAsset(this, "myFunction", "");
		* 			var arguments:SequentialAssetLoader = new SequentialAssetLoader();
		* 			arguments.push(new LoaderPreloader(functionAsset, "argument", "", "images/test.jpg"));
		* 			arguments.push(new StringProperty(functionAsset, "argument", "", "test 1 2 3" ));
		* 			functionAsset.asset = arguments;
		* 			functionAsset.progressive = arguments.progressive;
		* 			functionAsset.addEventListener(Event.COMPLETE, functionAssetCompleteHandler));
		* 			functionAsset.create();
		* 		}
		* 		
		* 		public function myMethod(myLoader:Loader, myString:String):void{
		* 			this.myLoader = myLoader;
		* 			this.myString = myString;
		* 		}
		* 	
		* 		protected function functionAssetCompleteHandler(event:Event):void {
		* 			trace(myLoader);
		* 			// outputs [Loader]
		* 			trace(myString);
		* 			// outputs "test 1 2 3"
		* 		}
		* 
		* 	}
		* 
		* }
		* </listing>
		* If you need to use bindings for your properties, you have to target scope for the bindings.<br>
		* Example :
		* <listing>
		* var functionAsset:FunctionAsset = new FunctionAsset(this, "myFunction", "");
		* var functionArguments:SequentialAssetLoader = new SequentialAssetLoader();
		* functionArguments.push(new LoaderPreloader(arrayPreloader, "argument", "", "{scope.assets}images/test.jpg"));
		* </listing>
		* 
		* @param scope - The object from which the targetpaths and bindings are evaluated.
		* @param name - The name of the method to call.
		* @param target - The path to the method container.
		*/
		public function FunctionAsset(scope:Object, name:String, target:String) {
			this.name = name;
			this.target = target;
			super(scope);
		}
		
		/**
		* Parses an xml object into a FunctionAsset object.
		* <p/>
		* The xml object must be formatted like this:
		* <listing>
		* &lt;Function name="myFunction" target=""&gt;
		* 	&lt;Loader name="argument" target="" url="{scope.assets}images/bandwidth.jpg" checkPolicyFile="false" securityDomain="false"/&gt;
		* 	&lt;Number name="argument" target=""&gt;5&lt;/Number&gt;
		* &lt;/Function&gt;
		* </listing>
		* 
		* @param scope - The scope used to evaluate bindings.
		* @param xml - The xml object defining the FunctionAsset.
		*/
		public static function fromXML(scope:Object, xml:XML):FunctionAsset {
			var functionAsset:FunctionAsset = new FunctionAsset(scope, xml.@name, xml.@target);
			var assetLoader:AssetLoader = SequentialAssetLoader.fromXML(functionAsset, xml);
			functionAsset.asset = assetLoader;
			functionAsset.progressive = assetLoader.progressive
			return functionAsset;
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
		
		private function assetComplete(event:Event):void {
			event.target.removeEventListener(Event.COMPLETE, assetComplete);
			complete();
		}
		
		override protected function complete():void {
			var name:String = parseString(this.name);
			var target:Object = findTarget(parseString(this.target));
			target[name].apply(this, targetArray.slice());
			targetArray = null;
			super.complete();
		}
		
		public override function toString():String {
			return "[FunctionAsset name=" + name + " target=" + target + "]";
		}
		
	}
	
}