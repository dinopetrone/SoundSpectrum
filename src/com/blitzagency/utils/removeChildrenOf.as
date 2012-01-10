package com.blitzagency.utils
{
	import com.blitzagency.ui.UIBase;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	public function removeChildrenOf(target:*, recursive:Boolean = false, stop:Boolean = true):void
	{
		if (target is Sprite)
		{
			if (target is MovieClip) MovieClip(target).stop();
			
			var len:int = Sprite(target).numChildren;
			for ( var i:int = 0; i < len; i++ ) 
			{
				var child:* = Sprite(target).removeChildAt(0);
				
				if (child is MovieClip && stop) MovieClip(child).stop();
				if (child is UIBase) UIBase(child).destroy();
				if (recursive) removeChildrenOf(child);
			}
		}
	} 
}