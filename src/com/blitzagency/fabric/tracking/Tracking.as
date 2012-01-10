package com.blitzagency.fabric.tracking 
{
	
	/*
	 * @author Patrick Matte
	 * @since 1.0 02/18/2009
	 * @version 1.0 02/18/2009
	 */
	import com.blitzagency.utils.XMLAlias;

	/**
	 * Tracking is used for site analytics.
	 */
	public class Tracking implements ITracking 
	{

		private var _events: Array;

		/**
		 * Creates a new instance of Tracking.
		 */
		public function Tracking() 
		{
			_events = new Array( );
		}

		/**
		 * Executes a tracking event
		 * @param name - The name of the event to track.
		 * @param replace - The string you want to replace in the event arguments.
		 */
		public function track(name: String, replace: String = ""): void 
		{
			var trackingCall: ITrackingCall;
			for (var i: int = 0; i < events.length ; i++) 
			{
				var call: ITrackingCall = events[i] as ITrackingCall;
				if (call.name == name) 
				{
					trackingCall = call;
				}
			}
			if (trackingCall) 
			{
				//trace( "Tracking.track " + trackingCall );
				trackingCall.create( replace );
			}
		}

		/**
		 * Parse an xml object into tracking events and adds them to the events list. 
		 */
		public function set eventsFromXML(value: XML): void 
		{
			var xmlList: XMLList = value.elements( );
			for (var i: int = 0; i < xmlList.length( ) ; i++) 
			{
				var name: String = xmlList[i].name( ).toString( );
				var classObject: Object = XMLAlias.getClassByAlias( name );
				var trackingCall: TrackingCall = classObject.fromXML( xmlList[i] );
				events.push( trackingCall );
			}
		}

		/**
		 * An array containing all the tracking events.
		 */
		public function get events(): Array 
		{
			return _events;
		}
	}
}
