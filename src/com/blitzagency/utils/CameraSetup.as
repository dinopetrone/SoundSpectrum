package com.blitzagency.utils 
{
	import com.blitzagency.ui.EventDispatcherBase;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.PixelSnapping;
	import flash.display.Sprite;
	import flash.events.ActivityEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.geom.Matrix;
	import flash.media.Camera;
	import flash.media.Video;
	import flash.system.Security;
	import flash.system.SecurityPanel;
	import flash.utils.Timer;

	public class CameraSetup extends EventDispatcherBase
	{
		public static const CAMERA_INITIALIZED :String = "cameraInitialized";
		public static var CAMERA_WARNING_DELAY :Number = 7000;
		
		[Public]
		public var camera           :Camera;
		
		[Private]
		private var checkCamTimer   :Timer;
		private var isVideoAdded    :Boolean = false;
		private var videoContainer  :Sprite;
		private var captureMatrix   :Matrix;
		
		[Getters_Setters]
		private var _video          :Video;
		private var _width          :Number;
		private var _height         :Number;
		private var _scale          :Number;
		private var _cameraFPS      :int = 12;
		private var _capture        :Bitmap;
		
		[Stage]
		
		public function CameraSetup( width:Number = 320, height:Number = 240, scale:Number = 1 )
		{
			_width  = width; 
			_height = height;
			_scale  = scale;
			
			init();
		}
		
		protected function init():void 
		{
			var index:int = 0;
			for ( var i:int = 0 ; i < Camera.names.length; i++ ) 
			{
				if ( Camera.names[ i ] == "USB Video Class Video" ) 
				{
					index = i;
				}
			}
			
			captureMatrix = new Matrix(scale, 0, 0, scale);
			_capture = new Bitmap( new BitmapData( width * scale, height * scale, false ) );
			
			camera = Camera.getCamera( String( index ) );
			camera.setMode( width, height, cameraFPS );
			
			checkCamTimer = new Timer( CAMERA_WARNING_DELAY );
			checkCamTimer.addEventListener( TimerEvent.TIMER, checkCamTimerTick );
			checkCamTimer.start();
            
			if ( camera != null ) 
			{
				isVideoAdded = true;
				videoContainer = new Sprite();
				
				_video = new Video( width, height );
				_video.attachCamera( camera );
				
				videoContainer.scaleX = videoContainer.scaleY = scale;
				videoContainer.addChild( _video );
				
				camera.addEventListener( ActivityEvent.ACTIVITY, cameraActivityHandler );
			}
			else return;
		}
		
		private function cameraActivityHandler( event:ActivityEvent ):void 
		{
			camera.removeEventListener( ActivityEvent.ACTIVITY, cameraActivityHandler );
			dispatchEvent( new Event( CAMERA_INITIALIZED ) );
		}
		
		private function checkCamTimerTick( event:TimerEvent ):void 
		{
			if ( camera.currentFPS != 0 )
			{
				checkCamTimer.stop();
				checkCamTimer.removeEventListener( TimerEvent.TIMER, checkCamTimerTick );
				checkCamTimer = null;
				
				if ( !isVideoAdded )
				{
					isVideoAdded = true;
					videoContainer = new Sprite();
					
					_video = new Video( width, height );
					_video.attachCamera( camera );
					
					videoContainer.scaleX = videoContainer.scaleY = scale;
					videoContainer.addChild( _video );
					
					camera.addEventListener( ActivityEvent.ACTIVITY, cameraActivityHandler );
				}
			} 
			else 
			{
				Security.showSettings( SecurityPanel.CAMERA );
			}
		}
		
		private function resetCameraMode():void
		{
			camera.setMode( width, height, cameraFPS );
		}
		
		public function set width( value:Number ):void 
		{
			_width = value;
			video.width = value;
			resetCameraMode()
		}
		
		public function set height( value:Number ):void 
		{
			_height = value;
			video.height = value;
			resetCameraMode()
		}
		
		public function set scale( value:Number ):void 
		{
			_scale = value;
			captureMatrix = new Matrix(scale, 0, 0, scale);
			video.scaleX = video.scaleY = value;
		}
		
		public function set cameraFPS( value:int ):void 
		{
			_cameraFPS = value;
			resetCameraMode()
		}
		
		public function get capture():Bitmap 
		{
			_capture.bitmapData.draw( video, captureMatrix );
			return _capture; 
		}
		
		public function get width()     :Number { return _width; }
		
		public function get height()    :Number { return _height; }
		
		public function get scale()     :Number { return _scale; }
		
		public function get cameraFPS() :int    { return _cameraFPS; }
		
		public function get video()     :Sprite { return videoContainer; }
		
		public function get rawVideo()  :Video  { return _video; }
		
	}
}