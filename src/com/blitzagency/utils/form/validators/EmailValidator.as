package com.blitzagency.utils.form.validators
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.FocusEvent;

	public class EmailValidator extends Validator
	{
		
		public function EmailValidator( target:Object, property:String, isRequired:Boolean = true, variableName:String = null, container:Object = null  ) 
		{
			super( target, property, isRequired, variableName, container );
			
			target.addEventListener( FocusEvent.FOCUS_OUT, validate );
			if ( target[ property ].length > 0 ) validate( null );
		}
		
		override public function validate( event:Event ):void 
		{
			if ( target[ property ].length < 1 && !isRequired ) isValid = true;
			else isValid = validateEmail( target[ property ] );				
			super.validate( event );
		}
		
		private function validateEmail( str:String ):Boolean
		{
			var at:String = "@"
			var dot:String = "."
			var lat:Number = str.indexOf(at);
			var lstr:Number = str.length;
			var ldot:Number = str.indexOf(dot)
			
			if (str.indexOf(at)==-1){
				return false;
			}
			if (str.indexOf(at)==-1 || str.indexOf(at)==0 || str.indexOf(at)==lstr-1){
				return false;
			}
			if (str.indexOf(dot)==-1 || str.indexOf(dot)==0 || str.indexOf(dot)==lstr-1){
				return false;
			}
			if (str.indexOf(at,(lat+1))!=-1){
				return false;
			}
			if (str.substring(lat-1,lat)==dot || str.substring(lat+1,lat+2)==dot){
				return false;
			}
			if (str.indexOf(dot,(lat+2))==-1){
				return false;
			}
			if (str.indexOf(" ")!=-1){
				return false;
			}
			return true;
		}
	}
}