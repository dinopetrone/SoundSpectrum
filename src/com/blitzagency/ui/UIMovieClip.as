package com.blitzagency.ui {
	
	/*
	 * @author Patrick Matte
	 * @since 1.0 2008/03/16
	 * @version 1.1 2008/09/18
	 * 
	 * @modified Yosef Flomin
	 * @revision 1.2 2010/04/30
	 * 
	 * @modified Yosef Flomin
	 * @revision 1.3 2010/05/17
	*/
	
	import flash.display.MovieClip;
	import flash.display.FrameLabel;
	import flash.display.Scene;
	import flash.events.Event;
	
	dynamic public class UIMovieClip extends UIBase 
	{
		protected var _enabled:Boolean = true;
		protected var _selected:Boolean;
		protected var _data:Object;
		protected var _state:String = "";
		protected var skins:Array = new Array();
		
		public var textField:UITextField;
		public var replayStates:Boolean = false;
		public var stateCompleted:Boolean;
		
		public static var ENABLED:String = "enabled";
		
		public function UIMovieClip() {
			super();
			stop();
			skins.push(this);
		}
		
		// @r1.2
		public function setState( value:String ):Boolean 
		{
			if (_state == value && !replayStates) {
				return false;
			}
			_state = value;
			stateCompleted = false;
			changeSkin(_state);
			dispatchEvent(new Event(UIMovieClipState.STATE_CHANGE));
			return true;
		}
		
		protected function changeSkin(label:String):void {
			for each(var skin:MovieClip in skins) {
				skin.gotoAndPlay(label);
			}
		}
		
		// @r1.2
		public function transitionIn():void {
			if (setState(UIMovieClipState.TRANSITION_IN))
			{
				visible = true;
			}
			else transitionInComplete();
		}
		
		protected function transitionInComplete():void {
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		// @r1.2
		public function transitionOut():void {
			if (setState(UIMovieClipState.TRANSITION_OUT))
			{
				visible = true;
			}
			else transitionOutComplete();
		}
		
		protected function transitionOutComplete():void {
			visible = false;
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		public override function set enabled(value:Boolean):void {
			if(value != _enabled){
				_enabled = value;
				mouseEnabled = _enabled;
				dispatchEvent(new Event(ENABLED));
				if (_enabled) {
					enable();
				}else {
					disable();
				}
			}
		}
		
		public override function get enabled():Boolean {
			return _enabled;
		}
		
		// @r1.2
		protected function enable():void {
			if (!selected){
				setState(UIMovieClipState.ENABLED);
			} else {
				setState(UIMovieClipState.ENABLED_SELECTED);
			}
		}
		
		// @r1.2
		protected function disable():void {
			if (!selected){
				setState(UIMovieClipState.DISABLED);
			} else {
				setState(UIMovieClipState.DISABLED_SELECTED);
			}
		}
		
		public function set selected(value:Boolean):void {
			if (value != _selected) {
				_selected = value;
				dispatchEvent(new Event(Event.CHANGE));
				if (_selected) {
					select();
				}else {
					deselect();
				}
			}
		}
		
		public function get selected():Boolean {
			return _selected;
		}
		
		// @r1.2
		protected function select():void {
			if (enabled){
				setState(UIMovieClipState.SELECTED);
			} else {
				setState(UIMovieClipState.SELECTED_DISABLED);
			}
		}
		
		// @r1.2
		protected function deselect():void {
			if (enabled){
				setState(UIMovieClipState.DESELECTED);
			} else {
				setState(UIMovieClipState.DESELECTED_DISABLED);
			}
		}
		
		public override function gotoAndPlay(frame:Object, scene:String = null):void {
			if (frame is String) {
				var targetScene:Scene = currentScene;
				if (scene) {
					for (var j = 0; j < scenes.length; j++ ) {
						var movieScene:Scene = scenes[j] as Scene;
						if (movieScene.name == scene) {
							targetScene = movieScene;
						}
					}
				}
				var labelExists:Boolean;
				var labels:Array = targetScene.labels;
				for (var i = 0; i < labels.length; i++) {
					var frameLabel:FrameLabel = labels[i] as FrameLabel;
					if (frameLabel.name == frame) {
						labelExists = true;
					}
				}
				if (labelExists) {
					super.gotoAndPlay(frame, scene);
				}else {
					//trace("FrameLabel '" + frame + "' not found on " + this);
				}
			}else {
				super.gotoAndPlay(frame, scene);
			}
		}
		
		override public function stop():void 
		{
			super.stop();
			stateCompleted = true;
		}
		
		public function set data(value:Object):void {
			_data = value;
		}
		
		public function get data():Object {
			return _data;
		}
		
		public function set label(value:String):void {
			textField.htmlText = value;
		}
		
		public function get label():String {
			return textField.text;
		}
		
		public function get state():String { return _state; }
		
		public override function toString():String{
			return("[" + "UIMovieClip" + ", name=" + name + "]");
		}
		
	}
	
}