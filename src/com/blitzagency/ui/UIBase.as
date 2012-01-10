package com.blitzagency.ui
{
	import com.blitzagency.utils.destroy;
	import flash.display.MovieClip;
	import flash.utils.Dictionary;
	
	public class UIBase extends MovieClip
	{
		[Public]
		public var listeners :Dictionary = new Dictionary(true);
		
		[Private]
		
		[Getters_Setters]
		private var _onPixel :Boolean;
		
		[Stage]
		
		public function UIBase()
		{
			super();
		}
		
		override public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void 
		{
			listeners[listener] = { type:type, listener:listener, useCapture:useCapture, priority:priority, useWeakReference:useWeakReference };
			super.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		
		override public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void 
		{
			delete(listeners[listener]);
			super.removeEventListener(type, listener, useCapture);
		}
		
		public function removeAllListeners():void
		{
			for each( var listener:Object in listeners ) 
			{
				removeEventListener(listener.type, listener.listener, listener.useCapture);
			}
		}
		
		public function set onPixel(value:Boolean):void 
		{
			_onPixel = value;
			x = x;
			y = y;
		}
		
		override public function set x(value:Number):void 
		{
			_onPixel ? super.x = Math.round(value) : super.x = value;
		}
		
		override public function set y(value:Number):void 
		{
			_onPixel ? super.y = Math.round(value) : super.y = value;
		}
		
		public function destroy():void
		{
			removeAllListeners();
			listeners = null;
		}
		
		public function get onPixel():Boolean { return _onPixel; }
	}
}