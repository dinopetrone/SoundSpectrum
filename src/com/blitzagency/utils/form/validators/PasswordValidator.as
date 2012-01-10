package com.blitzagency.utils.form.validators 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.FocusEvent;

	public class PasswordValidator extends Validator
	{
		public var minLength:int;
		public var targetCofirm:Object;
		
		public function PasswordValidator( target:Object, targetCofirm:Object, property:String, isRequired:Boolean = true, minLength:Number = 2, variableName:String = null, container:Object = null  )
		{
			super( target, property, isRequired, variableName, container );
			
			this.minLength = minLength;
			this.targetCofirm = targetCofirm;
			
			target.addEventListener( FocusEvent.FOCUS_OUT, validate );
			targetCofirm.addEventListener( Event.CHANGE, validate );
			
			if ( target[ property ].length > 0 ) validate( null );
			if ( targetCofirm[ property ].length > 0 ) validate( null );
		}
		
		override public function validate( event:Event ):void 
		{
			if ( target[ property ].length < minLength && isRequired ) isValid = false;
			else if ( target[ property ] != targetCofirm[ property ] ) isValid = false;
			else if ( !isRequired && target[ property ].length > 0 && target[ property ].length < 2 ) isValid = false;
			else isValid = true;
			
			super.validate( event );
		}
	}
}