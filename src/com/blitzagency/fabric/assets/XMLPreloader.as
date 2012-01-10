package com.blitzagency.fabric.assets {
	
	/*
	 * @author Patrick Matte
	 * @since 1.0 02/18/2009
	 * @version 1.0 02/18/2009
	 * 
	 * @modified Yosef Flomin
	 * @revision 1.2 2010/04/30
	*/
	
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;

	/**
	* XMLPreloader loads an external xml file.
	*/
	public class XMLPreloader extends URLLoaderPreloader {
		
		/**
		* Creates a new XMLPreloader.
		* <listing>
		* package {
		* 
		* 	import flash.display.MovieClip;
		* 	import com.blitzagency.fabric.assets.XMLPreloader;
		* 
		* 	public class Main extends MovieClip {
		* 		
		* 		var myXML:XML;
		* 
		* 		public function Main(){
		* 			var xmlPreloader:XMLPreloader = new XMLPreloader(this, "myXML", "", "myData.xml");
		* 			xmlPreloader.addEventListener(Event.COMPLETE, xmlPreloaderCompleteHandler));
		* 			xmlPreloader.create();
		* 		}
		* 		
		* 		function xmlPreloaderCompleteHandler(event:Event):void {
		* 			trace(myXML);
		* 			// outputs the xml object from the external file
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
		* @param url - The url to the external xml file.
		*/
		public function XMLPreloader(scope:Object, name:String, target:String, url:String, weight:int = 1) {
			super(scope, name, target, url, URLLoaderDataFormat.TEXT, weight);
		} //@r1.2
		
		/**
		* Parses an xml object into an XMLPreloader.
		* <p/>
		* The xml object must be formatted like this:
		* <listing>
		* &lt;XMLLoader name="myXML" target="" url="myData.xml"/&gt;
		* </listing>
		* 
		* @param scope - The scope used to evaluate bindings.
		* @param xml - The xml object defining the XMLPreloader.
		*/
		public static function fromXML(scope:Object, xml:XML):XMLPreloader {
			return new XMLPreloader(scope, xml.@name, xml.@target, xml.@url, xml.@weight);;
		} //@r1.2
		
		override protected function setProperty():void {
			var name:String = parseString(this.name);
			var target:Object = findTarget(parseString(this.target));
			target[name] = XML(urlLoader.data);
		}
		
		public override function toString():String {
			return "[XMLPreloader name=" + name + " target=" + target + "  url=" +  url + "]";
		}
		
	}
	
}