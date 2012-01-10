package com.blitzagency.utils 
{
	/*
	 * @author Yosef Flomin
	*/
	
	public class NumberUtils
	{
		public function NumberUtils() { };
		
		/**
		 *  Converts a Number to a String. If the Number has less digits than <maxDigits> 
		 *  zero's will be added until the String has equal length as <maxDigits>;
		 * 
		 * @param number    <Number> This is obviouse.
		 * @param maxDigits <int (default = 2)> If the number is less than this value, zeros will be added until the String lenght is equal to the value.
		 * 
		 */
		public static function zeroPadding( number:Number, maxDigits:int = 2 ):String
		{
			var numberAsString:String = number.toString();
			while (numberAsString.length < maxDigits) {
				numberAsString = "0" + numberAsString;
			}
			return numberAsString;
		}
		
		/**
		 *  Returns a random number between the maxValue and the minValue.
		 */
		public static function random( maxValue:Number = 100, minValue:Number = 0, round:Boolean = false ):Number
		{
			if ( round ) {
				return Math.floor(Math.random() * (1 + maxValue - minValue)) + minValue;
			}
			return ( Math.random() * ( maxValue - minValue ) ) + minValue;
		}
		
		/**
		 *  Evaluates parameters max, min and x to see if x is within the range of max and min.
		 *  If [x > max] or [x < min] it will return max or min respectively, otherwise it will
		 *  return x.
		 */
		public static function range( min:Number, x:Number, max:Number ):Number
		{
			return x < min ? min : (x > max ? max : x);
		}
		
		public static function commaParse( value:int ):String
		{
			var str:String = value.toString();
			var tempArr:Array = str.split("");
			tempArr = tempArr.reverse();
			
			var count:Number = 0
			for ( var i = 0; i < tempArr.length; i++) {
				count++
				if ( count >= 3 && ( i + 1 != tempArr.length ))	{	
					tempArr.splice(i + 1, 0, [","]);
					i++
					count =0
				}
			}
			tempArr = tempArr.reverse();
			return tempArr.join( "" );
		}
	}
}