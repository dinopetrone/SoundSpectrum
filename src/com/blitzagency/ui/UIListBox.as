package com.blitzagency.ui {
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import fl.transitions.Tween;
	import fl.transitions.easing.*;
	import fl.transitions.TweenEvent;
	
	public class UIListBox extends UIScrollPane {
		
		public var list:UIList = new UIList();
		private var _dataProvider:Array;
		public var buttonGroup:UIMovieClipGroup;
		private var _selectedIndex:Number;
		private var listTween:Tween;
		public var cellRenderer:Class;
		public var labelField:String = "label";
		protected var _maxHeight:Number = 300;
		
		public function UIListBox() {
			super();
			init();
		}
		
		protected function init():void {
			list.addEventListener(Event.RESIZE, listResize);
			list.align = UIList.VERTICAL;
			content = list;
			height = height;
		}
		
		private function listResize(event:Event):void {
			update();
		}
		
		public function set dataProvider(value:Array):void {
			buttonGroup = new UIMovieClipGroup();
			buttonGroup.disableMouseOnSelect = true;
			_dataProvider = value;
			buildList();
			height = list.height;
		}
		
		protected function buildList():void {
			var listProvider:Array = new Array();
			for (var i = 0; i < dataProvider.length; i++) {
				var button:UIButton = new cellRenderer();
				var data = dataProvider[i];
				if (data.hasOwnProperty(labelField)) {
					button.label = data[labelField];
				}
				button.data = data;
				button.name = "button" + i;
				button.addEventListener(MouseEvent.CLICK, buttonClick);
				buttonGroup.add(button);
				listProvider.push(button);
			}
			list.dataProvider = listProvider;
		}
		
		private function buttonClick(event:MouseEvent):void {
			var button:UIButton = event.currentTarget as UIButton;
			_selectedIndex = Number(button.name.split("button")[1]);
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		public function set selectedIndex(value:Number):void {
			_selectedIndex = value;
			buttonGroup.selection = buttonGroup.movieClips[value];
		}
		
		public function get selectedIndex():Number {
			return _selectedIndex;
		}
		
		public function set selectedData(value:Object):void {
			selectedIndex = dataProvider.indexOf(value);
		}
		
		public function get selectedData():Object {
			return dataProvider[selectedIndex];
		}
		
		public function get dataProvider():Array {
			return _dataProvider;
		}
		
		override public function set height(value:Number):void {
			super.height = Math.min(value, maxHeight);
			if (list.dataProvider) {
				resizeList();
			}
		}
		
		public function set maxHeight(value:Number):void {
			_maxHeight = value;
			height = height;
		}
		
		public function get maxHeight():Number {
			return _maxHeight;
		}
		
		override public function set width(value:Number):void {
			super.width = value;
			if (list.dataProvider) {
				resizeList();
			}
		}
		
		protected function resizeList():void {
			var buttonWidth:Number = width - list.marginLeft - list.marginRight;
			if (list.height > height) {
				buttonWidth -= verticalScrollBar.width;
			}
			for (var i = 0; i < list.dataProvider.length; i++) {
				var item:DisplayObject = list.dataProvider[i] as DisplayObject;
				item.width = buttonWidth;
			}
			update();
		}
		
		override public function transitionIn():void {
			visible = true;
			list.addEventListener(Event.COMPLETE, listTransitionInComplete);
			list.transitionIn();
		}
		
		private function listTransitionInComplete(e:Event):void {
			e.target.removeEventListener(Event.COMPLETE, listTransitionInComplete);
			transitionInComplete();
		}
		
		override public function transitionOut():void {
			list.addEventListener(Event.COMPLETE, listTransitionOutComplete);
			list.transitionOut();
		}
		
		private function listTransitionOutComplete(e:Event):void {
			e.target.removeEventListener(Event.COMPLETE, listTransitionOutComplete);
			transitionOutComplete();
		}
		
	}
	
}