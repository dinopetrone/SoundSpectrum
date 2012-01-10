package com.blitzagency.ui {
	
	/*
	 * @author Patrick Matte
	 * @since 1.0 2008/03/13
	 * @version 1.0 2008/03/13
	*/
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	public class UIMovieClipGroup extends EventDispatcher {
		
		public var disableMouseOnSelect:Boolean;
		public var movieClips:Array = new Array();
		private var _selection:UIMovieClip;
		private var _selectedIndex:int;
		
		private var _name:String;
		
		public function UIMovieClipGroup(name:String="default") {
			super();
			_name = name;
		}
		
		public function get name():String {
			return _name;
		}
		
		public function add(movieClip:UIMovieClip):void {
			movieClips.push(movieClip);
			movieClip.addEventListener(Event.CHANGE, changeHandler);
		}
		
		public function remove(movieClip:UIMovieClip):void {
			var index:Number = movieClips.indexOf(movieClip);
			if(index != -1) {
				movieClip.removeEventListener(Event.CHANGE, changeHandler);
				movieClips.splice(index, 1);
			}
		}
		
		public function removeAll():void{
			for each ( var mc:UIMovieClip in movieClips ){
				remove( mc );
			}
		}
		
		public function set selection(movieClip:UIMovieClip):void {
			if(movieClip){
				movieClip.selected = true;
			}else {
				if (_selection) {
					_selection.mouseEnabled = true;
					_selection.selected = false;
				}
			}
		}
		
		public function set selectedIndex(value:int):void {
			if (value < 0 || value > movieClips.length - 1) {
				new Error(value + " is an undefined UIMovieClipGroup index");
			}else {
				selection = movieClips[value];
			}
		}		
		
		public function get selection():UIMovieClip {
			if (_selection) {
				return _selection;
			} else {
				return null;
			}
		}
		
		public function get selectedIndex():int{
			return movieClips.indexOf(_selection);
		}
		
		private function changeHandler(event:Event):void {
			var movieClip:UIMovieClip = event.target as UIMovieClip;
			if (movieClip.selected) {
				select(movieClip);
			}else {
				deselect(movieClip);
			}
		}
		
		private function select(movieClip:UIMovieClip):void {
			if (selection) {
				selection.mouseEnabled = true;
				selection.selected = false;
			}
			_selection = movieClip;
			if (disableMouseOnSelect) {
				selection.mouseEnabled = false;
			}
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		private function deselect(movieClip:UIMovieClip):void {
			if (movieClip == _selection) {
				_selection = null;
				dispatchEvent(new Event(Event.CHANGE));
			}
		}
		
		public override function toString():String{
			return("[" + "UIMovieClipGroup" + ", name=" + name + "]");
		}
		
	}
	
}