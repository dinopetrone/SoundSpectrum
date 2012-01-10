package com.blitzagency.fabric.assets {
	
	/*
	 * @author Patrick Matte
	 * @since 1.0 02/18/2009
	 * @version 1.0 02/18/2009
	*/
	
	/**
	* BooleanProperty creates a Boolean from a string.
	*/
	public class BooleanProperty extends Property {
		
		/**
		* Creates a new BooleanProperty.
		* <listing>
		* package {
		* 
		* 	import flash.display.MovieClip;
		* 	import com.blitzagency.fabric.assets.BooleanProperty;
		* 
		* 	public class Main extends MovieClip {
		* 		
		* 		var myBoolean:Boolean;
		* 
		* 		public function Main(){
		* 			var booleanProperty:BooleanProperty = new BooleanProperty(this, "myBoolean", "", "true");
		* 			booleanProperty.addEventListener(Event.COMPLETE, booleanPropertyCompleteHandler));
		* 			booleanProperty.create();
		* 		}
		* 		
		* 		function booleanPropertyCompleteHandler(event:Event):void {
		* 			trace(myBoolean);
		* 			// outputs true
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
		public function BooleanProperty(scope:Object, name:String, target:String, value:String) {
			super(scope, name, target, value);
		}
		
		/**
		* Parses an xml object into a BooleanProperty object.<br/>
		* The xml object must be formatted like this:
		* <listing>
		* &lt;Boolean name="myBoolean" target=""&gt;true&lt;/Boolean&gt;
		* </listing>
		* @param scope - The scope used to evaluate bindings.
		* @param xml - The xml object defining the BooleanProperty.
		*/
		public static function fromXML(scope:Object, xml:XML):BooleanProperty {
			return new BooleanProperty(scope, xml.@name, xml.@target, xml.toString());
		}
		
		public override function create():void {
			var name:String = parseString(this.name);
			var target:Object = findTarget(parseString(this.target));
			target[name] = Boolean(parseString(value) == "true");
			complete();
		}
		
		public override function toString():String {
			return "[BooleanProperty name=" + name + " target=" +target +  " value=" + value + "]";
		}
		
	}
	
}