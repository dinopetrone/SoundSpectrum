package com.blitzagency.utils.form.validators
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.FocusEvent;

	public class PhoneValidator extends Validator
	{
		public function PhoneValidator( target:Object, property:String, isRequired:Boolean = true, variableName:String = null, container:Object = null )
		{
			super( target, property, isRequired, variableName, container );
			
			target.addEventListener( FocusEvent.FOCUS_OUT, validate );
			if ( target[ property ].length > 0 ) validate( null );
		}
		
		override public function validate( event:Event ):void 
		{
			var phoneStr:String = target[ property ].split( "-" ).join( "" );
			var phoneNbr:Number = Number( phoneStr );
			
			isValid = !isRequired;
			
			if ( !phoneNbr && isRequired ) {
				isValid = false;
			}
			else if ( phoneStr.length > 9 ) {
				isValid = true;
			}
			
			super.validate( event );
		}
	}
}
