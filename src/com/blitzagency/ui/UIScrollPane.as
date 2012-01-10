package com.blitzagency.ui {
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	public class UIScrollPane extends UIMovieClip {
		
		public var thumb:MovieClip;
		public var verticalScrollBar:UIScrollBar;
		public var horizontalScrollBar:UIScrollBar;
		public var contentMask:DisplayObject;
		public var background:DisplayObject;
		
		private var _content:DisplayObject;
		private var _resizeable:Boolean;
		private var _height:Number;
		private var _width:Number;
		
		private var startDragPoint:Point;
		private var startDragWidth:Number;
		private var startDragHeight:Number;
		private var scrollAxis:String = "none";
		
		public function UIScrollPane() {
			super();
			contentMask.visible = false;
			horizontalScrollBar.addEventListener(Event.CHANGE, horizontalScrollHandler);
			verticalScrollBar.addEventListener(Event.CHANGE, verticalScrollHandler);
			horizontalScrollBar.scrollUnit = 30;
			verticalScrollBar.scrollUnit = 30;
			contentMask.x = 0;
			contentMask.y = 0;
			thumb.mouseEnabled = false;
			height = verticalScrollBar.height + thumb.height;
			width = horizontalScrollBar.height + thumb.width;
		}
		
		public function set content(value:DisplayObject):void {
			if(content){
				content.removeEventListener(MouseEvent.MOUSE_WHEEL, verticalScrollBar.scrollWheel);
				//content.removeEventListener(MouseEvent.MOUSE_WHEEL, horizontalScrollBar.scrollWheel);
				content.mask = null;
				removeChild(content);
				_content = null;
			}
			if (value) {
				_content = value;
				content.mask = contentMask;
				content.addEventListener(MouseEvent.MOUSE_WHEEL, verticalScrollBar.scrollWheel);
				//content.addEventListener(MouseEvent.MOUSE_WHEEL, horizontalScrollBar.scrollWheel);
				addChildAt(content, 0);
				if (background) {
					swapChildren(content, background);
				}
			}
			horizontalScrollBar.scroll = 0;
			verticalScrollBar.scroll = 0;
			update();
		}
		
		public function get content():DisplayObject {
			return _content;
		}
		
		private function verticalScrollHandler(event:Event):void {
			if (content) {
				content.y = -event.target.scroll;
			}
		}
		
		private function horizontalScrollHandler(event:Event):void {
			if (content) {
				content.x = -event.target.scroll;
			}
		}
		
		public override function set width(value:Number):void {
			_width = value;
			if (background) {
				background.width = width;
			}
			update();
			dispatchEvent(new Event(Event.RESIZE));
		}
		
		public override function get width():Number {
			return _width;
		}
		
		public override function set height(value:Number):void {
			_height = value;
			if (background) {
				background.height = height;
			}
			update();
			dispatchEvent(new Event(Event.RESIZE));
		}
		
		public override function get height():Number {
			return _height;
		}
		
		public function update():void {
			if (content) {
				if (width >= content.width) {
					scrollAxis = "height";
				} else {
					scrollAxis = "auto";
				}
				if (height >= content.height) {
					if(scrollAxis == "auto"){
						scrollAxis = "width";
					}else {
						scrollAxis = "none";
					}
				}
				if (scrollAxis == "height") {
					if (width - thumb.width < content.width) {
						scrollAxis = "auto";
					}
				}
				if (scrollAxis == "width") {
					if (height - thumb.height < content.height) {
						scrollAxis = "auto";
					}
				}
				switch(scrollAxis) {
					case "width":
						updateWidth();
					break;
					case "height":
						updateHeight();
					break;
					case "auto":
						updateAuto();
					break;
					case "none":
						updateNone();
					break;
				}
				horizontalScrollBar.maxScroll = content.width - contentMask.width;
				horizontalScrollBar.scrollPageUnit = contentMask.width;
				horizontalScrollBar.scroll = -content.x;
				
				verticalScrollBar.maxScroll = content.height - contentMask.height;
				verticalScrollBar.scrollPageUnit = contentMask.height;
				verticalScrollBar.scroll = -content.y;
			} else {
				updateNone();
			}
			//dispatchEvent(new Event(Event.CHANGE));
		}
		
		public function updateWidth():void {
			verticalScrollBar.visible = false;
			horizontalScrollBar.visible = true;
			
			if (resizeable) {
				horizontalScrollBar.height = width - thumb.width;
				thumb.visible = true;
				contentMask.width = horizontalScrollBar.height + thumb.width;
			}else {
				horizontalScrollBar.height = width;
				thumb.visible = false;
				contentMask.width = horizontalScrollBar.height;
			}
			contentMask.height = height - thumb.height;
			
			horizontalScrollBar.x = 0;
			horizontalScrollBar.y = height;
			verticalScrollBar.x = width - verticalScrollBar.width;
			verticalScrollBar.y = 0;
			thumb.x = horizontalScrollBar.height;
			thumb.y = height - thumb.height;
		}
		
		public function updateHeight():void {
			verticalScrollBar.visible = true;
			horizontalScrollBar.visible = false;
			
			if (resizeable) {
				verticalScrollBar.height = height - thumb.height;
				thumb.visible = true;
				contentMask.height = verticalScrollBar.height + thumb.height;
			}else {
				verticalScrollBar.height = height;
				thumb.visible = false;
				contentMask.height = verticalScrollBar.height;
			}
			contentMask.width = width - thumb.width;
			
			horizontalScrollBar.x = 0;
			horizontalScrollBar.y = height;
			verticalScrollBar.x = width - verticalScrollBar.width;
			verticalScrollBar.y = 0;
			thumb.x = width - thumb.width;
			thumb.y = verticalScrollBar.height;
		}
		
		private function updateAuto():void {
			verticalScrollBar.visible = true;
			horizontalScrollBar.visible = true;
			thumb.visible = true;
			
			horizontalScrollBar.height = width - thumb.width;
			verticalScrollBar.height = height - thumb.height;
			
			contentMask.width = horizontalScrollBar.height;
			contentMask.height = verticalScrollBar.height;
			
			horizontalScrollBar.x = 0;
			horizontalScrollBar.y = verticalScrollBar.height + thumb.height;
			verticalScrollBar.x = horizontalScrollBar.height;
			verticalScrollBar.y = 0;
			thumb.x = horizontalScrollBar.height;
			thumb.y = verticalScrollBar.height;
		}
		
		private function updateNone():void {
			if (resizeable) {
				thumb.visible = true;
			}else {
				thumb.visible = false;
			}
			
			verticalScrollBar.visible = false;
			horizontalScrollBar.visible = false;
			
			contentMask.width = width;
			contentMask.height = height;
			
			horizontalScrollBar.x = 0;
			horizontalScrollBar.y = height;
			verticalScrollBar.x = width - verticalScrollBar.width;
			verticalScrollBar.y = 0;
			thumb.x = width - thumb.width;
			thumb.y = height - thumb.height;
		}
		
		public function set resizeable(value:Boolean):void {
			if (_resizeable != value) {
				_resizeable = value
				if(_resizeable){
					thumb.addEventListener(MouseEvent.MOUSE_DOWN, dragStart);
					thumb.mouseEnabled = true;
				}else {
					thumb.removeEventListener(MouseEvent.MOUSE_DOWN, dragStart);
					thumb.mouseEnabled = false;
				}
				update();
			}
		}
		
		public function get resizeable():Boolean {
			return _resizeable;
		}
		
		private function dragStart(event:MouseEvent):void {
			resetDrag();
			stage.addEventListener(MouseEvent.MOUSE_UP, dragStop);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, drag);
		}
		
		private function resetDrag():void {
			startDragPoint = new Point(mouseX, mouseY);
			startDragWidth = width;
			startDragHeight = height;
		}
		
		private function drag(event:Event):void {
			var dragXAmount:Number = mouseX - startDragPoint.x;
			if(dragXAmount != 0){
				width = startDragWidth + dragXAmount;
			}
			var dragYAmount:Number = mouseY - startDragPoint.y;
			if(dragYAmount != 0){
				height = startDragHeight + dragYAmount;
			}
			resetDrag();
		}
		
		private function dragStop(event:MouseEvent):void {
			stage.removeEventListener(MouseEvent.MOUSE_UP, dragStop);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, drag);
		}
		
	}
	
}