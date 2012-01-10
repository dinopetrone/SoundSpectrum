package com.blitzagency.utils.form.validators
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.FocusEvent;

	public class CheckBoxValidator extends Validator
	{
		public function CheckBoxValidator( target:Object, property:String, isRequired:Boolean = true, variableName:String = null, container:Object = null )
		{
			super( target, property, isRequired, variableName, container );
			target.addEventListener( Event.CHANGE, validate );
		}
		
		override public function validate( event:Event ):void 
		{
			if ( target[ property ] ) {
				isValid = true;
			}
			else { 
				isValid = false;
			}
			
			super.validate( event );
		}
	}
}
