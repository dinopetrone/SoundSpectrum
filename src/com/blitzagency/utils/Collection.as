package com.blitzagency.utils {
	
	import com.blitzagency.ui.EventDispatcherBase;
	import flash.events.Event;
	
	public class Collection extends EventDispatcherBase {
		
		protected var _children:Array;
		protected var _selectedData:Object;
		
		public function Collection() {
			super();
			_children = new Array();
		}
		
		public function set selectedData(value:Object):void {
			_selectedData = value;
			dispatchEvent(new Event(Event.SELECT));
		}
		
		public function get selectedData():Object {
			return _selectedData;
		}
		
		public function set selectedIndex(value:Number):void {
			selectedData = _children[value];
		}
		
		public function get selectedIndex():Number {
			return _children.indexOf(_selectedData);
		}
		
		public function set selectedId(value:String):void {
			var foundObject:Object;
			for each(var object:Object in _children) {
				if (object.id == value) {
					foundObject = object;
				}
			}
			if (foundObject) {
				selectedData = foundObject;
			}
		}
		
		public function get selectedId():String {
			var string:String;
			if (selectedData) {
				string = selectedData.id;
			}
			return string;
		}
		
		public function getChildByName(value:String):Object {
			var foundObject:Object;
			for each(var object:Object in _children) {
				if (object.id == value) {
					foundObject = object;
				}
			}
			return foundObject;
		}
		
		public function push(value:CollectionItem):void {
			value.parent = this;
			_children.push(value);
		}
		
		public function indexOf(value:CollectionItem):Number {
			return _children.indexOf(value);
		}
		
		public function get children():Array {
			return _children.slice();
		}
		
		public function get length():Number {
			return _children.length;
		}
		
		public function getChildAt(index:Number):CollectionItem {
			return _children[index];
		}
		
	}
	
}