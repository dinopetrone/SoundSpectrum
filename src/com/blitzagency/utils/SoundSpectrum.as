package com.blitzagency.utils
{
	import application.fountain.Positions;
	import flash.events.Event;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundMixer;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	
	public class SoundSpectrum
	{
		[Public]
		
		[Private]
		private var sound          :Sound;
		private var soundBytes     :ByteArray;
		private var soundChannel   :SoundChannel;
		
		private var channels       :int;
		
		[Getters_Setters]
		private var _channelLength :int = 256;
		private var _spectrum      :Vector.<Number>;
		
		[Stage]
		
		public function SoundSpectrum()
		{
			init();
		}
		
		protected function init():void 
		{
			channels = 256 / _channelLength;
			_spectrum = new Vector.<Number>(_channelLength);
		}
		
		public function load(url:String):void
		{
			if ( soundChannel ) soundChannel.stop();
			
			soundBytes = new ByteArray();
			sound = new Sound(new URLRequest(url));
			sound.addEventListener(Event.COMPLETE, playSound);
		}
		
		private function playSound( event:Event ):void 
		{
			event.target.removeEventListener(Event.COMPLETE, playSound);
			soundChannel = sound.play();
		}
		
		public function get spectrum():Vector.<Number>
		{
			if (!soundBytes) return null;
			
			SoundMixer.computeSpectrum(soundBytes);
			
			for ( var position:int = 0; position < _channelLength; position++ ) 
			{
				var strength:Number = 0;
				for ( var channel:int = 0; channel < channels; channel++ ) 
				{
					strength = soundBytes.readFloat() * 6;
				}
				_spectrum[position] = strength;
			}
			
			return _spectrum;
		}
		
		public function set channelLength( value:int ):void 
		{
			_channelLength = value;
			channels = 256 / _channelLength;
			_spectrum = new Vector.<Number>(_channelLength);
		}
	}
}