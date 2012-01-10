package com.blitzagency.fabric.assets {
	
	/*
	 * @author Patrick Matte
	 * @since 1.0 02/18/2009
	 * @version 1.0 02/18/2009
	*/
	
	import flash.events.Event;
	import flash.events.ProgressEvent;
	
	/**
	* ObjectPreloader creates a dynamic object.
	*/
	public class ObjectPreloader extends Asset {
		
		public var name:String;
		public var target:String;
		public var asset:Asset;
		public var object:Object;
		
		/**
		* Creates a new ObjectPreloader.
		* <p/>
		* You can use any asset to create objects inside the object.
		* <listing>
		* package {
		* 
		* 	import flash.display.MovieClip;
		* 	import com.blitzagency.fabric.assets.ObjectPreloader;
		* 	import com.blitzagency.fabric.assets.SequentialAssetLoader;
		* 	import com.blitzagency.fabric.assets.LoaderPreloader;
		* 	import com.blitzagency.fabric.assets.StringProperty;
		* 
		* 	public class Main extends MovieClip {
		* 		
		* 		var myObject:Object;
		* 
		* 		public function Main() {
		* 			var objectPreloader:ObjectPreloader = new ObjectPreloader(this, "myObject", "");
		* 			var objects:SequentialAssetLoader = new SequentialAssetLoader();
		* 			objects.push(new LoaderPreloader(objectPreloader, "", "object", "images/test.jpg"));
		* 			objects.push(new StringProperty(objectPreloader, "", "object", "myString" ));
		* 			objectPreloader.asset = objects;
		* 			objectPreloader.progressive = objects.progressive;
		* 			objectPreloader.addEventListener(Event.COMPLETE, objectPreloaderCompleteHandler));
		* 			objectPreloader.create();
		* 		}
		* 		
		* 		function objectPreloaderCompleteHandler(event:Event):void {
		* 			trace(myObject);
		* 			// outputs [Object]
		* 		}
		* 	
		* 	}
		* 
		* }
		* </listing>
		* If you need to use bindings for your properties, you have to target scope for the bindings.<br/>
		* Example :
		* <listing>
		* var objectPreloader:ObjectPreloader = new ObjectPreloader(this, "myObject", "");
		* var objects:SequentialAssetLoader = new SequentialAssetLoader();
		* objects.push(new LoaderPreloader(arrayPreloader, "", "object", "{scope.assets}images/test.jpg"));
		* </listing>
		* @param scope - The object from which the targetpaths and bindings are evaluated.
		* @param name - The name of the property.
		* @param target - The path to the property container.
		*/
		public function ObjectPreloader(scope:Object, name:String, target:String) {
			super(scope);
			this.name = name;
			this.target = target;
		}
		
		/**
		* Parses an xml object into an ObjectPreloader.<br/>
		* The xml object must be formatted like this:
		* <listing>
		* 	&lt;Object name="testObject" target="circle1.content"&gt;
		* 		&lt;Loader name="image" target="object" url="{scope.assets}images/bandwidth.jpg" checkPolicyFile="false" securityDomain="false"/&gt;
		* 		&lt;Number name="test" target="object"&gt;5&lt;/Number&gt;
		* 		&lt;Property name="link" target="object"&gt;scope.link&lt;/Property&gt;
		* 		&lt;Object name="testObject2" target="object"&gt;
		* 			&lt;Number name="test" target="object"&gt;5&lt;/Number&gt;
		* 			&lt;Property name="link" target="object"&gt;scope.scope.link&lt;/Property&gt;
		* 			&lt;Property name="link" target="object"&gt;scope.scope.link&lt;/Property&gt;
		* 		&lt;/Object&gt;
		* 	&lt;/Object&gt;
		* </listing>
		* @param scope - The scope used to evaluate bindings.
		* @param xml - The xml object defining the ObjectPreloader.
		*/
		public static function fromXML(scope:Object, xml:XML):ObjectPreloader {
			var objectPreloader:ObjectPreloader = new ObjectPreloader(scope, xml.@name, xml.@target);
			var assetLoader:SequentialAssetLoader = SequentialAssetLoader.fromXML(objectPreloader, xml);
			objectPreloader.asset = assetLoader;
			objectPreloader.progressive = assetLoader.progressive;
			return objectPreloader;
		}
		
		override public function create():void {
			_progress = 0;
			object = new Object();
			if (asset) {
				asset.addEventListener(Event.COMPLETE, assetComplete);
				asset.create();
			}else {
				complete();
			}
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
			target[name] = object;
			object = null;
			super.complete();
		}
		
		public override function toString():String {
			return "[ObjectPreloader name=" + name + " target=" + target + "]";
		}
		
	}
	
}