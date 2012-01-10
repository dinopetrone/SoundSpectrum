package com.blitzagency.utils
{
	/*
	 * @author Yosef Flomin
	*/
	
	import flash.net.SharedObject;
	import flash.system.Capabilities;
	
	public class LocalSharedObject
	{
		[Public]
		public var clearForTesting:Boolean;
		
		[Getters_Setters]
		private var _sharedObject:Object;
		
		public function LocalSharedObject(){}
		
		public static function getLocal(name:String, local:String = "", secure:Boolean = false, clearForTesting:Boolean = true):LocalSharedObject
		{
			var lso:LocalSharedObject = new LocalSharedObject();
			lso.clearForTesting = clearForTesting;
			
			try { lso.sharedObject = SharedObject.getLocal(name, local, secure); }
			catch ( error:Error ) 
			{ 
				trace("Sorry, Locale Shared Objects are disabled: \n" + error);
				lso.sharedObject = { }; 
				lso.data = { }; 
			};
			
			return lso;
		}
		
		public function set data( value:Object ):void 
		{
			sharedObject.data = value;
		}
		
		public function set sharedObject( value:Object ):void 
		{
			_sharedObject = value;
			if ( Capabilities.playerType == "External" && sharedObject is SharedObject && clearForTesting ) 
			{
				sharedObject.clear();
			}
		}
		
		public function get data():Object { return sharedObject.data; }
		
		public function get sharedObject():Object { return _sharedObject; }
	}
}