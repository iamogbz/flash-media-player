package Media {
	import flash.filesystem.File;
	import flash.net.URLRequest;
	import flash.events.Event;
	import Media.Audio.AudioFile;
	import Media.Video.VideoFile;
	import Playlist.PlaylistControl;
	
	public class MediaFile extends File{
		public static const FILENAME:String = new String("Untitled");
		public static const DEFAULT:String = new String("?");
		public static const AUDIO_MP3:String = new String("mp3");
		public static const AUDIO_WAV:String = new String("wav");
		public static const VIDEO_FLV:String = new String("flv");
		public static const VIDEO_MOV:String = new String("mov");
		public static const VIDEO_M4V:String = new String("m4v");
		public static const VIDEO_MP4:String = new String("mp4");
		public static const PLAYLIST:String = PlaylistControl.EXTENSION;
		public static const ALLOWED:Array = [{extension:AUDIO_MP3, type:MediaFileType.AUDIO},
											 {extension:AUDIO_WAV, type:MediaFileType.AUDIO},
											 {extension:VIDEO_FLV, type:MediaFileType.VIDEO},
											 {extension:VIDEO_MOV, type:MediaFileType.VIDEO},
											 {extension:VIDEO_M4V, type:MediaFileType.VIDEO},
											 {extension:VIDEO_MP4, type:MediaFileType.VIDEO},
											 {extension:PLAYLIST, type:MediaFileType.PLAYLIST}];
		
		protected var ready:Boolean;
		protected var fileType:String;
		protected var fileExtension:String;
		public var year:String, title:String, genre:String, album:String, artist:String;
		protected var info:String, length:Number;
		
		public function MediaFile(path:String = null) {
			if(path == null){
				path = File.documentsDirectory.url+File.separator+FILENAME;
			}
			super(path);
			info = DEFAULT;
			fileType = DEFAULT;
			fileExtension = DEFAULT;
			readyMedia();
		}
		public function checkFormat():String{
			for(var i:int = 0; i < ALLOWED.length; i++){
				if(this.extension != null && this.extension.toLowerCase() == ALLOWED[i].extension.toLowerCase()){// && fileExtension.toLowerCase() == DEFAULT.toLowerCase()){
					fileExtension = ALLOWED[i].extension.toLowerCase();
					fileType = ALLOWED[i].type;
				}
			}
			//return fileExtension.toLowerCase();
			return fileType.toLowerCase();
		}
		public function readyMedia():Boolean{
			ready = false;
			checkFormat();
			if(!this.exists || this.isDirectory){
				this.dispatchEvent(new MediaFileEvent(MediaFileEvent.NOT_EXISTING));
			}
			else if(this.extension.toLowerCase() != fileExtension){
				this.dispatchEvent(new MediaFileEvent(MediaFileEvent.INCORRECT_FORMAT));
			}
			else{
				setDefaultInfo();
				ready = true;
				this.dispatchEvent(new MediaFileEvent(MediaFileEvent.READY));
			}
			return ready;
		}
		public function loadMedia(url:String):void{
			if(this.url != url){
				this.url = url;
			}
			readyMedia();
		}
		
		protected function mediaLoaded(e:Event):void{
			setMediaInfo();
			this.dispatchEvent(new MediaFileEvent(MediaFileEvent.LOADED));
		}
		
		public function getMedia():Object{
			return {};
		}
		public function setMedia(url:String):void{
			loadMedia(url);
		}
		
		public function setDefaultInfo():void{
			var info:String = "";
			artist = "";
			title = name.replace("."+extension, "");
			info += title;
			length = 0;
			setInfo(info);
		}
		protected function setMediaInfo():void{
			var info:String = DEFAULT;
			title = DEFAULT;
			artist = DEFAULT;
			album = DEFAULT;
			length = 0;
			setInfo(info);
		}
		public function dropMedia():void{
		}
		
		public function isReady():Boolean{
			return this.ready;
		}
		
		public function getType():String{
			return this.fileType;
		}
		
		public function getInfo():String{
			return this.info;
		}
		protected function setInfo(info:String):void{
			//trace("setting media info");
			this.info = info;
		}
		
		public function getLength():Number{
			return this.length;
		}
		
		public function getMediaLength():String{
			return Media.MediaFile.normaliseLength(length);
		}
		
		public static function normaliseLength(length:Number):String{
			var msecs:Number = length;
			var secs:Number = Math.floor(msecs/1000);
			msecs %= 1000;
			var mins:Number = Math.floor(secs/60);
			secs %= 60;
			var hrs:Number = Math.floor(mins/60);
			mins %= 60;
			var days:Number = Math.floor(hrs/24);
			hrs %= 24;
			var l:String = "";
			if(days > 0){
				l += (days.toString()+" days, ");
			}
			return (l += normaliseTime(hrs, mins, secs));
		}
		public static function normaliseTime(hrs:Number, mins:Number, secs:Number):String{
			var nt:String = ""
			if(hrs > 0){
				if(hrs < 10){
					nt += "0"
				}
				nt += (hrs.toString() + ":");
			}
			if(mins < 10){
				nt += "0"
			}
			nt += (mins.toString() + ":");
			if(secs < 10){
				nt += "0"
			}
			return (nt += secs.toString());
		}
		
		public static function parseAudioFile(mediaFile:MediaFile):AudioFile{
			var audioFile:AudioFile = new AudioFile(mediaFile.url);
			return audioFile;
		}
		/*public static function parseSoundFile(mediaFile:MediaFile):SoundFile{
			var soundFile:SoundFile = new SoundFile(mediaFile.url);
			return soundFile;
		}*/
		public static function parseVideoFile(mediaFile:MediaFile):VideoFile{
			var videoFile:VideoFile = new VideoFile(mediaFile.url);
			return videoFile;
		}
	}
	
}
