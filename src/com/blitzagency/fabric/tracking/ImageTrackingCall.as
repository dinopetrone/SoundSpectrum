package com.blitzagency.fabric.tracking {
	
	/*
	 * @author Patrick Matte
	 * @since 1.0 02/18/2009
	 * @version 1.0 02/18/2009
	*/
	
	import flash.display.Loader;
	import flash.events.Event;
	import flash.net.URLRequest;
	
	/**
	* ImageTrackingCall is a tracking call that loads an image.
	*/
	public class ImageTrackingCall extends TrackingCall {
		
		public var url:String;
		public var loader:Loader;
		
		/**
		* Creates a new ImageTrackingCall.
		* 
		* @param name - The name of the tracking call.
		* @param url - The url of the image to load.
		*/
		public function ImageTrackingCall(name:String = null, url:String = null) {
			super(name);
			this.url = url;
		}
		
		/**
		* Parses an xml object into an ImageTrackingCall.
		* <p/>
		* The xml object must be formatted like this:
		* <listing>
		* <ImageCall name="EnterSite">
		* 	<url>http://ad.doubleclick.net/ad/N3880.FXNetworks.com/B3445621.7;dcove=o;sz=1x1;ord=[timestamp]?</url>
		* </ImageCall>
		* </listing>
		* 
		* @param xml - The xml object defining the ImageTrackingCall.
		*/
		public static function fromXML(xml:XML):ImageTrackingCall {
			var name:String = xml.@name;
			var url:String = xml.url[0].toString();
			var call:ImageTrackingCall = new ImageTrackingCall(name, url);
			return call;
		}
		
		override public function create(replace:String = ""):void {
			loader = new Loader()
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loaderComplete);
			loader.load(new URLRequest(url));
		}
		
		protected function loaderComplete(event:Event):void {
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, loaderComplete);
			loader.unload();
			loader = null;
		}
		
		public function toString():String {
			return "[ImageTrackingCall name=" + name + " url=" + url + "]";
		}
		
	}
	
}