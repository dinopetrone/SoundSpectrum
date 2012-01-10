package com.blitzagency.utils
{
	public class Ordinal
	{
		public function Ordinal()
		{
		}
		
		public static function convert(number:int):String{
			
			if ( number == 0 ) return "--";
			return number+suffixFor(number);		
		
		}
		
		public static function suffixFor(number:int):String{
			
			var suffix:String;
			
			if (number%100>10 && number%100<14) {
				suffix = "th";
				} else {
					switch (number%10) {
					case 0 :
						suffix = "th";
					break;
					case 1 :
						suffix = "st";
					break;
					case 2 :
						suffix = "nd";
					break;
					case 3 :
						suffix = "rd";
					break;
					default :
						suffix = "th";
					break;
				}
			}
		
			return suffix;
		}

	}
}