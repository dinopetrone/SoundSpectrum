package com.blitzagency.utils.form.events 
{
	import flash.display.MovieClip;
	import flash.events.Event;

	public class FormEvent extends Event
	{
		public static const INVALID:String = "invalid";
		public static const VALID:String = "valid";
		
		private var _data:*;
		public var targetContainer:Object;
		
		public function FormEvent( type:String, data:* = null )
		{
			super( type, true );
			this.data = data;
		}
		
		override public function clone():Event 
		{
			return new FormEvent( type );
		}
		
		public function get data():* { return _data; }
		
		public function set data( value:* ):void 
		{
			_data = value;
		}
	}
}
