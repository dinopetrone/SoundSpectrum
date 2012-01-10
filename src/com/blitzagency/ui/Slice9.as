package com.blitzagency.ui {
	
	import flash.display.MovieClip;
	
	public class Slice9 extends MovieClip {
		
		public var topLeft:MovieClip;
		public var top:MovieClip;
		public var topRight:MovieClip;
		public var left:MovieClip;
		public var middle:MovieClip;
		public var right:MovieClip;
		public var bottomLeft:MovieClip;
		public var bottom:MovieClip;
		public var bottomRight:MovieClip;
		
		public function Slice9() {
			width = width;
			height = height;
		}
		
		override public function get width():Number {
			return left.width + middle.width + right.width;
		}
		
		override public function set width(value:Number):void {
			topLeft.x = 0;
			topLeft.y = 0;
			top.x = topLeft.x + topLeft.width;
			top.y = topLeft.y;
			top.width = value - left.width - right.width;
			topRight.x = top.x + top.width;
			topRight.y = top.y;
			
			left.x = 0;
			left.y = topLeft.y + topLeft.height;
			middle.x = left.x + left.width;
			middle.y = left.y;
			middle.width = top.width;
			right.x = middle.x + middle.width;
			right.y = middle.y;
			
			bottomLeft.x = 0;
			bottomLeft.y = left.y + left.height;
			bottom.x = bottomLeft.x + bottomLeft.width;
			bottom.y = bottomLeft.y;
			bottom.width = top.width;
			bottomRight.x = bottom.x + bottom.width;
			bottomRight.y = bottom.y;
		}
		
		override public function get height():Number {
			return top.height + middle.height + bottom.height;
		}
		
		override public function set height(value:Number):void {
			topLeft.x = 0;
			topLeft.y = 0;
			top.x = topLeft.x + topLeft.width;
			top.y = topLeft.y;
			topRight.x = top.x + top.width;
			topRight.y = top.y;
			
			left.x = 0;
			left.y = topLeft.y + topLeft.height;
			left.height = value - top.height - bottom.height;
			middle.x = left.x + left.width;
			middle.y = left.y;
			middle.height = left.height;
			right.x = middle.x + middle.width;
			right.y = middle.y;
			right.height = left.height;
			
			bottomLeft.x = 0;
			bottomLeft.y = left.y + left.height;
			bottom.x = bottomLeft.x + bottomLeft.width;
			bottom.y = bottomLeft.y;
			bottomRight.x = bottom.x + bottom.width;
			bottomRight.y = bottom.y;
		}
		
	}
	
}