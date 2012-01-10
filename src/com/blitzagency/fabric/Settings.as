package com.blitzagency.fabric {
	
	/*
	 * @author Patrick Matte
	 * @since 1.0 02/18/2009
	 * @version 1.0 02/18/2009
	 * 
	 * @modified Yosef Flomin
	 * @revision 1.1 2010/05/17
	 * @note revised to extend EventDispatcherBase
	*/
	
	import com.blitzagency.ui.EventDispatcherBase;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.system.Capabilities;
	
	/**
	* Contains application settings locale, language, country, bandwidth and downloadSpeed.
	*/
	public class Settings extends EventDispatcherBase implements ISettings {
		
		public static var CHANGE_LANGUAGE:String = "changeLanguage";
		public static var CHANGE_COUNTRY:String = "changeCountry";
		public static var CHANGE_BANDWIDTH:String = "changeBandwidth";
		private var _language:String = "en";
		private var _bandwidth:String = "hi";
		private var _downloadSpeed:Number;
		private var _country:String = "us";
		
		public function Settings() {}
		
		/**
		* A string separated by an underscore like "en_US" where "en" is the language and "US" is the country.
		*/
		public function get locale():String {
			return (_language + "_" + _country).toLowerCase();
		}
		
		public function set locale(value:String):void {
			var array:Array = value.split("_");
			language = array[0];
			country = array[1];
			
		}
		
		/**
		* A string of two letters like "en".
		*/
		public function get language():String {
			return _language;
		}
		
		public function set language(value:String):void {
			_language = value.toLowerCase();
			dispatchEvent(new Event(CHANGE_LANGUAGE));
		}
		
		/**
		*  A string of two letter like "US".
		*/
		public function get country():String {
			return _country;
		}
		
		public function set country(value:String):void {
			_country = value.toUpperCase();
			dispatchEvent(new Event(CHANGE_COUNTRY));
		}
		
		/**
		* A string you can use to profile external assets like images, sounds or videos.
		*/
		public function get bandwidth():String {
			return _bandwidth;
		}
		
		public function set bandwidth(value:String):void {
			_bandwidth = value;
			dispatchEvent(new Event(CHANGE_BANDWIDTH));
		}
		
		/**
		* A Number in KB/s. Example: dialup is roughly 5.6 KB/s.
		*/
		public function get downloadSpeed():Number {
			return _downloadSpeed;
		}
		
		public function set downloadSpeed(value:Number):void {
			_downloadSpeed = value;
			var bandwidth:String = "hi";
			if (value < 65) {
				bandwidth = "low";
			}
			this.bandwidth = bandwidth;
		}
		
	}
	
}