package com.blitzagency.utils.operationQue
{
	import com.blitzagency.ui.EventDispatcherBase;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;	
	
	/*
	 * @author Yosef Flomin
	*/

	
	/**
	 * OperationQue is used to maintain only one enter frame / timer across the entire application.
	 * It is also used to easliy create and dispose of enter frame and timers.
	 */
	public class OperationQue extends EventDispatcherBase
	{
		private static var _instance :OperationQue = new OperationQue();
		
		[Public]
		public var timeInterval :Number = 0;
		public var queue        :Dictionary;
		
		[Private]
		private var shape       :Shape;
		private var lastTime    :Number = 0;
		private var warning     :String = "Warning! Trying to add method to OperationQue that already exists in the queue. Add Aborted.";
		
		private var _time       :Number;
		
		public function OperationQue()
		{
			if (_instance) throw new Error("Use Updater.instance");
			
			queue = new Dictionary(true);
			shape = new Shape();
			start();
		}
		
		private function update( event:Event ):void
		{
			_time = time;
			timeInterval = _time - lastTime;
			lastTime = _time
			
			for each( var operation:Operation in queue ) 
			{
				if (!operation.timeout && !operation.timerDelay) 
				{
					operation.run();
				}
				else if (operation.timeout &&
					(_time > operation.timeReference + operation.timeout))
				{
					operation.run();
					remove(operation.method);
				}
				else if (operation.timerDelay &&
					(_time > operation.timeReference + operation.timerDelay))
				{
					operation.run();
					if (operation.timerMaxTicks && operation.timerMaxTicks == operation.timerTicks)
					{
						remove(operation.method);
					}
					else operation.timeReference = _time;
				}
			}
		}
		
		public function start():void
		{
			shape.addEventListener(Event.ENTER_FRAME, update, false, 0, true);
		}
		
		public function stop():void
		{
			shape.removeEventListener(Event.ENTER_FRAME, update);
		}
		
		/**
		 *  Manually create and operation and add it. You do not need to specify the operation's time reference.
		 */
		public function addOperation(operation:Operation):void
		{
			if (queue[operation.method]) { trace(warning); return; }
			operation.timeReference = time;
			queue[operation.method] = operation;
		}
		
		/**
		 *  Create a timer. Same as <Timer>.
		 * 
		 * @param target        <Object> Target is neccessary so that you can later remove all operations associated with a target.
		 * @param delay         <Number> In milliseconds - How often the timer will be executed.
		 * @param limitExecutes <uint> The maximum amount of times this timer can execute. Value of 0 means no limit. 
		 * @param method        <Function> The function that will be executed when the timer ticks.
		 * @param ...params     <arguments> Any arguments that you want passed into the function that will be executed on timer tick. 
		 * 
		 */
		public function addTimer(target:Object, delay:Number, method:Function, limitExecutes:uint = 0, ...params):void
		{
			if (getOperation(method)) { trace(warning); return; }
			var operation:Operation = new Operation(target, method, params, 0, delay, time);
			operation.timerMaxTicks = limitExecutes;
			queue[method] = operation;
		}
		
		/**
		 *  Create a timeout. Same as <setTimeOut>.
		 * 
		 * @param target    <Object> Target is neccessary so that you can later remove all operations associated with a target.
		 * @param delay     <Number> In milliseconds - How often the timer will be executed.
		 * @param method    <Function> The function that will be executed when the timer ticks.
		 * @param ...params <arguments> Any arguments that you want passed into the function that will be executed on timer tick. 
		 * 
		 */
		public function addTimeout(target:Object, delay:Number, method:Function, ...params):void
		{
			if (getOperation(method)) { trace(warning); return; }
			var operation:Operation = new Operation(target, method, params, delay, 0, time);
			queue[method] = operation;
		}
		
		/**
		 *  Create an enter frame handler. Same as <Event.ENTER_FRAME>.
		 * 
		 * @param target    <Object> Target is neccessary so that you can later remove all operations associated with a target.
		 * @param method    <Function> The function that will be executed when the timer ticks.
		 * @param ...params <arguments> Any arguments that you want passed into the function that will be executed on timer tick. 
		 * 
		 */
		public function addEnterFrame(target:Object, method:Function, ...params):void
		{
			if (getOperation(method)) { trace(warning); return; }
			var operation:Operation = new Operation(target, method, params);
			queue[method] = operation;
		}
		
		/**
		 *  Reset an operation. Only useful for timer type operations.
		 * 
		 * @param method    <Function> The function that is associated with the operation.
		 * 
		 */
		public function reset(method:Function):void
		{
			for each( var operation:Operation in queue ) 
			{
				if (operation.method == method)
				{
					operation.timeReference = time;
				}
			}
		}
		
		/**
		 *  Remove an operation.
		 * 
		 * @param method    <Function> The function that is associated with the operation.
		 * 
		 */
		public function remove(method:Function):void
		{
			var operation:Operation = queue[method];
			if (operation)
			{
				delete queue[method];
				if (operation.autoDestroy) operation.destroy();
			}
		}
		
		/**
		 *  Remove all operations.
		 */
		public function removeAll():void
		{
			for each( var operation:Operation in queue ) 
			{
				delete queue[operation.method];
				if (operation.autoDestroy) operation.destroy();
			}
		}
		
		/**
		 *  Remove all operations that have functions in a specific target.
		 * 
		 * @param target    <Object> The target that has functions that were added to the operation que.
		 * 
		 */
		public function removeAllFrom(target:Object):void
		{
			for each( var operation:Operation in queue ) 
			{
				if (operation.target == target)
				{
					delete queue[operation.method];
					if (operation.autoDestroy) operation.destroy();
				}
			}
		}
		
		/**
		 *  Get the operation.
		 * 
		 * @param method    <Function> The function that is associated with the operation.
		 * 
		 */
		public function getOperation(method:Function):Operation
		{
			for each( var operation:Operation in queue ) 
			{
				if (operation.method == method)
				{
					return operation;
				}
			}
			return null;
		}
		
		public function traceAllOperations():void
		{
			for each( var operation:Operation in queue ) 
			{
				trace(operation.toString());
			}
		}
		
		/**
		 *  Get how many operations are in the queue.
		 */
		public function getOperationsCount():uint
		{
			var count:uint = 0;
			for each( var operation:Operation in queue ) 
			{
				count++;
			}
			return count;
		}
		
		public static function get instance():OperationQue { return _instance; }
		
		public function get time():Number { return getTimer(); }
	}
}