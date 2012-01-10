package com.blitzagency.fabric.assets {
	
	/*
	 * @author Patrick Matte
	 * @since 1.0 02/18/2009
	 * @version 1.0 02/18/2009
	*/
	
	/**
	* Property relays a objets reference to another object.
	*/
	public class Property extends Asset {
		
		public var name:String;
		public var target:String;
		public var value:String;
		
		/**
		* Creates a new Property.
		* <listing>
		* package {
		* 
		* 	import flash.display.MovieClip;
		* 	import com.blitzagency.fabric.assets.Property;
		* 
		* 	public class Main extends MovieClip {
		* 		
		* 		var myArray:Array;
		* 		var myTestArray:Array;
		* 
		* 		public function Main(){
		* 			myTestArray = new Array(1, 2, 3);
		* 			var property:Property = new Property(this, "myArray", "", "myTestArray");
		* 			property.addEventListener(Event.COMPLETE, propertyCompleteHandler));
		* 			property.create();
		* 		}
		* 		
		* 		function propertyCompleteHandler(event:Event):void {
		* 			trace(myArray);
		* 			// outputs 1, 2, 3
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
		* @param value - The path to the relayed property.
		*/
		public function Property(scope:Object, name:String, target:String, value:String) {
			super(scope);
			this.name = name;
			this.target = target;
			this.value = value;
		}
		
		/**
		* Parses an xml object into a Property object.
		* <p/>
		* The xml object must be formatted like this:
		* <listing>
		* &lt;Property name="myArray" target=""&gt;myTestArray&lt;/Boolean&gt;
		* </listing>
		* @param scope - The scope used to evaluate bindings.
		* @param xml - The xml object defining the Property.
		*/
		public static function fromXML(scope:Object, xml:XML):Property {
			return new Property(scope, xml.@name, xml.@target, xml.toString());
		}
		
		public override function create():void {
			var name:String = parseString(this.name);
			var target:Object = findTarget(parseString(this.target));
			target[name] = findTarget(parseString(value));
			complete();
		}
		
		public override function toString():String {
			return "[Property name=" + name + " target=" + target +  " value=" + value + "]";
		}
		
	}
	
}