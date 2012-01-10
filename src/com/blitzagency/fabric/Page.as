package com.blitzagency.fabric {
	
	/*
	 * @author Patrick Matte
	 * @since 1.0 02/18/2009
	 * @version 1.0 02/18/2009
	*/
	
	import com.blitzagency.fabric.assets.Asset;
	import com.blitzagency.fabric.assets.AssetLoader;
	import com.blitzagency.fabric.assets.IAsset;
	import com.blitzagency.fabric.assets.IAssetLoader;
	import com.blitzagency.fabric.assets.SequentialAssetLoader;
	import com.blitzagency.fabric.assets.ParallelAssetLoader;
	
	/**
	* Defines a page in the application. An application is made of multiple pages,<br/>
	* each page defines assets that are loaded and tasks that are accomplished<br/>
	* when each page is accessed.
	*/
	public class Page extends Base implements IPage {
		
		private var _id:String;
		private var _title:String;
		private var _defaultPage:String;
		private var _load:IAsset;
		private var _show:IAsset;
		private var _hide:IAsset;
		private var _pages:Array = new Array();
		
		/**
		* Creates a new page.
		* <p/>
		* For example, let's create a page that will preload a loader and then add the loader to <br/>
		* the root of the display list and call transitionIn() and transitionOut() on the loader content.
		* <listing>
		* package {
		* 
		* 	import flash.display.MovieClip;
		* 	import com.blitzagency.fabric.assets.AddChild;
		* 	import com.blitzagency.fabric.assets.RemoveChild;
		* 	import com.blitzagency.fabric.assets.LoaderPreloader;
		* 	import com.blitzagency.fabric.assets.Transition;
		* 	import com.blitzagency.fabric.assets.SequentialAssetLoader;
		* 
		* 	public class MyPage extends Page {
		* 		
		* 		public var myLoader:Loader;
		* 		
		* 		public function MyPage(scope:Object, id:String, title:String = "", defaultPage:String = ""){
		* 			super(scope, id, title, defaultPage);
		* 			load = new SequentialAssetLoader();
		* 			load.push(new LoaderPreloader(this, "myLoader", "", "images/test.swf"));
		* 			
		* 			show = new SequentialAssetLoader();
		* 			show.push(new AddChild(this, "scope", "myLoader", ""));
		* 			show.push(new Transition(this, "transitionIn", "myLoader"));
		*
		* 			hide = new SequentialAssetLoader();
		* 			hide.push(new Transition(this, "transitionOut", "myLoader"));
		* 			hide.push(new RemoveChild(this, "scope", "myLoader", ""));
		* 		}
		* 
		* 	}
		* 
		* }
		* </listing>
		* 
		* @param scope - The object from which the targetpaths and bindings are evaluated.
		* @param id - The string used by the navigation to call this page.
		* @param title - The title of this page.
		* @param defaultPage - The default child page that will also load when this page is loaded.
		*/
		public function Page(scope:Object, id:String, title:String = "", defaultPage:String = "") {
			super(scope);
			_id = id;
			_title = title;
			_defaultPage = defaultPage;
		}
		
		/**
		* A string used in the navigation location.
		*/
		public function get id():String {
			return _id;
		}
		
		public function set id(value:String):void {
			_id = value;
		}
		
		/**
		* A string for the title of the page.
		*/
		public function get title():String {
			return parseString(_title);
		}
		
		public function set title(value:String):void {
			_title = value;
		}
		
		/**
		* The name of a child page that you want to show when this page is navigated to.<br/>
		* Everytime a user navigates to this page, the default page will also be visible.
		*/
		public function get defaultPage():String {
			return parseString(_defaultPage);
		}
		
		public function set defaultPage(value:String):void {
			_defaultPage = value;
		}
		
		/**
		* Any object implementing IAsset.
		*/
		public function get load():IAsset {
			return _load;
		}
		
		public function set load(value:IAsset):void {
			_load = value;
		}
		
		/**
		* Any object implementing IAsset.
		*/
		public function get show():IAsset {
			return _show;
		}
		
		public function set show(value:IAsset):void {
			_show = value;
		}
		
		/**
		* Any object implementing IAsset.
		*/
		public function get hide():IAsset {
			return _hide;
		}
		
		public function set hide(value:IAsset):void {
			_hide = value;
		}
		
		/**
		* The array of child pages from this page.
		*/
		public function get pages():Array {
			return _pages;
		}
		
		public function set pages(value:Array):void {
			_pages = value;
		}
		
		/**
		* Parses an xml object into a Page object.<br/>
		* The xml object must be formatted like this
		* <listing>
		* <Page id="Nav" title="Navigation" defaultPage="Green1">
		* 	<Load>
		* 		<Loader name="background" target="" url="{assets}swf/background.swf" checkPolicyFile="false" securityDomain="false"/>
		* 		<DownloadSpeed name="downloadSpeed" target="settings" url="{assets}images/bandwidth.jpg" checkPolicyFile="false"/>
		* 		<Loader name="nav" target="" url="{assets}swf/nav.swf" checkPolicyFile="false" securityDomain="false"/>
		* 	</Load>
		* 	<Show>
		* 		<AddChild container="" child="background" depth="0"/>
		* 		<AddChild container="" child="nav" depth="1"/>
		* 	</Show>
		* 	<Hide>
		* 		<RemoveChild container="" child="nav"/>
		* 	</Hide>
		* 	<Page id="Green1" title="Green 1" defaultPage="">
		* 	</Page>
		* </Page>
		* </listing>
		* Notice how {assets} is put in front of every external asset. This means that the assets path will be evaluated at runtime.
		* 
		* 
		* @param scope - The scope used to evaluates bindings.
		* @param xml - The xml object defining the page.
		*/
		static public function fromXML(scope:Object, xml:XML):IPage {
			var id:String = xml.@id;
			var title:String = xml.@title;
			var defaultPage:String = xml.@defaultPage;
			var page:Page = new Page(scope, id, title, defaultPage);
			if (xml.Load) {
				page.load = AssetLoader.fromXML(scope, xml.Load[0]);
			}
			if (xml.Show) {
				page.show = AssetLoader.fromXML(scope, xml.Show[0]);
			}
			if (xml.Hide) {
				page.hide = AssetLoader.fromXML(scope, xml.Hide[0]);
			}
			for (var j = 0; j < xml.Page.length(); j++) {
				var child:IPage = Page.fromXML(scope, xml.Page[j]);
				page.pages.push(child);
			}
			return page;
		}
		
		/**
		* Returns the IPage that has the specified id.
		* 
		* @param id - The page id you are looking for.
		* @return IPage
		*/
		public function findPage(id:String):IPage {
			var page:Page;
			for (var i:int = 0; i < pages.length; i++) {
				var child:Page = pages[i] as Page;
				if (child.id == id) {
					page = child;
				}
			}
			return page;
		}
		
		public override function toString():String {
			return "[Page" + " id=" + id  + "]";
		}
		
	}
	
}