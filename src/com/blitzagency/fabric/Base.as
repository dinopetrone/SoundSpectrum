package com.blitzagency.fabric {
	
	/*
	 * @author Patrick Matte
	 * @since 1.0 02/18/2009
	 * @version 1.0 02/18/2009
	 * 
	 * @modified Yosef Flomin
	 * @revision 1.1 2010/05/17
	 * @note revised to extend EventDispatcherBase
	*/
	
	import flash.events.EventDispatcher;
	
	/**
	* Base is an abstract class that includes methods to evaluate objects from target paths.
	*/
	public class Base extends EventDispatcher {
		
		/**
		* Scope is the object from which the targetpaths will be evaluated.
		*/
		public var scope:Object;
		
		/**
		* Base is an abstract class that includes methods to evaluate objects from target paths.
		* @param scope - The object from which the targetpaths will be evaluated.
		*/
		public function Base(scope:Object) {
			super();
			this.scope = scope;
		}
		
		/**
		* Evaluates an object from the specified target path
		* @param targetPath - The targetpath to the object. ex.: "object.object[4].object[test].object"
		* @return The evaluated object.
		*/
		public function findTarget(targetPath:String):Object {
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
		* ex.: parseString(image1_{settings.language}_{settings.bandwidth}.jpg) could return 'image1_en_hi.jpg' if settings.language equals 'en' and settings.bandwidth equal 'hi'.
		* @param value - string to evaluate ex.: 'image1_{settings.language}_{settings.bandwidth}.jpg'.
		* @return The evaluated object.
		*/
		public function parseString(value:String):String {
			var parsedString:String = "";
			var parsedArray:Array = value.split("{");
			for (var i = 0; i < parsedArray.length; i++) {
				if (parsedArray[i].indexOf("}") != -1) {
					var parsedArray2:Array = parsedArray[i].split("}");
					var target:Object = findTarget(parsedArray2[0]);
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