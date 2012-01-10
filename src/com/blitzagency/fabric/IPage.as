package com.blitzagency.fabric {
	
	/*
	 * @author Patrick Matte
	 * @since 1.0 02/18/2009
	 * @version 1.0 02/18/2009
	*/
	
	import com.blitzagency.fabric.assets.IAsset;
	
	/**
	* Defines an interface for the Page class.
	* <p/>
	* When working with external SWFs, casting Page to IPage<br/>
	* will prevent all the Page classes to be exported with your swf.
	* <p/>
	* For example, if you want to access a Page in an external SWF:<br/>
	* var navigation:INavigation = FabricGateway.fabric.navigation;<br/>
	* var page:IPage = Navigation.findPage("page1/page2/page3");
	*/
	public interface IPage {
		
		/**
		* A string used in the navigation location.
		*/
		function get id():String;
		
		function set id(value:String):void;
		
		/**
		* A string for the title of the page.
		*/
		function get title():String;
		
		function set title(value:String):void;
		
		/**
		* The name of a child page that you want to show when this page is navigated to.<br/>
		* Everytime a user navigates to this page, the default page will also be visible.
		*/
		function get defaultPage():String;
		
		function set defaultPage(value:String):void;
		
		/**
		* Any object implementing IAsset.
		*/
		function get load():IAsset;
		
		function set load(value:IAsset):void;
		
		/**
		* Any object implementing IAsset.
		*/
		function get show():IAsset;
		
		function set show(value:IAsset):void;
		
		/**
		* Any object implementing IAsset.
		*/
		function get hide():IAsset;
		
		function set hide(value:IAsset):void;
		
		/**
		* The array of child pages from this page.
		*/
		function get pages():Array;
		
		function set pages(value:Array):void;
		
		/**
		* Returns the IPage that has the specified id.
		* 
		* @param id - The page id you are looking for.
		* @return IPage
		*/
		function findPage(path:String):IPage;
		
	}
	
}