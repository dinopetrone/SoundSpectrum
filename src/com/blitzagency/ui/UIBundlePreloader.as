package com.blitzagency.ui 
{
	import com.blitzagency.bundles.Bundle;
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class UIBundlePreloader extends UIMovieClipWithBundle
	{
		private var _swf         :Sprite;
		private var _swfResource :String;
		
		public function UIBundlePreloader() 
		{
			super();
			
			if ( loaderInfo.parameters.resources ) {
				bundleData = loaderInfo.parameters.resources;
			}
			if ( loaderInfo.parameters.swfPath ) {
				_swfResource = "name=swf|path=" + loaderInfo.parameters.swfPath;
				bundleData = bundleData ? bundleData : _swfResource;
			}
		}
		
		override public function set bundle( value:Bundle ):void 
		{
			if ( loaderInfo.parameters.resources && _swfResource ) {
				value.addResource( _swfResource );
			}
			super.bundle = value;
		}
		
		override protected function bundleIsReady(event:Event):void 
		{
			applyResourcesToProperties( this );
			
			if ( _swf && _swf is UIMovieClipWithBundle ) {
				UIMovieClipWithBundle( _swf ).bundle = bundle;
			}
		}
		
		public function get swfResource():String { return _swfResource; }
		
		public function get swf():Sprite { return _swf; }
		
		public function set swf( value:Sprite ):void 
		{
			_swf = value;
		}
	}
}