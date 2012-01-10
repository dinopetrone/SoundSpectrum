package com.blitzagency.utils
{
	/*
	 * @author Yosef Flomin
	*/
	
	import flash.utils.describeType;
	import flash.utils.getDefinitionByName;
	
	/**
	 *  You can specify <to> if the class your cloning has constructor arguments.
	 *  Otherwise a new Class will be instantiated and returned.
	 */
	public function clone(from:*, to:* = null):*
	{
		var xmlType:XML = describeType(from);
		
		var classPath:String = xmlType.@alias;
		if (!String(classPath))
		{
			classPath = xmlType.@name;
			classPath = classPath.replace("::", ".");
			classPath = classPath.replace("$", "");
		}
		
		if (classPath == "void") return to ? to : null;
		var ObjClass:Class = Class(getDefinitionByName(classPath));
		var obj:* = to ? to : new ObjClass();
		
		var xmlList:XMLList = xmlType..variable;
		
		// This is just an object, try to copy properties from "from" to "to"
		if (!xmlList.toString())
		{
			for (var prop:String in from)
			{
				if (to.hasOwnProperty(prop)) to[prop] = from[prop];
				else
				{
					trace("Warning: Property \"" + prop + "\" does not exist on " + to + " from " + from);
				}
			}
		}
		else
		{
			for each( var variable:XML in xmlList ) 
			{
				if (variable.@type == "Array")
				{
					obj[variable.@name] = [];
					for ( var i:int = 0; i < from[variable.@name].length; i++ ) 
					{
						obj[variable.@name].push(from[variable.@name][i]);
					}
				}
				else obj[variable.@name] = from[variable.@name];
			}
		}
		
		return obj;
	}
}

/*
<type name="application.vo::UserVo" base="Object" isDynamic="false" isFinal="false" isStatic="false" alias="application.vo.UserVo">
  <extendsClass type="Object"/>
  <variable name="myLand" type="application.vo::MyLandVo"/>
  <method name="clone" declaredBy="application.vo::UserVo" returnType="application.vo::UserVo"/>
</type>
*/
