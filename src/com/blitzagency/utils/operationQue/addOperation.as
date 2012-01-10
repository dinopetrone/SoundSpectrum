package com.blitzagency.utils.operationQue
{
	public function addEnterFrame(operation:Operation):void
	{
		OperationQue.instance.addOperation(operation);
	}
}