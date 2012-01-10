package com.blitzagency.ui 
{
	import com.blitzagency.bundles.Bundle;
	import com.blitzagency.bundles.BundleFactory;
	import com.blitzagency.bundles.BundleLoader;
	import com.blitzagency.bundles.Resource;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	
	public class UIMovieClipWithBundle extends UIMovieClip
	{
		private var _basePath   :String = "";
		private var _loadStyle  :String = BundleLoader.PARALLEL;
		private var _bundleData :Object;
		
		private var _bundle     :Bundle;
		
		public function UIMovieClipWithBundle() 
		{
			super();
			addEventListener( Event.ADDED_TO_STAGE, checkForBundle );
		}
		
		protected function checkForBundle( event:Event ):void 
		{
			removeEventListener( Event.ADDED_TO_STAGE, checkForBundle );
			
			if ( !bundle && bundleData ) {
				bundle = BundleFactory.create( bundleData );
				bundle.basePath = basePath;
				loadBundle();
			}
		}
		
		protected function loadBundle():void
		{
			if ( bundle && !bundle.startedLoad ) {
				bundle.addEventListener( Event.COMPLETE, bundleIsReady );
				bundle.addEventListener( ProgressEvent.PROGRESS, bundleProgress );
				bundle.load( loadStyle );
			}
		}
		
		protected function bundleProgress( event:ProgressEvent ):void 
		{
			// Override me sometime
		}
		
		protected function bundleIsReady( event:Event ):void 
		{
			transitionIn();
		}
		
		public function applyResourcesToProperties( scope:DisplayObject ):void
		{
			try { scope[ 'bundle' ] = bundle }
			catch ( error:Error ) { trace( "No bundle found on " + scope ); };
			
			for each( var resource:Resource in bundle ){
				try { scope[ resource.name ] = resource.content; } 
				catch ( error:Error ) { };
			} 
		}
		
		public function get bundle():Bundle { return _bundle; }
		
		public function get basePath():String { return _basePath; }
		
		public function get loadStyle():String { return _loadStyle; }
		
		public function get bundleData():Object { return _bundleData; }
		
		public function set bundle( value:Bundle ):void 
		{
			_bundle = value;
			removeEventListener( Event.ADDED_TO_STAGE, checkForBundle );
		}
		
		public function set basePath( value:String ):void 
		{
			_basePath = value;
		}
		
		public function set loadStyle( value:String ):void 
		{
			_loadStyle = value;
		}
		
		public function set bundleData( value:Object ):void 
		{
			_bundleData = value;
		}
	}
}