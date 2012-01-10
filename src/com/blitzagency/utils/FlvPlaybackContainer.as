package com.blitzagency.utils 
{
	import com.blitzagency.ui.UIMovieClip;
	import fl.video.FLVPlayback;
	import fl.video.LayoutEvent;
	import fl.video.MetadataEvent;
	import fl.video.SoundEvent;
	import fl.video.VideoEvent;
	import fl.video.VideoProgressEvent;
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public class FlvPlaybackContainer extends UIMovieClip
	{
		public static const PLAYING    :String = "playing";
		public static const PAUSED     :String = "paused";
		public static const STOPPED    :String = "stopped";
		
		public var flvIndex            :uint;
		public var currentState        :String;
		
		public var autoPlay            :Boolean = false;
		public var paused              :Boolean = false;
		public var playing             :Boolean = false;
		public var stopped             :Boolean = false;
		public var flvOnStage          :FLVPlayback;
		
		public var seekBar             :MovieClip;
		public var bufferingBar        :MovieClip;
		
		private var _source            :String;
		
		// These are used to relay and store any properties to flpOnStage.
		private var _propsRelay        :Object = {};
		
		public function FlvPlaybackContainer() 
		{
			super();
		}
		
		public function set source( url:String ):void
		{
			_source = url;
			setCurrentState( STOPPED );
				
			if ( autoPlay ) {
				playVideo();
			}
		}
		
		public function playVideo():void
		{
			if ( !source ) { return; }
			if ( paused ) 
			{
				setProperties(flvOnStage);
				flvOnStage.play();
				setCurrentState( PLAYING );
				return;
			}
			
			killLastPlaybackInstance();
			
			flvOnStage = new FLVPlayback();
			flvOnStage.width = width;
			flvOnStage.height = height;
			
			flvIndex = flvOnStage.activeVideoPlayerIndex;
			
			setListeners( flvOnStage, true );
			setProperties( flvOnStage );
			setControls( flvOnStage );
			
			addChild( flvOnStage );
			
			flvOnStage.play(source);
			setCurrentState( PLAYING );
		}
		
		public function stopVideo():void
		{
			if ( !source ) { return; }
			killLastPlaybackInstance();
			setCurrentState( STOPPED );
		}
		
		public function pauseVideo():void
		{
			if ( !source ) { return; }
			try 
			{
				flvOnStage.pause();
				propsRelay.playheadPercentage = flvOnStage.playheadPercentage;
			} catch ( e:Error ) { };
			
			setCurrentState( PAUSED );
		}
		
		public function seekPercent( value:Number ):void
		{
			if ( !source || !flvOnStage ) { return; }
			flvOnStage.seekPercent( value * 100 );
		}
		
		private function setListeners( fp:FLVPlayback, add:Boolean ):void
		{
			var method:Function = add ? fp.addEventListener : fp.removeEventListener;
			
			method( VideoEvent.AUTO_REWOUND            , flvDispatchedEvent );
			method( VideoEvent.BUFFERING_STATE_ENTERED , flvDispatchedEvent );
			method( VideoEvent.CLOSE                   , flvDispatchedEvent );
			method( VideoEvent.COMPLETE                , flvDispatchedEvent );
			method( VideoEvent.FAST_FORWARD            , flvDispatchedEvent );
			method( VideoEvent.PAUSED_STATE_ENTERED    , flvDispatchedEvent );
			method( VideoEvent.PLAYHEAD_UPDATE         , flvDispatchedEvent );
			method( VideoEvent.PLAYING_STATE_ENTERED   , flvDispatchedEvent );
			method( VideoEvent.READY                   , flvDispatchedEvent );
			method( VideoEvent.REWIND                  , flvDispatchedEvent );
			method( VideoEvent.SCRUB_FINISH            , flvDispatchedEvent );
			method( VideoEvent.SCRUB_START             , flvDispatchedEvent );
			method( VideoEvent.SEEKED                  , flvDispatchedEvent );
			method( VideoEvent.SKIN_LOADED             , flvDispatchedEvent );
			method( VideoEvent.STATE_CHANGE            , flvDispatchedEvent );
			method( VideoEvent.STOPPED_STATE_ENTERED   , flvDispatchedEvent );
			method( VideoEvent.SCRUB_START             , flvDispatchedEvent );
			method( VideoProgressEvent.PROGRESS        , flvDispatchedEvent );
			method( MetadataEvent.CUE_POINT            , flvDispatchedEvent );
			method( MetadataEvent.METADATA_RECEIVED    , flvDispatchedEvent );
			method( LayoutEvent.LAYOUT                 , flvDispatchedEvent );
			method( SoundEvent.SOUND_UPDATE            , flvDispatchedEvent );
		}
		
		private function setProperties( fp:FLVPlayback ):void
		{
			for ( var prop:String in propsRelay ) {
				try {
					fp[ prop ] = propsRelay[ prop ];
				} catch ( e:Error ) {
					trace( "<" + prop + "> property does not exist on FlvPlayback." )
				}
			}
		}
		
		private function setControls( fp:FLVPlayback ):void
		{
			if ( seekBar      ) { fp.seekBar      = seekBar      };
			if ( bufferingBar ) { fp.bufferingBar = bufferingBar };
		}
		
		private function flvDispatchedEvent( event:Event ):void 
		{
			dispatchEvent( event );
		}
		
		private function killLastPlaybackInstance():void
		{
			if ( flvOnStage ) {
				setListeners( flvOnStage, false );
				
				try {
					flvOnStage.stop();
				} catch ( e:Error ) { };
				
				flvOnStage.getVideoPlayer( flvIndex ).close();
				removeChild( flvOnStage );
				flvOnStage = null;
			}
		}
		
		private function setCurrentState( state:String ):void
		{
			currentState = state;
			playing = paused = stopped = false; 
			
			switch ( state ) {
				case PLAYING: playing = true; break;
				case PAUSED : paused  = true; break;
				case STOPPED: stopped = true; break;
			}
		}
		
		public function get source():String { return _source; }
		
		public function get propsRelay():Object { return _propsRelay; }
		
		public function set propsRelay(value:Object):void 
		{
			_propsRelay = value;
			if (flvOnStage) setProperties(flvOnStage);
		}
	}
}