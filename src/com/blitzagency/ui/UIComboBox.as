package com.blitzagency.ui {
	
	import com.blitzagency.ui.UIButton;
	import com.blitzagency.ui.UIMovieClip;
	import flash.display.MovieClip;

	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import fl.transitions.Tween;
	import fl.transitions.easing.*;
	import fl.transitions.TweenEvent;
	
	public class UIComboBox extends UIMovieClip {
		
		private var listBoxTween:Tween;
		public var button:UIButton;
		public var listBox:UIListBox;
		public var listBoxMask:MovieClip;
		public var updateButtonOnChange:Boolean = true;
		protected var _openingMethod:String;
		protected var _listAlign:String;
		
		public static var CENTER:String = "center";
		public static var LEFT:String = "left";
		public static var RIGHT:String = "right";
		
		public function UIComboBox() {
			super();
			listBoxMask.visible = false;
			listBox.y = -listBox.height + button.height;
			listBox.addEventListener(Event.CHANGE, listBoxChange);
			listBox.mask = listBoxMask;
			height = button.height;
			width = button.width;
			maxHeight = Number.MAX_VALUE;
			openingMethod = MouseEvent.CLICK;
			listAlign = LEFT;
		}
		
		public function set openingMethod(value:String):void {
			_openingMethod = value;
			switch(_openingMethod) {
				case MouseEvent.CLICK:
					button.removeEventListener(MouseEvent.ROLL_OVER, buttonEvent);
					button.addEventListener(MouseEvent.CLICK, buttonEvent);
				break;
				case MouseEvent.ROLL_OVER:
					button.removeEventListener(MouseEvent.CLICK, buttonEvent);
					button.addEventListener(MouseEvent.ROLL_OVER, buttonEvent);
				break;
			}
		}
		
		protected function buttonEvent(event:MouseEvent):void {
			open();
		}
		
		public function get openingMethod():String {
			return _openingMethod;
		}
		
		public function set dataProvider(value:Array):void {
			listBox.dataProvider = value;
			maxHeight = maxHeight;
		}
		
		public function get dataProvider():Array {
			return listBox.dataProvider;
		}
		
		private function listBoxChange(event:Event):void {
			if (button.selected) {
				close();
			}
			if (updateButtonOnChange) {
				updateButton();
			}
			dispatchEvent(event);
		}
		
		protected function updateButton():void {
			button.label = selectedData[listBox.labelField];
			button.data = selectedData;
		}
		
		public function open():void {
			if (!button.selected) {
				button.selected = true;
				listBoxTween = new Tween(listBox, "y", Strong.easeOut, listBox.y, button.height, 16, false);
				switch(_openingMethod) {
					case MouseEvent.CLICK:
						stage.addEventListener(MouseEvent.CLICK, stageMouseUpEvent);
					break;
					case MouseEvent.ROLL_OVER:
						addEventListener(Event.ENTER_FRAME, checkMouse);
					break;
				}
			}
		}
		
		private function checkMouse(event:Event):void {
			if (mouseY < button.y + button.height) {
				if (mouseX < button.x || mouseX > button.width + button.x || mouseY < button.y) {
					close();
				}
			} else {
				if (mouseX < listBox.x || mouseX > listBox.width + listBox.x || mouseY > listBox.y + listBox.height) {
					close();
				}
			}
		}
		
		public function close():void {
			button.selected = false;
			stage.removeEventListener(MouseEvent.CLICK, stageMouseUpEvent);
			removeEventListener(Event.ENTER_FRAME, checkMouse);
			listBoxTween = new Tween(listBox, "y", Strong.easeOut, listBox.y, button.y + button.height - listBox.height, 16, false);
		}
		
		private function stageMouseUpEvent(event:MouseEvent):void {
			if (mouseX < 0 || mouseX > width || mouseY <0 || mouseY > button.height + listBox.height) {
				close();
			}
		}
		
		public function set selectedIndex(value:Number):void {
			listBox.selectedIndex = value;
			updateButton();
		}
		
		public function get selectedIndex():Number {
			return listBox.selectedIndex;
		}
		
		public function set selectedData(value:Object):void {
			listBox.selectedData = value;
			updateButton();
		}
		
		public function get selectedData():Object {
			return listBox.selectedData;
		}
		
		override public function get width():Number {
			return button.width;
		}
		
		override public function set width(value:Number):void {
			button.width = value;
			listBox.width = value;
			listBoxMask.width = value;
			listAlign = listAlign;
		}
		
		override public function get height():Number {
			return button.height;
		}
		
		override public function set height(value:Number):void {
			button.height = value;
			listBoxMask.y = value;
			if (!button.selected) {
				listBox.y = -listBox.height + button.height;
			}
		}
		
		public function set maxHeight(value:Number):void {
			listBox.maxHeight = value;
			listBoxMask.height = listBox.height;
			if (!button.selected) {
				listBox.y = button.y + button.height - listBox.height;
			}
		}
		
		public function get maxHeight():Number {
			return listBox.maxHeight;
		}
		
		public function set listAlign(value:String):void {
			_listAlign = value;
			switch(value) {
				case CENTER:
					listBox.x = (button.x + button.width/2) - listBox.width / 2;
					listBoxMask.x = (button.x + button.width/2) - listBoxMask.width / 2;
				break;
				case LEFT:
					listBox.x = button.x;
					listBoxMask.x = button.x;
				break;
				case RIGHT:
					listBox.x = button.x + button.width - listBox.width;
					listBoxMask.x = button.x + button.width - listBoxMask.width;
				break;
			}
		}
		
		public function get listAlign():String {
			return _listAlign
		}
		
		public function set cellRenderer(value:Class):void {
			listBox.cellRenderer = value;
		}
		
		public function get cellRenderer():Class {
			return listBox.cellRenderer;
		}
		
	}
	
}