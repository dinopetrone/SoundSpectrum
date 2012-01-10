package com.blitzagency.utils 
{
	/*
	 * @author Yosef Flomin
	*/
	
	public class StringUtils 
	{
		public function StringUtils() {};
		
		/**
		 *  Evaluates the length of <text> and <maxChars> and truncates <text> if its larger.
		 * 
		 * @param text           <String> This is obviouse.
		 * @param maxChars       <int> If the length of <text> is less than this value, <text> will be truncated.
		 * @param minChars       <int (default = 0)> Only used is <findLastPeriod> is set to true.
		 * @param findLastPeriod <Boolean (default = false)> If TRUE - Will truncate <text> to the last period found only if <br/> the index of the period is less than <minChars>.
		 * @param etc            <String (default = "...")> This String will be appended to <text>. The length of <etc> will be decreased from <maxChars>.
		 * 
		 */
		public static function truncate( text:String, maxChars:int, minChars:int = 0, findLastPeriod:Boolean = false, etc:String = "..." ):String
		{
			if ( text.length < maxChars ) { return text; }
			var truncStr:String = text.slice( 0, maxChars - etc.length );
			
			if ( findLastPeriod ){
				var lastPeriod:int = truncStr.lastIndexOf( "." );
				if ( lastPeriod >= minChars && lastPeriod != -1 ) {
					truncStr = truncStr.slice( 0, lastPeriod ) + etc;
					return truncStr;
				}
			}
			
			var lastSpace:int = truncStr.lastIndexOf( " " );
			if ( lastSpace != -1 ) {
				truncStr = truncStr.slice( 0, lastSpace ) + etc;
			}
			
			return truncStr;
		}
		
		public static function cdataToString( text:String ):String
		{
			return text.split("&lt;").join("<").split("&gt;").join(">").split("&amp;quot;").join("\"").split("&quot;").join("\"").split("&apos;").join("\'");
		}
		
		public static function stringToNumber( value:String ):Number
		{
			var num:Number = 0;
			for ( var i:int = 0; i < value.length; i++ )
			{
				num += value.charCodeAt( i );
			}
			return num;
		}
		
		public static function secondsToTimeStamp( seconds:Number, delimiter:String = ":", zeroPadding:int = 2, showSeconds:Boolean = true, showMinutes:Boolean = true, showHours:Boolean = false, showDays:Boolean = false ):String
		{
			var days    :Number = Math.floor( seconds / 86400 );
			var hours   :Number = Math.floor( seconds / 3600 % 24 );
			var minutes :Number = Math.floor( seconds / 60 % 60 );
			var seconds :Number = Math.floor( seconds % 60 );
			
			var values  :Array = [ days, hours, minutes, seconds ];
			var options :Array = [ showDays, showHours, showMinutes, showSeconds ];
			var output  :String = "";
			
			for ( var i:int = 0; i < options.length; i++ ) 
			{
				if ( options[i] )
				{
					output += NumberUtils.zeroPadding( values[i], zeroPadding ) + delimiter;
				}
			}
			
			output = output.substring(0, output.length - delimiter.length);
			
			return output;
		}
	}
}