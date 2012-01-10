package com.blitzagency.ui
{
	import fl.transitions.Tween;
	import fl.transitions.easing.*;
	
	import flash.display.DisplayObject;
	
	public class TargetTransform
	{
		public var x:Number;
		public var y:Number;
		public var width:Number;
		public var height:Number;
		public var rotation:Number;
		
		public function TargetTransform(object:DisplayObject)
		{
			this.x = object.x;
			this.y = object.y;
			this.width = object.width;
			this.height = object.height;
			this.rotation = object.rotation;
		}
		
		/* Apply the transform information in this VO to a target  */
		public function applyTo(object:DisplayObject):void{
		
			object.x = x;
			object.y = y;
			object.width = width;
			object.height = height;
			object.rotation = rotation;
			
		}
		
		/* Apply the transform information in this VO to a target  */
		public function tweenTo(object:DisplayObject,duration:Number=.25):void{
			
			var xTween:Tween = new Tween(object,"x", Strong.easeOut, object.x, x, duration, true);
			var yTween:Tween = new Tween(object,"y", Strong.easeOut, object.y, y, duration, true);
			var wTween:Tween = new Tween(object,"width", Strong.easeOut, object.width, width, duration, true);
			var hTween:Tween = new Tween(object,"height", Strong.easeOut, object.height, height, duration, true);		
			var rTween:Tween = new Tween(object,"rotation", Strong.easeOut, object.rotation, rotation, duration, true);
			
		}

	}
}