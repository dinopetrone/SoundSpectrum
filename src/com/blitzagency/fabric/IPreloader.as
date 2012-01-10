package com.blitzagency.fabric {
	
	/*
	 * @author Patrick Matte
	 * @since 1.0 02/18/2009
	 * @version 1.0 02/18/2009
	*/
	
	import flash.events.IEventDispatcher;
	
	/**
	* Defines an interface for the navigation preloader.
	*/
	public interface IPreloader extends IEventDispatcher {
		
		/**
		* A Number from 0 to 1. Each preloader must implement IPreloader.
		*/
		function set progress(value:Number):void;
		
		function transitionIn():void;
		
		function transitionOut():void;
		
	}
	
}