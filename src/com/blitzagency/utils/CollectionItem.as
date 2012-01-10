package com.blitzagency.utils {
	
	public class CollectionItem {
		
		public var parent:Collection;
		protected var _id:String;
		
		public function CollectionItem() {
			
		}
		
		public function get index():Number {
			return parent.indexOf(this);
		}
		
		public function get id():String {
			return _id;
		}
		
		public function set id(value:String):void {
			_id = value;
		}
		
	}
	
}