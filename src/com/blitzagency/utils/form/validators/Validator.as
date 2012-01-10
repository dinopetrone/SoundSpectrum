package com.blitzagency.utils.form.validators
{
	import com.blitzagency.ui.EventDispatcherBase;
	import flash.display.MovieClip;
	import flash.events.EventDispatcher;
	import flash.events.Event;
	import com.blitzagency.utils.form.events.FormEvent;
	
	public class Validator extends EventDispatcherBase implements IValidator
	{
		public var isValid		: Boolean = false;
		public var isRequired	: Boolean = true;
		public var target		: Object;
		public var property		: String;
		public var variableName	: String;
		public var validatorType: Class;
		public var container	: Object;
		public var data			: * ;
		
		/* 
		 * If the Item is not required, the default validity is true unless
		 * the user starts typing, then it will check if the field is valid
		*/
		public function Validator( target:Object, property:String, isRequired:Boolean = true, variableName:String = null, container:Object = null ) 
		{ 
			if ( !isRequired ) isValid = true;
			
			this.target = target;
			this.property = property;
			this.isRequired = isRequired;
			
			if ( container ) this.container = container;
			else this.container = target;
			
			if ( variableName ) this.variableName = variableName;
			else this.variableName = target.name;
		}
		
		public function validate( event:Event = null ):void 
		{
			data = target[ property ];
			var formEvent:FormEvent;
			
			if ( isValid )
			{
				formEvent = new FormEvent( FormEvent.VALID, data );
				formEvent.targetContainer = container;
				dispatchEvent( formEvent );
			}
			else
			{
				formEvent = new FormEvent( FormEvent.INVALID, data );
				formEvent.targetContainer = container;
				dispatchEvent( formEvent );
			}
		}
	}
}