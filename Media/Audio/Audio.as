package Media.Audio {
	import flash.filesystem.File;
	import Media.MediaFile;
	import flash.media.Sound;
	import org.as3wavsound.WavSound;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.events.Event;
	import flash.net.URLLoaderDataFormat;
	import flash.utils.ByteArray;
	import flash.media.SoundTransform;
	import flash.media.ID3Info;
	import flash.events.EventDispatcher;
	
	public class Audio extends EventDispatcher{
		
		public var id3:ID3Info;
		private var sound:Object;
		private var soundLoader:URLLoader;
		
		public function Audio(url:String = null) {
			if(url != null) load(url);
		}
		
		public function load(url:String):void{
			var file:File = new File(url);
			if(file.exists && !file.isDirectory){
				if(file.extension.toLowerCase() == MediaFile.AUDIO_MP3){
					sound = new Sound();
					sound.load(new URLRequest(url));
					sound.addEventListener(Event.COMPLETE, audioLoaded);
				}
				else if(file.extension.toLowerCase() == MediaFile.AUDIO_WAV){
					soundLoader = new URLLoader();
					soundLoader.dataFormat = URLLoaderDataFormat.BINARY;
					soundLoader.load(new URLRequest(url));
					soundLoader.addEventListener(Event.COMPLETE, soundLoaded);
				}
			}
		}
		private function soundLoaded(e:Event):void{
			sound = new WavSound(e.target.data as ByteArray);
			audioLoaded(new Event(Event.COMPLETE));
		}
		private function audioLoaded(e:Event):void{
			if(sound.id3 != null && sound.id3 != undefined) id3 = sound.id3;
			else id3 = new ID3Info();
			this.dispatchEvent(new Event(Event.COMPLETE));
		}
		
		public function play(startTime:Number = 0, loops:int = 0, sndTransform:SoundTransform = null):Object{
			return sound.play(startTime, loops, sndTransform);
		}
		
		/*public function get id3():ID3Info{
			return this.id3;
		}*/
		
		public function get length():Number{
			return sound.length;
		}
		
		public function close():void{
			sound = null;
		}
		
	}
	
}
