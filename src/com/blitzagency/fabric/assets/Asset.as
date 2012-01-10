package com.blitzagency.fabric.assets {
	
	/*
	 * @author Patrick Matte
	 * @since 1.0 02/18/2009
	 * @version 1.0 02/18/2009
	 * 
	 * @modified Yosef Flomin
	 * @revision 1.2 2010/04/30
	*/
	
	import com.blitzagency.fabric.Base;
	import flash.events.Event;
	
	/**
	* Asset is an abstract class used to load or execute functions.
	*/
	public class Asset extends Base implements IAsset {
		
		private var _progressive:Boolean;
		
		protected var _weight:int = 1; //@r1.2
		protected var _progress:Number = 0;
		
		/**
		* Asset is an abstract class used to load or execute functions.
		* @param scope - The object from which the targetpaths and bindings are evaluated.
		*/
		public function Asset(scope:Object) {
			super(scope);
		}
		
		/**
		* Creates the asset.
		*/
		public function create():void {
			_progress = 0;
			complete();
		}
		
		/**
		* Dispatches a complete event when actions are completed.
		*/
		protected function complete():void {
			_progress = 1;
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		/**
		* Returns the progress of the asset if the asset is progressive. 
		* @return A Number from 0 to 1.
		*/
		public function get progress():Number {
			return _progress;
		}
		
		/**
		* Should be set to true for all assets that are loading external content.
		* @param scope - True if the asset is loading external content.
		*/
		public function set progressive(value:Boolean):void {
			_progressive = value;
		}
		
		/**
		* This value should be set to true for all assets that are loading external content.
		* @return true if the asset is loading external content.
		*/
		public function get progressive():Boolean {
			return _progressive;
		}
		
		//@r1.2
		public function get weight():int { 
			return _weight; 
		}
		
		//@r1.2
		public function set weight( value:int ):void {
			_weight = value;
		}
		
		/**
		* Resets the asset and sets the progress value back to 0 ready for the next time create() is called.
		*/
		public function destroy():void {
			_progress = 0;
		}
		
	}
	
}