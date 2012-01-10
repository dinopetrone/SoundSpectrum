package com.blitzagency.ui
{
	import flash.display.MovieClip;
	import flash.text.TextFormat;
	
	public class UITextFieldAsMask extends MovieClip
	{
		[Public]
		
		[Private]
		
		[Getters_Setters]
		
		[Stage]
		public var textField:UITextField;
		
		public function UITextFieldAsMask()
		{
			super();
			init();
		}
		
		protected function init():void 
		{
			
		}
		
		
		public function get text():String 
		{
			return textField.text;
		}
		
		public function set text(value:String):void 
		{
			textField.text = value;
		}
		
		public function get htmlText() :String
		{
			return textField.htmlText;
		}
		
		public function set htmlText(value:String):void 
		{
			textField.htmlText = value;
		}
		
		override public function set width(value:Number):void 
		{
			textField.width = value;
		}
		
		override public function get width():Number 
		{
			return textField.width;
		}
		
		override public function set height(value:Number):void 
		{
			textField.height = value;
		}
		
		override public function get height():Number 
		{
			return textField.height;
		}
		
		public function set marginTop(value:Number):void 
		{
			textField.marginTop = value;
		}
		
		public function get marginTop():Number 
		{
			return textField.marginTop;
		}
		
		public function set marginBottom(value:Number):void 
		{
			textField.marginBottom = value;
		}
		
		public function get marginBottom():Number 
		{
			return textField.marginBottom;
		}
		
		public function set marginLeft(value:Number):void 
		{
			textField.marginLeft = value;
		}
		
		public function get marginLeft():Number 
		{
			return textField.marginLeft
		}
		
		public function set marginRight(value:Number):void 
		{
			textField.marginRight = value;
		}
		
		public function get marginRight():Number 
		{
			return textField.marginRight;
		}
		
		public function set autoSize(value:Boolean ):void 
		{
			textField.autoSize = value;
		}
		
		public function get autoSize():Boolean 
		{
			return textField.autoSize
		}
		
		public function get textWidth()	:Number 
		{
			return textField.textWidth;
		}
		
		public function get textHeight():Number 
		{
			return textField.textHeight;
		}
		
		public function get maxScrollH():Number 
		{
			return textField.maxScrollH;
		}
		
		public function get maxScrollV():Number 
		{
			return textField.maxScrollV;
		}
		
		public function set scrollV(value:Number):void 
		{
			textField.scrollV = value;
		}		
		
		public function get scrollV():Number 
		{
			return textField.scrollV;
		}
		
		public function set scrollH(value:Number):void 
		{
			textField.scrollH = value;
		}
		
		public function get scrollH():Number 
		{
			return textField.scrollH;
		}
		
		public function set multiline(value:Boolean):void 
		{
			textField.multiline = value;
		}
		
		public function get multiline():Boolean 
		{
			return textField.multiline;
		}
		
		public function get wordWrap():Boolean 
		{
			return textField.wordWrap;
		}
		
		public function set wordWrap(value:Boolean):void 
		{
			textField.wordWrap = value;
		}
		
		public function setTextFormat(format:TextFormat, beginIndex:int = -1, endIndex:int = -1):void 
		{
			textField.setTextFormat(format, beginIndex, endIndex);
		}
		
		public function getTextFormat(beginIndex:int = -1, endIndex:int = -1):TextFormat 
		{
			return textField.getTextFormat(beginIndex, endIndex);
		}
	}
}