package com.blitzagency.fabric
{
	import com.blitzagency.ui.UIMovieClip;
	
	public class NavigationLayer
	{
		[Public]
		public var target       :UIMovieClip;
		public var index        :int;
		public var deeplinkName :String;
		
		public function NavigationLayer(target:UIMovieClip, index:int = 0, deeplinkName:String = null)
		{
			this.deeplinkName = deeplinkName;
			this.target = target;
			this.index = index;
		}
	}
}