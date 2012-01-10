package com.blitzagency.utils 
{
	/*
	 * @author Yosef Flomin
	*/
	import com.blitzagency.ui.EventDispatcherBase;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundMixer;
	import flash.media.SoundTransform;
	import flash.utils.Timer;
	
	public class SoundManager extends EventDispatcherBase
	{
		private static var soundTargets:Array = [];
		
		public var globalVolume		:Number = 1;
		public var targetVolume		:Number = 1;
		public var playingVolume	:Number = 1;
		
		public var ambientChannel     :SoundChannel;
		public var playingSoundChannel:SoundChannel = new SoundChannel();
		public var toPlaySoundChannel :SoundChannel = new SoundChannel();
		
		private var globalToVolume	:Number = 0;
		private var globalFadeTimer	:Timer;
		private var globalVolumeIncrement :Number;
		
		private var targetToVolume	:Number = 0;
		private var targetFadeTimer	:Timer;
		private var targetVolumeIncrement :Number;
		private	var playingVolumeIncrement:Number;
		private var isCrossFadingSounds:Boolean;
		
		public function SoundManager() { };
		
		public function mute():void{
			SoundMixer.soundTransform = new SoundTransform( 0 );
		}
		
		public function unMute():void{
			SoundMixer.soundTransform = new SoundTransform(globalVolume);
		}
		
		/**
		 *  Fades Global Volume. Leave parameter as default to toggle the volume on/off.
		 * 
		 * @param fromVolume   <Number (default = current volume)> Starting volume, ranging from 0 (silent) to 1 (full volume).
		 * @param toVolume     <Number (default = inverse of current volume)> Ending volume, ranging from 0 (silent) to 1 (full volume).
		 * @param fadeSpeed    <Number (default = 1000)> Amount of milliseconds the fade will last.
		 * 
		 */
		public function fadeAllSound( toVolume:Number = undefined, fromVolume:Number = undefined, fadeSpeed:Number = 1000 ):void
		{
			destroyGlobalTimer();
			
			globalVolume   = Math.round( globalVolume );
			fromVolume 	   = undefined ? fromVolume : globalVolume;
			toVolume 	   = undefined ? toVolume : Number(!globalVolume);
			globalVolume   = fromVolume;
			globalToVolume = toVolume;
			
			globalVolumeIncrement = ( globalToVolume - globalVolume ) / 10;
			
			globalFadeTimer = new Timer( fadeSpeed / 10, 10 );
			globalFadeTimer.addEventListener( TimerEvent.TIMER, updateGlobalVolume );
			globalFadeTimer.addEventListener( TimerEvent.TIMER_COMPLETE, destroyGlobalTimer );
			globalFadeTimer.start();
		}
		
		/**
		 *  Fades The Volume for a specific Sound Object.
		 * 
		 * @param soundChanngel  <Sound>  The SoundChannel to fade the volume on.
		 * @param fromVolume     <Number> Starting volume, ranging from 0 (silent) to 1 (full volume).
		 * @param toVolume       <Number> Ending volume, ranging from 0 (silent) to 1 (full volume).
		 * @param fadeSpeed      <Number (default = 1000)> Amount of milliseconds the fade will last.
		 * 
		 */
		public function fadeTargetSound( soundChannel:SoundChannel, fromVolume:Number, toVolume:Number, fadeSpeed:Number = 1000 ):void
		{
			destroyTargetTimer();
			isCrossFadingSounds = false;
			
			targetVolume   = fromVolume;
			targetToVolume = toVolume;
			
			targetVolumeIncrement = ( targetToVolume - targetVolume ) / 10;
			playingSoundChannel = soundChannel;
			playingSoundChannel.soundTransform = new SoundTransform( fromVolume );
			
			targetFadeTimer = new Timer( fadeSpeed / 10, 10 );
			targetFadeTimer.addEventListener( TimerEvent.TIMER, updateTargetVolume );
			targetFadeTimer.addEventListener( TimerEvent.TIMER_COMPLETE, destroyTargetTimer );
			targetFadeTimer.start();
		}
		
		/**
		 *  Cross Fades between two SoundChannels
		 * 
		 * @param playingSoundChannel  <SoundChannel> The SoundChannel to fade the volume out.
		 * @param toPlaySoundChannel   <SoundChannel> The SoundChannel to fade the volume in.
		 * @param toPlayVolume         <Number> The volume that toPlaySoundChannel will end on.
		 * @param fadeSpeed     	   <Number (default = 1000)> Amount of milliseconds the fade will last.
		 * 
		 */
		public function crossFadeTargetSounds( playingSoundChannel:SoundChannel, toPlaySoundChannel:SoundChannel, toPlayVolume:Number, fadeSpeed:Number = 1000 ):void
		{
			destroyTargetTimer();
			isCrossFadingSounds = true;
			
			targetVolume   = playingSoundChannel.soundTransform.volume;
			targetToVolume = toPlayVolume;
			
			playingVolumeIncrement 	 = targetVolume / 10;
			targetVolumeIncrement 	 = targetToVolume / 10;
			this.playingSoundChannel = playingSoundChannel;
			this.toPlaySoundChannel  = toPlaySoundChannel;
			this.toPlaySoundChannel.soundTransform = new SoundTransform( 0 );
			
			targetFadeTimer = new Timer( fadeSpeed / 10, 10 );
			targetFadeTimer.addEventListener( TimerEvent.TIMER, updateTargetVolume );
			targetFadeTimer.addEventListener( TimerEvent.TIMER_COMPLETE, destroyTargetTimer );
			targetFadeTimer.start();
		}
		
		public static function addSound(targets:Array, eventForSound:String, sound:Sound):Boolean
		{
			var soundExists:Boolean = false;
			for each( var obj:Object in targets ) 
			{
				for each( var soundTarget:SoundTarget in soundTargets ) 
				{
					if(soundTarget.target == obj && soundTarget.event == eventForSound && soundTarget.sound == sound)
					{
						soundExists = true;
					}
				}
				if (!soundExists)
				{
					soundTargets.push(new SoundTarget(obj, eventForSound, sound));
					obj.addEventListener(eventForSound, playTargetSound);
				}
			}
			return soundExists;
		}
		
		public static function removeSound(targets:Array, eventForSound:String):void
		{
			for ( var i:int = 0; i < soundTargets.length; i++ ) 
			{
				for each( var obj:Object in targets ) 
				{
					if (soundTargets[i].target == obj && soundTargets[i].event == eventForSound)
					{
						obj.removeEventListener(eventForSound, playTargetSound);
						soundTargets.splice(i, 1);
					}
				}
			}
		}
		
		private static function playTargetSound( event:Event ):void 
		{
			for each( var soundTarget:SoundTarget in soundTargets ) 
			{
				if (soundTarget.target == event.target && event.type == soundTarget.event)
				{
					soundTarget.sound.play();
				}
			}
		}
		
		private function updateGlobalVolume( event:TimerEvent ):void 
		{
			globalVolume += globalVolumeIncrement;
			SoundMixer.soundTransform = new SoundTransform( globalVolume );
		}
		
		private function updateTargetVolume( event:TimerEvent ):void 
		{
			if ( !isCrossFadingSounds )	{
				targetVolume += targetVolumeIncrement;
				playingSoundChannel.soundTransform = new SoundTransform( targetVolume );
			}
			else {
				targetVolume -= playingVolumeIncrement;
				targetToVolume = + targetVolumeIncrement;
				playingSoundChannel.soundTransform = new SoundTransform( targetVolume );
				toPlaySoundChannel.soundTransform = new SoundTransform( targetToVolume );
			}
		}
		
		private function destroyTargetTimer( event:TimerEvent = null ):void 
		{
			if ( targetFadeTimer ) {
				targetFadeTimer.stop();
				targetFadeTimer.removeEventListener( TimerEvent.TIMER, updateTargetVolume );
				targetFadeTimer.removeEventListener( TimerEvent.TIMER_COMPLETE, destroyTargetTimer );
				targetFadeTimer = null;
			}
		}
		
		private function destroyGlobalTimer( event:TimerEvent = null ):void 
		{
			if ( globalFadeTimer ) {
				globalFadeTimer.stop();
				globalFadeTimer.removeEventListener( TimerEvent.TIMER, updateGlobalVolume );
				globalFadeTimer.removeEventListener( TimerEvent.TIMER_COMPLETE, destroyGlobalTimer );
				globalFadeTimer = null;
			}
		}
	}
}

import flash.media.Sound;

class SoundTarget
{
	public var target :Object;
	public var sound  :Sound;
	public var event  :String;
	
	public function SoundTarget(t:Object, e:String, s:Sound)
	{
		target = t;
		sound = s;
		event = e;
	}
}