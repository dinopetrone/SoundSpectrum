package com.blitzagency.utils {
	
	public class XMLAlias {
		
		private static var aliases:Object = new Object();
		
		public static function registerClassAlias(aliasName:String, classObject:Class):void {
			aliases[aliasName] = classObject;
		}
		
		public static function getClassByAlias(aliasName:String):Class {
			var classObject:Class;
			if (aliases[aliasName]) {
				classObject = aliases[aliasName];
			} else {
				throw new Error(aliasName + " is not a valid xml alias");
			}
			return classObject;
		}
		
		public static function hasClassAlias(aliasName:String):Boolean {
			return aliases.hasOwnProperty(aliasName);
		}
		
	}
	
}