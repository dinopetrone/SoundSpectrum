package com.blitzagency.fabric {
	
	/*
	 * @author Patrick Matte
	 * @since 1.0 02/18/2009
	 * @version 1.0 02/18/2009
	*/
	
	import flash.display.Sprite;
	import flash.events.IEventDispatcher;
	
	/**
	* Defines an interface for the Navigation class.
	* <p/>
	* When working with external SWFs, casting Navigation to INavigation<br/>
	* will prevent all the Navigation classes to be exported with your swf.
	* <p/>
	* For example, if you want to access Navigation in an external SWF:<br/>
	* var navigation:INavigation = FabricGateway.fabric.navigation;
	*/
	public interface INavigation extends IEventDispatcher {
		
		/**
		* A string separated by a "/". Example: "page1/page2/page3/page4" where page1 is the tree of the navigation.
		*/
		function get location():String;
		
		function set location(value:String):void;
		
		/**
		 * When the navigation receives a path that includes a value that it doesn't recognise, it set a deeplink value.<br/>
		 * For example if you try to set the location to "page1/page2/video1" and "page2" doesn't include a "video1" page in its children, then the deeplink value will be set to "video1".
		*/
		function get deepLink():String;
		
		/**
		* An object implementing IPage.
		*/
		function get tree():IPage;
		
		function set tree(value:IPage):void;
		
		/**
		 * Returns the IPage instance at the specified page path.<br/>
		 * For example: findPage("page1/page2/page3") returns the IPage instance of page3.<br/>
		 * This method is really useful if you want to dynamically create a navigation menu from a collection of pages.
		 * @return IPage
		*/
		function findPage(path:String):IPage;
		
	}
	
}