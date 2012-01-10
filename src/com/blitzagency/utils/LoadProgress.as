package com.blitzagency.utils 
{
	import flash.display.MovieClip;
	
	public class LoadProgress 
	{
		public static const COMPLETE:String = "loadComplete";
		
		public var target    :MovieClip;
		public var progress  :Number = 0;
		public var completed :Boolean = false;
		
		public function LoadProgress( target:MovieClip ):void
		{
			this.target = target;
		}
	}
}