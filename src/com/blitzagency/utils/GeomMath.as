package com.blitzagency.utils
{
	/*
	 * @author Yosef Flomin
	*/
	
	public class GeomMath 
	{
		public var x         :Number;
		public var y         :Number;
		public var z         :Number;
		public var rotation  :Number;
		public var rotationX :Number;
		public var rotationY :Number;
		public var rotationZ :Number;
		
		public function GeomMath(props:Object = null) 
		{ 
			for ( var prop:String in props ) 
			{
				if (hasOwnProperty(prop)) this[prop] = props[prop];
			}
		}
		
		public static function degToRad( degrees:Number ):Number
		{
			return ( Math.PI * degrees ) / 180;
		}
		
		public static function radToDeg( radian:Number ):Number
		{
			return ( 180 * radian ) / Math.PI
		}
		
		public static function triangleAngle( x:Number, y:Number, direction:Number = 1 ):Number
		{
			return radToDeg( Math.atan2(y, x) ) * direction;
		}
		
		public static function circlePoint( radius:Number, angle:Number ):GeomMath
		{
			var radians :Number = degToRad( angle );
			var xCoord  :Number = Math.cos( radians ) * radius;
			var yCoord  :Number = Math.sin( radians ) * radius;
			
			return new GeomMath( { x:xCoord, y:yCoord } );
		}
		
		public static function spherePoint( radius:Number, rotationY:Number, rotationX:Number ):GeomMath
		{
			var radiansX :Number = degToRad( rotationX );
			var xCoord2  :Number = radius * Math.cos( radiansX );
			var yCoord2  :Number = radius * Math.sin( radiansX );
			
			var radiansY :Number = degToRad( rotationY );
			var xCoord   :Number = xCoord2 * Math.cos( radiansY );
			var yCoord   :Number = xCoord2 * Math.sin( radiansY );
			
			return new GeomMath({ x:xCoord, y:yCoord2, z:yCoord });
		}
		
		public static function ellipsePoint(widthRadius:Number, heightRadius:Number, rotation:Number, xPos:Number, yPos:Number):GeomMath
		{
			var obj:Object = {};
			var t:Number = Math.atan2(yPos, xPos);
			t -= degToRad(rotation);
			
			obj.x = widthRadius * Math.cos(t) * Math.cos(rotation) - heightRadius * Math.sin(t) * Math.sin(rotation);
			obj.y = widthRadius * Math.cos(t) * Math.sin(rotation) + heightRadius * Math.sin(t) * Math.cos(rotation);
			obj.rotation = t;
			
			return new GeomMath(obj);
		}
		
		public static function ellipsoidPoint(widthRadius:Number, heightRadius:Number, depthRadius:Number, rotationY:Number, rotationZ:Number, xPos:Number, yPos:Number, zPos:Number):GeomMath
		{
			var numb3d :Object = { };
			var angleZ :Number = Math.atan2(yPos, xPos);
			var angleX :Number = Math.atan2(zPos, xPos);
			
			angleZ -= degToRad(rotationZ);
			angleX -= degToRad(rotationY);
			
			numb3d.x = widthRadius * Math.cos(angleZ) * Math.cos(rotationZ) - heightRadius * Math.sin(angleZ) * Math.sin(rotationZ);
			numb3d.y = widthRadius * Math.cos(angleZ) * Math.sin(rotationZ) + heightRadius * Math.sin(angleZ) * Math.cos(rotationZ);
			numb3d.z = depthRadius * Math.cos(angleX) * Math.sin(rotationY) + heightRadius * Math.sin(angleX) * Math.cos(rotationY);
			
			return new GeomMath(numb3d);
		}
	}
}