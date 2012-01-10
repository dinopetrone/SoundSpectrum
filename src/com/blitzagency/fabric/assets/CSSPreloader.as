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
	import flash.text.StyleSheet;

	/**
	* CSSPreloader loads an external .css file and converts it to an actionscript StyleSheet.
	*/
	public class CSSPreloader extends URLLoaderPreloader {
		
		/**
		* Creates a new CSSPreloader.
		* <listing>
		* package {
		* 
		* 	import flash.text.StyleSheet;
		* 	import com.blitzagency.fabric.assets.CSSPreloader;
		* 
		* 	public class Main extends MovieClip {
		* 		
		* 		public var style:StyleSheet;
		* 	
		* 		public function Main(){
		* 			var cssPreloader:CSSPreloader = new CSSPreloader(this, "myStyle", "", "css/style.css");
		* 			cssPreloader.addEventListener(Event.COMPLETE, cssCompleteHandler));
		* 			cssPreloader.create();
		* 		}
		* 	
		* 		function cssCompleteHandler(event:Event):void {
		* 			trace(style);
		* 			// outputs [StyleSheet]
		* 		}
		* 
		* 	}
		* 
		* }
		* </listing>
		* @param scope - The object from which the targetpaths and bindings are evaluated.
		* @param name - The name of the property.
		* @param url - The url to the .css file.
		*/
		public function CSSPreloader(scope:Object, name:String, target:String, url:String, weight:int = 1) {
			super(scope, name, target, url, URLLoaderDataFormat.TEXT, weight);
		} //@r1.2
		
		/**
		* Parses an xml object into a CSSPreloader object.<br/>
		* The xml object must be formatted like this:
		* <listing>
		* &lt;CSS name="myStyle" target="" url="css/style.css"/&gt;
		* </listing>
		* @param scope - The scope used to evaluate bindings.
		* @param xml - The xml object defining the CSSPreloader.
		*/
		public static function fromXML(scope:Object, xml:XML):CSSPreloader {
			return new CSSPreloader(scope, xml.@name, xml.@target, xml.@url, xml.@weight);
		} //@r1.2
		
		override protected function setProperty():void {
			var name:String = parseString(this.name);
			var target:Object = findTarget(parseString(this.target));
			var styleSheet:StyleSheet = new StyleSheet();
			styleSheet.parseCSS(urlLoader.data);
			target[name] = styleSheet;
		}
		
		public override function toString():String {
			return "[CSSPreloader name=" + name + " target=" + target + "  url=" +  url + "]";
		}
		
	}
	
}