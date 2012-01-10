package com.blitzagency.fabric.assets {
	
	/*
	 * @author Patrick Matte
	 * @since 1.0 02/18/2009
	 * @version 1.0 02/18/2009
	*/
	
	/**
	* RemoveChild is a shortcut to remove a DisplayObject from a DisplayObjectContainer.
	*/
	public class RemoveChild extends Asset {
		
		public var container:String;
		public var child:String;
		
		/**
		* Creates a new RemoveChild.
		* <listing>
		* package {
		* 
		* 	import flash.display.MovieClip;
		* 	import com.blitzagency.fabric.assets.RemoveChild;
		* 
		* 	public class Main extends MovieClip {
		* 		
		* 		var test:MovieClip = new MovieClip();
		* 
		* 		public function Main(){
		* 			addChild(test);
		* 			var removeChild:RemoveChild = new RemoveChild(this, "", "nav");
		* 			removeChild.addEventListener(Event.COMPLETE, removeChildCompleteHandler));
		* 			removeChild.create();
		* 		}
		* 		
		* 		function removeChildCompleteHandler(event:Event):void {
		* 			trace(contains(test));
		* 			// outputs false
		* 		}
		* 	
		* 	}
		* 
		* }
		* </listing>
		* 
		* @param scope - The object from which the targetpaths and bindings are evaluated.
		* @param container - The path to the container.
		* @param child - The path to the child.
		*/
		public function RemoveChild(scope:Object, container:String, child:String) {
			super(scope);
			this.container = container;
			this.child = child;
		}
		
		/**
		* Parses an xml object into a RemoveChild object.
		* <p/>
		* The xml object must be formatted like this:
		* <listing>
		* &lt;RemoveChild container="" child="nav"/&gt;
		* </listing>
		* 
		* @param scope - The scope used to evaluate bindings.
		* @param xml - The xml object defining the RemoveChild.
		*/
		public static function fromXML(scope:Object, xml:XML):RemoveChild {
			return new RemoveChild(scope, xml.@container, xml.@child);
		}
		
		override public function create():void {
			var container:Object = findTarget(parseString(this.container));
			var child:Object = findTarget(parseString(this.child));
			container.removeChild(child);
			complete();
		}
		
	}
	
}