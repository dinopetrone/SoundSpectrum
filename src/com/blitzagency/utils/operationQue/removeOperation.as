package com.blitzagency.utils.operationQue
{
	public function removeOperation(method:Function):void
	{
		OperationQue.instance.remove(method);
	}
}