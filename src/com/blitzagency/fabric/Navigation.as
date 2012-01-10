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
	import com.blitzagency.utils.operationQue.OperationQue;
	import flash.display.Sprite;
	import flash.events.Event;
	import com.blitzagency.fabric.assets.SequentialAssetLoader;
	import com.blitzagency.fabric.events.NavigationEvent;
	import flash.events.EventDispatcher;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	
	/**
	* Navigation is used to display different states of an application
	*/
	public class Navigation extends EventDispatcherBase implements INavigation {
		public var currentPage:IPage;
		
		protected var _tree:IPage;
		
		protected var activePages:Array = new Array();
		protected var transitionInPages:Array;
		protected var transitionOutPages:Array;
		
		protected var inTransition:Boolean;
		protected var interruptTransition:Boolean;
		protected var _deepLink:String = "";
		protected var _location:String = "";
		protected var transitionInPath:String;
		protected var pageLoader:SequentialAssetLoader;
		protected var timer:Timer;
		
		public var preloader:IPreloader;
		
		/**
		* Creates a new Navigation instance. Navigation is used to navigate in a structure of pages.<br/>
		* The root page is called tree. Navigation have a root page.<br/>
		* To navigate to a new page, you need to set a new location. Always start the navigation path<br/>
		* with a children of the tree page.<br/>
		* For example in "Page1/Page2/Page3", Page1 is a child of the tree page.
		* <p/>
		* About the transition sequence.<br/>
		* When you navigate to a new page, the framework start by navgating to back to the parent page<br/>
		* of the new branch where you want to go.<br/>
		* For example, if you are on "Page1/Page2/Page3/Page4 and you want to go to Page1/Page3/Page4,<br/>
		* the navigation will transition out the child pages back to Page1, then load the next page,<br/>
		* and once the loading has finished, will transition in the new pages.<br/>
		* <p/>
		* Navigation also dispatches some events. See NavigationEvent.
		*/
		public function Navigation() {
			super();
		}
		
		/**
		* An object implementing IPage.
		*/
		public function get tree():IPage {
			return _tree;
		}
		
		public function set tree(value:IPage):void {
			_tree = value;
		}
		
		/**
		* A string separated by a "/". Example: "page1/page2/page3/page4" where page1 is the tree of the navigation.
		*/
		public function get location():String {
			return _location;
		}
		
		public function set location(value:String):void {
			trace("Navigation.location = \"" + value + "\"");
			transitionInPath = value;
			if (inTransition) {
				interruptTransition = true;
			} else {
				changePage();
			}
		}
		
		protected function transitionInterrupted():void {
			changePage();
		}
		
		protected function changePage():void {
			interruptTransition = false;
			inTransition = true;
			findTransitionInPages();
			addDefaultPages();
			findTransitionOutPages();
			
			currentPage = transitionInPages[transitionInPages.length - 1];
			
			_location = "";
			var locationArray:Array = activePages.concat(transitionInPages);
			for (var i = 1; i < locationArray.length; i++) {
				_location += locationArray[i].id;
				if(i < locationArray.length - 1){
					_location += "/";
				}
			}
			/*
			trace("transitionInPages = " + transitionInPages);
			trace("transitionOutPages = " + transitionOutPages);
			trace("activePages = " + activePages);
			*/
			
			startTransitions();
		}
		
		protected function startTransitions():void {
			dispatchEvent(new NavigationEvent(NavigationEvent.TRANSITION_START));
			startTransitionOut();
		}
		
		protected function findTransitionInPages():void {
			transitionInPages = new Array(tree);
			if (transitionInPath.length > 0) {
				var index:Number = 0;
				var transitionInPathArray:Array = transitionInPath.split("/");
				var page:IPage = tree;
				while (page && index < transitionInPathArray.length) {
					page = page.findPage(transitionInPathArray[index]);
					if (page) {
						transitionInPages.push(page);
					} else {
						_deepLink = transitionInPathArray.slice(index).join("/");
						//trace("Navigation.deepLink = " + deepLink);
						dispatchEvent(new NavigationEvent(NavigationEvent.DEEPLINK));
					}
					index++;
				}
			}
		}
		
		protected function addDefaultPages():void {
			var lastPage:IPage = transitionInPages[transitionInPages.length-1];
			if (lastPage.defaultPage != "") {
				lastPage = lastPage.findPage(lastPage.defaultPage);
				transitionInPages.push(lastPage);
				addDefaultPages();
			}
		}
		
		protected function findTransitionOutPages():void {
			transitionOutPages = new Array();
			var breakIndex:Number = 0;
			for (var i = 0; i < activePages.length; i++) {
				var active:Array = activePages.slice(0, i + 1);
				var activePath:String = active.join("/");
				var transIn:Array = transitionInPages.slice(0, i + 1);
				var transInPath:String = transIn.join("/");
				if (activePath == transInPath) {
					breakIndex++;
				}
			}
			transitionOutPages = activePages.splice(breakIndex);
			transitionInPages.splice(0, breakIndex);
		}
		
		/**
		 * When the navigation receives a path that includes a value that it doesn't recognise, it set a deeplink value.<br/>
		 * For example if you try to set the location to "page1/page2/video1" and "page2" doesn't include a "video1" page in its children, then the deeplink value will be set to "video1".
		*/
		public function get deepLink():String {
			return _deepLink;
		}
		
		protected function startTransitionOut():void {
			if (interruptTransition) {
				while (transitionOutPages.length > 0) {
					var page:IPage = transitionOutPages.shift();
					activePages.push(page);
				}
				transitionInterrupted();
				return;
			}
			dispatchEvent(new NavigationEvent(NavigationEvent.TRANSITION_OUT_START));
			transitionOut();
		}
		
		protected function transitionOut():void {
			if (transitionOutPages.length > 0) {
				var page:IPage = transitionOutPages[transitionOutPages.length - 1];
				if (page.hide) {
					page.hide.addEventListener(Event.COMPLETE, pageTransitionOutComplete);
					page.hide.create();
				} else {
					page.load.destroy();
					transitionOutPages.pop();
					transitionOut();
				}
			} else {
				dispatchEvent(new NavigationEvent(NavigationEvent.TRANSITION_OUT_COMPLETE));
				startLoading();
			}
		}
		
		protected function pageTransitionOutComplete(event:Event):void {
			event.target.removeEventListener(Event.COMPLETE, pageTransitionOutComplete);
			var page:IPage = transitionOutPages.pop();
			page.load.destroy();
			transitionOut();
		}
		
		protected function startLoading():void {
			if (interruptTransition) {
				transitionInterrupted();
				return;
			}
			if(transitionInPages.length > 0){
				pageLoader = new SequentialAssetLoader();
				for (var i:int = 0; i < transitionInPages.length; i++) {
					var page:IPage = transitionInPages[i] as IPage;
					pageLoader.push(page.load);
				}
				pageLoader.addEventListener(Event.COMPLETE, pageLoaderComplete);
				//trace("pageLoader.progressive = " + pageLoader.progressive);
				if (pageLoader.progressive) {
					var firstPage:IPage = transitionInPages[0] as IPage;
					if (preloader) {
						preloader.addEventListener(Event.COMPLETE, preloaderTransitionInComplete);
						preloader.transitionIn();
					}else {
						pageLoader.create();
					}
				} else {
					pageLoader.create();
				}
			} else {
				transitionsComplete();
			}
		}
		
		protected function preloaderTransitionInComplete(event:Event):void {
			preloader.removeEventListener(Event.COMPLETE, preloaderTransitionInComplete);
			pageLoader.create();
			dispatchLoadingProgress();
			OperationQue.instance.addEnterFrame(this, dispatchLoadingProgress);
		}
		
		protected function dispatchLoadingProgress(event:Event = null):void {
			preloader.progress = pageLoader.progress;
		}
		
		protected function pageLoaderComplete(event:Event):void {
			event.target.removeEventListener(Event.COMPLETE, pageLoaderComplete);
			if (preloader && pageLoader.progressive) {
				OperationQue.instance.remove(dispatchLoadingProgress);
				dispatchLoadingProgress();
				preloader.addEventListener(Event.COMPLETE, preloaderTransitionOutComplete);
				preloader.transitionOut();
			} else {
				startTransitionIn();
			}
		}
		
		protected function preloaderTransitionOutComplete(e:Event):void {
			preloader.removeEventListener(Event.COMPLETE, preloaderTransitionOutComplete);
			startTransitionIn();
		}
		
		protected function startTransitionIn():void {
			if (interruptTransition) {
				while (transitionInPages.length > 0) {
					var page:IPage = transitionInPages.pop();
					page.load.destroy();
				}
				transitionInterrupted();
				return;
			}
			dispatchEvent(new NavigationEvent(NavigationEvent.TRANSITION_IN_START));
			transitionIn();
		}
		
		protected function transitionIn():void {
			if (transitionInPages.length > 0) {
				var page:IPage = transitionInPages.shift() as IPage;
				activePages.push(page);
				if (page.show) {
					page.show.addEventListener(Event.COMPLETE, pageTransitionInComplete);
					page.show.create();
				} else {
					transitionIn();
				}
			} else {
				dispatchEvent(new NavigationEvent(NavigationEvent.TRANSITION_IN_COMPLETE));
				transitionsComplete();
			}
		}
		
		protected function pageTransitionInComplete(event:Event):void {
			event.target.removeEventListener(Event.COMPLETE, pageTransitionInComplete);
			transitionIn();
		}

		protected function transitionsComplete():void {
			inTransition = false;
			//trace("Navigation.transitionsComplete");
			dispatchEvent(new NavigationEvent(NavigationEvent.TRANSITION_COMPLETE));
			if (interruptTransition) {
				transitionInterrupted();
			}
		}
		
		/**
		 * Returns the IPage instance at the specified page path.
		 * For example: findPage("page1/page2/page3") returns the IPage instance of page3.
		 * This method is really useful if you want to dynamically create a navigation menu from a collection of pages.
		 * @return IPage
		*/
		public function findPage(path:String):IPage {
			var page:IPage = tree;
			if (path.length > 0) {
				var pageArray:Array = path.split("/");
				for (var i:Number = 0; i < pageArray.length; i++) {
					page = page.findPage(pageArray[i]);
				}
			}
			return page;
		}
		
	}
	
}