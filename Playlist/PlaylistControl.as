package Playlist {
	import flash.display.Sprite;
	import flash.filesystem.File;
	import flash.net.FileFilter;
	import flash.filesystem.FileStream;
	import flash.net.URLRequest;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.FileListEvent;
	import flash.display.MovieClip;
	import flash.text.TextField;
	import fl.transitions.Tween;
	import fl.transitions.easing.*;
	import flash.geom.Rectangle;
	import flash.filesystem.FileMode;
	import Media.MediaFile;
	import Media.MediaFileEvent;
	import Media.Audio.AudioFile;
	import Media.Video.VideoFile;
	import flash.display.NativeMenu;
	import flash.display.NativeMenuItem;
	import flash.display.BitmapData;
	import flash.desktop.NotificationType;
	import flash.events.KeyboardEvent;
	import flash.filters.DropShadowFilter;
	
	public class PlaylistControl extends Sprite{
		
		public static const playlistItemXMLFORMAT:XML = new XML(<playlistItem src=""/>);
		//public static const playlistVersionXMLFORMAT:XML = new XML(<?opl version="1.0" encoding="utf-8"?>);
		public static const playlistXMLFORMAT:XML = new XML(<playlist>
																<head>
																	<meta name="Generator" content="Ogbz Media Player -- 2.03"/>
																	<meta name="ItemCount" content="0"/>
																	<author/>
																	<title>Untitled</title>
																</head>
																<body/>
															</playlist>);
		
		public static const FILENAME:String = new String("Untitled");
		public static const EXTENSION:String = new String("opl");
		public static const MINWIDTH:int = new int(200);
		public static const PADDING:int = new int(4);
		public static const MAXWIDTH:int = new int(500);
		
		public static const LOOPNONE:int = new int(0);
		public static const LOOPONE:int = new int(1);
		public static const LOOPALL:int = new int(2);
		
		private var tweenSpd:int = new int(12);
		private var scrollSpd:int = new int(6);
		
		private var playlist:XML;
		//private var playlistItems:Vector.<PlaylistItem>;
		private var playlistItems:Array;
		private var playedItems:Array;
		private var currentItem:PlaylistItem;
		private var updated:Boolean;
		private var saved:Boolean;
		private var selected:Boolean;
		private var urlLoader:URLLoader;
		private var saveFile:File, mediaFile:MediaFile, mediaFileFilter:FileFilter;
		private var fileStream:FileStream;
		private var cont:MovieClip
		private var color:Number;
		private var _width:Number, _height:Number;
		private var rollerMinHeight:int;
		private var rollerMaxHeight:int;
		private var contMaskWidth:Number;
		private var dragArea:Rectangle;
		private var scrollingUp:Boolean;
		private var scrollingDown:Boolean;
		private var tweenCont:Tween;
		private var tweenContItem:Tween;
		private var tweenRoller:Tween;
		private var tweenFade:Tween;
		private var autoFade:Boolean;
		private var yesItem:NativeMenuItem;
		private var noItem:NativeMenuItem;
		private var tooltip:ToolTip;
		
		private var loop:int;
		private var shuffle:Boolean;
		private var playing:Boolean;
		private var reverse:Boolean = false;
		private var playItem:PlaylistItem;
		
		public function PlaylistControl( _height:Number, _width:Number = 300, playlistUrl:String = null) {
			init();
			listeners();
			if(playlistUrl == null){
				setMediaFileDefault();
			}
			else{
				mediaFile = new MediaFile(playlistUrl);
				initPlaylist();
			}
			saveFile = mediaFile;
			
			this._height = _height;
			this._width = _width;
			setSize(_width, _height);
		}
		
		private function init():void{			
			autoFade = false;
			color = 0x101010;
			cont = new MovieClip();
			cont.x = PADDING/2;
			cont.y = contMask.y;
			cont.mask = contMask;
			this.addChildAt(cont, 4);
			playlist = playlistXMLFORMAT;
			playlistItems = new Array();
			//playlistItems = new Vector.<PlaylistItem>();
			var mf:String = "Media file"; //(."+EXTENSION+", ."+MediaFile.AUDIO_MP3+", ."+MediaFile.VIDEO_FLV+")";
			var me:String = "*."+EXTENSION+";"+"*."+MediaFile.AUDIO_MP3+";"+"*."+MediaFile.VIDEO_FLV+";"+"*."+MediaFile.VIDEO_MOV+";"+"*."+MediaFile.VIDEO_MP4;
			mediaFileFilter = new FileFilter(mf, me);
			
			tooltip = new ToolTip(0xffffff);
			//tooltip.setFont("Segoe UI Regular");
			this.addChild(tooltip);
			tooltip.visible = false;
		}
		private function initPlaylist():void{
			if(!mediaFile.exists){
				setMediaFileDefault();
				this.dispatchEvent(new PlaylistEvent(PlaylistEvent.NOT_EXISTING));
			}
			else if(mediaFile.extension.toLowerCase() != EXTENSION){
				setMediaFileDefault();
				this.dispatchEvent(new PlaylistEvent(PlaylistEvent.INCORRECT_FORMAT));
			}
			else{
				mediaFile.addEventListener(Event.SELECT, loadMediaFile);
				mediaFile.dispatchEvent(new Event(Event.SELECT));
			}
		}
		private function listeners():void{
			chkBtn.addEventListener(MouseEvent.MOUSE_UP, toggleState);
			chkBtn.addEventListener(MouseEvent.MOUSE_MOVE, showToolTip);
			divider.addEventListener(MouseEvent.MOUSE_MOVE, showToolTip);
			playlistTitle.addEventListener(Event.CHANGE, updatePlaylistTitle);
			playlistTitle.addEventListener(MouseEvent.MOUSE_MOVE, titleToolTip);
			
			roller.addEventListener(MouseEvent.MOUSE_DOWN, beginDrag);
			scrollArea.addEventListener(MouseEvent.MOUSE_UP, moveRoller);
			upBtn.addEventListener(MouseEvent.MOUSE_DOWN, scrollUp);
			downBtn.addEventListener(MouseEvent.MOUSE_DOWN, scrollDown);
			upBtn.addEventListener(MouseEvent.MOUSE_UP, stopScroll);
			downBtn.addEventListener(MouseEvent.MOUSE_UP, stopScroll);
			
			this.addEventListener(MouseEvent.MOUSE_WHEEL, scroll);
			this.addEventListener(KeyboardEvent.KEY_UP, showLetter, true, 1);
		}
		public function setPlaylist(url:String):void{
			mediaFile.url = url;
			initPlaylist();
		}
		private function setMediaFileDefault():void{
			saved = false;
			mediaFile = new MediaFile(File.documentsDirectory.url+File.separator+FILENAME+"."+EXTENSION);
		}
		private function setPlaylistDefaultValues():void{
			updated = false;
			setState(false);
			playing = false;
			scrollingUp = false;
			scrollingDown = false;
			playedItems = [];
			//setMediaFileDefault();
			playlistTitle.text = playlist.head.title;
		}
		public function newPlaylist(e:Event):void{
			this.resetPlaylist();
			this.setMediaFileDefault();
			this.setPlaylistDefaultValues();
		}
		public function openMediaFile(e:Event):void{
			mediaFile.addEventListener(Event.SELECT, loadMediaFile);
			mediaFile.browseForOpen("Open Media file", [mediaFileFilter]);
		}		
		public function addMediaFiles(e:Event):void{
			mediaFile.addEventListener(FileListEvent.SELECT_MULTIPLE, addPlaylistItems);
			mediaFile.browseForOpenMultiple("Select Media file(s)", [mediaFileFilter]);
		}
		public function addMediaFolder(e:Event):void{
			mediaFile.addEventListener(Event.SELECT, addPlaylistDirectory);
			mediaFile.browseForDirectory("Select Folder");
		}
		private function loadMediaFile(e:Event):void{
			//trace("playlist ctrl load media");
			if(mediaFile.extension.toLowerCase() == EXTENSION){
				//trace("playlistCtrl load playlist");
				loadPlaylist(mediaFile);
			}
			else if(mediaFile.readyMedia()){
				//trace("playlistCtrl open media");
				stop();
				resetPlaylist();
				loadPlaylistItems([mediaFile]);
			}
			var idx:int = 0;
			if(playItem != null){
				idx = playItem.index
			}
			if(!playing && playlistItems.length > 0){
				show(idx);
				play();
			}
			mediaFile.removeEventListener(Event.SELECT, loadMediaFile);
		}
		private function addPlaylistItems(fle:FileListEvent):void{
			loadPlaylistItems(fle.files as Array);
			mediaFile.removeEventListener(FileListEvent.SELECT_MULTIPLE, addPlaylistItems);
		}
		private function addPlaylistDirectory(e:Event):void{
			mediaFile = e.target as MediaFile;
			if(mediaFile.isDirectory){
				loadPlaylistItems(mediaFile.getDirectoryListing());
			}
			mediaFile.removeEventListener(Event.SELECT, addPlaylistDirectory);
		}
		public function loadPlaylist(file:File):void{
			stop();
			resetPlaylist();
			mediaFile.url = file.url;
			urlLoader = new URLLoader(new URLRequest(mediaFile.url));
			urlLoader.addEventListener(Event.COMPLETE, playlistLoaded);
		}
		private function playlistLoaded(e:Event):void{
			saveFile = mediaFile;
			playlist = new XML(e.target.data);
			
			//trace("playlistItems length: "+playlist.body.playlistItem.length());
			
			setMediaFileDefault();
			setPlaylistDefaultValues();
			playlistTitle.text = playlist.head.title;
			saved = true;
			updated = true;
			this.setSize(_width, _height);
			for(var i:int = 0; i < playlist.body.playlistItem.length(); i++){
				mediaFile = new MediaFile(playlist.body.playlistItem[i].@src);
				if(mediaFile.readyMedia() && !inPlaylist(mediaFile)){
					insertItem(mediaFile);
				}
				else if(!mediaFile.exists){
					delete playlist.body.playlistItem[i];
					updated = false;
				}
			}
			this.dispatchEvent(new PlaylistEvent(PlaylistEvent.LOADED));
			play();
		}
		public function loadPlaylistItems(files:Array){
			var num:int = playlistItems.length;
			for(var i:int = 0; i < files.length; i++){
				var item:XML = XML(playlistItemXMLFORMAT);
				mediaFile = new MediaFile(files[i].url);
				if(files[i].extension == EXTENSION){
					insertPlaylist(files[i].url);
				}
				else if(mediaFile.readyMedia() && !inPlaylist(mediaFile)){
					item.@src = files[i].url;
					playlist.body.playlistItem += item;
					insertItem(mediaFile);
					//playlist.child("body").appendChild(item);
				}
				else if(mediaFile.isDirectory){
					//trace(mediaFile.getDirectoryListing());
					//trace("adding directory...");
					loadPlaylistItems(mediaFile.getDirectoryListing());
				}
			}
			//trace("playlist length:",playlist.body.playlistItem.length());
			arrangeCont();
			//trace("playlist:",playlist.toXMLString());
			if(files.length == 1){
				stop();
				if(inPlaylist(mediaFile)){
					playItem = playlistItems[whereInPlaylist(mediaFile)];
				}
				else if(playlistItems.length > 0){
					playItem = playlistItems[playlistItems.length-1];
				}
				if(!isPlaying()){
					//trace("play item",playlistItems.length-1,playlistItems[playlistItems.length-1].tooltip());
					play();
				}
			}
		}
		private function insertPlaylist(url:String){
			urlLoader = new URLLoader(new URLRequest(url));
			urlLoader.addEventListener(Event.COMPLETE, playlistInserted);
		}
		private function playlistInserted(e:Event):void{
			var insertedPlaylist:XML = new XML(e.target.data);
			for(var i:int = 0; i < insertedPlaylist.body.playlistItem.length(); i++){
				playlist.body.playlistItem += insertedPlaylist.body.playlistItem[i];
				mediaFile = new MediaFile(insertedPlaylist.body.playlistItem[i].@src);
				if(mediaFile.readyMedia() && !inPlaylist(mediaFile)){
					insertItem(mediaFile);
				}
			}
		}
		private function insertItem(mediaFile:MediaFile):void{
			var playlistItem:PlaylistItem = new PlaylistItem(mediaFile, contMaskWidth);
			playlistItem.setWidth(contMaskWidth);
			playlistItem.x = PADDING;
			playlistItem.y = playlistItems.length * PlaylistItem.HEIGHT;
			playlistItem.index = playlistItems.length;
			playlistItem.addEventListener(PlaylistEvent.READY, startReorder);
			playlistItem.addEventListener(PlaylistEvent.PLAY, readyMedia);
			playlistItem.addEventListener(PlaylistEvent.DELETE, deletePlaylistItem);
			playlistItem.addEventListener(MouseEvent.MOUSE_MOVE, showToolTip);
			playlistItems.push(cont.addChild(playlistItem));
			chkBtn.setState(false);
			updated = false;
			arrangeCont();
			//stage.nativeWindow.notifyUser(NotificationType.INFORMATIONAL);
		}
		private function inPlaylist(mediaFile:MediaFile):Boolean{
			for(var i:int = 0; i < playlistItems.length; i++){
				if(playlistItems[i].getMediaFile().url == mediaFile.url){
					return true;
				}
			}
			return false;
		}
		private function whereInPlaylist(mediaFile:MediaFile):int{
			for(var i:int = 0; i < playlistItems.length; i++){
				if(playlistItems[i].getMediaFile().url == mediaFile.url){
					return i;
				}
			}
			return -1;
		}
		private function readyMedia(ple:PlaylistEvent):void{
			var playlistItem:PlaylistItem = ple.target as PlaylistItem;
			if(playlistItem.getMediaFile().exists){
				if(playItem == playlistItem){
					if(playing){
						//trace("play2pause");
						playing = false;
						this.dispatchEvent(new PlaylistEvent(PlaylistEvent.PAUSE, playItem.getMediaFile()));
					}
					else{
						//trace("pause2play");
						playing = true;
						this.dispatchEvent(new PlaylistEvent(PlaylistEvent.PLAY, playItem.getMediaFile()));
					}
				}
				else{
					//trace("stop2play");
					playedItems = playedItems || [];
					if(playItem && !reverse){
						playedItems.push(playItem.index);
					}
					stop();
					playItem = playlistItem;
					//trace(playedItems);
					this.playing = true;
					this.dispatchEvent(new PlaylistEvent(PlaylistEvent.PLAY, playItem.getMediaFile()));
					this.dispatchEvent(new PlaylistEvent(PlaylistEvent.UPDATE, playItem));
				}
				playlistItem.play();
				show(playlistItem.index);
			}
			else{
				stop();
				stopCurrentItem();
				currentItem = playlistItem;
				selectCurrentItem();
				mediaFile = playlistItem.getMediaFile();
				recoverMedia();
			}
		}
		private function stopCurrentItem():void{
			if(currentItem != playItem && currentItem != null){
				currentItem.stop();
			}
		}
		private function selectCurrentItem():void{
			if(currentItem != playItem && currentItem != null){
				currentItem.select();
			}
		}
		private function recoverMedia(e:Event = null):void{
			if(stage.nativeWindow.displayState == "minimized"){
				stage.nativeWindow.restore();
				stage.nativeWindow.notifyUser("informational");
			}
			mediaFile.browseForOpen("MediaFile missing! Select Replacement for "+currentItem.title+" ...", [mediaFileFilter]);
			mediaFile.addEventListener(Event.SELECT, replaceMedia);
			mediaFile.addEventListener(Event.CANCEL, dropMedia);
		}
		private function replaceMedia(e:Event):void{
			currentItem.setMediaFile(mediaFile);
			currentItem.dispatchPlayEvent();
			mediaFile.removeEventListener(Event.SELECT, replaceMedia);
		}
		private function dropMedia(e:Event = null):void{
			this.deleteItem(currentItem);
			mediaFile.removeEventListener(Event.CANCEL, dropMedia);
		}
		public function play(e:Event = null):void{
			if(playItem != null && playlistItems.length > 0 && playItem == playlistItems[playItem.index]){
				playItem.dispatchPlayEvent();
			}
			else if((playItem == null || playItem != playlistItems[playItem.index]) && playlistItems.length > 0 ){
				playItem = playlistItems[0];
				playItem.dispatchPlayEvent();
			}
			else{
				stop();
			}
		}
		public function next(e:Event = null):void{
			if(playItem != null){
				nextLoop(loop);
			}
		}
		public function nextLoop(loop:int):void{
			stop();
			//trace("loop:",loop);
			if(loop == LOOPNONE && playItem.index < playlistItems.length - 1){
				//trace("next");
				shuffleNext(shuffle);
			}
			else if(loop == LOOPONE){
				//trace("repeat");
				play();
			}
			else if(loop == LOOPALL){
				//trace("next");
				shuffleNext(shuffle);
			}
		}
		public function shuffleNext(shuffle:Boolean):void{
			var nextItem:int = playItem.index;
			if(playItem != null && playlistItems.length > 0){
				if(shuffle){
					//trace("shuffle: "+shuffle);
					while(nextItem == playItem.index && playlistItems.length > 1) nextItem = Math.floor(Math.random()*playlistItems.length);
				}
				else{
					nextItem = playItem.index + 1;
					if(nextItem > playlistItems.length - 1){
						nextItem = 0;
					}
				}
				playlistItems[nextItem].dispatchPlayEvent();
			}
			else{
				stop();
			}
		}
		public function previous(e:Event = null):void{
			var prevItem:int;
			if(playedItems.length > 0){
				//trace(playedItems);
				//stop();
				prevItem = playedItems[playedItems.length - 1];
				playedItems.pop();
				if(playlistItems[prevItem].getMediaFile().exists){
					reverse = true;
					playlistItems[prevItem].dispatchPlayEvent();
				}
				else{
					stop();
					stopCurrentItem();
					currentItem = playlistItems[prevItem];
					selectCurrentItem();
					mediaFile.browseForOpen("MediaFile missing! Select Replacement...", [mediaFileFilter]);
					mediaFile.addEventListener(Event.SELECT, replaceMedia);				
				}
			}
			else{
				stop();
			}
		}
		public function pause(e:Event = null):void{
			playing = false;
			arrangeCont();
			this.dispatchEvent(new PlaylistEvent(PlaylistEvent.PAUSE, playItem));
		}
		public function stop(e:Event = null):void{
			if(playItem != null){
				playItem.stop();
			}
			playing = false;
			reverse = false;
			arrangeCont();
			this.dispatchEvent(new PlaylistEvent(PlaylistEvent.STOP, playItem));
			this.dispatchEvent(new PlaylistEvent(PlaylistEvent.UPDATE, playItem));
		}
		public function isPlaying():Boolean{
			return this.playing;
		}
		public function isShuffling():Boolean{
			return this.shuffle;
		}
		public function clearPlaylist(e:Event = null):void{
			while(playlistItems.length > 0){
				deleteItem(playlistItems[0]);
			}
			playItem = null;
			playedItems = [];
		}
		private function resetPlaylist():void{
			clearPlaylist();
			playlist = playlistXMLFORMAT;
		}
		
		public function deletePlaylistItem(e:Event){
			stopCurrentItem();
			currentItem = null;
			//trace("before delete -->");
			//trace("playlist length: "+playlistItems.length);
			if(e.target is PlaylistItem){
				var item:PlaylistItem = e.target as PlaylistItem;
				this.deleteItem(item);
			}
			else{
				for(var i:int = 0; i < playlistItems.length; i++){
					if(playlistItems[i].isSelected()){
						this.deleteItem(playlistItems[i]);
						i = -1;
					}
				}
			}
			//trace("after delete -->");
			//trace("playlist length: "+playlistItems.length);
			//trace("playlist:",playlist);
		}
		private function deleteItem(item:PlaylistItem):void{
			var idx:int = item.index;
			//trace("item deleted: "+idx+", "+playlistItems[idx].index);
			if(playItem == playlistItems[idx]){
				stop(new Event(Event.ACTIVATE));
			}
			for(var i:int = 0; i < playlist.body.playlistItem.(@src == item.getMediaFile().url).length(); i++){
				delete playlist.body.playlistItem.(@src == item.getMediaFile().url)[i];
			}
			//delete playlist.body.playlistItem[idx];
			cont.removeChild(playlistItems[idx]);
			playlistItems.splice(idx, 1);
			playlistItems.sort(compare);
			chkBtn.setState(false);
			updated = false;
			arrangeCont();
			//trace("playlistItem:", playlist.body.playlistItem);
		}
		
		public function savePlaylist(e:Event):void{
			if(saveFile.exists && saved){
				save(saveFile, playlist);
			}
			else{
				saveFile.addEventListener(Event.SELECT, createPlaylist);
				saveFile.browseForSave("Select Playlist Location");
			}
		}
		private function createPlaylist(e:Event):void{
			save(saveFile, playlist);
		}
		private function save(file:File, data:Object):void{
			if(file.extension == null || file.extension != EXTENSION){
				file.url += ("."+EXTENSION);
			}
			fileStream = new FileStream();
			fileStream.open(file, FileMode.WRITE);
			fileStream.writeUTFBytes(data.toString());
			fileStream.close();
			updated = true;
			saved = true;
		}
		
		private function compare(item1:PlaylistItem, item2:PlaylistItem):Number{
			return (item1.index - item2.index);
		}
		public function orderBy(property:String = "title"):void{
			//trace("sort by:",property);
			playlistItems.sortOn([property,"name"],Array.CASEINSENSITIVE);
			updated = false;
			arrangeCont();
		}
		private function startReorder(ple:PlaylistEvent):void{
			stopCurrentItem();
			currentItem = ple.target as PlaylistItem;
			selectCurrentItem();
			cont.setChildIndex(currentItem, cont.numChildren-1);
			dragArea = new Rectangle(currentItem.x, 0, 0, cont.height);
			currentItem.startDrag(false,dragArea);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, reorder);
			stage.addEventListener(MouseEvent.MOUSE_UP, stopReorder);
		}
		private function reorder(me:MouseEvent):void{
			var idx:int = Math.floor((currentItem.y+PlaylistItem.HEIGHT/2)/PlaylistItem.HEIGHT);
			if(idx > playlistItems.length-1)idx = playlistItems.length-1;
			
			playlist.body.playlistItem[idx].@src = currentItem.getMediaFile().url;
			playlist.body.playlistItem[currentItem.index].@src = playlistItems[idx].getMediaFile().url;
			
			playlistItems[idx].index = currentItem.index;
			currentItem.index = idx;
			
			playlistItems.sort(compare);
			updated = false;
			arrangeCont();
		}
		public function updatePlaylist():void{
			//trace("update playlist items");
			playlist.normalize();
			for(var i:int = 0; i < playlistItems.length; i++){
				playlistItems[i].index = i;
				if(!playlistItems[i].isDragging()){
					playlistItems[i].tweenTo(i * PlaylistItem.HEIGHT);
				}
				playlistItems[i].setWidth(contMaskWidth);
				playlist.body.playlistItem[i].@src = (playlistItems[i] as PlaylistItem).getMediaFile().url;
				//bg.visible = true;
				//trace("arrange: "+i+", "+playlistItems[i].index);
			}
			playlist.head.meta.(@name == "ItemCount").@content = playlist.body.playlistItem.length();
			//playlist.head.author = File.userDirectory.creator;
			playlist.normalize();
		}
		private function arrangeCont():void{
			updatePlaylist();
			updateRoller();
		}
		private function stopReorder(me:MouseEvent){
			currentItem.stopDrag();
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, reorder);
			stage.removeEventListener(MouseEvent.MOUSE_UP, stopReorder);
			currentItem.afterDrop();
			//trace("playlist body:",playlist.body);
		}
		
		private function toggleState(me:MouseEvent):void{
			chkBtn.toggleState();
			selected = chkBtn.getState();
			updateState();
		}
		private function setState(state:Boolean):void{
			chkBtn.setState(state);
			selected = chkBtn.getState();
			updateState();
		}
		private function updateState():void{
			for(var i:int = 0; i < playlistItems.length; i++){
				playlistItems[i].setState(selected);
			}
		}
		
		private function show(idx:int):void{
			if(playlistItems.length > idx){
				dragArea = new Rectangle(roller.x,scrollArea.y,0,scrollArea.height - roller.height);
				var midY:Number = contMask.y + contMask.height/2;
				/*var itemY:Number = contMask.y + idx * PlaylistItem.HEIGHT;
				var contY:Number = (contMask.y - itemY) + midY;*/
				var contY:Number =  midY - idx * PlaylistItem.HEIGHT;
				var contHeight:Number = playlistItems.length * PlaylistItem.HEIGHT;
				var rollerY:Number = (contMask.y - contY)/(contHeight - contMask.height) * dragArea.height + dragArea.y;
				updateScroll(testRoller(rollerY), testCont(contY));
				//trace("show",idx);
				stopCurrentItem();
				currentItem = playlistItems[idx];
				selectCurrentItem();
			}
		}
		private function showLetter(ke:KeyboardEvent):void{
			var idx:Number = ( currentItem ) ? currentItem.index + 1 : 0;
			for(var i:int = 0; i < playlistItems.length; i++ && idx++){
				if(idx >= playlistItems.length) idx = 0;
				if(playlistItems[idx].title.toLowerCase().charCodeAt(0) == ke.charCode){
					show(idx);
					break;
				}
			}
		}
		
		private function beginDrag(e:Event):void{
			dragArea = new Rectangle(roller.x,scrollArea.y,0,scrollArea.height - roller.height);
			roller.startDrag(false, dragArea);
			roller.removeEventListener(MouseEvent.MOUSE_DOWN, beginDrag);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, updateCont);
			stage.addEventListener(MouseEvent.MOUSE_UP, endDrag);
		}
		private function endDrag(e:Event):void{
			roller.stopDrag();
			roller.addEventListener(MouseEvent.MOUSE_DOWN, beginDrag);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, updateCont);
			stage.removeEventListener(MouseEvent.MOUSE_UP, endDrag);
			updateCont();
		}
		private function scroll(me:MouseEvent):void{
			var rollerY:Number;
			rollerY = roller.y - me.delta*scrollSpd;
			var contY:Number = contMask.y - (rollerY - dragArea.y)/dragArea.height * (cont.height - contMask.height);
			updateScroll(testRoller(rollerY), testCont(contY));
		}
		private function scrollDown(me:MouseEvent):void{
			scrollingDown = true;
			this.addEventListener(Event.ENTER_FRAME, testScroll);
		}
		private function scrollUp(me:MouseEvent):void{
			scrollingUp = true;
			this.addEventListener(Event.ENTER_FRAME, testScroll);
		}
		private function testScroll(e:Event){
			var rollerY:Number;
			if(scrollingUp){rollerY = roller.y - scrollSpd;}
			else if(scrollingDown){rollerY = roller.y + scrollSpd;}
			var contY:Number = contMask.y - (rollerY - dragArea.y)/dragArea.height * (cont.height - contMask.height);
			updateScroll(testRoller(rollerY), testCont(contY));
		}
		private function stopScroll(me:MouseEvent):void{
			scrollingDown = false;
			scrollingUp = false;
			this.removeEventListener(Event.ENTER_FRAME, testScroll);
		}
		private function updateScroll(rollerY:Number, contY:Number):void{
			scrollRoller(testRoller(rollerY));
			scrollCont(testCont(contY));
		}
		private function testCont(contY:Number):Number{
			var contHeight:Number = playlistItems.length * PlaylistItem.HEIGHT;
			if (contY < contMask.y - (contHeight - contMask.height)){
				contY = contMask.y - (contHeight - contMask.height);
			}
			if (contY > contMask.y){
				contY = contMask.y;
			}
			return contY;
		}
		private function scrollCont(newY:Number):void{
			tweenCont = new Tween(cont,"y",Strong.easeOut,cont.y,newY,tweenSpd,false);
		}
		private function updateCont(e:Event = null):void{
			var contHeight:Number = playlistItems.length * PlaylistItem.HEIGHT;
			var contY:Number;
			if(contHeight > contMask.height){
				upBtn.visible = true;
				scrollArea.visible = true;
				downBtn.visible = true;
				roller.visible = true;
				contY = contMask.y - (roller.y - dragArea.y)/dragArea.height * (cont.height - contMask.height);
			}
			else{
				upBtn.visible = false;
				scrollArea.visible = false;
				downBtn.visible = false;
				roller.visible = false;
				contY = contMask.y;
			}
			scrollCont(testCont(contY));
		}
		private function testRoller(rollerY:Number):Number{
			if (rollerY < scrollArea.y){
				rollerY = scrollArea.y;
			}
			if (rollerY > scrollArea.y + scrollArea.height - roller.height){
				rollerY = scrollArea.y + scrollArea.height - roller.height;
			}
			return rollerY;
		}
		private function scrollRoller(newY:Number):void{
			tweenRoller = new Tween(roller,"y",Strong.easeOut,roller.y,newY,tweenSpd,false);
		}
		private function moveRoller(e:Event):void{
			dragArea = new Rectangle(roller.x,scrollArea.y,0,scrollArea.height - roller.height);
			var rollerY:Number = mouseY - roller.height / 2;
			var contY:Number = contMask.y - (rollerY - dragArea.y)/dragArea.height * (cont.height - contMask.height);
			updateScroll(testRoller(rollerY), testCont(contY));
		}
		private function updateRoller():void{
			rollerMinHeight = roller.width * 2;
			rollerMaxHeight = scrollArea.height;
			var contHeight:Number = playlistItems.length * PlaylistItem.HEIGHT;
			var rh:Number = contMask.height / contHeight * scrollArea.height;
			if(rh < rollerMinHeight)rh = rollerMinHeight;
			else if(rh > rollerMaxHeight)rh = rollerMaxHeight;
			roller.setHeight(rh);
			dragArea = new Rectangle(roller.x,scrollArea.y,0,scrollArea.height - roller.height);
			roller.y = (contMask.y - cont.y)/(contHeight - contMask.height) * dragArea.height + dragArea.y;
			if(roller.y < scrollArea.y)roller.y = scrollArea.y;
			if(roller.y > scrollArea.y + scrollArea.height - roller.height)roller.y = scrollArea.y + scrollArea.height - roller.height;
			if(contHeight > contMask.height){
			}
			else{
				roller.y = scrollArea.y;
			}
			updateCont();
		}
		
		private function updatePlaylistTitle(e:Event):void{
			if(playlist.head.title.toString() != e.target.text){
				updated = false;
			}
			playlist.head.title = e.target.text;
		}
		public function getHeight():Number{
			return this._height;
		}
		public function getWidth():Number{
			return this._width;
		}
		public function setSize(_width:Number, _height:Number):void{
			this._width = _width;
			this._height = _height;
			divider.height = _height;
			playlistTitle.width = _width - PADDING*2 - chkBtn.x - chkBtn.width;
			playlistTitle.x = _width - playlistTitle.width - PADDING;
			downBtn.x = _width - downBtn.width;
			downBtn.y = _height;
			upBtn.x = downBtn.x;
			scrollArea.x = downBtn.x;
			scrollArea.height = downBtn.y - downBtn.height - scrollArea.y;
			roller.x = downBtn.x + PADDING/2;
			contMask.height = _height - contMask.y;
			contMask.width = _width*2;
			contMaskWidth = scrollArea.x - PADDING/2 - PADDING;
			getSkin();
			arrangeCont();
			//setOrientation();
		}
		public function setOrientation():void{
			this.x = stage.stageWidth - _width;
			this.y = 0;
		}
		private function getSkin():void{
			var skin:Skin = new Skin();
			skin.addEventListener(CustomEvent.LOADED, drawBackground);
		}
		private function drawBackground(ce:CustomEvent):void{
			this.graphics.clear();
			//this.graphics.beginFill(color, .5);
			this.graphics.beginBitmapFill(ce.getSecondaryTarget() as BitmapData);
			this.graphics.drawRect(0,0,_width,_height);
			this.graphics.endFill();
		}
		public function getAutoFade():Boolean{
			return this.autoFade;
		}
		public function setAutoFade(autoFade:Boolean):void{
			if(autoFade){// && !this.autoFade){
				this.addEventListener(MouseEvent.MOUSE_OVER, fadeIn);
				this.addEventListener(MouseEvent.MOUSE_OUT, fadeOut);
			}
			else if(!autoFade && this.autoFade){
				this.removeEventListener(MouseEvent.MOUSE_OVER, fadeIn);
				this.removeEventListener(MouseEvent.MOUSE_OUT, fadeOut);
			}
			this.autoFade = autoFade;
			this.alpha = Number(!autoFade);
		}
		private function fadeIn(me:MouseEvent):void{
			tweenFade = new Tween(this, "alpha", Strong.easeOut, this.alpha, 1, tweenSpd, false);
		}
		private function fadeOut(me:MouseEvent):void{
			tweenFade = new Tween(this, "alpha", Strong.easeOut, this.alpha, .01, tweenSpd, false);
		}
		public function getColor():Number{
			return this.color;
		}
		public function setColor(color:Number):void{
			this.color = color;
			getSkin();
		}
		public function getPlayItem():PlaylistItem{
			return playItem;
		}
		public function getPlaylistItems():Array{
			return playlistItems;
		}
		/*public function getPlaylistItems():Vector.<PlaylistItem>{
			return playlistItems;
		}*/
		public function getLoop():int{
			return this.loop;
		}
		public function setLoop(loop:int):void{
			this.loop = loop;
		}
		public function getShuffle():Boolean{
			return this.shuffle;
		}
		public function setShuffle(shuffle:Boolean):void{
			this.shuffle = shuffle;
		}
		public function getSaveStatus():Boolean{
			if(this.saved != saveFile.exists) this.saved = saveFile.exists;
			return this.saved;
		}
		public function getCurrentStatus():Boolean{
			return this.updated;
		}
		
		private function titleToolTip(me:MouseEvent):void{
			tooltip.setOrientation(ToolTip.TOP);
			tooltip.setContInfo("Set Playlist Title");
			tooltip.setTargetX(mouseX);
			tooltip.setTargetY(mouseY + PADDING*2);
			tooltip.visible = true;
			testToolTip(tooltip);
			playlistTitle.addEventListener(MouseEvent.MOUSE_OUT, hideToolTip);
		}
		private function showToolTip(me:MouseEvent):void{
			tooltip.setOrientation(ToolTip.TOP);
			var contInfo:String = "?";
			try{
			if(me.target.tooltip != null){
				contInfo = me.target.tooltip();
			}
			else if(me.currentTarget.tooltip != null){
				contInfo = me.currentTarget.tooltip();
			}
			}
			catch(e:Error){
				//trace(e);
			}
			tooltip.setContInfo(contInfo);
			tooltip.setTargetX(mouseX);
			tooltip.setTargetY(mouseY + PADDING*2);
			tooltip.visible = true;
			testToolTip(tooltip);
			me.target.addEventListener(MouseEvent.MOUSE_OUT, hideToolTip);
		}
		private function hideToolTip(me:MouseEvent):void{
			tooltip.visible = false;
		}
		private function testToolTip(tooltip:ToolTip):void{
			if(tooltip.y + tooltip.height > _height){
				tooltip.setTargetY(mouseY - PADDING*2);
				tooltip.setOrientation(ToolTip.BOTTOM);
				if(tooltip.x + tooltip.width/2 > _width){
					tooltip.setOrientation(ToolTip.BOTTOM_RIGHT);
				}
				else if(tooltip.x - tooltip.width/2 < 0){
					tooltip.setOrientation(ToolTip.BOTTOM_LEFT);
				}
			}
			else if(tooltip.x + tooltip.width/2 > _width){
				tooltip.setOrientation(ToolTip.TOP_RIGHT);
			}
			else if(tooltip.x - tooltip.width/2 < 0){
				tooltip.setOrientation(ToolTip.TOP_LEFT);
			}
		}
		/*private function testToolTip(tooltip:ToolTip):void{
			if(tooltip.y + tooltip.height/2 > _height){
				tooltip.setOrientation(ToolTip.BOTTOM_RIGHT);
			}
			else if(tooltip.y - tooltip.height/2 < 0){
				tooltip.setOrientation(ToolTip.TOP_RIGHT);
			}
		}*/
	}
}