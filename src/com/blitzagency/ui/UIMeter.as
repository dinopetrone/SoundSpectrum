package com.blitzagency.ui 
{
	import com.blitzagency.ui.UIMovieClip;
	import com.blitzagency.ui.UITextField;
	import fl.motion.easing.Elastic;
	import fl.transitions.Tween;
	import flash.display.MovieClip;
	
	public class UIMeter extends UIMovieClip
	{
		public var fill			:MovieClip;
		public var percent		:UITextField;
		
		private var scaleTween	:Tween;
		private var textTween	:Tween;
		
		public function UIMeter() { };
		
		public function set value( value:Number ):void 
		{
			scaleTween = new Tween( fill, "scaleX", Elastic.easeOut, 0, value, 2, true );
			textTween = new Tween( this, "percentData", Elastic.easeOut, 0, value, 2, true );
		}
		
		public function set percentData( value:Number ):void
		{
			percent.text = String( Math.round( value * 100 ) ) + "%";
			percentShadow.text = String( Math.round( value * 100 ) ) + "%";
		}
	}
}