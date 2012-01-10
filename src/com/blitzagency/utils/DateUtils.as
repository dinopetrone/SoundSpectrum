package com.blitzagency.utils 
{
	/*
	 * @author Yosef Flomin
	*/
	
	public class DateUtils 
	{
		public static var months     :Array = [ "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December" ];
		public static var monthsAbrv :Array = [ "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec" ];
		
		public function DateUtils() { };
		
		public static function getMonthFromStr( month:String ):int
		{
			var monthId:int = months.indexOf( month ) + 1;
			monthId = monthId ? monthId : monthsAbrv.indexOf( month ) + 1;
			
			return monthId;
		}
		
		public static function getMonthFromIndex( index:int, useAbbreviated:Boolean = false ):String
		{
			var month:String = !useAbbreviated ? months[ index + 1 ] : monthsAbrv[ index + 1 ];
			return month;
		}
		
		/**
		 *  Converts a <Date> Object to a standard date String: "mm.dd.yy";
		 * 
		 * @param fromDate	<Date> This is obviouse.
		 * @param seperator	<String (default = ".")> The Seperator to use between date values.
		 * 
		 */
		public function dateToString( date:Date, seperator:String = "." ):String
		{
			var monthStr:String = NumberUtils.zeroPadding( date.month + 1 );
			var dayStr	:String = NumberUtils.zeroPadding( date.date );
			var yearStr	:String = String( date.fullYear ).substr( 2, 2 );
			
			var dateString:String = monthStr + seperator + dayStr + seperator + yearStr;
			return dateString;
		}
		
		public static function getMinutesFromSeconds(p_sec:Number):String {
			var min:int = Math.floor(p_sec / 60);
			var sec:int = p_sec % 60;
			return sec < 10 ? min + ":0" + sec : min + ":" + sec;
		}
	}
}