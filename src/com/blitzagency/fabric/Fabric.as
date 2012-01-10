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
	
	import com.asual.swfaddress.*;
	import com.blitzagency.fabric.assets.*;
	import com.blitzagency.fabric.events.*;
	import com.blitzagency.fabric.tracking.*;
	import com.blitzagency.ui.UIBase;
	import com.blitzagency.utils.*;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	
	/**
	* Fabric is the main application class. It includes a navigation class,<br/>
	* it also registers with SWFAddress for deeplinking functionnality, it can track analytics<br/>
	* and it includes some settings for locale and bandwidth profiling.
	*/
	public class Fabric extends UIBase implements IFabric {
		
		public static var mainURL:String = "global/config/main.xml";
		
		/**
		* Defines the first page of the site, unless a SWFAddress deeplink is defined.
		*/
		public var startPage:String = "";
		
		/**
		* Defines the path to the external assets.
		*/
		public var assets:String = "../../";
		
		/**
		* Use when loading assets from a remote server.
		*/
		public var securityDomain:String = "false";
		
		protected var _version:Number = 0.93;
		protected var _navigation:Navigation;
		protected var _tracking:Tracking;
		protected var _settings:Settings = new Settings();
		protected var _treeContextMenu:TreeContextMenu;
		
		public function Fabric() {
			super();
			
			FabricGateway.fabric = this;
			
			if (loaderInfo.parameters.assets) {
				assets = loaderInfo.parameters.assets;
			}
			if (loaderInfo.parameters.securityDomain) {
				securityDomain = loaderInfo.parameters.securityDomain;
			}
			if (loaderInfo.parameters.startPage) {
				startPage = loaderInfo.parameters.startPage;
			}
			if (loaderInfo.parameters.locale) {
				settings.locale = loaderInfo.parameters.locale;
			}
			
			/**
			* Registering all the assets with XMLAlias.
			*/
			//assets
			XMLAlias.registerClassAlias("Transition", Transition);
			XMLAlias.registerClassAlias("Sound", SoundPreloader);
			XMLAlias.registerClassAlias("AssetLoader", AssetLoaderPreloader);
			XMLAlias.registerClassAlias("DownloadSpeed", DownloadSpeedPreloader);
			XMLAlias.registerClassAlias("Loader", LoaderPreloader);
			XMLAlias.registerClassAlias("NetStream", NetStreamPreloader);
			XMLAlias.registerClassAlias("Object", ObjectPreloader);
			XMLAlias.registerClassAlias("Array", ArrayPreloader);
			XMLAlias.registerClassAlias("URLLoader", URLLoaderPreloader);
			XMLAlias.registerClassAlias("XMLLoader", XMLPreloader);
			XMLAlias.registerClassAlias("DynamicAssetLoader", DynamicAssetLoader);
			XMLAlias.registerClassAlias("Class", ClassPreloader);
			XMLAlias.registerClassAlias("Function", FunctionAsset);
			XMLAlias.registerClassAlias("Boolean", BooleanProperty);
			XMLAlias.registerClassAlias("Number", NumberProperty);
			XMLAlias.registerClassAlias("Property", Property);
			XMLAlias.registerClassAlias("String", StringProperty);
			XMLAlias.registerClassAlias("XMLList", XMLListProperty);
			XMLAlias.registerClassAlias("XML", XMLProperty);
			XMLAlias.registerClassAlias("Parallel", ParallelAssetLoader);
			XMLAlias.registerClassAlias("Sequential", SequentialAssetLoader);
			XMLAlias.registerClassAlias("AddChild", AddChild);
			XMLAlias.registerClassAlias("RemoveChild", RemoveChild);
			XMLAlias.registerClassAlias("CSS", CSSPreloader);
			
			// tracking
			XMLAlias.registerClassAlias("JSCall", JSTrackingCall);
			XMLAlias.registerClassAlias("ImageCall", ImageTrackingCall);
			
			_navigation = new Navigation();
			_tracking = new Tracking();
			//_settings = new Settings();
			
			navigation.addEventListener(NavigationEvent.TRANSITION_START, trackPage);
			navigation.addEventListener(NavigationEvent.TRANSITION_IN_COMPLETE, updateSwfAddress);
			navigation.addEventListener(NavigationEvent.TRANSITION_OUT_COMPLETE, updateSwfAddress);
			
			var assetLoaderPreloader:AssetLoaderPreloader = new AssetLoaderPreloader(this, "", assets + mainURL);
			assetLoaderPreloader.addEventListener(Event.COMPLETE, assetLoaderPreloaderComplete);
			assetLoaderPreloader.create();
			_treeContextMenu = new TreeContextMenu(this);
		}
		
		public function set contextMenuTree(boo:Boolean):void{
			_treeContextMenu.enable = boo;
		}
		
		protected function trackPage(event:Event):void {
			tracking.track(navigation.location);
		}
		
		protected function updateSwfAddress( event:NavigationEvent ):void 
		{
			SWFAddress.setTitle(Navigation(navigation).currentPage.title);
			SWFAddress.setValue(navigation.location  + "/" + navigation.deepLink);
		}
		
		protected function assetLoaderPreloaderComplete(event:Event):void {
			event.target.removeEventListener(Event.COMPLETE, assetLoaderPreloaderComplete);
			if (SWFAddress.getValue() != "/") {
				gotoSWFAddress();
			} else {
				navigation.location = startPage;
			}
			SWFAddress.addEventListener(SWFAddressEvent.CHANGE, gotoSWFAddress);
		}
		
		protected function gotoSWFAddress(event:Event = null):void {
			var path:String = SWFAddress.getValue();
			if ( path != "/" && path.substring(1) != navigation.location && path.substr(1) != navigation.location + "/" + navigation.deepLink )
			{
				navigation.location = path.substr(1);
			}
		}
		
		/**
		* tree parses an xml object to a Page instance and set the navigation tree
		* @param targetPath - The targetpath to the object. ex.: "object.object[4].object[test].object"
		*/
		public function set tree(value:XML):void {
			navigation.tree = Page.fromXML(this, value);
		}
		
		/**
		* The instance of the Navigation class. 
		*/
		public function get navigation():INavigation {
			return _navigation;
		}
		
		/**
		* The instance of the Settings class. 
		*/
		public function get settings():ISettings {
			return _settings;
		}
		
		/**
		* The instance of the Tracking class. 
		*/
		public function get tracking():ITracking {
			return _tracking;
		}
		
		/**
		* A Number. 
		*/
		public function get version():Number {
			return _version;
		}
		
	}
	
}