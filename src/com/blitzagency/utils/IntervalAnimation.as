package com.blitzagency.utils {
	
	import flash.utils.setInterval;
	import flash.utils.clearInterval;

	public class IntervalAnimation {
		
		private var objects:Array;
		private var time:Number;
		private var interval:Number;
		private var index:Number;
		
		public function IntervalAnimation(time:Number = 33) {
			this.time = time;
			objects = new Array();
		}
		
		public function add(object:Object, method:String):void {
			objects.push(new Array(object, method));
		}
		
		public function start():void {
			index = 0;
			interval = setInterval(callMethod, time, objects, this);
		}
		
		public function callMethod(objects:Array, intervalAnimation:Object):void {
			if (objects.length > 0) {
				var array:Array = objects.shift();
				array[0][array[1]]();
			} else {
				clearInterval(intervalAnimation.interval);
			}
		}
		
	}

}