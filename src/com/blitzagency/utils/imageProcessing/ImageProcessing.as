package com.blitzagency.utils.imageProcessing
{
	/*
	 * @author Yosef Flomin
	*/
	
	import com.blitzagency.utils.GeomMath;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class ImageProcessing
	{
		public static const IN_RANGE  :String = "><";
		public static const OUT_RANGE :String = "<>";
		
		[Public]
		public var featureColors  :Object;
		public var totalFeatures  :uint;
		
		[Private]
		private var diff          :uint = 2000000;
		private var edgeDiff      :uint = 500000;
		private var zero          :Point = new Point();
		private var byte          :uint = 8;
		
		private var fc            :Object         // temp place to store existing feature color
		private var tpo           :Point;         // temp point to consider
		private var tw            :uint;          // temp length of X pixels vector
		private var th            :uint;          // temp length of Y pixels vector
		private var x             :uint;          // temp x loop value
		private var y             :uint;          // temp y loop value
		private var ti            :uint;          // temp index of points in [circlePoints]
		private var tc            :Vector.<uint>; // temp pixel vector
		private var tpi           :uint;          // temp pixel to consider
		private var tpr           :uint;          // temp pixel on radius to consider
		private var d             :int;           // temp radius to center pixel value delta
		private var td            :int;           // temp sum of radius to center pixel value deltas
		private var tbd           :BitmapData;    // temp bitmap data
		
		private var r             :uint;          // temp red value of center
		private var g             :uint;          // temp green value of center
		private var b             :uint;          // temp blue value of center
		private var r1            :uint;          // temp red value of radius
		private var g1            :uint;          // temp green value of radius
		private var b1            :uint;          // temp blue value of radius
		private var r2            :uint;          // temp red value of radius
		private var g2            :uint;          // temp green value of radius
		private var b2            :uint;          // temp blue value of radius
		
		private var ps            :uint;          // temp pixels to skip for thresholding
		private var pi            :int;           // temp amplification iteration thresholding
		private var tpx           :int;           // temp x amplification iteration thresholding
		private var tpy           :int;           // temp y amplification iteration thresholding
		private var pxi           :int;           // temp x min amplification iteration thresholding
		private var pxa           :int;           // temp x man amplification iteration thresholding
		private var pyi           :int;           // temp y min amplification iteration thresholding
		private var pya           :int;           // temp y max amplification iteration thresholding
		private var a             :uint;          // temp auto pixel skipping bool for thresholding
		
		private var vcS           :Vector.<uint>; // temp source vector
		private var vcT           :Vector.<uint>; // temp target vector
		private var npx           :uint;          // temp vector x y pixel location
		
		private var apx           :Object;        // temp amplified pixels x
		private var apy           :Object;        // temp amplified pixels y
		private var sx            :uint = 0;      // temp bool if pixel was amplified
		
		// Provides a faster method
		// of getting pixels on radius
		private var px1           :int;           // -- temp points on circle round the center -- \/
		private var px2           :int;
		private var px3           :int;
		private var px4           :int;
		private var px5           :int;
		private var px6           :int;
		private var px7           :int;
		private var px8           :int;
		private var py1           :int;
		private var py2           :int;
		private var py3           :int;
		private var py4           :int;
		private var py5           :int;
		private var py6           :int;
		private var py7           :int;
		private var py8           :int;           // --------------------------------------------- /\
		
		private var tp1           :uint;          // temp pixel deltas on circle round the center  \/
		private var tp2           :uint;
		private var tp3           :uint;
		private var tp4           :uint;
		private var tp5           :uint;
		private var tp6           :uint;
		private var tp7           :uint;
		private var tp8           :uint;          // --------------------------------------------- /\
		
		[Getters_Setters]
		private var _pointsToTest :uint = 8;      // Do not change unless you are using the linked list
		private var _radius       :uint = 2;
		private var _imageWidth   :Number = 1;
		private var _imageHeight  :Number = 1;
		
		public function ImageProcessing(width:Number = 320, height:Number = 240)
		{
			imageWidth = width;
			imageHeight = height;
			init();
		}
		
		private function init():void
		{
			generateCirclePoints();
		}
		
		public function thresholdWithVec(target:BitmapData, source:BitmapData, lowThreshold:uint, highThreshold:uint = 0xFFFFFFFF, operation:String = "><", color:uint = 0xFFFFFFFF, amplification:uint = 0, pixelsToSkip:uint = 0, copySource:Boolean = false, rect:Rectangle = null, dest:Point = null):void
		{
			rect = rect ? rect : source.rect;
			dest = dest ? dest : zero;
			
			vcS = source.getVector(rect);
			vcT = target.getVector(rect);
			tw  = target.width;
			th  = target.height;
			pi  = amplification;
			a   = pixelsToSkip; 
			ps  = a ? pixelsToSkip + 1 : 1;
			apx = { };
			
			r1 = (lowThreshold >>> 16) & 255; 
			g1 = (lowThreshold >>> 8) & 255; 
			b1 = lowThreshold & 255;
			
			r2 = (highThreshold >>> 16) & 255; 
			g2 = (highThreshold >>> 8) & 255; 
			b2 = highThreshold & 255;
			
			// Loop through width pixels
			for (x = 0; x < tw; x += ps) 
			{
				if (pi)	
				{
					// check amplification bounds (width < x > 0)
					pxi = (x < pi) ? 0 : -pi;
					pxa = (x + pi > tw) ? 0 : pi;
				}
				sx = apx[x] ? 1 : 0;
				apy = { };
				
				// Loop through height pixels
				for (y = 0; y < th; y += ps) 
				{
					// amplified pixels, skip em
					while (sx && apy[y]) y++;
					
					// Store pixel value
					npx = x + (tw * y); // source.getPixel(x, y);
					tpi = vcS[npx];
					r = (tpi >>> 16) & 255; 
					g = (tpi >>> 8) & 255; 
					b = tpi & 255;
					
					if (operation == "><")
					{
						// within r, g, b range
						if (r > r1 && 
							r < r2 && 
							g > g1 && 
							g < g2 && 
							b > b1 && 
							b < b2)
						{
							vcT[npx] = color; // target.setPixel(x, y, color);
							
							// amplify?
							if (!pi) continue;
							
							// check amplification bounds (height < y > 0)
							pyi = (y < pi) ? 0 : -pi;
							pya = (y + pi > th) ? 0 : pi;
							
							// set pixels around center to same color
							for (tpx = pxi; tpx < pxa; tpx++) 
							{
								for (tpy = pyi; tpy < pya; tpy++) 
								{
									if (tpx == 0 && tpy == 0 ) continue;
									//target.setPixel(x + tpx, y + tpy, color);
									vcT[x + tpx + (tw * (y + tpy))] = color;
									
									// we dont need to process these pixels, lets skip em on next iteration
									apx[x + tpx] = 1; apy[y + tpy] = 1;
								}
							}
						}
						else {
							if (copySource) vcT[npx] = vcS[npx]; //target.setPixel(x, y, source.getPixel(x, y));
						}
					}
					else if (operation == "<>") 
					{
						// outside r, g, b range
						if (r < r1 || 
							r > r2 || 
							g < g1 || 
							g > g2 || 
							b < b1 || 
							b > b2)
						{
							vcT[npx] = color; //target.setPixel(x, y, color);
							
							// amplify?
							if (!pi) continue;
							
							// check amplification bounds (height, width < x , y > 0)
							pyi = (y < pi) ? 0 : -pi;
							pya = (y + pi > th) ? 0 : pi;
							
							// set pixels around center to same color
							for (tpx = pxi; tpx < pxa; tpx++) 
							{
								for (tpy = pyi; tpy < pya; tpy++) 
								{
									if (tpx == 0 && tpy == 0 ) continue;
									//target.setPixel(x + tpx, y + tpy, color);
									vcT[x + tpx + (tw * (y + tpy))] = color;
									
									// we dont need to process these pixels, lets skip em on next iteration
									apx[x + tpx] = 1; apy[y + tpy] = 1;
								}
							}
						}
						else 
						{
							if (copySource) vcT[npx] = vcS[npx]; //target.setPixel(x, y, source.getPixel(x, y));
						}
					}
				}
			}
			target.setVector(rect, vcT);
		}
		
		public function thresholdWithBd(target:BitmapData, source:BitmapData, lowThreshold:uint, highThreshold:uint = 0xFFFFFFFF, operation:String = "><", color:uint = 0xFFFFFFFF, amplification:uint = 0, pixelsToSkip:uint = 0, copySource:Boolean = false, rect:Rectangle = null, dest:Point = null):void
		{
			rect = rect ? rect : source.rect;
			dest = dest ? dest : zero;
			
			tw  = target.width;
			th  = target.height;
			pi  = amplification;
			a   = pixelsToSkip; 
			ps  = a ? pixelsToSkip + 1 : 1;
			apx = { };
			
			r1 = (lowThreshold >>> 16) & 255; 
			g1 = (lowThreshold >>> 8) & 255; 
			b1 = lowThreshold & 255;
			r2 = (highThreshold >>> 16) & 255; 
			g2 = (highThreshold >>> 8) & 255; 
			b2 = highThreshold & 255;
			
			// Loop through width pixels
			for (x = 0; x < tw; x += ps) 
			{
				if (pi)	
				{
					// check amplification bounds (width < x > 0)
					pxi = (x < pi) ? 0 : -pi;
					pxa = (x + pi > tw) ? 0 : pi;
					sx = apx[x] ? 1 : 0;
					apy = { };
				}
				
				// Loop through height pixels
				for (y = 0; y < th; y += ps) 
				{
					// amplified pixels, skip em
					if (pi) while (sx && apy[y]) y++;
					
					// Store pixel value
					tpi = source.getPixel(x, y);
					r = (tpi >>> 16) & 255; g = (tpi >>> 8) & 255; b = tpi & 255;
					
					if (operation == "><")
					{
						// within r, g, b range
						if (r > r1 && 
							r < r2 && 
							g > g1 && 
							g < g2 && 
							b > b1 && 
							b < b2)
						{
							target.setPixel(x, y, color);
							
							// amplify?
							if (!pi) continue;
							
							// check amplification bounds (height < y > 0)
							pyi = (y < pi) ? 0 : -pi;
							pya = (y + pi > th) ? 0 : pi;
							
							// set pixels around center to same color
							for (tpx = pxi; tpx < pxa; tpx++) 
							{
								for (tpy = pyi; tpy < pya; tpy++) 
								{
									if (tpx == 0 && tpy == 0 ) continue;
									target.setPixel(x + tpx, y + tpy, color);
									
									// we dont need to process these pixels, lets skip em on next iteration
									apx[x + tpx] = 1; apy[y + tpy] = 1;
								}
							}
						}
						else 
						{
							if (copySource) target.setPixel(x, y, source.getPixel(x, y));
						}
					}
					else if (operation == "<>")
					{
						// outside r, g, b range
						if (r < r1 || 
							r > r2 || 
							g < g1 || 
							g > g2 || 
							b < b1 || 
							b > b2)
						{
							target.setPixel(x, y, color);
							
							// amplify?
							if (!pi) continue;
							
							// check amplification bounds (height, width < x , y > 0)
							pyi = (y < pi) ? 0 : -pi;
							pya = (y + pi > th) ? 0 : pi;
							
							// set pixels around center to same color
							for (tpx = pxi; tpx < pxa; tpx++) 
							{
								for (tpy = pyi; tpy < pya; tpy++) 
								{
									if (tpx == 0 && tpy == 0 ) continue;
									target.setPixel(x + tpx, y + tpy, color);
									
									// we dont need to process these pixels, lets skip em on next iteration
									apx[x + tpx] = 1; apy[y + tpy] = 1;
								}
							}
						}
						else 
						{
							if (copySource) target.setPixel(x, y, source.getPixel(x, y));
						}
					}
				}
			}
		}
		
		public function getEdges(bd:BitmapData, amplification:uint = 0, pixelsToSkip:uint = 0):BitmapData
		{
			pi  = amplification;
			a   = pixelsToSkip; 
			ps  = a ? pixelsToSkip + 1 : 1;
			apx = { };
			
			tw = bd.width;
			th = bd.height;
			featureColors = fc = { };
			totalFeatures = 0;
			
			// Loop through width pixels
			for (x = radius; x < tw - radius; x+=ps) 
			{
				if (pi)	
				{
					// check amplification bounds (width < x > 0)
					pxi = (x < pi) ? 0 : -pi;
					pxa = (x + pi > tw) ? 0 : pi;
					sx = apx[x] ? 1 : 0;
					apy = { };
				}
				
				// Loop through height pixels
				for (y = radius; y < th - radius; y+=ps) 
				{
					// amplified pixels, skip em
					if (pi) while (sx && apy[y]) y++;
					
					// Store pixel value
					tpi = bd.getPixel(x, y);
					
					// Iterate through points on radius. This replaces a loop
					// through a list as the fastest method of computation
					// -- get pixel on radius. -- get absolute value of center pix minus radius pix
					tpr = bd.getPixel(px1 + x, px1 + y); tp1 = (tpr < tpi) ? tpi - tpr : tpr - tpi;
					tpr = bd.getPixel(px2 + x, px2 + y); tp2 = (tpr < tpi) ? tpi - tpr : tpr - tpi;
					tpr = bd.getPixel(px3 + x, px3 + y); tp3 = (tpr < tpi) ? tpi - tpr : tpr - tpi;
					tpr = bd.getPixel(px4 + x, px4 + y); tp4 = (tpr < tpi) ? tpi - tpr : tpr - tpi;
					tpr = bd.getPixel(px5 + x, px5 + y); tp5 = (tpr < tpi) ? tpi - tpr : tpr - tpi;
					tpr = bd.getPixel(px6 + x, px6 + y); tp6 = (tpr < tpi) ? tpi - tpr : tpr - tpi;
					tpr = bd.getPixel(px7 + x, px7 + y); tp7 = (tpr < tpi) ? tpi - tpr : tpr - tpi;
					tpr = bd.getPixel(px8 + x, px8 + y); tp7 = (tpr < tpi) ? tpi - tpr : tpr - tpi;
					
					// sum of differences
					td = tp1 + tp2 + tp3 + tp4 + tp5 + tp6 + tp7 + tp8;
					
					if (td > diff) {
						tbd.setPixel(x, y, td);
						
						// amplify?
						if (!pi) continue;
						
						// check amplification bounds (height, width < x , y > 0)
						pyi = (y < pi) ? 0 : -pi;
						pya = (y + pi > th) ? 0 : pi;
						
						// set pixels around center to same color
						for (tpx = pxi; tpx < pxa; tpx++) 
						{
							for (tpy = pyi; tpy < pya; tpy++) 
							{
								if (tpx == 0 && tpy == 0 ) continue;
								tbd.setPixel(x + tpx, y + tpy, td);
								
								// we dont need to process these pixels, lets skip em on next iteration
								apx[x + tpx] = 1; apy[y + tpy] = 1;
							}
						}
							
						// NOT USED
						
						// store the 'id' of this edge if it doesnt exist already
						// use fc to store which 'color range' id already exists
						//if (!fc[td])
						//{
							//fc[td] = td;
							
							// use featureColors so we can cycle through them
							// this complicated version of using an object is
							// faster than using arrays or vectors
							//featureColors[totalFeatures] = td;
							//totalFeatures++;
						//}
					}
					else tbd.setPixel(x, y, 0x000000);
				}
			}
			return tbd;
		}
		
		private function generateCirclePoints():void
		{
			for (var i:int = 0; i < pointsToTest; i++) 
			{
				var p:Point = GeomMath.circlePoint(radius, 360 - (360 / pointsToTest * i));
				this['px' + (i + 1)] = Math.round(p.x);
				this['py' + (i + 1)] = Math.round(p.y);
			}
		}
		
		public function set radius( value:uint ):void 
		{
			_radius = value;
			generateCirclePoints()
		}
		
		public function set pointsToTest( value:uint ):void 
		{
			_pointsToTest = value;
			generateCirclePoints()
		}
		
		public function set imageWidth( value:Number ):void 
		{
			_imageWidth = value;
			tc = new Vector.<uint>(value * imageHeight);
			tbd = new BitmapData(value, imageHeight, false, 0x000000);
		}
		
		public function set imageHeight( value:Number ):void 
		{
			_imageHeight = value;
			tc = new Vector.<uint>(imageWidth * value);
			tbd = new BitmapData(imageWidth, value, false, 0x000000);
		}
		
		public function get radius():uint { return _radius; }
		
		public function get pointsToTest():uint { return _pointsToTest; }
		
		public function get imageWidth():Number { return _imageWidth; }
		
		public function get imageHeight():Number { return _imageHeight; }
	}
}