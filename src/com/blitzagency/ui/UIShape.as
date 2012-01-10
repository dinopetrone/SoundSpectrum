package com.blitzagency.ui {
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	
	public class UIShape extends UIBase {
		
		public var shape:MovieClip;
		
		public function UIShape() {
			super();
		}
		
		override public function get width():Number {
			return shape.width;
		}
		
		override public function set width(value:Number):void {
			shape.width = value;
		}
		
		override public function get height():Number {
			return shape.height;
		}
		
		override public function set height(value:Number):void {
			shape.height = value;
		}
		
		override public function get scaleX():Number {
			return shape.scaleX;
		}
		
		override public function set scaleX(value:Number):void {
			shape.scaleX = value;
		}
		
		override public function get scaleY():Number {
			return shape.scaleY;
		}
		
		override public function set scaleY(value:Number):void {
			shape.scaleY = value;
		}
		
		override public function get rotation():Number {
			return shape.rotation;
		}
		
		override public function set rotation(value:Number):void {
			shape.rotation = value;
		}
		
		override public function get x():Number {
			return shape.x;
		}
		
		override public function set x(value:Number):void {
			shape.x = value;
		}
		
		override public function get y():Number {
			return shape.y;
		}
		
		override public function set y(value:Number):void {
			shape.y = value;
		}
		
	}
	
}