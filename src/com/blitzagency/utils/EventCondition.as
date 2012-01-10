package com.blitzagency.utils {

	import com.blitzagency.ui.EventDispatcherBase;
	import flash.events.Event;
	import flash.events.EventDispatcher;

	public class EventCondition extends EventDispatcherBase {
		
		private var total:Number = 0;
		private var index:Number = 0;
		
		public function EventCondition(){}
		
		public function add(object:EventDispatcher, event:String):void {
			object.addEventListener(event, eventHandler);
			total++;
		}
		
		private function eventHandler(event:Event):void {
			event.target.removeEventListener(event.type, eventHandler);
			index++;
			if (index == total) {
				dispatchEvent(new Event(Event.COMPLETE));
			}
		}
		
	}

}