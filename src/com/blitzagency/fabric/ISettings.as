package com.blitzagency.fabric {
	
	/*
	 * @author Patrick Matte
	 * @since 1.0 02/18/2009
	 * @version 1.0 02/18/2009
	*/
	
	import flash.events.IEventDispatcher;
	
	/**
	* Defines an interface for the Settings class.
	* <p/>
	* When working with external SWFs, casting Settings to ISettings<br/>
	* will prevent all the Settings code to be exported with your swf.
	* <p/>
	* For example, if you want to access Settings in an external SWF:<br/>
	* var settings:ISettings = FabricGateway.fabric.settings;
	*/
	public interface ISettings extends IEventDispatcher {
		
		/**
		* A string of two letters like "en".
		*/
		function get language():String;
		
		function set language(value:String):void;
		
		/**
		* A string you can use to profile external assets like images, sounds or videos.
		*/
		function get bandwidth():String;
		
		function set bandwidth(value:String):void;
		
		/**
		* A string separated by an underscore like "en_US" where "en" is the language and "US" is the country.
		*/
		function get locale():String;
		
		function set locale(value:String):void;
		
		/**
		* A string of two letter like "US".
		*/
		function get country():String;
		
		function set country(value:String):void;
		
		/**
		* A Number in KB/s. Example: dialup is roughly 5.6 KB/s.
		*/
		function get downloadSpeed():Number;
		
		function set downloadSpeed(value:Number):void;
		
	}
	
}