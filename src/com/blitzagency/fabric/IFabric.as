package com.blitzagency.fabric {
	
	/*
	 * @author Patrick Matte
	 * @since 1.0 02/18/2009
	 * @version 1.0 02/18/2009
	*/
	
	import com.blitzagency.fabric.tracking.ITracking;
	
	/**
	* Defines an interface for the Fabric class.
	* <p/>
	* When working with external SWFs, casting Fabric to IFabric<br/>
	* will prevent all the Fabric classes to be exported with your swf.
	* <p/>
	* For example, if you want to access fabric in an external SWF:<br/>
	* var fabric:IFabric = FabricGateway.fabric;
	*/
	public interface IFabric {
		
		/**
		* The instance of the Navigation class.
		*/
		function get navigation():INavigation;
		
		/**
		* The instance of the Tracking class. 
		*/
		function get tracking():ITracking;
		
		/**
		* The instance of the Settings class. 
		*/
		function get settings():ISettings;
		
		/**
		* A Number. 
		*/
		function get version():Number;
		
	}
	
}