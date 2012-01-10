package com.blitzagency.ui {
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.ui.Mouse;
	
	public class BoundingBox extends Sprite {
		
		public static const TRANSFORM_START:String = "transformStart";
		public static const TRANSFORM_END:String = "transformEnd";
		
		public static const TRANSFORM_SHOW_BOX:String = "showBox";
		public static const TRANSFORM_HIDE_BOX:String = "hideBox";
		
		private var target:DisplayObject;
		
		private var topLeft:MovieClip;
		private var top:MovieClip;
		private var topRight:MovieClip;
		private var right:MovieClip;
		private var bottomLeft:MovieClip;
		private var bottom:MovieClip;
		private var bottomRight:MovieClip;
		private var left:MovieClip;
		
		private var topLeftRotation:MovieClip;
		private var topRotation:MovieClip;
		private var topRightRotation:MovieClip;
		private var rightRotation:MovieClip;
		private var bottomLeftRotation:MovieClip;
		private var bottomRotation:MovieClip;
		private var bottomRightRotation:MovieClip;
		private var leftRotation:MovieClip;
		
		private var resizeWidth:Boolean;
		private var resizeHeight:Boolean;
		private var move:String;
		
		private var targetTransform:TargetTransform;
		private var borderLeft:MovieClip = new BorderVertical();
		private var borderTop:MovieClip = new BorderHorizontal();
		private var borderRight:MovieClip = new BorderVertical();
		private var borderBottom:MovieClip = new BorderHorizontal();
		private var dragPoint:Point;
		
		private var scaleXFactor:Number = 1;
		private var scaleYFactor:Number = 1;
		
		private var registrationPoint:MovieClip = new RegistrationPoint();
		
		private var rotationHandles:Sprite = new Sprite();
		private var resizeHandles:Sprite = new Sprite();
		
		private var iconResize:MovieClip = new IconResize();
		private var iconMove:MovieClip = new IconMove();
		private var iconRotate:MovieClip = new IconRotate();
		private var cursor:MovieClip;
		
		private var mouseIsDown:Boolean;
		private var shiftIsDown:Boolean;
		
		public function BoundingBox(target:DisplayObject) {
			this.target = target;
			
			iconResize.mouseEnabled = false;
			iconResize.mouseChildren = false;
			iconMove.mouseEnabled = false;
			iconMove.mouseChildren = false;
			iconRotate.mouseEnabled = false;
			iconRotate.mouseChildren = false;
			
			addChild(rotationHandles);
			addChild(target);
			addChild(resizeHandles);
			hideBox();
			var borders:Array = new Array(borderLeft, borderTop, borderRight, borderBottom);
			for (var j = 0; j < borders.length; j++) {
				var border:MovieClip = borders[j] as MovieClip;
				border.addEventListener(MouseEvent.MOUSE_DOWN, startDragPosition);
				border.addEventListener(MouseEvent.ROLL_OVER, changeMouse);
				border.addEventListener(MouseEvent.ROLL_OUT, resetMouse);
				resizeHandles.addChild(border);
			}
			
			var handles:Array = new Array("topLeft", "top", "topRight", "right", "bottomRight", "bottom", "bottomLeft", "left");
			for (var i = 0; i < handles.length; i++) {
				var rotationHandle:MovieClip = new RotationHandle();
				rotationHandle.addEventListener(MouseEvent.MOUSE_DOWN, startRotation);
				rotationHandle.addEventListener(MouseEvent.ROLL_OVER, changeMouse);
				rotationHandle.addEventListener(MouseEvent.ROLL_OUT, resetMouse);
				rotationHandles.addChild(rotationHandle);
				this[handles[i]+"Rotation"] = rotationHandle;
				
				var handle:Handle = new Handle();
				handle.addEventListener(MouseEvent.MOUSE_DOWN, startResize);
				handle.addEventListener(MouseEvent.ROLL_OVER, changeMouse);
				handle.addEventListener(MouseEvent.ROLL_OUT, resetMouse);
				resizeHandles.addChild(handle);
				this[handles[i]] = handle;
			}
			
			resizeHandles.addChild(registrationPoint);
			registrationPoint.addEventListener(MouseEvent.MOUSE_DOWN, startDragPosition);
			registrationPoint.addEventListener(MouseEvent.ROLL_OVER, changeMouse);
			registrationPoint.addEventListener(MouseEvent.ROLL_OUT, resetMouse);
			
			addEventListener(MouseEvent.MOUSE_DOWN, mouseDownEvent);
			
			addEventListener(Event.ADDED_TO_STAGE, addedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, removedFromStage);
			
		}
		
		private function addedToStage(event:Event):void{
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownEvent);
			stage.addEventListener(KeyboardEvent.KEY_UP, keyUpEvent);
		}
		
		private function removedFromStage(event:Event):void{
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, keyDownEvent);
			stage.removeEventListener(KeyboardEvent.KEY_UP, keyUpEvent);
		}
		
		private function changeMouse(event:MouseEvent):void {
			if (mouseIsDown) {
				return;
			}
			Mouse.hide();
			switch(event.target) {
				case borderLeft:
				case borderTop:
				case borderRight:
				case borderBottom:
				case registrationPoint:
					cursor = iconMove;
				break;
				case topLeftRotation:
				case topRotation:
				case topRightRotation:
				case rightRotation:
				case bottomLeftRotation:
				case bottomRotation:
				case bottomRightRotation:
				case leftRotation:
					cursor = iconRotate;
				break;
				case topLeft:
				case bottomRight:
					cursor = iconResize;
					iconResize.rotation = 45;
				break;
				case topRight:
				case bottomLeft:
					cursor = iconResize;
					iconResize.rotation = -45;
				break;
				case top:
				case bottom:
					cursor = iconResize;
					iconResize.rotation = 90;
				break;
				case right:
				case left:
					cursor = iconResize;
					iconResize.rotation = 0;
				break;
			}
			stage.addChild(cursor);
			cursor.x = stage.mouseX;
			cursor.y = stage.mouseY;
			addEventListener(Event.ENTER_FRAME, updateCursor);
		}
		
		private function updateCursor(event:Event):void {
			cursor.x = stage.mouseX;
			cursor.y = stage.mouseY;
		}
		
		private function resetMouse(event:MouseEvent):void {
			if (mouseIsDown) {
				return;
			}
			removeEventListener(Event.ENTER_FRAME, updateCursor);
			if(cursor){
				stage.removeChild(cursor);
			}
			cursor = null;
			Mouse.show();
		}
		
		protected function mouseDownEvent(event:MouseEvent):void {
			showBox();
		}
		
		protected function keyDownEvent(event:KeyboardEvent):void{		
			if ( event.keyCode == 16 ){
				shiftIsDown=true;			
			}			
		}
		
		protected function keyUpEvent(event:KeyboardEvent):void{		
			if ( event.keyCode == 16 ){
				shiftIsDown=false;			
			}		
		}
			
		public function showBox():void {
			
			dispatchEvent( new Event( TRANSFORM_SHOW_BOX ));

			width = width;
			height = height;
			resizeHandles.visible = true;
			rotationHandles.visible = true;
		}
		
		public function hideBox():void {
			
			dispatchEvent( new Event( TRANSFORM_HIDE_BOX ));
			
			resizeHandles.visible = false;
			rotationHandles.visible = false;
			
		}
		
		public override function set width(value:Number):void {
			
			//Round value up to prevent any sub-pixel transformation
			value = Math.max(0, value);
			
			target.width = value;
			
			//Move borders and handles to match new width
			top.x = width / 2;
			topRight.x = width;
			right.x = width;
			bottomRight.x = width;
			bottom.x = width / 2;
			borderTop.width = width;
			borderRight.x = width;
			borderBottom.width = width;
			
			topRotation.x = width / 2;
			topRightRotation.x = width;
			rightRotation.x = width;
			bottomRightRotation.x = width;
			bottomRotation.x = width / 2;
			
			registrationPoint.x = value / 2;
		}
		
		public override function get width():Number {
			return target.width;
		}
		
		public override function set height(value:Number):void {
			value = Math.max(0, value);
			target.height = value;
			
			right.y = height / 2;
			bottomRight.y = height;
			bottom.y = height;
			bottomLeft.y = height;
			left.y = height / 2;
			borderLeft.height = height;
			borderRight.height = height;
			borderBottom.y = height;
			
			rightRotation.y = height / 2;
			bottomRightRotation.y = height;
			bottomRotation.y = height;
			bottomLeftRotation.y = height;
			leftRotation.y = height / 2;
			
			registrationPoint.y = height / 2;
		}
		
		public override function get height():Number {
			return target.height;
		}
		
		private function startResize(event:MouseEvent):void {
			
			dispatchEvent( new Event(TRANSFORM_START) );			
			
			mouseIsDown = true;
			dragPoint = new Point(parent.mouseX, parent.mouseY);
			switch(event.target) {
				case topLeft:
					scaleXFactor = -1;
					scaleYFactor = -1;
					resizeWidth = true;
					resizeHeight = true;
					move = "xy";
				break;
				case top:
					scaleXFactor = 1;
					scaleYFactor = -1;
					resizeWidth = false;
					resizeHeight = true;
					move = "y";
				break;
				case topRight:
					scaleXFactor = 1;
					scaleYFactor = -1;
					resizeWidth = true;
					resizeHeight = true;
					move = "y";
				break;
				case right:
					scaleXFactor = 1;
					scaleYFactor = 1;
					resizeWidth = true;
					resizeHeight = false;
					move = "none";
				break;
				case bottomRight:
					scaleXFactor = 1;
					scaleYFactor = 1;
					resizeWidth = true;
					resizeHeight = true;
					move = "none";
				break;
				case bottom:
					scaleXFactor = 1;
					scaleYFactor = 1;
					resizeWidth = false;
					resizeHeight = true;
					move = "none";
				break;
				case bottomLeft:
					scaleXFactor = -1;
					scaleYFactor = 1;
					resizeWidth = true;
					resizeHeight = true;
					move = "x";
				break;
				case left:
					scaleXFactor = -1;
					scaleYFactor = 1;
					resizeWidth = true;
					resizeHeight = false;
					move = "x";
				break;
			}
			targetTransform = new TargetTransform(this);
			stage.addEventListener(Event.ENTER_FRAME, enterFrameEvent);
			stage.addEventListener(MouseEvent.MOUSE_UP, stopResize);
		}
		
		private function enterFrameEvent(event:Event):void {
			
			var radians:Number = Math.atan2((parent.mouseY - dragPoint.y), (parent.mouseX - dragPoint.x));
			var degrees:Number = radians * 180 / Math.PI ;
			degrees -= rotation;
			var xPos:Number = parent.mouseX - dragPoint.x;
			var yPos:Number = parent.mouseY - dragPoint.y;
			var radius:Number = Math.sqrt(xPos * xPos + yPos * yPos);
			var radians2:Number = degrees * (Math.PI / 180);		
			
			var xOffset:Number = radius * Math.cos(radians2);
			var yOffset:Number = radius * Math.sin(radians2);
			
			var constrainedOffset:Number = radius / Math.sqrt(2);
			//trace(" xPos:"+xPos);
			//trace(" yPos:"+yPos);
			
			//Resize with constrained proportions when shift key is down
			if (resizeWidth && resizeHeight && shiftIsDown ) {				
				
				//TODO: better way to do this? This causes a hitch in transitioning from expand to contract
				//Need to detect if we are expanding or contracting. We can use angles for that.
				var scale:int=-1;
				if ( scaleXFactor == -1 && scaleYFactor == -1 && ( degrees < -45 || degrees > 135 )  ||
					scaleXFactor == 1 && scaleYFactor == -1 && degrees > -135 && degrees < 45  ||
					scaleXFactor == 1 && scaleYFactor == 1 && degrees > -45 && degrees < 135 ||
					scaleXFactor == -1 && scaleYFactor == 1 && degrees > -135 && degrees > 45 ) scale = 1;
					
				width = targetTransform.width + scale * constrainedOffset;
				height = targetTransform.height + scale * constrainedOffset;		
				
			} else {
				
				if (resizeWidth) {
					width = targetTransform.width + xOffset * scaleXFactor;
					if (!resizeHeight) {
						height=height;
					}
				}
				
				if (resizeHeight) {
					height = targetTransform.height + yOffset * scaleYFactor;
					if (!resizeWidth) {
						width = width;
					}
				} 
				
			}
			
			var radiansX:Number = rotation * Math.PI / 180;
			var radiansY:Number = (rotation - 90) * Math.PI / 180;
			var xMove:Number = 0;
			var yMove:Number = 0;
			
			//trace("degrees: "+degrees);
			
			if ( shiftIsDown ){
				switch(move) {
					case "x":
						xMove = constrainedOffset * Math.cos(radiansX);
						yMove = constrainedOffset * Math.sin(radiansX);
					break;
					case "y":
						xMove = constrainedOffset * Math.cos(radiansY) * -1;
						yMove = constrainedOffset * Math.sin(radiansY) * -1;
					break;
					case "xy":
						var radians3:Number = ( rotation + 45 ) * (Math.PI / 180);						
						xMove = Math.cos( radians3 ) * constrainedOffset * Math.SQRT2;
						yMove = Math.sin( radians3 ) * constrainedOffset * Math.SQRT2;				
					break;
				}
				
				xMove = xMove * -scale;
				yMove = yMove * -scale;

			} else {
				
				switch(move) {
					case "x":
						xMove = xOffset * Math.cos(radiansX);
						yMove = xOffset * Math.sin(radiansX);
					break;
					case "y":
						xMove = yOffset * Math.cos(radiansY) * -1;
						yMove = yOffset * Math.sin(radiansY) * -1;
					break;
					case "xy":
						xMove = xPos;
						yMove = yPos;								
					break;
				}
				
			}
			
			x  = targetTransform.x + xMove;
			y  = targetTransform.y + yMove;
		}
		
		private function stopResize(event:MouseEvent):void {
			stage.removeEventListener(Event.ENTER_FRAME, enterFrameEvent);
			stage.removeEventListener(MouseEvent.MOUSE_UP, stopResize);
			mouseIsDown = false;
			resetMouse(event);		
			dispatchEvent( new Event(TRANSFORM_END) );
		}
		
		private function startDragPosition(event:MouseEvent):void {
			
			dispatchEvent( new Event(TRANSFORM_START) );		
			
			mouseIsDown = true;
			dragPoint = new Point(parent.mouseX, parent.mouseY);
			targetTransform = new TargetTransform(this);
			stage.addEventListener(Event.ENTER_FRAME, dragPosition);
			stage.addEventListener(MouseEvent.MOUSE_UP, stopDragPosition);
		}
		
		private function dragPosition(event:Event):void {
			//trace("dragPosition x " + (targetTransform.x + (parent.mouseX - dragPoint.x)));
			//trace("dragPosition y " + (targetTransform.y + (parent.mouseY - dragPoint.y)));
			x = targetTransform.x + (parent.mouseX - dragPoint.x);
			y = targetTransform.y + (parent.mouseY - dragPoint.y);
		}
		
		private function stopDragPosition(event:MouseEvent):void {
			//trace("stopDragPosition " + stage);
			mouseIsDown = false;
			stage.removeEventListener(Event.ENTER_FRAME, dragPosition);
			stage.removeEventListener(MouseEvent.MOUSE_UP, stopDragPosition);
			resetMouse(event);
			dispatchEvent( new Event(TRANSFORM_END) );
		}
		
		private function startRotation(event:MouseEvent):void {			
			dispatchEvent( new Event(TRANSFORM_START) );			
			mouseIsDown = true;
			dragPoint = new Point(parent.mouseX, parent.mouseY);
			targetTransform = new TargetTransform(this);
			stage.addEventListener(Event.ENTER_FRAME, rotatePosition);
			stage.addEventListener(MouseEvent.MOUSE_UP, stopRotation);
		}
		
		private function rotatePosition(event:Event):void {
			var radians:Number = Math.atan2(height / 2, width / 2);
			
			var degrees:Number = radians * 180 / Math.PI + targetTransform.rotation;
			
			var radius:Number = Math.sqrt((width/2) * (width/2) + (height/2) * (height/2));
			var centerPoint:Point = Point.polar(radius , degrees * Math.PI / 180);
			centerPoint.x = centerPoint.x + targetTransform.x;
			centerPoint.y = centerPoint.y + targetTransform.y;
			
			var startRadians:Number = Math.atan2((dragPoint.y - centerPoint.y), (dragPoint.x - centerPoint.x));
			var startDegrees:Number = startRadians * 180 / Math.PI ;
			var currentRadians:Number = Math.atan2((parent.mouseY - centerPoint.y), (parent.mouseX - centerPoint.x));
			var currentDegrees:Number = currentRadians * 180 / Math.PI ;
			
			if ( shiftIsDown ){
				var snapDegrees:int = Math.round(targetTransform.rotation - startDegrees + currentDegrees);
				snapDegrees -= snapDegrees % 15;
				rotation = snapDegrees;
			} else {
				rotation = Math.round(targetTransform.rotation - startDegrees + currentDegrees);
			}
			
			
			//trace("Rotation: "+rotation);
			
			var degrees2:Number = radians * 180 / Math.PI + rotation;
			var centerPoint2:Point = Point.polar(radius , degrees2 * Math.PI / 180);
			centerPoint2.x = centerPoint2.x + x;
			centerPoint2.y = centerPoint2.y + y;
			
			x += centerPoint.x - centerPoint2.x;
			y += centerPoint.y - centerPoint2.y;
		}
		
		private function stopRotation(event:MouseEvent):void {
			mouseIsDown = false;
			stage.removeEventListener(Event.ENTER_FRAME, rotatePosition);
			stage.removeEventListener(MouseEvent.MOUSE_UP, stopRotation);
			resetMouse(event);		
			dispatchEvent( new Event(TRANSFORM_END) );		
		}

	}
	
}