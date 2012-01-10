package com.blitzagency.fabric.assets {
	
	/*
	 * @author Patrick Matte
	 * @since 1.0 02/18/2009
	 * @version 1.0 02/18/2009
	 * 
	 * @modified Yosef Flomin
	 * @revision 1.2 2010/04/30
	*/
	
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.media.SoundTransform;
    import flash.net.NetConnection;
    import flash.net.NetStream;
	import flash.events.Event;
	import flash.events.NetStatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.AsyncErrorEvent;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.utils.setTimeout;

	/**
	* NetStreamPreloader loads a NetStream object.
	*/
	public class NetStreamPreloader extends Asset {
		
		public var name:String;
		public var target:String;
		public var url:String;
		public var checkPolicyFile:String;
		public var buffer:Number;
		
		private var connection:NetConnection;
		private var timer:Timer;
		private var netStream:NetStream;
		
		/**
		* Creates a new NetStreamPreloader.
		* <listing>
		* package {
		* 
		* 	import flash.display.MovieClip;
		* 	import com.blitzagency.fabric.assets.NetStreamPreloader;
		*	import flash.media.SoundTransform;
		*	import flash.media.Video;
		*	import flash.net.NetStream;
		* 
		* 	public class Main extends MovieClip {
		* 		
		* 		private var video:Video = new Video(640, 480);
		* 		private var _netStream:NetStream;
		* 
		* 		public function Main(){
		* 			addChild(video);
		* 			var netStreamPreloader:NetStreamPreloader = new NetStreamPreloader(this, "myNetStream", "", "myVideo.flv", "false", 1);
		* 			netStreamPreloader.addEventListener(Event.COMPLETE, netStreamPreloaderCompleteHandler));
		* 			netStreamPreloader.create();
		* 		}
		* 
		* 		public function set myNetStream(value:NetStream):void {
		* 			_netStream = value;
		* 			_netStream.client = this;
		* 			_netStream.soundTransform = new SoundTransform(0);
		* 			video.attachNetStream(_netStream);
		* 		}
		* 		
		*		public function onMetaData(obj:Object):void {
		*			_netStream.pause();
		*		}
		*		
		* 		function netStreamPreloaderCompleteHandler(event:Event):void {
		* 			trace(myNetStream);
		* 			// outputs [NetStream]
		*			_netStream.soundTransform = new SoundTransform(1);
		*			_netStream.resume();
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
		* @param url - The url to the image or swf.
		* @param checkPolicyFile - A Boolean to check for a cross-domain policy file.
		* @param buffer - A Number from 0 to 1. specifies how much of the video you want to preload.
		*/
		public function NetStreamPreloader(scope:Object, name:String, target:String, url:String, checkPolicyFile:String = "false", buffer:Number = 1, weight:int = 1) {
			super(scope);
			this.name = name;
			this.target = target;
			this.url = url;
			this.checkPolicyFile = checkPolicyFile;
			this.buffer = buffer;
			this.weight = weight ? weight : 1;
			progressive = true;
			timer = new Timer(33);
			timer.addEventListener(TimerEvent.TIMER, timerInterval);
		} //@r1.2
		
		/**
		* Parses an xml object into a NetStreamPreloader object.<br/>
		* The xml object must be formatted like this:
		* <listing>
		* &lt;NetStream name="myNetStream" target="" url="{assets}vidoes/myVideo.flv" checkPolicyFile="false" buffer="0.5"/&gt;
		* </listing>
		* 
		* @param scope - The scope used to evaluate bindings.
		* @param xml - The xml object defining the NetStreamPreloader.
		*/
		public static function fromXML(scope:Object, xml:XML):NetStreamPreloader {
			var buffer:Number = 1;
			if (xml.@buffer.length() > 0) {
				buffer = Number(xml.@buffer);
			}
			return new NetStreamPreloader(scope, xml.@name, xml.@target, xml.@url, xml.@checkPolicyFile, buffer, xml.@weight);;
		} //@r1.2
		
		public override function create():void{
			_progress = 0;
			connection = new NetConnection();
			connection.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
			connection.connect(null);
		}
		
		private function netStatusHandler(event:NetStatusEvent):void {
			trace("netStatusHandler = " + event.info.code);
			switch (event.info.code) {
				case "NetConnection.Connect.Success":
					connectStream();
				break;
				case "NetStream.Play.Start":
					//trace("NetStream.Play.Start");
				break;
				case "NetStream.Play.StreamNotFound":
					trace(this);
				break;
			}
		}
		
       private function connectStream():void {
			var url:String = parseString(this.url);
			var checkPolicyFile:Boolean = Boolean(parseString(this.checkPolicyFile) == "true");
			
			netStream = new NetStream(connection);
			
			var target:Object = findTarget(parseString(this.target));
			var name:String = parseString(this.name);
			target[name] = netStream;
			
			netStream.addEventListener(AsyncErrorEvent.ASYNC_ERROR, asynErrorHandler);
			netStream.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
			netStream.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			netStream.checkPolicyFile = checkPolicyFile;
            netStream.play(url);
			
 			connection.close();
			connection = null;
			timer.start();
       }
	   
	   private function ioErrorHandler(event:IOErrorEvent):void {
		   trace("NetStreamPreloader " + event);
	   }
		
		private function asynErrorHandler(event:AsyncErrorEvent):void {
			trace("NetStreamPreloader " + event);
		}
		
		private function timerInterval(event:TimerEvent):void {
			checkLoading();
		}
		
		private function checkLoading():void {
			_progress = netStream.bytesLoaded / netStream.bytesTotal;
			if (progress >= buffer) {
				timer.stop();
				setTimeout(complete, 250);
			}
		}
		
		override protected function complete():void {
			netStream.removeEventListener(AsyncErrorEvent.ASYNC_ERROR, asynErrorHandler);
			netStream.removeEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
			netStream.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			netStream = null;
			super.complete();
		}
		
		public override function toString():String {
			return "[NetStreamPreloader name=" + name + " target=" + target + " url=" + url + "]";
		}
		
	}
	
}