package com.blitzagency.fabric.assets {
	
	/*
	 * @author Patrick Matte
	 * @since 1.0 02/18/2009
	 * @version 1.0 02/18/2009
	*/
	
	/**
	* NumberProperty creates a Number from a string.
	*/
	public class NumberProperty extends Property {
		
		/**
		* Creates a new NumberProperty.
		* <listing>
		* package {
		* 
		* 	import flash.display.MovieClip;
		* 	import com.blitzagency.fabric.assets.NumberProperty;
		* 
		* 	public class Main extends MovieClip {
		* 		
		* 		var myNumber:Number;
		* 
		* 		public function Main(){
		* 			var numberProperty:NumberProperty = new NumberProperty(this, "myNumber", "", "3");
		* 			numberProperty.addEventListener(Event.COMPLETE, numberPropertyCompleteHandler));
		* 			numberProperty.create();
		* 		}
		* 		
		* 		function numberPropertyCompleteHandler(event:Event):void {
		* 			trace(myNumber);
		* 			// outputs 3
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
		* @param value - A String Number.
		*/
		public function NumberProperty(scope:Object, name:String, target:String, value:String) {
			super(scope, name, target, value);
		}
		
		/**
		* Parses an xml object into a BooleanProperty object.<br/>
		* The xml object must be formatted like this:
		* <listing>
		* &lt;Number name="myNumber" target=""&gt;5&lt;/Number&gt;
		* </listing>
		* 
		* @param scope - The scope used to evaluate bindings.
		* @param xml - The xml object defining the NumberProperty.
		*/
		public static function fromXML(scope:Object, xml:XML):NumberProperty {
			return new NumberProperty(scope, xml.@name, xml.@target, xml.toString());
		}
		
		public override function create():void {
			var name:String = parseString(this.name);
			var target:Object = findTarget(parseString(this.target));
			target[name] = Number(parseString(value));
			complete();
		}
		
		public override function toString():String {
			return "[NumberProperty name=" + name + " target=" + target +  " value=" + value + "]";
		}
		
	}
	
}