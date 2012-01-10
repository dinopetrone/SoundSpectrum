package com.blitzagency.fabric.tracking {
	
	/*
	 * @author Patrick Matte
	 * @since 1.0 02/18/2009
	 * @version 1.0 02/18/2009
	*/
	
	public class TrackingCall implements ITrackingCall {
		
		protected var _name:String;
		
		/**
		* Creates a new TrackingCall. TrackingCall should never be instantiated directly, it should always be extended.
		* 
		* @param name - The name of the tracking call.
		* @param url - The url of the image to load.
		*/
		public function TrackingCall(name:String = null) {
			this.name = name;
		}
		
		/**
		* The name of the tracking call.
		*/
		public function get name():String {
			return _name;
		}
		
		public function set name(value:String):void {
			_name = value;
		}
		
		/**
		* Executes the tracking call.
		* 
		* @param replace - Let's you specify a replacement string to create dynamic tracking calls.
		*/
		public function create(replace:String = ""):void {
			
		}
		
	}
	
}