package com.blitzagency.utils
{
	public class XMLToAS
	{
		/* A utility class for mapping xml nodes to custom actionscript types */
		
		/**
		 * 
		 * Map the node values of xml to the properties of object with the same name.
		 * If xml has child nodes, 
		 * 
		 * @param object
		 * @param xml
		 * @param recursive Specifies whether to auto-map sub-nodes to other Actionscript types
		 * using XMLAlias()
		 * 
		 */		
		public static function map( object:Object, xml:XML, recursive:Boolean=true ):void
		{
			
			var nodeName:String = xml.name();
			
			if ( object.hasOwnProperty( nodeName ) ){				
				if ( recursive ){
					if ( xml.children().length() > 1 ){
						//This is probably an Array
						object[nodeName] = arrayFromXML(xml);
					} else{
						object[nodeName] = fromXML( xml );	
					}									
				} else {				
					object[nodeName] = xml;					
				}
				
			} else {
				//trace("public var "+nodeName+":String;");
				trace("[XMLToVO] public property :"+nodeName+" not found on "+object);
			}	
		
		}
		
		/**
		 * This method will take an XML node and optional returnType 
		 * and return an instance of the returnType populated with data
		 * from xml.<br>
		 * If a returnType is not passed, XMLAlias.getClassByAlias is used.<br>
		 * Finally, if an alias has not been registered or if the xml 
		 * represents a native type (such as Integer or String) it will return
		 * xml.toString().
		 * 
		 * @param xml Root or terminal XML node to map to Object
		 * @param returnType Class type to instantiate and populate with XML values
		 * @return A Object of returnType Class
		 * 
		 */		
		public static function fromXML(xml:XML,returnType:Class=null):*
		{
			
			var nodeName:String = xml.localName();
			
			if ( ! returnType ){
				if ( XMLAlias.hasClassAlias( nodeName ) ){
					returnType = XMLAlias.getClassByAlias(nodeName);
				} else {
					//Probably a terminal node (and so a native type) or unmapped type
					return xml.toString();
				}			
			}
			
			var objInstance:Object = new returnType();			
			for ( var i:int=0; i < xml.children().length(); i ++ ){
				map( objInstance, xml.children()[i] );
			}
						
			var attributes:XMLList=xml.@*;
			for ( var a:int=0; a<attributes.length(); a++){
				map( objInstance, attributes[a] );
			}
			
			return objInstance;
			
		}
		
		/**
		 * Returns an Array of custom types from an XML tree. If a returnType is not
		 * specified, XMLAlias.getClassByAlias() is used to look up the appropriate
		 * Class for each xml node.
		 * 
		 * @param xml Root or terminal XML node to map to Object
		 * @param returnType Class type to instantiate and populate with XML values
		 * @return Pre-populated instance of returnType Class
		 * @return An Array of Pre-populated Objects instances.
		 * 
		 */
		public static function arrayFromXML(xml:*,returnType:Class=null,nodeName:String=null):Array
		{
			var array:Array = new Array();
			for ( var i:int=0; i < xml.children().length(); i ++ ){
				if ( ! nodeName || ( xml.children()[i].name() == nodeName )  ){
					array.push( fromXML( xml.children()[i], returnType ) );				
				}			
			}			
			return array;
			
		}

	}
}