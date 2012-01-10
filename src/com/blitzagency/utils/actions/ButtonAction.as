package com.blitzagency.utils.actions
{
	import com.blitzagency.utils.callToAction.CallToAction;
	import com.blitzagency.utils.XMLAlias;
	
	public class ButtonAction 
	{
		public var path 		:String;
		public var callToAction	:CallToAction;
		
		public function ButtonAction() { };
		
		public static function fromXML( xml:XML ):ButtonAction
		{
			var action:ButtonAction = new ButtonAction();
			action.path = xml.action.path;
			
			var classReference:Class = XMLAlias.getClassByAlias( xml.action.@type );
			action.callToAction = CallToAction( classReference.fromXML( xml.action[0] ) );
			
			return action;
		}
	}
}