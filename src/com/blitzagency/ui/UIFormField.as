package com.blitzagency.ui 
{
	import com.blitzagency.ui.UITextField;
	import flash.display.MovieClip;
	import flash.events.FocusEvent;
	
	public class UIFormField extends UIMovieClip
	{
		public var inputField        :UITextField;
		public var requiredNotice    :MovieClip;
		public var labelTextColor    :uint = 0x5C5C5C;
		public var displayAsPassword :Boolean;
		
		protected var _valid         :Boolean;
		protected var _isRequired    :Boolean;
		protected var _inputLabel    :String;
		
		public function UIFormField()
		{
			super();
			init();
		}
		
		private function init():void
		{
			
		}
		
		public function set valid( value:Boolean ):void
		{
			_valid = value;
			if ( value ) {
				setState(UIFormFieldState.VALID);
			}
			else {
				setState(UIFormFieldState.INVALID);
			}
		}
		
		override public function set tabIndex( value:int ):void 
		{
			inputField.textField.tabIndex = value;
		}
		
		public function set isRequired( value:Boolean ):void 
		{
			_isRequired = value;
			
			if ( requiredNotice ) {
				requiredNotice.visible = value;
			}
		}
		
		public function set text( value:String ):void 
		{	
			inputField.textField.displayAsPassword = displayAsPassword;
			inputField.text = value; 
			dispatchEvent( new FocusEvent( FocusEvent.FOCUS_OUT ) );
		}
		
		override public function set label( value:String ):void 
		{
			if (textField) 
			{
				super.label = value;
			}
			else 
			{
				if (!_inputLabel)
				{
					inputField.textField.addEventListener(FocusEvent.FOCUS_IN, inputFieldWasSelected);
					inputField.textField.addEventListener(FocusEvent.FOCUS_OUT, inputFieldWasDeselected);
				}
				_inputLabel = value;
				inputField.textField.displayAsPassword = false;
				inputField.text = "<font color='#" + labelTextColor.toString(16) + "'>" + value + "</font>";
			}
		}
		
		private function inputFieldWasSelected( event:FocusEvent ):void 
		{
			if (inputField.text == _inputLabel)
			{
				inputField.text = "";
				inputField.textField.displayAsPassword = displayAsPassword;
			}
		}
		
		private function inputFieldWasDeselected( event:FocusEvent ):void 
		{
			if (inputField.text == "")
			{
				inputField.textField.displayAsPassword = false;
				inputField.text = "<font color='#" + labelTextColor.toString(16) + "'>" + _inputLabel + "</font>";
			}
		}
		
		public function get text():String 
		{
			if (inputField.text == _inputLabel) return "";
			return inputField.text; 
		}
		
		public function get valid():Boolean { return _valid; }
		
		public function get isRequired():Boolean { return _isRequired; }
		
		override public function get tabIndex():int { return inputField.textField.tabIndex; }
	}
}