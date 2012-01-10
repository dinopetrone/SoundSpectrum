package com.blitzagency.ui
{
	import com.blitzagency.utils.destroy;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	
	public class EventDispatcherBase extends EventDispatcher
	{
		[Public]
		public var listeners:Dictionary = new Dictionary(true);
		
		[Private]
		
		[Getters_Setters]
		
		[Stage]
		
		public function EventDispatcherBase(target:IEventDispatcher = null)
		{
			super(target);
		}
		
		override public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = true):void 
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
		
		public function destroy():*
		{
			removeAllListeners();
			listeners = null;
			return null;
		}
	}
}