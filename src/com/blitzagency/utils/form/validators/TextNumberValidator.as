package com.blitzagency.utils.form.validators
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.FocusEvent;

	public class TextNumberValidator extends Validator
	{
		public var minLength:int;
		
		public function TextNumberValidator( target:Object, property:String, isRequired:Boolean = true, variableName:String = null, container:Object = null, minLength:Number = 2  )
		{
			super( target, property, isRequired, variableName, container );
			
			this.minLength = minLength;
			
			target.addEventListener( FocusEvent.FOCUS_OUT, validate );
			if ( target[ property ].length > 0 ) validate( null );
		}
		
		override public function validate( event:Event ):void 
		{
			if ( target[ property ].length < minLength && isRequired ) 
			{
				isValid = false;
			}
			else if ( !isRequired && target[ property ].length > 0 && target[ property ].length < 2 ) 
			{
				isValid = false;
			}
			else isValid = true;
			
			for ( var i:int = 0; i < target[ property ].length; i++ ) 
			{
				if (isNaN(Number(String(target[ property ]).charAt(i))))
				{
					isValid = false;
				}
			}
			
			super.validate( event );
		}
	}
}
