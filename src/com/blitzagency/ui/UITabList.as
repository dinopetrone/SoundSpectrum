package com.blitzagency.ui {
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	public class UITabList extends UIList {
		
		public var foreground:DisplayObject;
		public var buttonGroup:UIMovieClipGroup;
		
		public function UITabList() {
			super();
			buttonGroup = new UIMovieClipGroup();
			buttonGroup.addEventListener(Event.CHANGE, buttonGroupChangeHandler);
		}
		
		private function buttonGroupChangeHandler(e:Event):void {
			if (buttonGroup.selection) {
				childContainer.addChildAt(buttonGroup.selection, dataProvider.length - 1);
				if (foreground) {
					foreground.x = buttonGroup.selection.x * -1;
					buttonGroup.selection.addChild(foreground);
				}
			}
		}
		
		override protected function addObjects():void {
			super.addObjects();
			for each(var button:UIButton in dataProvider) {
				buttonGroup.add(button);
			}
		}
		
		override protected function removeObjects():void {
			super.removeObjects();
			for each(var button:UIButton in dataProvider) {
				buttonGroup.remove(button);
			}
		}
		
	}
	
}