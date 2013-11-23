package Media.Video {
	import flash.filesystem.File;
	import flash.net.URLRequest;
	import flash.events.Event;
	import fl.video.VideoEvent;
	import fl.video.FLVPlayback;
	import Media.MediaFile;
	import Media.MediaFileEvent;
	
	public class VideoFile extends MediaFile{
		public static const FILENAME:String = new String("Video");
		
		private var video:FLVPlayback;
		
		public function VideoFile(path:String) {
			super(path);
		}
		
		public override function loadMedia(url:String):void{
			if(this.url != url){
				this.url = url;
			}
			if(readyMedia()){
				video = new FLVPlayback();
				video.load(url);
				video.addEventListener(VideoEvent.READY, this.mediaLoaded);
			}
		}
		
		protected override function mediaLoaded(e:Event):void{
			this.setMediaInfo();
			this.dispatchEvent(new MediaFileEvent(MediaFileEvent.LOADED));
		}
		
		public override function getMedia():Object{
			return this.video;
		}
		public override function setMedia(url:String):void{
			this.loadMedia(url);
		}
		public override function dropMedia():void{
			//video.closeVideoPlayer(0);
			video = null;
		}
		
		protected override function setMediaInfo():void{
			var info:String = "";
			artist = "";
			title = name.replace("."+extension, "");
			info += title;
			length = video.totalTime * 1000;
			setInfo(info);
		}
		
		public override function getMediaLength():String{
			return Media.MediaFile.normaliseLength(length);
		}
		
	}
	
}
