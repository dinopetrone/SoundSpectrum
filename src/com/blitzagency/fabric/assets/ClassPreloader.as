package com.blitzagency.fabric.assets {
	
	/*
	 * @author Patrick Matte
	 * @since 1.0 02/18/2009
	 * @version 1.0 02/18/2009
	*/
	
	import flash.events.Event;
	import flash.utils.getDefinitionByName;
	
	/**
	* ClassPreloader creates an instance of a class.
	*/
	
	public class ClassPreloader extends Asset {
		
		public var name:String;
		public var target:String;
		public var className:String;
		public var asset:Asset;
		private var targetArray:Array;
		
		/**
		* Creates a new ClassPreloader.
		* <p/>
		* Due to actionscript not supporting constructor overloading,<br/>
		* there's a set maximum of 10 possible arguments.<br/>
		* You can use any asset to create arguments passed to the constructor.
		* <listing>
		* package {
		* 
		* 	import flash.display.Loader;
		* 	
		* 	public class TestObject {
		* 		
		* 		public var image:Loader;
		* 		public var text:String;
		* 		
		* 		public function TestObject(image:Loader, text:String){
		* 			this.image = image;
		* 			this.text = text;
		* 		}
		* 		
		* 	}
		* 
		* }
		* 
		* package {
		* 
		* 	import flash.display.MovieClip;
		* 	import com.blitzagency.fabric.assets.ClassPreloader;
		* 	import com.blitzagency.fabric.assets.LoaderPreloader;
		* 	import com.blitzagency.fabric.assets.StringProperty;
		* 	import com.blitzagency.fabric.assets.SequentialAssetLoader;
		* 
		* 	public class Main extends MovieClip {
		* 		
		* 		public var testObject:TestObject;
		* 	
		* 		public function Main(){
		* 			var classPreloader:ClassPreloader = new ClassPreloader(this, "testObject", "", "TestObject");
		* 			var arguments:SequentialAssetLoader = new SequentialAssetLoader();
		* 			arguments.push(new LoaderPreloader(classPreloader, "argument", "", "images/test.jpg"));
		* 			arguments.push(new StringProperty(classPreloader, "argument", "", "test 1 2 3"));
		* 			classPreloader.asset = arguments;
		* 			classPreloader.progressive = arguments.progressive;
		* 			classPreloader.addEventListener(Event.COMPLETE, classPreloaderCompleteHandler));
		* 			classPreloader.create();
		* 			
		* 		}
		* 	
		* 		function classPreloaderCompleteHandler(event:Event):void {
		* 			trace(testObject.image);
		* 			// outputs [Loader]
		* 			trace(testObject.text);
		* 			// outputs "test 1 2 3"
		* 		}
		* 
		* 	}
		* 
		* }
		* </listing>
		* If you need to use bindings for your properties, you have to target scope for the bindings.<br/>
		* Example:
		* <listing>
		* var classPreloader:ArrayPreloader = new ArrayPreloader(this, "myArray", "");
		* var arguments:SequentialAssetLoader = new SequentialAssetLoader();
		* arguments.push(new LoaderPreloader(classPreloader, "argument", "", "{scope.assets}images/test.jpg"));
		* </listing>
		* 
		* @param scope - The object from which the targetpaths and bindings are evaluated.
		* @param name - The name of the property.
		* @param target - The path to the property container.
		* @param className - The full name of the class ie. "flash.display.MovieClip"
		*/
		public function ClassPreloader(scope:Object, name:String, target:String, className:String) {
			this.name = name;
			this.target = target;
			this.className = className;
			super(scope);
		}
		
		public static function fromXML(scope:Object, xml:XML):ClassPreloader {
			var classPreloader:ClassPreloader =  new ClassPreloader(scope, xml.@name, xml.@target, xml.@className);
			var assetLoader:SequentialAssetLoader = SequentialAssetLoader.fromXML(classPreloader, xml);
			classPreloader.asset = assetLoader;
			classPreloader.progressive = assetLoader.progressive;
			return classPreloader;
		}
		
		/**
		* Parses an xml object into a ArrayPreloader object.<br/>
		* The xml object must be formatted like this:
		* <listing>
		* &lt;Class name="testClass" target="circle1.content" className="frameworkDemo.TestClass"&gt;
		* 	&lt;Loader name="argument" target="" url="{scope.assets}images/bandwidth.jpg" checkPolicyFile="false" securityDomain="false"/&gt;
		* 	&lt;Number name="argument" target=""&gt;5&lt;/Number&gt;
		* &lt;/Class&gt;
		* </listing>
		* @param scope - The scope used to evaluate bindings.
		* @param xml - The xml object defining the ClassPreloader.
		*/
		override public function create():void {
			targetArray = new Array();
			if (asset) {
				asset.addEventListener(Event.COMPLETE, assetComplete);
				asset.create();
			} else {
				complete();
			}
		}
		
		public function set argument(value:Object):void {
			targetArray.push(value);
		}
		
		override public function get progress():Number { 
			return asset.progress;
		}
		
		private function assetComplete(event:Event):void {
			event.target.removeEventListener(Event.COMPLETE, assetComplete);
			complete();
		}
		
		override protected function complete():void {
			var classReference:Object = getDefinitionByName(className);
			var object:Object;
			switch(targetArray.length) {
				case 0:
					object = new classReference();
				break;
				case 1:
					object = new classReference(targetArray[0]);
				break;
				case 2:
					object = new classReference(targetArray[0],targetArray[1]);
				break;
				case 3:
					object = new classReference(targetArray[0],targetArray[1],targetArray[2]);
				break;
				case 4:
					object = new classReference(targetArray[0],targetArray[1],targetArray[2],targetArray[3]);
				break;
				case 5:
					object = new classReference(targetArray[0],targetArray[1],targetArray[2],targetArray[3],targetArray[4]);
				break;
				case 6:
					object = new classReference(targetArray[0],targetArray[1],targetArray[2],targetArray[3],targetArray[4],targetArray[5]);
				break;
				case 7:
					object = new classReference(targetArray[0],targetArray[1],targetArray[2],targetArray[3],targetArray[4],targetArray[5],targetArray[6]);
				break;
				case 8:
					object = new classReference(targetArray[0],targetArray[1],targetArray[2],targetArray[3],targetArray[4],targetArray[5],targetArray[6],targetArray[7]);
				break;
				case 9:
					object = new classReference(targetArray[0],targetArray[1],targetArray[2],targetArray[3],targetArray[4],targetArray[5],targetArray[6],targetArray[7],targetArray[8]);
				break;
				case 10:
					object = new classReference(targetArray[0],targetArray[1],targetArray[2],targetArray[3],targetArray[4],targetArray[5],targetArray[6],targetArray[7],targetArray[8],targetArray[9]);
				break;
			}
			targetArray = null;
			
			var target:Object = findTarget(parseString(this.target));
			var name:String = parseString(this.name);
			target[name] = object;
			super.complete();
		}
		
	}
	
}