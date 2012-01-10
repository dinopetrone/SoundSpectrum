package com.blitzagency.utils.form.validators
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.FocusEvent;

	public class BirthdayValidator extends Validator
	{
		public var minLength:int;
		public var delimiter:String;
		
		public function BirthdayValidator( target:Object, property:String, isRequired:Boolean = true, delimiter:String = "/", variableName:String = null, container:Object = null, minLength:Number = 2  )
		{
			super( target, property, isRequired, variableName, container );
			
			this.minLength = minLength;
			this.delimiter = delimiter;
			
			target.addEventListener( FocusEvent.FOCUS_OUT, validate );
			if ( target[ property ].length > 0 ) validate( null );
		}
		
		override public function validate( event:Event ):void 
		{
			isValid = true;
			var prop:String = target[ property ];
			
			if ( prop.length < minLength && isRequired ) 
			{
				isValid = false;
			}
			else if ( !isRequired && prop.length > 0 && prop.length < minLength ) 
			{
				isValid = false;
			}
			else
			{
				var dates:Array = prop.split(delimiter);
				if (dates.length != 3)
				{
					isValid = false;
				}
				else
				{
					for each(var str:String in dates)
					{
						if (str.length != 2) isValid = false;
					}
				}
			}
			
			super.validate( event );
		}
	}
}
