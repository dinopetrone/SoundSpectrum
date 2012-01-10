package com.blitzagency.ui {

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	
	public class UIDragAndDropManager extends EventDispatcher {
		
		public static const DRAG_COMPLETE:String = "dragComplete";
		
		private var list:UIList;
		public var selectedObject:InteractiveObject;
		private var selectedIndex:Number;
		private var copyBitmap:Bitmap;
		private var stage:Stage;
		private var dropTarget:InteractiveObject;
		private var dropTargetIndex:Number;
		private var dragging:Boolean;
		private var divider:DisplayObject;
		private var newIndex:Number;
		public var enabled:Boolean;
		
		private var startPoint:Point;
		
		public function UIDragAndDropManager(list:UIList) {
			this.list = list;
			var dividerBitmapData:BitmapData = new BitmapData(1, 100, false, 0x00000000);
			divider = new Bitmap(dividerBitmapData);
		}
		
		public function checkForDrag(event:MouseEvent):void {
			if (enabled) {
				selectedObject = event.currentTarget as InteractiveObject;
				selectedIndex = list.dataProvider.indexOf(selectedObject);
				dropTarget = selectedObject;
				dropTargetIndex = selectedIndex;
				stage = selectedObject.stage;
				startPoint = new Point(stage.mouseX, stage.mouseY);
				stage.addEventListener(MouseEvent.MOUSE_MOVE, watchDrag);
				stage.addEventListener(MouseEvent.MOUSE_UP, cancelDrag);
			}
		}
		
		private function watchDrag(event:MouseEvent):void {
			if (Math.abs(stage.mouseX - startPoint.x) > 10 || Math.abs(stage.mouseY - startPoint.y) > 10) {
				stage.removeEventListener(MouseEvent.MOUSE_MOVE, watchDrag);
				stage.removeEventListener(MouseEvent.MOUSE_UP, cancelDrag);
				startDrag();
			}
		}
		
		private function cancelDrag(event:MouseEvent):void {
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, watchDrag);
			stage.removeEventListener(MouseEvent.MOUSE_UP, cancelDrag);
		}
		
		private function startDrag():void {
			//trace("startDrag");
			var copyBitmapData:BitmapData = new BitmapData(selectedObject.width, selectedObject.height, true, 0x00000000);
			var colorTransform:ColorTransform = new ColorTransform(1, 1, 1, 0.5, 0, 0, 0, 0);
			copyBitmapData.draw(selectedObject, null, colorTransform);
			copyBitmap = new Bitmap(copyBitmapData);
			copyBitmap.x = stage.mouseX - copyBitmap.width / 2;
			copyBitmap.y = stage.mouseY - copyBitmap.height / 2;
			stage.addChild(copyBitmap);
			stage.addEventListener(Event.ENTER_FRAME, setIndex);
			stage.addEventListener(MouseEvent.MOUSE_UP, stopDrag);
			dragging = true;
			divider.rotation = 0;
			switch(list.align) {
				case UIList.HORIZONTAL:
					divider.height = selectedObject.height;
				break;
				case UIList.VERTICAL:
					divider.height = selectedObject.width;
				break;
			}
			list.addChild(divider);
			for (var i = 0; i < list.dataProvider.length; i++) {
				var object:InteractiveObject = list.dataProvider[i] as InteractiveObject;
				object.addEventListener(MouseEvent.ROLL_OVER, rollOverEvent);
			}
		}
		
		private function setIndex(event:Event):void {
			copyBitmap.x = stage.mouseX - copyBitmap.width / 2;
			copyBitmap.y = stage.mouseY - copyBitmap.height / 2;
			var mousePos:Number;
			switch(list.align) {
				case UIList.HORIZONTAL:
					divider.y = dropTarget.y;
					divider.rotation = 0;
					mousePos = list.mouseX - dropTarget.x;
					if (mousePos < dropTarget.width / 2) {
						newIndex = dropTargetIndex;
						divider.x = dropTarget.x - list.hSpace / 2;
					}else {
						newIndex = dropTargetIndex + 1;
						divider.x = dropTarget.x + dropTarget.width + list.hSpace / 2;
					}
				break;
				case UIList.VERTICAL:
					divider.x = dropTarget.x;
					divider.rotation = -90;
					mousePos = list.mouseY - dropTarget.y;
					if (mousePos < dropTarget.height / 2) {
						newIndex = dropTargetIndex;
						divider.y = dropTarget.y - list.vSpace / 2;
					}else {
						newIndex = dropTargetIndex + 1;
						divider.y = dropTarget.y + dropTarget.height + list.vSpace / 2;
					}
				break;
			}
			//trace("newIndex "+newIndex);
		}
		
		private function rollOverEvent(event:MouseEvent):void {
			dropTarget = event.target as InteractiveObject;
			dropTargetIndex = list.dataProvider.indexOf(dropTarget);
		}
		
		private function stopDrag(e:MouseEvent):void {
			
			stage.removeEventListener(Event.ENTER_FRAME, setIndex);
			stage.removeEventListener(MouseEvent.MOUSE_UP, stopDrag);
			stage.removeChild(copyBitmap);
			list.swapItems(selectedIndex, newIndex);
			list.removeChild(divider);
			//trace("stopDrag swapItems("+selectedIndex+", "+newIndex+")");
			for (var i = 0; i < list.dataProvider.length; i++) {
				var object:InteractiveObject = list.dataProvider[i] as InteractiveObject;
				object.removeEventListener(MouseEvent.ROLL_OVER, rollOverEvent);
			}
			
			dispatchEvent(new Event(DRAG_COMPLETE));
			
		}
		
	}
	
}