package 
{
	import com.adobe.serialization.json.JSON;
	import com.blitzagency.ui.UIButton;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundMixer;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	

	public class Main extends Sprite
	{
		
		private var _soundFile:File;
		private var _timer:Timer;
		private var _output:Object = {};
		private var _sound:Sound;
		private var _channel:SoundChannel;
		
		public var btn_browse: UIButton;
		public var txt_file: TextField;
		public var btn_go: UIButton;

		
		public function Main()
		{
			btn_go.addEventListener(MouseEvent.CLICK, onGo);
			btn_browse.addEventListener(MouseEvent.CLICK, onBrowser);
			btn_go.visible = false;
			_timer = new Timer(100);
			_timer.addEventListener(TimerEvent.TIMER, onTick);
		}

		

		private function onBrowser(event : MouseEvent) : void {
			_soundFile = File.desktopDirectory;
			_soundFile.addEventListener(Event.SELECT, onFileSelect);
			_soundFile.browseForOpen("Select an MP3");
		}

		private function onFileSelect(event:Event) : void {
			txt_file.text =  _soundFile.nativePath;
			btn_go.visible = true;
		}

		private function onGo(event : MouseEvent) : void {
			var sound:Sound = new Sound();
			sound.load(new URLRequest(_soundFile.url));
			var channel:SoundChannel = sound.play();
			channel.addEventListener(Event.SOUND_COMPLETE, onSoundComplete);
			_output = {};
			_sound = sound;
			_channel = channel;
			_timer.start();
		}

		private function onSoundComplete(event : Event = null) : void {
			_timer.stop();
			var jsonStr:String = JSON.encode(_output);
			writeToFile(jsonStr);
		}
		private function onTick(event : TimerEvent) : void {
			var ba:ByteArray = new ByteArray();
			SoundMixer.computeSpectrum( ba );
			//trace(_channel.position);
			var pos:int = Math.round(_channel.position /100)*100;
			var tempArr:Array = [];
			for ( var i:uint = 0; i < 256; i++ )
			{
				var num:Number = ba.readFloat();
				tempArr.push(num);
			}
			_output[pos] = tempArr;
			
			//temp
			/*
			if(pos > 10000){
				onSoundComplete();
			}
			*/
		}
		
		private function writeToFile(str:String):void{
			var file:File = File.desktopDirectory.resolvePath("json.txt");
			var stream:FileStream = new FileStream();
			stream.open(file, FileMode.WRITE);
			stream.writeUTFBytes(str);
			stream.close();
		}
	}
}
