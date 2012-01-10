package com.blitzagency.fabric.tracking {
	
	/*
	 * @author Patrick Matte
	 * @since 1.0 02/18/2009
	 * @version 1.0 02/18/2009
	*/
	
	/**
	* Defines an interface for the TrackingCall class.
	* <p/>
	* Every tracking call must implement this interface.
	*/
	public interface ITrackingCall {
		
		/**
		* The name of the tracking call.
		*/
		function get name():String;
		
		function set name(value:String):void;
		
		/**
		* Executes the tracking call.
		* 
		* @param replace - Let's you specify a replacement string to create dynamic tracking calls.
		*/
		function create(replace:String = ""):void;
		
	}
	
}