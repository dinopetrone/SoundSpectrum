package com.blitzagency.utils.operationQue
{
	public function addTimeout(target:Object, delay:Number, method:Function, ...params):void
	{
		var args:Array = params;
		args.unshift(method);
		args.unshift(delay);
		args.unshift(target);
		OperationQue.instance.addTimeout.apply(null, args);
	}
}