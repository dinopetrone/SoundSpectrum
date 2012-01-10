package com.blitzagency.ui {	
	
	/*
	 * @author Patrick Matte
	 * @since 1.0 2008/10/08
	 * @version 1.1 2008/11/03
	 * 
	 * @modified Yosef Flomin
	 * @revision 1.2 2010/04/30
	 * 
	 * @modified Yosef Flomin
	 * @revision 1.3 2011/01/18
	*/
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	public class UITextField extends MovieClip {
		
		public var background:DisplayObject;
		public var textField:TextField;
		
		private var _marginTop:Number = 0;
		private var _marginLeft:Number = 0;
		private var _marginRight:Number = 0;
		private var _marginBottom:Number = 0;
		
		private var _autoSize:Boolean;
		
		// @r1.3
		private var _autoFontResize:Boolean;
		
		public function UITextField() {
			if (background) {
				_marginTop = textField.y;
				_marginLeft = textField.x;
				_marginRight = background.width - textField.x - textField.width;
				_marginBottom = background.height - textField.y - textField.height;
			}
			
			// @r1.2
			textField.defaultTextFormat = textField.getTextFormat();
		}
		
		public function get text():String {
			return textField.text;
		}
		
		public function set text(value:String):void {
			// @r1.2
			htmlText = value;
		}
		
		public function get htmlText() :String {
			return textField.htmlText;
		}
		
		public function set htmlText(value:String):void {
			textField.htmlText = value;
			if (autoSize && background) {
				width = marginLeft + textField.width + marginRight;
			}
			// @r1.3
			if (autoFontResize && !autoSize) {
				var format:TextFormat = textField.getTextFormat();
				format.size = textField.defaultTextFormat.size;
				textField.setTextFormat(format);
				
				while (textField.maxScrollV > 1 || textField.maxScrollH > 1)
				{
					format.size = Number(format.size) - 1;
					textField.setTextFormat(format);
				}
			}
		}
		
		override public function set width(value:Number):void {
			textField.x = marginLeft;
			textField.width = value - marginLeft - marginRight;
			if ( background ){
				background.width = value;
			}
		}
		
		override public function get width():Number {
			var _width:Number = textField.width;
			if (background) {
				_width = background.width;
			}
			return _width;
		}
		
		override public function set height(value:Number):void {
			textField.y = marginTop;
			textField.height = value - marginTop - marginBottom;
			if (background) {
				background.height = value;
			}
		}
		
		override public function get height():Number {
			var _height:Number = textField.height;
			if (background) {
				_height = background.height;
			}
			return _height;
		}
		
		public function set marginTop(value:Number):void {
			_marginTop = value;
			height = height;
		}
		
		public function get marginTop():Number {
			return _marginTop;
		}
		
		public function set marginBottom(value:Number):void {
			_marginBottom = value;
			height = height;
		}
		
		public function get marginBottom():Number {
			return _marginBottom;
		}
		
		public function set marginLeft(value:Number):void {
			_marginLeft = value;
			width = width;
		}
		
		public function get marginLeft():Number {
			return _marginLeft
		}
		
		public function set marginRight(value:Number):void {
			_marginRight = value;
			width = width;
		}
		
		public function get marginRight():Number {
			return _marginRight;
		}
		
		public function set autoSize(value:Boolean ):void {
			_autoSize = value;
			if (value) {
				textField.autoSize = TextFieldAutoSize.LEFT;
			}else {
				textField.autoSize = TextFieldAutoSize.NONE;
			}
		}
		
		public function get autoSize():Boolean {
			return _autoSize
		}
		
		// @r1.3
		public function set autoFontResize(value:Boolean):void 
		{
			_autoFontResize = value;
			text = text;
		}
		
		// @r1.3
		public function get autoFontResize():Boolean 
		{ 
			return _autoFontResize; 
		}
		
		public function get textWidth()	:Number {
			return textField.textWidth;
		}
		
		public function get textHeight():Number {
			return textField.textHeight;
		}
		
		public function get maxScrollH():Number {
			return textField.maxScrollH;
		}
		
		public function get maxScrollV():Number {
			return textField.maxScrollV;
		}
		
		public function set scrollV(value:Number):void {
			textField.scrollV = value;
		}		
		
		public function get scrollV():Number {
			return textField.scrollV;
		}
		
		public function set scrollH(value:Number):void {
			textField.scrollH = value;
		}
		
		public function get scrollH():Number {
			return textField.scrollH;
		}
		
		public function set multiline(value:Boolean):void {
			textField.multiline = value;
		}
		
		public function get multiline():Boolean {
			return textField.multiline;
		}
		
		public function get wordWrap():Boolean {
			return textField.wordWrap;
		}
		
		public function set wordWrap(value:Boolean):void {
			textField.wordWrap = value;
		}
		
		public function setTextFormat(format:TextFormat, beginIndex:int = -1, endIndex:int = -1):void {
			textField.setTextFormat(format, beginIndex, endIndex);
		}
		
		public function getTextFormat(beginIndex:int = -1, endIndex:int = -1):TextFormat {
			return textField.getTextFormat(beginIndex, endIndex);
		}
	}
}
