package com.blitzagency.away3d.view
{
	import away3d.cameras.Camera3D;
	import away3d.containers.Scene3D;
	import away3d.containers.View3D;
	import com.blitzagency.utils.operationQue.OperationQue;
	import flash.events.Event;
	
	public class BasicView extends View3D
	{
		[Public]
		public var autoResize :Boolean = true;
		
		[Private]
		
		[Getters_Setters]
		
		[Stage]
		
		public function BasicView( initializers:Object = null )
		{
			super(initializers);
			init();
		}
		
		protected function init():void 
		{
			scene  = new Scene3D();
			camera = new Camera3D();
			camera.z = -1000;
			
			addEventListener(Event.ADDED_TO_STAGE, addedToStage);
		}
		
		protected function addedToStage( event:Event ):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
			stage.addEventListener(Event.RESIZE, resize);
		}
		
		protected function resize( event:Event = null ):void 
		{
			if (autoResize)
			{
				x = stage.stageWidth / 2;
				y = stage.stageHeight / 2;
			}
		}
		
		public function startRendering():void
		{
			OperationQue.instance.addEnterFrame(this, render);
		}
		
		public function stopRendering():void
		{
			OperationQue.instance.remove(render);
		}
	}
}