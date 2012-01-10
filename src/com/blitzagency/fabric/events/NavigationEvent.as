package com.blitzagency.fabric.events {
	
	/*
	 * @author Patrick Matte
	 * @since 1.0 02/18/2009
	 * @version 1.0 02/18/2009
	*/
	
	import flash.events.Event;

	/**
	* NavigationEvent is dispatched by the Navigation class.
	*/
	public class NavigationEvent extends Event {
		
		public static var TRANSITION_START:String = "transitionStart";
		public static var TRANSITION_COMPLETE:String = "transitionComplete";
		public static var TRANSITION_IN_START:String = "transitionInStart";
		public static var TRANSITION_IN_COMPLETE:String = "transitionInComplete";
		public static var TRANSITION_OUT_START:String = "transitionOutStart";
		public static var TRANSITION_OUT_COMPLETE:String = "transitionOutComplete";
		public static var DEEPLINK:String = "deeplink";
		
		/**
		* Creates a new NavigationEvent.
		* 
		* @param type - The type of event dispatched from the navigation.
		* @param bubbles - Determines whether the Event object participates in the bubbling stage of the event flow. The default value is false.
		* @param cancelable - Determines whether the Event object can be canceled. The default values is false.
		*/
		public function NavigationEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false) {
			super(type, bubbles, cancelable);
		}
		
		public override function clone():Event {
			return new NavigationEvent(type);
		}
		
	}
	
}