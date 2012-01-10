package com.blitzagency.ui {
	
	/*
	 * @author Patrick Matte
	 * @since 1.0 2008/03/16
	 * @version 1.1 2008/09/18
	 * 
	 * @modified Yosef Flomin
	 * @revision 1.2 2010/04/30
	 * 
	 * @modified Dino Petrone
	 * @revision 1.3 2010/05/25
	*/
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	
	public class UIButton extends UIMovieClip {
		
		public static var RIGHT_MOUSE_DOWN:String = "rightMouseDown";
		public static var RIGHT_MOUSE_UP:String = "rightMouseUp";
		public static var BUTTON_DOWN:String = "buttonDown";
		
		private var mouseIsDown:Boolean;
		private var mouseIsOver:Boolean;
		
		public var autoRepeat:Boolean = false;
		public var repeatDelay:Number = 300;
		public var repeatInterval:Number = 100;
		private var delay:Timer;
		private var repeat:Timer;
		
		public var toggle:Boolean;
		public var deselectable:Boolean = true;
		public var allowDragOver:Boolean;
		public var background:MovieClip;
		
		protected var _marginTop:Number = 0;
		protected var _marginLeft:Number = 0;
		protected var _marginRight:Number = 0;
		protected var _marginBottom:Number = 0;
		private var _enabledTransition:Boolean = true; // @r1.3
		
		public function UIButton() {
			super();
			buttonMode = true;
			mouseChildren = false;
			mouseEnabled = true;
			init();
		}
		
		protected function init():void {
			if (background && textField) {
				_marginTop = textField.y;
				_marginLeft = textField.x;
				_marginRight = background.width - textField.x - textField.width;
				_marginBottom = background.height - textField.y - textField.height;
			}
		}
		
		// @r1.3
		public function disableForPreTransition():void
		{
			super.enabled = false;
		}
		
		// @r1.3
		override protected function transitionInComplete():void 
		{
			if(_enabledTransition)
				mouseEnabled = true;
			super.transitionInComplete();
		}
		
		// @r1.3
		override protected function transitionOutComplete():void 
		{
			if(_enabledTransition)
				mouseEnabled = true;
			super.transitionOutComplete();
		}
		
		// @r1.3
		override public function transitionIn():void 
		{
			mouseEnabled = false;
			super.transitionIn();
		}
		
		// @r1.3
		override public function transitionOut():void 
		{
			mouseEnabled = false;
			super.transitionOut();
		}
		
		// @r1.3
		override public function set enabled(value:Boolean):void 
		{
			_enabledTransition = value;
			super.enabled = value;
		}
		
		override public function set mouseEnabled(value:Boolean):void {
			if (value) {
				addEventListener(MouseEvent.ROLL_OVER, rollOverEvent, false, int.MAX_VALUE);
				addEventListener(MouseEvent.ROLL_OUT, rollOutEvent, false, int.MAX_VALUE);
				addEventListener(MouseEvent.MOUSE_DOWN, mouseDownEvent, false, int.MAX_VALUE);
				addEventListener(MouseEvent.MOUSE_UP, mouseUpEvent, false, int.MAX_VALUE);
				addEventListener(MouseEvent.CLICK, clickEvent, false, int.MAX_VALUE);
				addEventListener(RIGHT_MOUSE_DOWN, mouseDownEvent, false, int.MAX_VALUE);
			} else {
				removeEventListener(MouseEvent.ROLL_OVER, rollOverEvent);
				removeEventListener(MouseEvent.ROLL_OUT, rollOutEvent);
				removeEventListener(MouseEvent.MOUSE_DOWN, mouseDownEvent);
				removeEventListener(MouseEvent.MOUSE_UP, mouseUpEvent);
				removeEventListener(MouseEvent.CLICK, clickEvent);
				removeEventListener(RIGHT_MOUSE_DOWN, mouseDownEvent);
				mouseIsOver = false;
			}
			super.mouseEnabled = value;
		}
		
		private function rollOverEvent(event:MouseEvent) {
			mouseIsOver = true;
			if(event.buttonDown) {
				if(mouseIsDown || allowDragOver) {
					stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUpOutsideEvent);
					stage.removeEventListener(RIGHT_MOUSE_UP, mouseUpOutsideEvent);
					dragOver();
				}
			}else {
				rollOver();
			}
		}
		
		private function rollOutEvent(event:MouseEvent):void {
			mouseIsOver = false;
			if(event.buttonDown) {
				if(mouseIsDown || allowDragOver) {
					stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpOutsideEvent);
					stage.addEventListener(RIGHT_MOUSE_UP, mouseUpOutsideEvent);
					dragOut();
				}
			}else{
				rollOut();
			}
		}
		
		private function mouseDownEvent(event:MouseEvent):void {
			mouseIsDown = true;
			buttonDown();
			press();
		}
		
		private function mouseUpEvent(event:MouseEvent):void {
			if (!mouseIsDown || allowDragOver) {
				rollOverEvent(event);
			}
		}
		
		protected function clickEvent(event:MouseEvent):void {
			mouseIsDown = false;
			if (toggle) {
				if (!selected || deselectable) {
					selected = !selected;
				}
			}
			release();
		}
		
		private function mouseUpOutsideEvent(event:MouseEvent):void {
			event.currentTarget.removeEventListener(MouseEvent.MOUSE_UP, mouseUpOutsideEvent);
			event.currentTarget.removeEventListener(RIGHT_MOUSE_UP, mouseUpOutsideEvent);
			mouseIsDown = false;
			releaseOutside();
		}
		
		protected function rollOver():void {
			if (!selected) {
				setState(UIButtonState.ROLLOVER); // @r1.2
			} else {
				setState(UIButtonState.ROLLOVER_SELECTED); // @r1.2
			}
		}	
		
		protected function rollOut():void {
			if (!selected) {
				setState(UIButtonState.ROLLOUT); // @r1.2
			} else {
				setState(UIButtonState.ROLLOUT_SELECTED); // @r1.2
			}
		}
		
		protected function press():void {
			if (!selected) {
				setState(UIButtonState.PRESS); // @r1.2
			} else {
				setState(UIButtonState.PRESS_SELECTED); // @r1.2
			}
		}
		
		protected function release():void {
			if (!selected) {
				setState(UIButtonState.RELEASE); // @r1.2
			} else {
				setState(UIButtonState.RELEASE_SELECTED); // @r1.2
			}
		}
		
		protected function dragOver():void {
			if (!selected) {
				setState(UIButtonState.DRAGOVER); // @r1.2
			} else {
				setState(UIButtonState.DRAGOVER_SELECTED); // @r1.2
			}
		}
		
		protected function dragOut():void {
			if (!selected) {
				setState(UIButtonState.DRAGOUT); // @r1.2
			} else {
				setState(UIButtonState.DRAGOUT_SELECTED); // @r1.2
			}
		}
		
		protected function releaseOutside():void {
			rollOut();
		}
		
		private function buttonDown():void {
			dispatchEvent(new MouseEvent(BUTTON_DOWN));
			if (autoRepeat) {
				stage.addEventListener(MouseEvent.MOUSE_UP, stopRepeat);
				delay = new Timer(repeatDelay, 1);
				delay.addEventListener(TimerEvent.TIMER_COMPLETE, startRepeat);
				delay.start();
			}
		}
		
		private function startRepeat(event:TimerEvent):void {
			repeat = new Timer(repeatInterval);
			repeat.addEventListener(TimerEvent.TIMER, repeatEvent);
			repeat.start();
		}
		
		private function repeatEvent(event:TimerEvent):void {
			dispatchEvent(new MouseEvent(BUTTON_DOWN));
		}
		
		private function stopRepeat(event:MouseEvent):void {
			event.target.removeEventListener(MouseEvent.MOUSE_UP, stopRepeat);
			delay.removeEventListener(TimerEvent.TIMER_COMPLETE, startRepeat);
			if(repeat){
				repeat.removeEventListener(TimerEvent.TIMER, repeatEvent);
			}
		}
		
		override public function set width(value:Number):void {
			//textField.x = marginLeft;
			if (background) {
				background.width = value;
			} else if (textField) {
				textField.width = value - marginLeft - marginRight;
			} else {
				super.width = value;
			}
		}
		
		override public function get width():Number {
			var _width:Number = super.width;
			if (background) {
				_width = background.width;
			}
			return _width;
		}
		
		override public function set height(value:Number):void {
			//textField.y = marginTop;
			if (background) {
				background.height = value;
			} else if (textField) {
				//textField.height = value - marginTop - marginBottom;
			} else {
				super.height = value;
			}
		}
		
		override public function get height():Number {
			var _height:Number = super.height;
			if (background) {
				_height = background.height;
			}
			return _height;
		}
		
		public function set marginTop(value:Number):void {
			_marginTop = value;
			height = height;
		}
		
		public function get marginTop():Number {
			return _marginTop;
		}
		
		public function set marginBottom(value:Number):void {
			_marginBottom = value;
			height = height;
		}
		
		public function get marginBottom():Number {
			return _marginBottom;
		}
		
		public function set marginLeft(value:Number):void {
			_marginLeft = value;
			width = width;
		}
		
		public function get marginLeft():Number {
			return _marginLeft
		}
		
		public function set marginRight(value:Number):void {
			_marginRight = value;
			width = width;
		}
		
		public function get marginRight():Number {
			return _marginRight;
		}
		
		override public function set label(value:String):void {
			super.label = value;
			if (textField.autoSize && background) {
				width = marginLeft + textField.width + marginRight;
			}
		}
		
		public override function toString():String{
			return("[" + "UIButton" + ", name=" + name + "]");
		}
		
	}
	
}