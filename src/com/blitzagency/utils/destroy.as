package com.blitzagency.utils
{
	/*
	 * @author Yosef Flomin
	*/
	
	import com.blitzagency.ui.UIBase;
	import com.blitzagency.utils.operationQue.removeAllOperationsFrom;
	import flash.display.Sprite;
	import flash.system.System;
	import flash.utils.describeType;
	
	public function destroy(obj:*, recursive:Boolean = false):void
	{
		var xmlType:XML = describeType(obj);
		var xmlList:XMLList = xmlType..variable;
		
		var subXMLType:XML;
		
		removeChildrenOf(obj, recursive, true);
		removeAllOperationsFrom(obj);
		
		var destroyFunctions:Array = ["destroy", "close", "stop"];
		
		for each( var variable:XML in xmlList ) 
		{
			// Dont try nulls and Dont kill singletons
			if (obj[variable.@name] && !obj[variable.@name].hasOwnProperty("instance"))
			{
				for each( var subObj:* in obj[variable.@name] ) 
				{
					subXMLType = describeType(subObj);
					if (subXMLType.@isFinal || !recursive) subObj = null;
					else destroy(subObj, recursive);
				}
				
				subXMLType = describeType(obj[variable.@name]);
				if (subXMLType.@isFinal || !recursive) obj[variable.@name] = null;
				else destroy(obj[variable.@name], recursive);
				
				if (obj[variable.@name])
				{
					for each( var func:String in destroyFunctions ) 
					{
						if (obj[variable.@name][func])
						{
							try { obj[variable.@name][func]() } catch(e:*) { };
						}
					}
				}
			}
		}
	}
}