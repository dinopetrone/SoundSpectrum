package com.blitzagency.ui {
	
	/*
	 * @author Patrick Matte
	 * @since 1.0 2008/03/25
	 * @version 1.2 2008/09/19
	*/
	
	import flash.display.DisplayObject;
	import com.blitzagency.ui.UIMovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import com.blitzagency.utils.EventCondition;
	
	public class UIList extends UIMovieClip {
		
		private var _dataProvider:Array = new Array();
		private var _align:String = HORIZONTAL;
		private var _wrap:Number = uint.MAX_VALUE;
		private var _vSpace:Number = 0;
		private var _hSpace:Number = 0;
		private var _marginTop:Number = 0;
		private var _marginLeft:Number = 0;
		private var _marginRight:Number = 0;
		private var _marginBottom:Number = 0;
		private var _dragAndDrop:Boolean;
		public var dragAndDropManager:UIDragAndDropManager;
		protected var childContainer:Sprite = new Sprite();
		
		public static var VERTICAL:String = "vertical";
		public static var HORIZONTAL:String = "horizontal";
		
		public function UIList() {
			super();
			addChild(childContainer);
			dragAndDropManager = new UIDragAndDropManager(this);
		}
		
		public function set dataProvider(value:Array):void {
			removeObjects();
			_dataProvider = value;
			addObjects();
		}
		
		public function get dataProvider():Array {
			return _dataProvider;
		}
		
		protected function addObjects():void {
			if (dataProvider) {
				for (var i = 0; i < dataProvider.length; i++) {
					var child:DisplayObject = dataProvider[i] as DisplayObject;
					child.addEventListener(MouseEvent.MOUSE_DOWN, dragAndDropManager.checkForDrag);
					childContainer.addChild(child);
				}
				update();
			}
		}
		
		protected function removeObjects():void {
			if(dataProvider){
				for (var i = 0; i < dataProvider.length; i++) {
					var child:DisplayObject = dataProvider[i] as DisplayObject;
					child.removeEventListener(MouseEvent.MOUSE_DOWN, dragAndDropManager.checkForDrag);
					childContainer.removeChild(child);
				}
			}
		}
		
		public function update():void {
			switch(align) {
				case HORIZONTAL:
					alignHorizontal();
				break;
				case VERTICAL:
					alignVertical();
				break;
			}
			dispatchEvent(new Event(Event.RESIZE));
		}
		
		protected function alignVertical():void {
			var totalHeight:Number = 0;
			var xPos:Number = marginLeft;
			var yPos:Number = marginTop;
			var childWidth:Number = 0;
			for (var i = 0; i < dataProvider.length; i++) {
				var child:DisplayObject = dataProvider[i] as DisplayObject;
				if (yPos + child.height > wrap - marginBottom && childWidth > 0) {
					yPos = marginTop;
					xPos += childWidth + hSpace;
					childWidth = 0;
				}
				childWidth = (child.width > childWidth)?child.width:childWidth;
				child.x = xPos;
				child.y = yPos;
				yPos += child.height + vSpace;
				totalHeight = (yPos > totalHeight)?yPos:totalHeight;
			}
			
		}
		
		protected function alignHorizontal():void {
			var totalWidth:Number = 0;
			var xPos:Number = marginLeft;
			var yPos:Number = marginTop;
			var childHeight:Number = 0;
			for (var i = 0; i < dataProvider.length; i++) {
				var child:DisplayObject = dataProvider[i] as DisplayObject;
				if (xPos + child.width > wrap - marginRight && childHeight > 0) {
					xPos = marginLeft;
					yPos += childHeight + vSpace;
					childHeight = 0;
				}
				childHeight = (child.height > childHeight)?child.height:childHeight;
				child.x = xPos;
				child.y = yPos;
				xPos += child.width + hSpace
				totalWidth = (xPos > totalWidth)?xPos:totalWidth;
			}
		}
		
		public function set align(value:String):void {
			_align = value;
			if(dataProvider){
				update();
			}
		}
		
		public function get align():String {
			return _align;
		}
		
		public function set wrap(value:Number):void {
			_wrap = value;
			if(dataProvider){
				update();
			}
		}
		
		public function get wrap():Number {
			return _wrap;
		}
		
		public function set vSpace(value:Number):void {
			_vSpace = value;
			if(dataProvider){
				update();
			}
		}
		
		public function get vSpace():Number {
			return _vSpace;
		}
		
		public function set hSpace(value:Number):void {
			_hSpace = value;
			if(dataProvider){
				update();
			}
		}
		
		public function get hSpace():Number {
			return _hSpace;
		}
		
		public function set marginTop(value:Number):void {
			_marginTop = value;
			if(dataProvider){
				update();
			}
		}
		
		public function get marginTop():Number {
			return _marginTop;
		}
		
		public function set marginBottom(value:Number):void {
			_marginBottom = value;
			if(dataProvider){
				update();
			}
		}
		
		public function get marginBottom():Number {
			return _marginBottom;
		}
		
		public function set marginLeft(value:Number):void {
			_marginLeft = value;
			if(dataProvider){
				update();
			}
		}
		
		public function get marginLeft():Number {
			return _marginLeft
		}
		
		public function set marginRight(value:Number):void {
			_marginRight = value;
			if(dataProvider){
				update();
			}
		}
		
		public function get marginRight():Number {
			return _marginRight;
		}
		
		public function set dragAndDrop(value:Boolean):void {
			dragAndDropManager.enabled = value;
		}
		
		public function get dragAndDrop():Boolean {
			return dragAndDropManager.enabled;
		}
		
		public function swapItems(index1:Number, index2:Number):void {
			var temp:String = "temp";
			var index1Object:DisplayObject = dataProvider.splice(index1, 1, temp)[0] as DisplayObject;
			dataProvider.splice(index2, 0, index1Object);
			var tempIndex:Number = dataProvider.indexOf(temp);
			dataProvider.splice(tempIndex, 1);
			update();
		}
		
		override public function get width():Number {
			return childContainer.width + marginLeft + marginRight;
		}
		
		override public function get height():Number {
			return childContainer.height + marginTop + marginBottom;
		}
		
		override public function transitionIn():void {
			visible = true;
			var eventCondition:EventCondition = new EventCondition();
			eventCondition.addEventListener(Event.COMPLETE, transitionInConditionComplete);
			for each(var clip:UIMovieClip in dataProvider) {
				eventCondition.add(clip, Event.COMPLETE);
				clip.transitionIn();
			}
		}
		
		private function transitionInConditionComplete(e:Event):void {
			e.target.removeEventListener(Event.COMPLETE, transitionInConditionComplete);
			transitionInComplete();
		}
		
		override public function transitionOut():void {
			var eventCondition:EventCondition = new EventCondition();
			eventCondition.addEventListener(Event.COMPLETE, transitionOutConditionComplete);
			for each(var clip:UIMovieClip in dataProvider) {
				eventCondition.add(clip, Event.COMPLETE);
				clip.transitionOut()
			}
		}
		
		private function transitionOutConditionComplete(e:Event):void {
			e.target.removeEventListener(Event.COMPLETE, transitionOutConditionComplete);
			transitionOutComplete();
		}
	}
	
}