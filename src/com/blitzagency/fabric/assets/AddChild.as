package com.blitzagency.fabric.assets {
	
	/*
	 * @author Patrick Matte
	 * @since 1.0 02/18/2009
	 * @version 1.0 02/18/2009
	*/
	
	/**
	* AddChild is a shortcut to add a DisplayObject to the display list of a DisplayObjectContainer.
	*/
	public class AddChild extends Asset {
		
		public var container:String;
		public var child:String;
		public var depth:String;
		
		/**
		* Creates a new AddChild.
		* <listing>
		* package {
		* 
		* 	import flash.display.MovieClip
		* 	import com.blitzagency.fabric.assets.AddChild;
		* 
		* 	public class Main extends MovieClip {
		* 		
		* 		var test:MovieClip = new MovieClip();
		* 
		* 		public function Main(){
		* 			var addChild:AddChild = new AddChild(this, "", "test", "3");
		* 			addChild.addEventListener(Event.COMPLETE, addChildCompleteHandler));
		* 			addChild.create();
		* 		}
		* 		
		* 		function addChildCompleteHandler(event:Event):void {
		* 			trace(contains(test));
		* 			// outputs true
		* 			trace(getChildAt(3));
		* 			// outputs [MovieClip]
		* 		}
		* 
		* 	}
		* 
		* }
		* </listing>
		* @param scope - The object from which the targetpaths and bindings are evaluated.
		* @param container - The path to the container.
		* @param child - The path to the child.
		* @param depth - The depth at which to the child.
		*/
		public function AddChild(scope:Object, container:String, child:String, depth:String = "") {
			super(scope);
			this.container = container;
			this.child = child;
			this.depth = depth;
		}
		
		/**
		* Parses an xml object into a AddChild object.<br/>
		* The xml object must be formatted like this:
		* <listing>
		* &lt;AddChild container="" child="test" depth="3"/&gt;
		* </listing>
		* @param scope - The scope used to evaluate bindings.
		* @param xml - The xml object defining the AddChild.
		*/
		public static function fromXML(scope:Object, xml:XML):AddChild {
			return new AddChild(scope, xml.@container, xml.@child, xml.@depth);
		}
		
		override public function create():void {
			var container:Object = findTarget(parseString(this.container));
			var child:Object = findTarget(parseString(this.child));
			var depth:Number;
			var depthString:String = parseString(this.depth);
			if (depthString.length > 0) {
				depth = Number(depthString);
			}
			if (isNaN(depth)) {
				container.addChild(child);
			} else {
				container.addChildAt(child, depth);
			}
			complete();
		}
		
		public override function toString():String {
			return "[LoaderPreloader child=" + child + " container=" + container + " depth=" + depth + "]";
		}
		
	}
	
}