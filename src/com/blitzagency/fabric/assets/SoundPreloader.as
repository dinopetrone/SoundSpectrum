package com.blitzagency.fabric.assets {
	
	/*
	 * @author Patrick Matte
	 * @since 1.0 02/18/2009
	 * @version 1.0 02/18/2009
	 * 
	 * @modified Yosef Flomin
	 * @revision 1.2 2010/04/30
	*/
	
    import flash.media.Sound;
    import flash.net.URLRequest;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.media.Sound;
	
	/**
	* SoundPreloader loads an external sound file into an actionscript object.
	*/
	public class SoundPreloader extends Asset {
		
		public var name:String;
		public var target:String;
		public var url:String;
		
		/**
		* Creates a new SoundPreloader.
		* <listing>
		* package {
		* 
		* 	import flash.display.MovieClip;
		* 	import com.blitzagency.fabric.assets.SoundPreloader;
		* 
		* 	public class Main extends MovieClip {
		* 		
		* 		var mySound:Sound;
		* 
		* 		public function Main(){
		* 			var soundPreloader:SoundPreloader = new SoundPreloader(this, "mySound", "sounds/mySound.mp3");
		* 			soundPreloader.addEventListener(Event.COMPLETE, soundPreloaderCompleteHandler));
		* 			soundPreloader.create();
		* 		}
		* 		
		* 		function soundPreloaderCompleteHandler(event:Event):void {
		* 			trace(mySound);
		* 			// outputs [Sound]
		* 		}
		* 	
		* 	}
		* 
		* }
		* </listing>
		* 
		* @param scope - The object from which the targetpaths and bindings are evaluated.
		* @param name - The name of the sound.
		* @param target - The path to the sound container.
		* @param url - The url to the external sound file.
		*/
		public function SoundPreloader(scope:Object, name:String, target:String, url:String, weight:int = 1) {
			super(scope);
			this.name = name;
			this.target = target;
			this.url = url;
			this.weight = weight ? weight : 1;
			progressive = true;
		} //@r1.2
		
		/**
		* Parses an xml object into a SoundPreloader.
		* <p/>
		* The xml object must be formatted like this:
		* <listing>
		* &lt;Sound name="mySound" target="" url="sounds/mySound.mp3"&gt;
		* </listing>
		* 
		* @param scope - The scope used to evaluate bindings.
		* @param xml - The xml object defining the SoundPreloader.
		*/
		public static function fromXML(scope:Object, xml:XML):SoundPreloader {
			return new SoundPreloader(scope, xml.@name, xml.@target, xml.@url, xml.@weight);;
		} //@r1.2
		
		public override function create():void {
			_progress = 0;
			var urlRequest:URLRequest = new URLRequest(parseString(url));
			var sound:Sound = new Sound();
			
			var target:Object = findTarget(parseString(this.target));
			var name:String = parseString(this.name);
			target[name] = sound;
			
			sound.addEventListener(Event.COMPLETE, completeHandler);
			sound.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			sound.addEventListener(ProgressEvent.PROGRESS, progressHandler);
			sound.load(urlRequest);
		}
		
		private function completeHandler(event:Event):void {
			var sound:Sound = event.target as Sound;
			sound.removeEventListener(Event.COMPLETE, completeHandler);
			sound.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			sound.removeEventListener(ProgressEvent.PROGRESS, progressHandler);
			
			complete();
		}
		
		private function ioErrorHandler(event:Event):void {
			trace("ioErrorHandler: " + event);
		}
		
		private function progressHandler(event:ProgressEvent):void {
			_progress = event.bytesLoaded / event.bytesTotal;
		}
		
		public override function toString():String {
			return "[SoundPreloader name=" + name + " target=" + target + "]";
		}
		
	}
	
}