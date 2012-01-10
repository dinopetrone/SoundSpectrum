package com.blitzagency.fabric.assets {
	
	/*
	 * @author Patrick Matte
	 * @since 1.0 02/18/2009
	 * @version 1.0 02/18/2009
	*/
	
	/**
	* XMLListProperty creates an actionscript XMLList from a string.
	*/
	public class XMLListProperty extends Property {
		
		/**
		* Creates a new XMLListProperty.
		* <listing>
		* package {
		* 
		* 	import flash.display.MovieClip;
		* 	import com.blitzagency.fabric.assets.XMLListProperty;
		* 
		* 	public class Main extends MovieClip {
		* 		
		* 		var myArray:Array;
		* 
		* 		public function Main(){
		* 			var myXMLList:XMLList;
		* 			var xmlListProperty:XMLListProperty = new XMLListProperty(this, "myXMLList", "", "<one>1</one><two>2</two><three>3</three>");
		* 			xmlListProperty.addEventListener(Event.COMPLETE, xmlListPropertyCompleteHandler));
		* 			xmlListProperty.create();
		* 		}
		* 		
		* 		function xmlListPropertyCompleteHandler(event:Event):void {
		* 			trace(myXMLList);
		* 			// outputs <one>1</one><two>2</two><three>3</three>
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
		* @param value - the xmlList string.
		*/
		public function XMLListProperty(scope:Object, name:String, target:String, value:String) {
			super(scope, name, target, value);
		}
		
		/**
		* Parses an xml object into a XMLListProperty object.
		* <p/>
		* The xml object must be formatted like this:
		* <listing>
		* &lt;XMLList name="myXMLList" target=""&gt;
		* 	&lt;one&gt;1&lt;/one&gt;
		* 	&lt;two&gt;2&lt;/two&gt;
		* 	&lt;three&gt;3&lt;/three&gt;
		* &lt;/XMLList&gt;
		* </listing>
		* 
		* @param scope - The scope used to evaluate bindings.
		* @param xml - The xml object defining the XMLListProperty.
		*/
		public static function fromXML(scope:Object, xml:XML):XMLListProperty {
			return new XMLListProperty(scope, xml.@name, xml.@target, xml.elements("*").toString());
		}
		
		public override function create():void {
			var name:String = parseString(this.name);
			var target:Object = findTarget(parseString(this.target));
			target[name] = XMLList(parseString(value));
			complete();
		}
		
		public override function toString():String {
			return "[XMLListProperty name=" + name + " target=" + target + "]";
		}
		
	}
	
}