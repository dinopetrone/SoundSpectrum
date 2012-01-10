package com.blitzagency.utils.imageProcessing
{
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	public class TriangleMesh extends Sprite
	{
		[Public]
		public var bitmapData     :BitmapData;
		public var triangleData   :TriangleData;
		public var debugAnchors   :Vector.<Sprite> = new Vector.<Sprite>();
		
		[Private]
		protected var anchorIndex :int;
		protected var anchorDown  :Sprite;
		
		[Getters_Setters]
		protected var _debugMode  :Boolean;
		
		[Stage]
		
		public function TriangleMesh(bitmapData:BitmapData, triangleData:TriangleData)
		{
			this.bitmapData = bitmapData;
			this.triangleData = triangleData;
			
			super();
			init();
		}
		
		protected function init():void 
		{
			redraw();
		}
		
		public function set debugMode(value:Boolean):void
		{
			_debugMode = value;
			
			var anchor:Sprite;
			if (debugAnchors)
			{
				for each (anchor in debugAnchors) 
				{
					removeChild(anchor);
					anchor.removeEventListener(MouseEvent.MOUSE_DOWN, onAnchorDown);
					anchor.removeEventListener(MouseEvent.MOUSE_UP, onAnchorUp);
				}
				debugAnchors = new Vector.<Sprite>();
			}
			if (debugMode)
			{
				var len:uint = triangleData.vertices.length;
				for ( var i:int = 0; i < len; i += 2 ) 
				{
					anchor = new Sprite();
					anchor.graphics.lineStyle(20);
					anchor.graphics.lineTo(1, 0);
					
					anchor.x = triangleData.vertices[i];
					anchor.y = triangleData.vertices[i + 1];
					anchor.useHandCursor = true;
					anchor.buttonMode = true;
					
					var label:TextField = new TextField();
					label.x = -4;
					label.y = -9;
					label.mouseEnabled = false;
					label.textColor = 0xffffff;
					label.text = String(debugAnchors.length);
					
					anchor.addChild(label);
					addChild(anchor);
					debugAnchors.push(anchor);
					
					anchor.addEventListener(MouseEvent.MOUSE_DOWN, onAnchorDown);
					anchor.addEventListener(MouseEvent.MOUSE_UP, onAnchorUp);
				}
			}
		}
		
		protected function onAnchorDown(event:MouseEvent):void 
		{
			anchorDown = Sprite(event.target);
			anchorDown.startDrag();
			anchorIndex = debugAnchors.indexOf(anchorDown);
			if (stage) stage.addEventListener(MouseEvent.MOUSE_MOVE, onAnchorMove);
		}
		
		private function onAnchorMove(event:MouseEvent):void 
		{
			triangleData.vertices[anchorIndex * 2]     = anchorDown.x;
			triangleData.vertices[anchorIndex * 2 + 1] = anchorDown.y;
			redraw();
			event.updateAfterEvent();
		}
		
		protected function onAnchorUp(event:MouseEvent):void 
		{
			if (anchorDown)
			{
				anchorDown.stopDrag();
				anchorDown.removeEventListener(MouseEvent.MOUSE_MOVE, onAnchorMove);
			}
		}
		
		public function redraw():void
		{
			graphics.clear();
			graphics.beginBitmapFill(bitmapData);
			graphics.drawTriangles(triangleData.vertices, triangleData.indices, triangleData.uvtData);
			graphics.endFill();
		}
		
		public function get debugMode():Boolean { return _debugMode; }
	}
}