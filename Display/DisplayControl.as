package Display {
	//import flash.media.Sound;
	//import flash.media.SoundChannel;
	import flash.media.SoundMixer;
	import flash.media.SoundTransform;
	import flash.display.Sprite;
	import Visualisation.Visualisation;
	import Media.MediaFile;
	import Media.Audio.Audio;
	import Media.Audio.AudioFile;
	import Media.Video.VideoFile;
	import fl.video.FLVPlayback;
	import fl.video.VideoAlign;
	import fl.video.VideoEvent;
	import fl.video.VideoScaleMode;
	import flash.net.URLRequest;
	import flash.events.Event;
	import flash.utils.ByteArray;
	import Visualisation.Visualisation;
	import Visualisation.Simulation.Simulation;
	import Visualisation.Simulation.SimulationType;
	import Visualisation.Simulation.Bars.Bars;
	import Visualisation.Simulation.Bars.BarsType;
	import Visualisation.Simulation.Board.Board;
	import Visualisation.Simulation.Board.BoardType;
	import Visualisation.Simulation.Burst.Burst;
	import Visualisation.Simulation.Burst.BurstType;
	import Visualisation.Simulation.Fire.Fire;
	import Visualisation.Simulation.Trail.Trail;
	import Visualisation.Simulation.Trail.TrailType;
	import Visualisation.Simulation.Wave.Wave;
	import Visualisation.Simulation.Wave.WaveType;
	import Media.MediaFileEvent;
	import Media.MediaFileType;
	
	public class DisplayControl extends Sprite{
		
		private var ba:ByteArray;//byte array to read sound
		private var audio:Audio;
		private var visualisation:Visualisation;
		private var simulations:Array = new Array(SimulationType.ART, SimulationType.BARS, SimulationType.BOARD, SimulationType.BURST, SimulationType.FIRE, SimulationType.TRAIL, SimulationType.WAVE);
		private var simulationsType:Array = new Array(1, 2, 2, 2, 1, 3, 2);
		
		private var video:FLVPlayback;
		
		private var currentMedia:MediaFile, color:uint;
		private var playObject:Object, scale:String;
		private var _width:Number, _height:Number;
		private var simType:String, simSetting:String;
		private var volume:Number, playing:Boolean;
		private var playPosition:Number, staticPosition:Number, length:Number;
		private var milliseconds:Number = 1000;
		
		public function DisplayControl(_width:Number, _height:Number) {
			init();
			listeners();
			setSize(_width, _height);
		}
		public function init():void{
			ba = new ByteArray();
			visualisation = new Visualisation();
			addChild(visualisation);
			visualisation.visible = false;
			video = new FLVPlayback();
			addChild(video);
			video.visible = false;
			video.fullScreenTakeOver = false;
			scale = "auto";
			playPosition = 0;
			staticPosition = 0;
			color = 0x020202;
		}
		public function listeners():void{
			this.addEventListener(Event.ENTER_FRAME, update);
		}
		private function update(e:Event):void{
			if(playObject != null && playing){
				if(currentMedia.checkFormat() == MediaFileType.AUDIO.toLowerCase() && currentMedia.readyMedia()){
					playPosition = playObject.position;
					length = audio.length;
					visualisation.visible = true;
					video.visible = false;
				}
				else if(currentMedia.checkFormat() == MediaFileType.VIDEO.toLowerCase() && currentMedia.readyMedia()){
					playPosition = playObject.playheadTime * milliseconds;
					length = playObject.totalTime * milliseconds;
					visualisation.visible = false;
					video.visible = true;
				}
			}
			SoundMixer.computeSpectrum(ba);
			if(visualisation.visible){
				visualisation.step(ba);
			}
			dispatchEvent(new DisplayEvent(DisplayEvent.UPDATE));
		}
		public function play(ce:CustomEvent):void{
			var mediaFile:MediaFile = ce.getSecondaryTarget() as MediaFile;
			//if (this.currentMedia) this.currentMedia.dropMedia();////////////////////////////////////////////////////////////new line
			if(mediaFile.checkFormat() == MediaFileType.AUDIO.toLowerCase() && mediaFile.readyMedia()){
				this.currentMedia = MediaFile.parseAudioFile(mediaFile);
				//if(audio) audio.close();////////////////////////////////////////////////////////////new line
				//audio = null;////////////////////////////////////////////////////////////new line
				audio = new Audio(currentMedia.url);
				audio.addEventListener(Event.COMPLETE, audioLoaded);
			}
			else if(mediaFile.checkFormat() == MediaFileType.VIDEO.toLowerCase() && mediaFile.readyMedia()){
				this.currentMedia = MediaFile.parseVideoFile(mediaFile);
				//playObject = null;////////////////////////////////////////////////////////////new line
				playObject = video;
				playObject.play(currentMedia.url);
				jumpTo(staticPosition);
			}
			//this.currentMedia.loadMedia(this.mediaFile.url);
			//this.currentMedia.addEventListener(MediaFileEvent.LOADED, mediaLoaded);		
		}
		private function mediaLoaded(mfe:MediaFileEvent):void{
			//playObject = null;////////////////////////////////////////////////////////////new line
			playObject = currentMedia.getMedia();
			length = currentMedia.getLength();
			currentMedia.dropMedia();
		}
		private function audioLoaded(e:Event):void{
			jumpTo(staticPosition);
		}
		public function jumpTo(position:Number):void{
			staticPosition = position;
			SoundMixer.stopAll();
			if(currentMedia.checkFormat() == MediaFileType.AUDIO.toLowerCase() && currentMedia.readyMedia()){
				playObject = null;////////////////////////////////////////////////////////////new line
				playObject = audio.play(staticPosition);
				length = audio.length;
				playing = true;
				visualisation.visible = true;
				video.visible = false;
				playObject.addEventListener(Event.SOUND_COMPLETE, mediaComplete);
			}
			else if(currentMedia.checkFormat() == MediaFileType.VIDEO.toLowerCase() && currentMedia.readyMedia()){
				playObject.seek(staticPosition/milliseconds);
				//playObject.playheadTime = staticPosition/milliseconds;
				playObject.play();
				length = playObject.totalTime * milliseconds;
				playing = true;
				visualisation.visible = false;
			//setScale(getScale());
				video.visible = true;
				playObject.addEventListener(VideoEvent.COMPLETE, mediaComplete);
			}
			//trace("play:",staticPosition);
		}
		public function pause(ce:CustomEvent = null):void{
			if(currentMedia.checkFormat() == MediaFileType.AUDIO.toLowerCase() && currentMedia.readyMedia()){
				staticPosition = playObject.position;
				playObject.stop();
				visualisation.visible = true;
				video.visible = false;
			}
			else if(currentMedia.checkFormat() == MediaFileType.VIDEO.toLowerCase() && currentMedia.readyMedia()){
				staticPosition = playObject.playheadTime * milliseconds;// - milliseconds/1.5;
				playObject.stop();
				visualisation.visible = false;
				video.visible = true;
			}
			SoundMixer.stopAll();
			playing = false;
			listeners();
			//trace("pause:",staticPosition);
		}
		public function stop(ce:CustomEvent = null):void{
			if(playObject != null){
				playObject.stop();
				playObject = null;////////////////////////////////////////////////////////////new line
			}
			staticPosition = 0;
			playPosition = 0;
			video.visible = false;
			SoundMixer.stopAll();
			playing = false;
		}
		public function mediaComplete(e:Event):void{
			dispatchEvent(new DisplayEvent(DisplayEvent.COMPLETE));
		}
		public function isPlaying():Boolean{
			return this.playing
		}
		
		public function getPosition():Number{
			if(playing){
				return playPosition;
			}
			else{
				return staticPosition;
			}
		}
		
		public function getLength():Number{
			return this.length;
		}
		
		public function getCurrentMedia():MediaFile{
			return this.currentMedia;
		}
		
		public function getVolume():Number{
			return this.volume;
		}
		public function setVolume(volume:Number):void{
			this.volume = volume;
			SoundMixer.soundTransform = new SoundTransform(volume/100);
		}
		private function getWidth():Number{
			return this._width;
		}
		private function getHeight():Number{
			return this._height;
		}
		public function setSize(_width:Number, _height:Number):void{
			this._width = _width;
			this._height = _height
			visualisation.setSize(_width, _height);
			//trace("setsize");
			setScale(scale);
			drawBackground();
		}
		private function drawBackground():void{
			this.graphics.clear();
			this.graphics.beginFill(color);
			this.graphics.drawRect(0,0,_width,_height);
			this.graphics.endFill();
		}
		public function getVideo():FLVPlayback{
			return this.video;
		}
		public function setVisualisation(simType:String, simSetting:String):void{
			this.simType = simType.toLowerCase();
			this.simSetting = simSetting;
			visualisation.setSimulation(this.simType, this.simSetting);
		}
		public function getVisualisation():Visualisation{
			return this.visualisation;
		}
		public function getScale():String{
			return this.scale;
		}

		public function setScale(scale:String):void{
			this.scale = scale.toLowerCase();
			video.addEventListener(fl.video.LayoutEvent.LAYOUT, center);
			video.addEventListener(fl.video.LayoutEvent.LAYOUT, scaleRipple);
			video.scaleMode = VideoScaleMode.NO_SCALE;
		}
		private function center(e:Event = null):void{
			video.x = (_width - video.width)/2;
			video.y = (_height - video.height)/2;
			trace("x, y:",video.x,video.y);
		}
		private function scaleRipple(e:Event = null):void{
			video.removeEventListener(fl.video.LayoutEvent.LAYOUT, scaleRipple);
			var preferredHeight:Number = video.height;
			var preferredWidth:Number = video.width;
			try{
				if(this.scale == "auto"){
					trace(this.scale,"= auto");
					video.scaleMode = VideoScaleMode.MAINTAIN_ASPECT_RATIO;
					video.setSize(_width, _height);
				}
				else if(this.scale == "fill"){
					trace(this.scale,"= fill");
					video.scaleMode = VideoScaleMode.EXACT_FIT;
					video.setSize(_width, _height);
				}
				else if(this.scale == "width"){
					trace(this.scale,"= width");
					video.scaleMode = VideoScaleMode.MAINTAIN_ASPECT_RATIO;
					//video.height = _width * preferredHeight/preferredWidth;
					video.width = _width;
				}
				else if(this.scale == "height"){
					trace(this.scale,"= height");
					video.scaleMode = VideoScaleMode.MAINTAIN_ASPECT_RATIO;
					//video.width = _height * preferredWidth/preferredHeight;
					video.height = _height;
				}
				else{
					trace(this.scale,"= ?");
					video.scaleMode = VideoScaleMode.MAINTAIN_ASPECT_RATIO;
					video.setSize(preferredWidth, preferredHeight);
					video.setScale(parseInt(scale)/100, parseInt(scale)/100);
				}
			}
			catch(e:Error){
				//trace("Cannot set video scale:",e);
			}
			//trace(this.scale);
			
		}
		public function shuffleSimulation(e:Event = null):void{
			//var type:int = Math.floor(Math.random()*simulations.length);
			var setting:String = Math.floor(Math.random()*simulationsType[simulations.indexOf(simType)]).toString();
			//visualisation.setSimulation(simulations[type], setting);
			visualisation.setSimulation(simType, setting);
		}
	}
	
}