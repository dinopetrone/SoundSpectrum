package com.blitzagency.ui {
	
	/*
	 * @author Patrick Matte
	 * @since 1.0 2008/03/13
	 * @version 1.0 2008/03/13
	*/
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.events.Event;
	
	public class UIScrollBar extends UIMovieClip {
		
		private var _maxScroll:Number = 0;
		private var _scroll:Number = 0;
		
		public var track:MovieClip;
		public var elevator:MovieClip;
		public var inertia:Number = 0.5;
		public var scrollUnit:Number = 1;
		public var scrollPageUnit:Number = 1;
		
		protected var scrollTarget:Number = 0;
		private var dragOffsetY:Number;
		public var isScrolling:Boolean;
		
		public function UIScrollBar() {
			super();
			elevator.addEventListener(MouseEvent.MOUSE_DOWN, dragStart);
			track.addEventListener(MouseEvent.MOUSE_DOWN, scrollPage);
			track.buttonMode = false;
			addEventListener(MouseEvent.MOUSE_WHEEL, scrollWheel);
			maxScroll = 0;
		}
		
		public override function set width(value:Number):void {
			track.width = value;
			elevator.width = value;
		}
		
		public override function get width():Number {
			return track.width;
		}
		
		public override function set height(value:Number):void {
			track.height = value;
			changeElevatorHeight();
		}
		
		public override function get height():Number {
			return track.height;
		}
		
		protected function changeElevatorHeight():void{
			var scaleFactor:Number = (maxScroll + height) / height;
			elevator.height = track.height / scaleFactor;
		}
		
		public function set maxScroll(value:Number):void {
			_maxScroll = Math.max(0, value);
			elevator.visible = (_maxScroll > 0);
			changeElevatorHeight();
			enabled = (_maxScroll > 0);
		}
		
		public function get maxScroll():Number{
			return _maxScroll;
		}
		
		private function dragStart(event:MouseEvent):void {
			stage.addEventListener(MouseEvent.MOUSE_UP, dragStop);
			isScrolling = true;
			dragOffsetY = mouseY - elevator.y;
			stage.addEventListener(MouseEvent.MOUSE_MOVE, dragElevator);
			stage.addEventListener(MouseEvent.MOUSE_UP, dragStop);
		}
		
		private function dragStop(event:MouseEvent):void {
			isScrolling = false;
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, dragElevator);
			stage.removeEventListener(MouseEvent.MOUSE_UP, dragStop);
		}
		
		private function dragElevator(event:MouseEvent):void {
			var yMouse:Number = mouseY - dragOffsetY - track.y;
			yMouse = Math.min(yMouse, (track.height - elevator.height));
			yMouse = Math.max(yMouse, 0);
			scroll = Math.round(yMouse * maxScroll/(track.height - elevator.height));
		}
		
		public function scrollWheel(event:MouseEvent):void{
			scroll = scrollTarget + scrollUnit * event.delta / -3;
		}
		
		public function set scroll(value:Number):void {
			var newScrollTarget:Number = Math.min(value, maxScroll);
			newScrollTarget = Math.max(newScrollTarget, 0);
			scrollTarget = newScrollTarget;
			removeEventListener(Event.ENTER_FRAME, easeScroll);
			addEventListener(Event.ENTER_FRAME, easeScroll);
		}
		
		public function get scroll():Number{
			return Math.round(_scroll);
		}
		
		public function easeScroll(event:Event):void {
			var newScroll:Number = _scroll + (scrollTarget - _scroll) * inertia;
			_scroll = Math.round(newScroll * 10) / 10;
			elevator.y = (scroll * (track.height - elevator.height) / maxScroll) + track.y;
			dispatchEvent(new Event(Event.CHANGE));
			if(!isScrolling && scroll == scrollTarget){
				removeEventListener(Event.ENTER_FRAME, easeScroll);
				dispatchEvent(new Event(Event.COMPLETE));
			}
		}
		
		private function scrollPage(event:MouseEvent):void {
			if(mouseY < elevator.y){
				scroll = scrollTarget - scrollPageUnit;
			}else{
				scroll = scrollTarget + scrollPageUnit;
			}
		}
		
		protected override function enable():void {
			mouseEnabled = true;
		}
		
		protected override function disable():void {
			mouseEnabled = false;
		}
		
		public override function toString():String {
			return("[" + "UIScrollbar" + ", name= " + name + ", width=" + width + ", height=" + height + ", scroll=" + scroll + ", maxScroll=" + maxScroll + "]");
		}
		
	}
	
}