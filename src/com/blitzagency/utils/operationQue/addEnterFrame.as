package com.blitzagency.utils.operationQue
{
	public function addEnterFrame(target:Object, method:Function, ...params):void
	{
		var args:Array = params;
		args.unshift(method);
		args.unshift(target);
		OperationQue.instance.addEnterFrame.apply(null, args);
	}
}