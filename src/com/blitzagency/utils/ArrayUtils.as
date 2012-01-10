package com.blitzagency.utils
{
	/*
	 * @author Yosef Flomin
	*/
	
	public class ArrayUtils
	{
		public static function fromXMLList(list:XMLList, objectLabel:String = null):Array
		{
			var arr:Array = [];
			for each( var xml:XML in list ) 
			{
				if (objectLabel)
				{
					var obj:Object = { };
					obj[objectLabel] = xml;
					arr.push(obj);
				}
				else arr.push(xml);
			}
			return arr;
			
		}
		
		/**
		 * @author	Max Maxwell
		 */
		public static function shuffle(array:Array):Array
		{
			var arr1:Array = array.slice();
			var arr2:Array = [];
			
			while (arr1.length > 0)
			{
				arr2.push(arr1.splice(Math.round(Math.random() * (arr1.length - 1)), 1)[0]);
			}
			
			return arr2;
		}
	}
}