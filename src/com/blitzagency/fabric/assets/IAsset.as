package com.blitzagency.fabric.assets {
	
	/*
	 * @author Patrick Matte
	 * @since 1.0 02/18/2009
	 * @version 1.0 02/18/2009
	*/
	
	import flash.events.IEventDispatcher;
	
	/**
	* Defines an interface for the Asset class.
	* <p/>
	* All assets should implement this interface.
	*/
	public interface IAsset extends IEventDispatcher {
		
		/**
		* Creates the asset.
		*/
		function create():void;
		
		/**
		* Should be set to true for all assets that are loading external content.
		* @param scope - True if the asset is loading external content.
		*/
		function set progressive(value:Boolean):void;
		
		/**
		* This value should be set to true for all assets that are loading external content.
		* @return true if the asset is loading external content.
		*/
		function get progressive():Boolean;
		
		/**
		* Returns the progress of the asset if the asset is progressive. 
		* @return A Number from 0 to 1.
		*/
		function get progress():Number;
		
		/**
		* Resets the asset and sets the progress value back to 0 ready for the next time create() is called.
		*/
		function destroy():void;
		
	}
	
}