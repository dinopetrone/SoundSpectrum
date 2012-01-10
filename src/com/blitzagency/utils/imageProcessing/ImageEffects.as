package com.blitzagency.utils.imageProcessing
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.geom.Matrix;
	
	public class ImageEffects
	{
		public static function pixelate(target:DisplayObject, pixelSize:uint):Bitmap
		{
			var bitmapData :BitmapData = new BitmapData(target.width / pixelSize, target.height / pixelSize, false);
			var bitmap     :Bitmap = new Bitmap(bitmapData);
			
			var scaleMatrix:Matrix = new Matrix();
			scaleMatrix.scale(1 / pixelSize, 1 / pixelSize);
			
			bitmapData.draw(target, scaleMatrix);
			
			bitmap.width = target.width;
			bitmap.height = target.height;
			
			return bitmap
		}
		
		public static function slice(image:DisplayObject, rows:int, columns:int):TriangleMesh
		{
			var bd:BitmapData = new BitmapData(image.width, image.height, true, 0x00000000);
			bd.draw(image);
			
			var tData :TriangleData = defineTriangles(image.width, image.height, rows, columns);
			var mesh  :TriangleMesh = new TriangleMesh(bd, tData);
			
			return mesh;
		}
		
		public static function defineTriangles(width:Number, height:Number, rows:int, columns:int):TriangleData
		{
			var td  :TriangleData = new TriangleData();
			var dx  :Number = width / rows;
			var dy  :Number = height / columns;
			
			td.vertices = new Vector.<Number>();
			td.uvtData  = new Vector.<Number>();
			td.indices  = new Vector.<int>();
			
			for (var y:int = 0; y < rows; y++) 
			{
				for(var x:int = 0; x < columns; x++)
				{
					td.vertices.push(dx * x, dy * y);
					td.uvtData.push(x / (columns - 1), y / (rows - 1));
				}
			}
			
			for (y = 0; y < rows - 1; y++) 
			{
				for(x = 0; x < columns - 1; x++)
				{
					var i:int = x + y * columns;
					td.indices.push(i, i + 1, i + columns + 1);
					td.indices.push(i, i + columns + 1, i + columns);
				}
			}
			
			return td;
		}
	}
}