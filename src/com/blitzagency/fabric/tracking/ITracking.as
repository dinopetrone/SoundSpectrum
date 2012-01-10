package com.blitzagency.fabric.tracking {
	
	/*
	 * @author Patrick Matte
	 * @since 1.0 02/18/2009
	 * @version 1.0 02/18/2009
	*/
	
	/**
	* Defines an interface for the Tracking class.
	* <p/>
	* When working with external SWFs, casting Tracking to ITracking<br/>
	* will prevent all the Tracking code to be exported with your swf.
	* <p/>
	* For example, if you want to access Tracking in an external SWF:<br/>
	* var tracking:ITracking = FabricGateway.fabric.tracking;
	*/
	public interface ITracking {
		
		/**
		* Calls a tracking event
		* @param name - The name of the event to track.
		* @param replace - The string you want to replace in the event arguments.
		*/
		function track(name:String, replace:String = ""):void;
		
		/**
		* An array containing all the tracking events.
		*/
		function get events():Array
		
	}
	
}