package com.blitzagency.ui {
	
	import fl.transitions.easing.Strong;
	import fl.transitions.easing.Regular;
	import fl.transitions.easing.None;
	import fl.transitions.easing.Elastic;
	import fl.transitions.easing.Bounce;
	import fl.transitions.easing.Back;
	import fl.transitions.Tween;
	import fl.transitions.TweenEvent;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Point;
	
	public class UIWipe extends UIMovieClip {
		
		public static var TOP:String = "top";
		public static var LEFT:String = "left";
		public static var RIGHT:String = "right";
		public static var BOTTOM:String = "bottom";
		public static var TOP_LEFT:String = "topLeft";
		public static var TOP_RIGHT:String = "topRight";
		public static var BOTTOM_RIGHT:String = "bottomRight";
		public static var BOTTOM_LEFT:String = "bottomLeft";
		
		public var shape:MovieClip;
		
		public var timeIn:Number = 30;
		public var timeOut:Number = 30;
		public var edgeIn:String = LEFT;
		public var edgeOut:String = LEFT;
		public var easingIn:String = "Strong.easeOut";
		public var easingOut:String = "Strong.easeIn";
		
		private var equations:Object;
		
		private var tweenX:Tween;
		private var tweenY:Tween;
		
		
		public function UIWipe() {
			super();
			equations = new Object();
			
			equations.Strong = Strong;
			equations.Regular = Regular;
			equations.None = None;
			equations.Elastic = Elastic;
			equations.Bounce = Bounce;
			equations.Back = Back;
			
			shape.scaleX = 0;
			shape.scaleY = 0;
		}
		
		override public function transitionIn():void {
			var point:Point = getPoint(edgeIn);
			tweenX = new Tween(shape, "x", getEasing(easingIn), point.x, 75, timeOut, false);
			tweenX.addEventListener(TweenEvent.MOTION_FINISH, tweenInComplete);
			tweenY = new Tween(shape, "y", getEasing(easingIn), point.y, 75, timeOut, false);
			setSize(edgeIn);
		}
		
		private function tweenInComplete(e:TweenEvent):void {
			transitionInComplete();
		}
		
		override public function transitionOut():void {
			var point:Point = getPoint(edgeOut);
			tweenX = new Tween(shape, "x", getEasing(easingOut), 75, point.x, timeOut, false);
			tweenX.addEventListener(TweenEvent.MOTION_FINISH, tweenOutComplete);
			tweenY = new Tween(shape, "y", getEasing(easingOut), 75, point.y, timeOut, false);
			setSize(edgeOut);
		}
		
		private function tweenOutComplete(e:TweenEvent):void {
			shape.scaleX = 0;
			shape.scaleY = 0;
			transitionOutComplete();
		}
		
		private function setSize(value:String):void {
			switch(value) {
				case TOP:
				case LEFT:
				case RIGHT:
				case BOTTOM:
					shape.scaleX = 1;
					shape.scaleY = 1;
					shape.rotation = 0;
				break;
				case TOP_LEFT:
				case TOP_RIGHT:
				case BOTTOM_RIGHT:
				case BOTTOM_LEFT:
					shape.scaleX = 1.414;
					shape.scaleY = 1.414;
					shape.rotation = 45;
				break;
			}
		}
		
		private function getPoint(value:String):Point {
			var x:Number;
			var y:Number;
			switch(value) {
				case TOP:
					x = 75;
					y = -75;
				break;
				case LEFT:
					x = -75;
					y = 75;
				break;
				case RIGHT:
					x = 225;
					y = 75;
				break;
				case BOTTOM:
					x = 75;
					y = 225;
				break;
				case TOP_LEFT:
					x = -75;
					y = -75;
				break;
				case TOP_RIGHT:
					x = 225;
					y = -75;
				break;
				case BOTTOM_RIGHT:
					x = 225;
					y = 225;
				break;
				case BOTTOM_LEFT:
					x = -75;
					y = 225;
				break;
			}
			return new Point(x, y);
		}
		
		private function getEasing(value:String):Function{
			var array:Array = value.split(".");
			var func:Function = equations[array[0]][array[1]] as Function;
			return func;
		}
		
		override public function get width():Number {
			return scaleX * 150;
		}
		
		override public function set width(value:Number):void {
			scaleX = value / 150;
		}
		
	}
	
}