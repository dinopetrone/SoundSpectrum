package com.blitzagency.fabric.assets {
	
	/*
	 * @author Patrick Matte
	 * @since 1.0 02/18/2009
	 * @version 1.0 02/18/2009
	*/
	
	/**
	* StringProperty creates a String.
	*/
	public class StringProperty extends Property {
		
		/**
		* Creates a new StringProperty.
		* <listing>
		* package {
		* 
		* 	import flash.display.MovieClip;
		* 	import com.blitzagency.fabric.assets.StringProperty;
		* 
		* 	public class Main extends MovieClip {
		* 		
		* 		var myString:String;
		* 
		* 		public function Main(){
		* 			var stringProperty:StringProperty = new StringProperty(this, "myString", "", "test 1 2 3");
		* 			stringProperty.addEventListener(Event.COMPLETE, stringPropertyCompleteHandler));
		* 			stringProperty.create();
		* 		}
		* 		
		* 		function stringPropertyCompleteHandler(event:Event):void {
		* 			trace(myString);
		* 			// outputs "test 1 2 3"
		* 		}
		* 	
		* 	}
		* 
		* }
		* </listing>
		* 
		* @param scope - The object from which the targetpaths and bindings are evaluated.
		* @param name - The name of the property.
		* @param target - The path to the property container.
		* @param value - true or false.
		*/
		public function StringProperty(scope:Object, name:String, target:String, value:String) {
			super(scope, name, target, value);
		}
		
		/**
		* Parses an xml object into a StringProperty object.
		* <p/>
		* The xml object must be formatted like this:
		* <listing>
		* &lt;String name="myString" target=""&gt;test 1 2 3&lt;/String&gt;
		* </listing>
		* 
		* @param scope - The scope used to evaluate bindings.
		* @param xml - The xml object defining the StringProperty.
		*/
		public static function fromXML(scope:Object, xml:XML):StringProperty {
			return new StringProperty(scope, xml.@name, xml.@target, xml.toString());
		}
		
		override public function create():void {
			var name:String = parseString(this.name);
			var target:Object = findTarget(parseString(this.target));
			target[name] = parseString(value);
			complete();
		}
		
		public override function toString():String {
			return "[StringProperty name=" + name + " target=" + target +  " value=" + value + "]";
		}
		
	}
	
}