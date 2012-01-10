package com.blitzagency.fabric
{
	import com.blitzagency.fabric.assets.AssetLoader;
	import com.blitzagency.fabric.assets.SequentialAssetLoader;
	import com.blitzagency.fabric.assets.Transition;
	import com.blitzagency.fabric.Navigation;
	import com.blitzagency.ui.UIMovieClip;
	import com.blitzagency.ui.UIMovieClipState;
	
	public class LayeredNavigation extends Navigation
	{
		[Public]
		public var layers :Array;
		
		[Private]
		
		[Getters_Setters]
		
		[Stage]
		
		public function LayeredNavigation(  )
		{
			super();
			init();
		}
		
		protected function init():void 
		{
			layers = [];
		}
		
		override protected function findTransitionInPages():void 
		{
			super.findTransitionInPages();
			
			var deeplinks :Array = deepLink.split("/");
			var len       :uint = layers.length;
			
			for ( var i:int = 0; i < len; i++ ) 
			{
				var navLayer:NavigationLayer = layers[i];
				for ( var ii:int = 0; ii < deeplinks.length; ii++ ) 
				{
					if (navLayer.deeplinkName == deeplinks[ii])
					{
						if (navLayer.target.state != UIMovieClipState.TRANSITION_IN)
						{
							var page:Page = new Page(navLayer.target, navLayer.target.name);
							
							page.show = new SequentialAssetLoader();
							page.load = new SequentialAssetLoader();
							page.hide = new SequentialAssetLoader();
							
							AssetLoader(page.show).push(new Transition(navLayer.target, "transitionIn", ""));
							transitionInPages.push(page);
						}
					}
				}
			}
		}
		
		override protected function findTransitionOutPages():void 
		{
			super.findTransitionOutPages();
			var len:uint = layers.length;
			for ( var i:int = 0; i < len; i++ ) 
			{
				var navLayer:NavigationLayer = layers[i];
				if (navLayer.target.state == UIMovieClipState.TRANSITION_IN)
				{
					var page:Page = new Page(navLayer.target, navLayer.target.name);
					
					page.show = new SequentialAssetLoader();
					page.load = new SequentialAssetLoader();
					page.hide = new SequentialAssetLoader();
					
					AssetLoader(page.hide).push(new Transition(navLayer.target, "transitionOut", ""));
					transitionOutPages.push(page);
				}
			}
		}
		
		public function addLayer(target:UIMovieClip, index:int = 0, deeplinkName:String = null):NavigationLayer
		{
			if (getLayer(target)) return null;
			
			var navLayer:NavigationLayer = new NavigationLayer(target, index, deeplinkName);
			var len:uint = layers.length;
			for ( var i:uint = 0; i < len; i++ ) 
			{
				if (navLayer.index > layers[i].index)
				{
					layers.splice(i, 0, navLayer);
					return navLayer;
				}
			}
			layers.unshift(navLayer);
			return navLayer;
		}
		
		public function removeLayer(target:UIMovieClip):NavigationLayer
		{
			var layer:NavigationLayer = getLayer(target);
			if (layer)
			{
				return layers.splice(layers.indexOf(layer), 1);
			}
			return null;
		}
		
		private function getLayer(target:UIMovieClip):NavigationLayer
		{
			var len:uint = layers.length;
			for ( var i:int = 0; i < len; i++ ) 
			{
				if (layers[i].target == target) return layers[i];
			}
			return null;
		}
	}
}