package com.blitzagency.utils.operationQue
{
	public function addTimer(target:Object, delay:Number, method:Function, limitExecutes:uint = 0, ...params):void
	{
		var args:Array = params;
		args.unshift(limitExecutes);
		args.unshift(method);
		args.unshift(delay);
		args.unshift(target);
		OperationQue.instance.addTimer.apply(null, args);
	}
}