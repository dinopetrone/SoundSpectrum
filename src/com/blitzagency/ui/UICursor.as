package com.blitzagency.ui 
{
	/*
	 * @author Yosef Flomin
	*/
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.ui.Mouse;
	
	public class UICursor extends UIBase
	{
		public var area :MovieClip;
		
		public function UICursor() 
		{
			super();
			mouseEnabled = false;
			mouseChildren = false;
			
			addEventListener( Event.ADDED_TO_STAGE, addStageListeners );
		}
		
		private function addStageListeners( event:Event ):void 
		{
			stage.addEventListener( MouseEvent.MOUSE_DOWN, setFrame );
			stage.addEventListener( MouseEvent.MOUSE_UP, setFrame );
			
			if ( area ) {
				area.addEventListener( MouseEvent.ROLL_OVER , hideMouse );
				area.addEventListener( MouseEvent.ROLL_OUT  , showMouse );
				area.addEventListener( MouseEvent.MOUSE_MOVE, moveMe    );
			}
		}
		
		private function setFrame( event:MouseEvent ):void 
		{
			switch( event.type ) {
				case MouseEvent.MOUSE_DOWN: gotoAndStop( "down" ); break;
				case MouseEvent.MOUSE_UP  : gotoAndStop( "up"   ); break;
			}
		}
		
		private function hideMouse( event:MouseEvent ):void 
		{
			Mouse.hide();
			visible = true;
		}
		
		private function showMouse( event:MouseEvent ):void 
		{
			Mouse.show();
			visible = false;
		}
		
		private function moveMe( event:MouseEvent ):void 
		{
			x = area.mouseX;
			y = area.mouseY;
		}
	}
}