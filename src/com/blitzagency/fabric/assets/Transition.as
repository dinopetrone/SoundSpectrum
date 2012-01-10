package com.blitzagency.fabric.assets {
	
	/*
	 * @author Patrick Matte
	 * @since 1.0 02/18/2009
	 * @version 1.0 02/18/2009
	*/
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	/**
	* Transition calls a method on an object and waits for a complete event to resume.
	*/
	public class Transition extends Asset {
		
		public var name:String;
		public var target:String;
		
		/**
		* Creates a new Transition.
		* <listing>
		* package {
		* 
		* 	import flash.display.MovieClip;
		* 	import com.blitzagency.ui.UIMovieClip;
		* 	import com.blitzagency.fabric.assets.Transition;
		* 
		* 	public class Main extends MovieClip {
		* 		
		* 		var mc:UIMovieClip = new UIMovieClip();
		* 
		* 		public function Main(){
		* 			var transition:Transition = new Transition(this, "transitionIn", "mc");
		* 			transition.addEventListener(Event.COMPLETE, transitionCompleteHandler));
		* 			transition.create();
		* 		}
		* 		
		* 		function transitionCompleteHandler(event:Event):void {
		* 			trace("transitionCompleteHandler");
		* 		}
		* 	
		* 	}
		* 
		* }
		* </listing>
		* 
		* @param scope - The object from which the targetpaths and bindings are evaluated.
		* @param name - The name of the method.
		* @param target - The path to the method container.
		*/
		public function Transition(scope:Object, name:String, target:String) {
			super(scope);
			this.name = name;
			this.target = target;
		}
		
		/**
		* Parses an xml object into a Transition object.
		* <p/>
		* The xml object must be formatted like this:
		* <listing>
		* &lt;Transition name="transitionIn" target="mc"/&gt;
		* </listing>
		* 
		* @param scope - The scope used to evaluate bindings.
		* @param xml - The xml object defining the Transition.
		*/
		public static function fromXML(scope:Object, xml:XML):Transition {
			return new Transition(scope, xml.@name, xml.@target);
		}
		
		public override function create():void {
			var name:String = parseString(this.name);
			var target:EventDispatcher = findTarget(parseString(this.target)) as EventDispatcher;
			target.addEventListener(Event.COMPLETE, transitionComplete);
			target[name]();
		}
		
		private function transitionComplete(event:Event):void {
			event.target.removeEventListener(Event.COMPLETE, transitionComplete);
			complete();
		}
		
		public override function toString():String {
			return "[Transition name=" + name + " target=" + target + "]";
		}
		
	}
	
}