package com.blitzagency.fabric.assets {
	
	/*
	 * @author Patrick Matte
	 * @since 1.0 02/18/2009
	 * @version 1.0 02/18/2009
	*/
	
	/**
	* XMLProperty creates an actionscript XML from a string.
	*/
	public class XMLProperty extends Property {
		
		/**
		* Creates a new XMLProperty.
		* <listing>
		* package {
		* 
		* 	import flash.display.MovieClip;
		* 	import com.blitzagency.fabric.assets.XMLProperty;
		* 
		* 	public class Main extends MovieClip {
		* 		
		* 		var myArray:Array;
		* 
		* 		public function Main(){
		* 			var myXML:XML;
		* 			var xmlProperty:XMLProperty = new XMLProperty(this, "myXML", "", "<number><one>1</one><two>2</two><three>3</three></number>");
		* 			xmlProperty.addEventListener(Event.COMPLETE, xmlPropertyCompleteHandler));
		* 			xmlProperty.create();
		* 		}
		* 		
		* 		function xmlPropertyCompleteHandler(event:Event):void {
		* 			trace(myXML);
		* 			// outputs <number><one>1</one><two>2</two><three>3</three></number>
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
		* @param value - the xml string.
		*/
		public function XMLProperty(scope:Object, name:String, target:String, value:String) {
			super(scope, name, target, value);
		}
		
		/**
		* Parses an xml object into a XMLProperty object.
		* <p/>
		* The xml object must be formatted like this:
		* <listing>
		* &lt;XML name="myXML" target=""&gt;
		* 	&lt;numbers&gt;
		* 		&lt;one&gt;1&lt;/one&gt;
		* 		&lt;two&gt;2&lt;/two&gt;
		* 		&lt;three&gt;3&lt;/three&gt;
		* 	&lt;/numbers&gt;
		* &lt;/XML&gt;
		* </listing>
		* 
		* @param scope - The scope used to evaluate bindings.
		* @param xml - The xml object defining the XMLProperty.
		*/
		public static function fromXML(scope:Object, xml:XML):XMLProperty {
			return new XMLProperty(scope, xml.@name, xml.@target, xml.elements("*").toString());
		}
		
		public override function create():void {
			var name:String = parseString(this.name);
			var target:Object = findTarget(parseString(this.target));
			target[name] = XML(parseString(value));
			complete();
		}
		
		public override function toString():String {
			return "[XMLProperty name=" + name + " target=" + target + "]";
		}
		
	}
	
}