package com.blitzagency.fabric {
	
	/*
	 * @author Patrick Matte
	 * @since 1.0 02/18/2009
	 * @version 1.0 02/18/2009
	*/
	
	/**
	* TargetPath is a utility class that includes static methods to evaluate objects from target paths.
	*/
	public class TargetPath {
		
		/**
		* Evaluates an object from the specified targetpath
		* @param targetPath - The targetpath to the object. ex.: "object.object[4].object[test].object"
		* @param scope - The object from which the targetpaths are evaluated.
		* @return The evaluated object.
		*/
		public static function findTarget(targetPath:String, scope:Object):Object {
			var target:Object = scope;
			if (targetPath.length > 0) {
				var targetArray:Array = targetPath.split(".");
				for (var i = 0; i < targetArray.length; i++) {
					var parseArray:Array = targetArray[i].split("[");
					target = target[parseArray.shift()];
					for (var j = 0; j < parseArray.length; j++ ) {
						var parseArrayString:String = parseArray[j].split("]")[0];
						target = target[parseArrayString];
					}
				}
			}
			return target;
		}
		
		/**
		* Binds strings and targetpaths together using findtarget
		* <p/>
		* ex.: parseString(image1_{settings.language}_{settings.bandwidth}.jpg) could return 'image1_en_hi.jpg'<br/>
		* if settings.language equals 'en' and settings.bandwidth equal 'hi'.
		* @param value - The string to evaluate, ie. 'image1_{settings.language}_{settings.bandwidth}.jpg'.
		* @param scope - The object from which the targetpaths are evaluated.
		* @return The evaluated object.
		*/
		public static function parseString(value:String, scope:Object):String {
			var parsedString:String = "";
			var parsedArray:Array = value.split("{");
			for (var i = 0; i < parsedArray.length; i++) {
				if (parsedArray[i].indexOf("}") != -1) {
					var parsedArray2:Array = parsedArray[i].split("}");
					var target:Object = findTarget(parsedArray2[0], scope);
					if (target) {
						parsedString += target.toString();
					}
					parsedString += parsedArray2[1];
				}else {
					parsedString += parsedArray[i];
				}
			}
			return parsedString;
		}
		
	}
	
}