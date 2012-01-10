package com.blitzagency.utils {

	import flash.utils.*;
	
	public class Trace {
		
		/**
		* Traces out a dynamic object.
		* @param obj - The object you want to trace out.
		* @param level - level is just used to indent the trace  result with spaces.
		*/
		public static function recurse(obj:Object, level:Number = -1):void {
			level++;
			for (var i in obj) {
				var string:String = "";
				for (var j = 0; j < level; j++) {
					string = string + "  ";
				}
				trace(string + "" + i + " = " + obj[i]);
				var classType:String = getQualifiedClassName(obj[i]);
				if (classType != "XML" && classType != "XMLList") {
					recurse(obj[i], level);
				}
			}
		}
		
	}
	
}