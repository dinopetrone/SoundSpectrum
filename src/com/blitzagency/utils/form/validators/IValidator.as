package com.blitzagency.utils.form.validators 
{
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	
	public interface IValidator extends IEventDispatcher
	{
		function validate( event:Event ):void ;
	}
}
