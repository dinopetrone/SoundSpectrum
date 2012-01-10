package com.blitzagency.ui 
{
	import caurina.transitions.Tweener;
	import flash.display.MovieClip;
	
	public class UILoaderProgress extends UIBase
	{
		public var animation:MovieClip;
		public var animationProgress:Number = 0;
		
		private var startedHiding:Boolean = false;
		private var isVisible:Boolean = true;
		
		public function UILoaderProgress() 
		{
			super();
			visible = false;
		}
		
		public function reset():void
		{
			animationProgress = 0;
			animation.gotoAndStop( 1 );
		}
		
		public function hide():void
		{
			isVisible = visible = false;
		}
		
		public function show():void
		{
			isVisible = true;
		}
		
		public function set progress( value:Number ):void
		{
			if ( isVisible ) {
				alpha = 1;
				visible = true;
			}
			startedHiding = false;
			Tweener.addTween( this, { animationProgress:value, time:.2, onUpdate:doAnimationGoto, transition:"easeinsine" } );
		}
		
		private function doAnimationGoto():void
		{
			animation.gotoAndStop( Math.ceil( animationProgress * animation.totalFrames ) );
			if ( animationProgress == 1 && !startedHiding ) {
				Tweener.addTween( this, { alpha:0, time:.2, onComplete:setVisibility, transition:"easeinsine" } );
				startedHiding = true;
			}
		}
		
		private function setVisibility():void
		{
			visible = false;
		}
	}
}