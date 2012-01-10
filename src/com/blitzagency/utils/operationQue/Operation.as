package com.blitzagency.utils.operationQue
{
	
	/*
	 * @author Yosef Flomin
	*/
	
	public class Operation
	{
		[Public]
		public var target        :Object;
		public var method        :Function;
		public var params        :Array;
		public var timeout       :Number;
		public var timerDelay    :Number;
		public var timerMaxTicks :uint;
		public var timerTicks    :uint;
		public var timeReference :Number;
		public var autoDestroy   :Boolean = true;
		
		public function Operation(target:Object, func:Function, params:Array, timeout:Number = 0, timer:Number = 0, curtime:Number = 0)
		{
			this.method = func;
			this.params = params;
			this.target = target;
			this.timeout = timeout;
			this.timerDelay = timer;
			this.timeReference = curtime;
		}
		
		public function run():void
		{
			if (timerMaxTicks) timerTicks++;
			method.apply(null, params);
		}
		
		public function destroy():void
		{
			method = null;
			params = null;
			target = null;
		}
		
		public function toString():String
		{
			return "[Operation target=" + target + " method=" + method + " params=" + params + "]";
		}
	}
}