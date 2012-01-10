package com.blitzagency.utils
{
	public function recurseFunction(target:Object, getChildMethod:String, childrenCountProperty:String, method:String, ...params):void
	{
		if (target.hasOwnProperty(getChildMethod) && 
			target.hasOwnProperty(childrenCountProperty))
		{
			var len:uint = target[childrenCountProperty];
			for ( var i:int = 0; i < len; i++ ) 
			{
				var child:Object = target[getChildMethod](i);
				if (child)
				{
					if (child.hasOwnProperty(method))
					{
						child[method].apply(null, params);
					}
					
					var allParams :Array = [child, getChildMethod, childrenCountProperty, method];
					allParams.concat(params);
					
					recurseFunction.apply(null, allParams);
				}
			}
		}
	}
}