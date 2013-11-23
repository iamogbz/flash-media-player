package Media.Audio {
	import flash.filesystem.File;
	import flash.net.URLRequest;
	import flash.events.Event;
	import Media.MediaFile;
	import Media.MediaFileEvent;
	
	public class AudioFile extends MediaFile{
		
		public static const FILENAME:String = new String("Audio");
		
		private var audio:Audio;
		
		public function AudioFile(path:String) {
			super(path);
		}
		
		public override function loadMedia(url:String):void{
			if(this.url != url){
				this.url = url;
			}
			if(readyMedia()){
				audio = new Audio();
				audio.load(url)
				audio.addEventListener(Event.COMPLETE, this.mediaLoaded);
			}
		}
		
		protected override function mediaLoaded(e:Event):void{
			this.setMediaInfo();
			this.dispatchEvent(new MediaFileEvent(MediaFileEvent.LOADED));
		}
		
		public override function getMedia():Object{
			return this.audio;
		}
		public override function setMedia(url:String):void{
			this.loadMedia(url);
		}
		public override function dropMedia():void{
			audio.close();
			audio = null;
		}
		
		protected override function setMediaInfo():void{
			var info:String = "";
			album = "";
			artist = "";
			genre = "";
			title = "";
			year = "";
			if(audio.id3.artist != null && audio.id3.artist != ""){
				artist = audio.id3.artist;
				info += audio.id3.artist;
				info += "\n";
			}
			if(audio.id3.track != null && audio.id3.track != ""){
				info += "0";
				info += audio.id3.track;
				info += " - ";
			}
			if(audio.id3.songName != null && audio.id3.songName != ""){
				title = audio.id3.songName;
				info += audio.id3.songName;
				info += "\n";
			}
			else{
				title = name.replace("."+extension, "");
				info += title;
				info += "\n";
			}
			if(audio.id3.album != null && audio.id3.album != ""){
				album = audio.id3.album;
				info += audio.id3.album;
				info += " - ";
			}
			if(audio.id3.year != null && audio.id3.year != ""){
				year = audio.id3.year;
				info += audio.id3.year;
				info += "\n";
			}
			if(audio.id3.genre != null && audio.id3.genre != ""){
				genre = audio.id3.genre;
				info += audio.id3.genre;
			}
			length = audio.length;
			setInfo(info);
		}
		
		public override function getMediaLength():String{
			return Media.MediaFile.normaliseLength(audio.length);
		}
	}
	
}