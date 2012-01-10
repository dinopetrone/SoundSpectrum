package com.blitzagency.utils
{
	/*
	 * @author Yosef Flomin
	*/ 
	
	import application.howYouRover.model.HowYouRoverModel;
	import com.blitzagency.ui.UIBase;
	import com.blitzagency.utils.operationQue.OperationQue;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.system.Security;
	
	public class YouTubePlayer extends UIBase
	{
		public static const READY          :String = "onReady";
		public static const ERROR          :String = "onError";
		public static const STATE_CHANGE   :String = "onStateChange";
		public static const QUALITY_CHANGE :String = "onPlaybackQualityChange";
		
		public static const UNSTARTED      :int = -1;
		public static const ENDED          :int = 0;
		public static const PLAYING        :int = 1;
		public static const PAUSED         :int = 2;
		public static const BUFFERING      :int = 3;
		public static const QUEUED         :int = 5;
		
		[Public]
		public var isReady         :Boolean;
		public var isPlaying       :Boolean;
		public var player          :Object;
		public var state           :int;
		
		[Private]
		private var playerLoader   :Loader;
		private var chromeless     :Boolean;
		
		[Getters_Setters]
		private var _id            :String;
		
		[Stage]
		
		public function YouTubePlayer( chromeless:Boolean = false )
		{
			this.chromeless = chromeless;
			super();
			init();
		}
		
		protected function init():void 
		{
			visible = false;
			Security.allowDomain("*");
		}
		
		public function play(id:String = ""):void
		{
			_id = id;
			visible = false;
			
			if (!player) loadPlayer();
			else 
			{
				stop();
				playVideo();
			}
		}
		
		public function stop():void
		{
			if (player && isReady && isPlaying) 
			{
				player.stopVideo();
				isPlaying = false;
				visible = false;
			}
		}
		
		private function playVideo():void
		{
			visible = true;
			if (_id.indexOf("www.youtube.com") == -1)
			{
				player.loadVideoById(_id);
			}
			else
			{
				player.loadVideoByUrl(_id);
			}
			player.playVideo();
		}
		
		public function loadPlayer():void
		{
			playerLoader = new Loader();
			playerLoader.contentLoaderInfo.addEventListener(Event.INIT, initYouTubePlayer);
			playerLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, loaderError);
			if (chromeless) playerLoader.load(new URLRequest("http://www.youtube.com/apiplayer?version=3"));
			else playerLoader.load(new URLRequest("http://www.youtube.com/v/" + _id + "?version=3"));
		}
		
		public function setSize(width:Number, height:Number):void
		{
			player.setSize(width, height);
		}
		
		public function destroy():void
		{
			player.destroy();
			removeChild(playerLoader);
			playerLoader.unload();
		}
		
		private function initYouTubePlayer( event:Event ):void 
		{
			event.target.removeEventListener(Event.COMPLETE, initYouTubePlayer);
			addChild(playerLoader);
			
			playerLoader.content.addEventListener(READY, playerIsReady);
			playerLoader.content.addEventListener(ERROR, playerFailed);
			playerLoader.content.addEventListener(STATE_CHANGE, playerStateChanged);
			playerLoader.content.addEventListener(QUALITY_CHANGE, playerQualityChanged);
		}
		
		private function playerIsReady( event:Event ):void 
		{
			isReady = true;
			player  = playerLoader.content;
			
			if (height && width) 
			{
				setSize(width, height);
			}
			
			playVideo();
		}
		
		private function playerFailed( event:Event ):void 
		{
			dispatchEvent(event);
		}
		
		private function playerStateChanged( event:Event ):void 
		{
			state = Object(event).data;
			
			if (state == PLAYING) visible = true;
			isPlaying = (state == PLAYING)
			
			dispatchEvent(event);
		}
		
		private function playerQualityChanged( event:Event ):void 
		{
			dispatchEvent(event);
		}
		
		private function loaderError( event:IOErrorEvent ):void 
		{
			trace("YouTube player failed to load.. BOOOOOOOOO!!");
			dispatchEvent(event);
		}
	}
}