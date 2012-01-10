package com.blitzagency.utils.form.validators
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.FocusEvent;

	public class MultiEmailValidator extends Validator
	{
		private var delimiter:String;
		
		public function MultiEmailValidator( target:Object, property:String, delimiter:String, isRequired:Boolean = true, variableName:String = null, container:Object = null  ) 
		{
			super( target, property, isRequired, variableName, container );
			
			this.delimiter = delimiter;
			
			target.addEventListener( FocusEvent.FOCUS_OUT, validate );
			if ( target[ property ].length > 0 ) validate( null );
		}
		
		override public function validate( event:Event ):void 
		{
			isValid = validateEmails( target[ property ] );				
			super.validate( event );
		}
		
		private function validateEmails( str:String ):Boolean
		{
			// Kill any extra spaces in the string, and create array seperated by <delimiter>
			var emailsArr:Array = str.split( " " ).join( "" ).split( delimiter );
			
			for ( var i:int = 0; i < emailsArr.length; i++ )
			{
				var emailStr:String = emailsArr[i];
				
				var at:String = "@"
				var dot:String = "."
				var lat:Number = emailStr.indexOf(at);
				var lstr:Number = emailStr.length;
				var ldot:Number = emailStr.indexOf(dot)
				
				if (emailStr.indexOf(at)==-1){
					return false;
				}
				if (emailStr.indexOf(at)==-1 || emailStr.indexOf(at)==0 || emailStr.indexOf(at)==lstr-1){
					return false;
				}
				if (emailStr.indexOf(dot)==-1 || emailStr.indexOf(dot)==0 || emailStr.indexOf(dot)==lstr-1){
					return false;
				}
				if (emailStr.indexOf(at,(lat+1))!=-1){
					return false;
				}
				if (emailStr.substring(lat-1,lat)==dot || emailStr.substring(lat+1,lat+2)==dot){
					return false;
				}
				if (emailStr.indexOf(dot,(lat+2))==-1){
					return false;
				}
				if (emailStr.indexOf(" ")!=-1){
					return false;
				}
			}
			
			return true;
		}
	}
}