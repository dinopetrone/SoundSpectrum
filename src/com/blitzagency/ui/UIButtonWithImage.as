package com.blitzagency.ui
{
	import com.blitzagency.ui.UIButton;
	
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.geom.Rectangle;

	public class UIButtonWithImage extends UIButton
	{
		[Public]
		public var imageXOffset :Number = 0;
		public var imageYOffset :Number = 0;
		public var rect			:Rectangle;
		
		[Private]
		
		[Getters_Setters]
		private var _content    :DisplayObject;
		private var _image      :Loader;
		
		[Stage]
		public var imageContainer :Sprite;
		
		public function UIButtonWithImage(  )
		{
			super();
			if(!imageContainer){
				imageContainer = new Sprite();
				addChild(imageContainer);
			}
		}
		
		override protected function init():void 
		{
			super.init();
		}
		
		public function set image(value:Loader):void
		{
			_image = value;
			_content = value.content;
			imageContainer.addChild(value);
			value.x = imageXOffset;
			value.y = imageYOffset;
			
			if(rect != null)
			{
				value.x = (rect.width / 2) - (value.width / 2);
				value.y = (rect.height / 2) - (value.height / 2);
			}
		}
		
		public function get content():DisplayObject{
			return _content;
		}
		
		public function get image():Loader { return _image; }
		
	}
}
