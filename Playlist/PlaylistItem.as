package Playlist {
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import fl.transitions.Tween;
	import fl.transitions.easing.*;
	import Media.MediaFile;
	import Media.MediaFileEvent;
	import Media.Audio.AudioFile;
	import Media.Video.VideoFile;
	import Media.MediaFileType;
	
	public class PlaylistItem extends MovieClip {
		
		public static const HEIGHT:Number = new Number(20);
		public static const PADDING:Number = new Number(4);
		
		public static const ALBUM:String = new String("album");
		public static const ARTIST:String = new String("artist");
		public static const TITLE:String = new String("title");
		public static const GENRE:String = new String("genre");
		public static const YEAR:String = new String("year");
		public var album:String, artist:String, genre:String, title:String, year:String;
		
		private var _width:Number;
		private var mediaFile:MediaFile;
		private var selected:Boolean, dragging:Boolean;
		private var tween:Tween;
		public var index:int;
		//public var xml:XML;
		
		public function PlaylistItem(mediaFile:MediaFile, _width:Number) {
			this._width = _width;
			selected = false;
			playBtn.visible = false;
			titleField.text = "";
			artistField.text = "";
			durationField.text = "";
			//blendMode = "hardlight";
			init();
			listeners();
			
			if(mediaFile.checkFormat() == MediaFileType.AUDIO.toLowerCase()){
				this.mediaFile = MediaFile.parseAudioFile(mediaFile);
			}
			else if(mediaFile.checkFormat() == MediaFileType.VIDEO.toLowerCase()){
				this.mediaFile = MediaFile.parseVideoFile(mediaFile);
			}
			mediaReady();
			//this.mediaFile.loadMedia(this.mediaFile.url);
			this.mediaFile.addEventListener(MediaFileEvent.LOADED, mediaLoaded);		
		}
		private function init():void{
			titleField.autoSize = TextFieldAutoSize.LEFT;
			//artistField.autoSize = TextFieldAutoSize.LEFT;
			durationField.autoSize = TextFieldAutoSize.LEFT;
		}
		private function listeners():void{
			this.addEventListener(MouseEvent.MOUSE_OVER, showPlayButton);
			this.addEventListener(MouseEvent.MOUSE_OUT, hidePlayButton);
			chkBtn.addEventListener(MouseEvent.MOUSE_UP, toggleState);
			playBtn.addEventListener(MouseEvent.MOUSE_DOWN, testForDrag);
			playBtn.addEventListener(MouseEvent.MOUSE_UP, dispatchPlayEvent);
			delBtn.addEventListener(MouseEvent.MOUSE_UP, dispatchDeleteEvent);
		}
		private function deListeners():void{
			this.removeEventListener(MouseEvent.MOUSE_OVER, showPlayButton);
			this.removeEventListener(MouseEvent.MOUSE_OUT, hidePlayButton);
			chkBtn.removeEventListener(MouseEvent.MOUSE_UP, toggleState);
			playBtn.removeEventListener(MouseEvent.MOUSE_UP, dispatchPlayEvent);
			delBtn.removeEventListener(MouseEvent.MOUSE_UP, dispatchDeleteEvent);
		}
		private function mediaReady(e:Event = null):void{
			name = (mediaFile.name)?mediaFile.name:"";
			album = (mediaFile.album)?mediaFile.album:"";
			artist = (mediaFile.artist)?mediaFile.artist:"";
			genre = (mediaFile.genre)?mediaFile.genre:"";
			title = (mediaFile.title)?mediaFile.title:"";
			year = (mediaFile.year)?mediaFile.year:"";
			titleField.text = title;
			artistField.text = artist;
			durationField.text = "";
		}
		private function mediaLoaded(e:Event):void{
			mediaReady();
			durationField.text = mediaFile.getMediaLength();
			this.setWidth(_width);
			mediaFile.dropMedia();
		}
		public function tooltip():String{
			return mediaFile.getInfo();
		}
		public function toggleState(me:MouseEvent):void{
			chkBtn.toggleState()
			selected = chkBtn.getState();
		}
		public function setState(state:Boolean):void{
			chkBtn.setState(state);
			selected = chkBtn.getState();
		}
		public function isSelected():Boolean{
			return this.selected;
		}
		public function select():void{
			titleField.textColor = 0xffcc00;
		}
		public override function play():void{
			titleField.textColor = 0x006699;
		}
		public override function stop():void{
			titleField.textColor = 0x0;
		}
		public function testForDrag(me:MouseEvent):void{
			//select();
			stage.addEventListener(MouseEvent.MOUSE_MOVE, prepForDrag);
		}
		public function prepForDrag(me:MouseEvent):void{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, prepForDrag);
			deListeners();
			var scale:Number = 1.1;
			var pw:Number = _width;
			scaleX = scale;
			x = PADDING + (pw - pw*scale)/2;
			var ph:Number = HEIGHT;
			scaleY = scale;
			y = (index * HEIGHT) + (ph - ph*scale)/2;
			dragging = true;
			this.dispatchEvent(new PlaylistEvent(PlaylistEvent.READY));
		}
		public function afterDrop():void{
			dragging = false;
			scaleX = 1;
			x = PADDING;
			scaleY = 1;
			y = index * HEIGHT;
			listeners();
		}
		public function isDragging():Boolean{
			return this.dragging;
		}
		public function tweenTo(newY:Number):void{
			tween = new Tween(this,"y",Strong.easeOut,y,newY,2,false);
		}
		
		private function showPlayButton(me:MouseEvent):void{
			playBtn.visible = true;
		}
		private function hidePlayButton(me:MouseEvent):void{
			playBtn.visible = false;
		}
		
		public function dispatchPlayEvent(e:Event = null):void{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, prepForDrag);
			this.mediaFile.loadMedia(this.mediaFile.url);
			this.dispatchEvent(new PlaylistEvent(PlaylistEvent.PLAY));
		}
		public function dispatchDeleteEvent(e:Event = null):void{
			//this.deListeners()
			this.dispatchEvent(new PlaylistEvent(PlaylistEvent.DELETE));
		}
		
		public function getMediaFile():MediaFile{
			return this.mediaFile;
		}
		public function setMediaFile(mediaFile:MediaFile):void{
			if(mediaFile.exists){
				this.mediaFile = mediaFile;
				mediaFile.loadMedia(mediaFile.url);
			}
			else{
				this.dispatchEvent(new MediaFileEvent(MediaFileEvent.NOT_EXISTING));
			}
		}
		
		public function setWidth(_width:Number):void{
			init();
			this._width = _width;
			this.graphics.clear();
			this.graphics.beginFill(0,0.1);
			//this.graphics.drawRect(0,0,_width,HEIGHT);
			this.graphics.endFill();
			delBtn.x = _width - delBtn.width - PADDING;
			durationField.x = delBtn.x - durationField.width - PADDING;
			chkBtn.x = PADDING;
			titleField.x = chkBtn.x + chkBtn.width + PADDING;
			if(titleField.x + titleField.width >= durationField.x - PADDING){
				titleField.autoSize = TextFieldAutoSize.NONE;
				titleField.width = durationField.x - PADDING - titleField.x;
			}
			artistField.x = titleField.x + titleField.width + PADDING;
			var w:Number = durationField.x - artistField.x - PADDING;
			if(w<0)w=0;
			artistField.width = w;
			playBtn.x = titleField.x;
			playBtn.setWidth((delBtn.x - titleField.x - PADDING) / playBtn.scaleX);
		}
		
	}
	
}
