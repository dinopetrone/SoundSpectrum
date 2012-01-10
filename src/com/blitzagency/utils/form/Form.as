package com.blitzagency.utils.form 
{
	import com.blitzagency.ui.EventDispatcherBase;
	import com.blitzagency.utils.form.events.FormEvent;
	import flash.events.Event;
	import com.blitzagency.utils.form.validators.*;
	import flash.net.URLVariables;

	public class Form extends EventDispatcherBase
	{
		private var _validators		:Array;
		private var _isValid		:Boolean;
		private var _formVariables	:URLVariables;
		
		public function Form() 
		{
			validators = new Array();
		}
		
		public function addValidator( validator:Validator ):void
		{
			validators.push( validator );
			validator.addEventListener( FormEvent.VALID, dispatchFormEvent );
			validator.addEventListener( FormEvent.INVALID, dispatchFormEvent );
		}
		
		private function dispatchFormEvent( event:FormEvent ):void 
		{
			var formEvent:FormEvent = new FormEvent( event.type, event.data );
			formEvent.targetContainer = event.targetContainer;
			dispatchEvent( formEvent );
		}
		
		public function get isValid():Boolean
		{
			_isValid = true;
			formVariables = new URLVariables();
			
			for each ( var validator:Validator in validators )
			{
				if ( !validator.isValid ) _isValid = false;
				else 
				{
					if ( validator.data ) {
						formVariables[ validator.variableName ] = validator.data;
					}
					if ( formVariables[ validator.variableName ] == null ) {
						formVariables[ validator.variableName ] == "";
					}
				}
			}
			
			return _isValid;
		}
		
		public function validate():void
		{
			for each( var validator:Validator in _validators ) 
			{
				validator.validate();
			}
		}
		
		public function inValidate():void
		{
			for each ( var validator:Validator in validators )
			{
				validator.isValid = false;
			}
		}
		
		/*
		 * validators[x].target to access the target of validator. 
		 * validators[x].target[validator.property] for the property of the target.
		 */
		public function get validators():Array { return _validators; }
		
		public function set validators( value:Array ):void 
		{
			_validators = value;
		}
		
		/*
		 * formVariables is only set after form.isValid() is executed. 
		 */
		public function get formVariables():URLVariables { return _formVariables; }
		
		public function set formVariables( value:URLVariables ):void 
		{
			_formVariables = value;
		}
	}
}
