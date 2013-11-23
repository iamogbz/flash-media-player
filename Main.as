package {

	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageDisplayState;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundMixer;
	import flash.media.SoundTransform;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.FileFilter;
	import flash.filesystem.File;
	import flash.filesystem.FileStream;
	import flash.filesystem.FileMode;
	import Playlist.PlaylistControl;
	import Playlist.PlaylistEvent;
	import Player.PlayerControl;
	import Player.PlayerEvent;
	import Display.DisplayControl;
	import Display.DisplayEvent;
	import flash.display.Screen;
	import flash.events.ScreenMouseEvent;
	import flash.display.NativeMenu;
	import flash.display.NativeMenuItem;
	import flash.display.NativeWindow;
	import flash.display.NativeWindowType;
	import flash.display.NativeWindowInitOptions;
	import flash.display.NativeWindowDisplayState;
	import flash.events.NativeWindowDisplayStateEvent;
	import flash.display.Sprite;
	import flash.display.Loader;
	import flash.display.Bitmap;
	import flash.display.InteractiveObject;
	import flash.desktop.Clipboard;
	import flash.desktop.ClipboardFormats;
	import flash.desktop.NativeApplication;
	import flash.desktop.NativeDragManager;
	import flash.desktop.NativeDragActions;
	import flash.events.NativeDragEvent;
	import flash.desktop.Icon;
	import flash.desktop.SystemTrayIcon;
	import flash.desktop.InvokeEventReason;
	import flash.events.InvokeEvent;
	import Media.Audio.AudioFile;
	import Media.Video.VideoFile;
	import Media.MediaFile;
	import flash.events.NativeWindowBoundsEvent;
	import Notice.NoticeWindow;
	import Display.CurrentMedia;
	import Media.MediaFileType;
	
	public class Main extends MovieClip {

		private var playlistCtrl:PlaylistControl;//section to edit playlist
		private var playerCtrl:PlayerControl;//section to control playback
		private var displayCtrl:DisplayControl;//section to view playback
		private var menu:CustomMenu;//window menu
		private var settings:XML,settingsNamespace:Namespace,settingsFile:File,settingsLoader:URLLoader;
		private var loop:int,shuffle:Boolean,color:Number;
		private var currentMedia:MovieClip;
		private var minimizeToTray:Boolean, trayIcon:SystemTrayIcon, trayIconLoader:Loader, trayIconImage:Bitmap;
		private var trayMenu:CustomMenu;//tray menu
		private var dropArea:Sprite, noticeWindow:NoticeWindow, aboutWin:InfoWindow, helpWin:InfoWindow;
		
		public function Main() {
			init();
			listeners();
			trace(NativeApplication.nativeApplication.applicationDescriptor.toXMLString());
		}
		
		private function init():void {
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			NativeDragManager.dropAction = "play";
			color = 0;
			minimizeToTray = false;
			playerCtrl = new PlayerControl(stage.stageWidth);
			this.addChildAt(playerCtrl, 0);
			playerCtrl.setOrientation();
			playlistCtrl = new PlaylistControl(stage.stageHeight - playerCtrl.getHeight(),PlaylistControl.MINWIDTH);
			this.addChildAt(playlistCtrl, 0);
			playlistCtrl.setOrientation();
			currentMedia = new CurrentMedia();
			currentMedia.x = 10;
			currentMedia.y = 10;
			currentMedia.visible = false;
			this.addChildAt(currentMedia, 0);
			displayCtrl = new DisplayControl(stage.stageWidth - playlistCtrl.getWidth(),stage.stageHeight - playerCtrl.getHeight());
			this.addChildAt(displayCtrl, 0);
			settingsFile = new File(File.applicationStorageDirectory.nativePath + File.separator + "Settings.xml");
			if (settingsFile.exists) {
				loadSettings();
			}
			else{
				settingsFile = new File(File.applicationDirectory.nativePath + File.separator + "Settings.xml");
				if (settingsFile.exists) {
					loadSettings();
				}
			}
			var menuFile:File = new File(File.applicationDirectory.nativePath + File.separator + "Menu.xml");
			if (menuFile.exists) {
				menu = new CustomMenu(menuFile.url);
				stage.nativeWindow.menu = menu;
				stage.nativeWindow.menu.addEventListener(CustomEvent.LOADED, menuLoaded);
			}
			trayIcon = NativeApplication.nativeApplication.icon as SystemTrayIcon;
			var trayMenuFile:File = new File(File.applicationDirectory.nativePath + File.separator + "TrayMenu.xml");
			if (trayMenuFile.exists) {
				trayMenu = new CustomMenu(trayMenuFile.url);
				trayIcon.menu = trayMenu;
				trayIcon.menu.addEventListener(CustomEvent.LOADED, trayMenuLoaded);
			}
			var trayIconFile:File = new File(File.applicationDirectory.nativePath + File.separator + "MediaPlayer_16.png");
			if (trayIconFile.exists) {
				trayIconLoader = new Loader();
				trayIconLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, trayIconLoaded);
				trayIconLoader.load(new URLRequest(trayIconFile.url));
			}
			dropArea = new Sprite();
			dropArea.visible = false;
			this.addChild(dropArea);
		}
		
		private function listeners():void{
			//ctrlListeners();
			//menuListeners();
			NativeApplication.nativeApplication.addEventListener(InvokeEvent.INVOKE, invokeHandler);
			NativeApplication.nativeApplication.autoExit = false;
			stage.nativeWindow.addEventListener(Event.CLOSE, exit, false, 0, true);
			stage.nativeWindow.addEventListener(NativeWindowDisplayStateEvent.DISPLAY_STATE_CHANGING, displayStateHandler);
			this.addEventListener(NativeDragEvent.NATIVE_DRAG_ENTER, dragEnter);
		}
		
		private function invokeHandler(ie:InvokeEvent):void{
			//trace(ie.arguments);
			playlistCtrl.addEventListener(PlaylistEvent.PLAY, displayCtrl.play);
			playlistCtrl.addEventListener(PlaylistEvent.PAUSE, displayCtrl.pause);
			playlistCtrl.addEventListener(PlaylistEvent.STOP, displayCtrl.stop);
			//playlistCtrl.newPlaylist(ie);
			for(var i:int = 0; i < ie.arguments.length; i++){
				var file:File = new File(ie.arguments[i]);
				if(!file.isDirectory && file.extension.toLowerCase() == PlaylistControl.EXTENSION){
					playlistCtrl.loadPlaylist(file);
				}
				else{
					playlistCtrl.loadPlaylistItems([file]);
				}
			}
			/*if(!playlistCtrl.isPlaying()){
				//trace("init play");
				playlistCtrl.play();
			}*/
			if(stage.nativeWindow.displayState == NativeWindowDisplayState.MINIMIZED) showWindow(new ScreenMouseEvent(ScreenMouseEvent.MOUSE_UP));
		}
		
		private function dragEnter(nde:NativeDragEvent):void{
			//trace("enter");
			dropArea.visible = true;
			this.removeEventListener(NativeDragEvent.NATIVE_DRAG_ENTER, dragEnter);
			this.addEventListener(NativeDragEvent.NATIVE_DRAG_DROP, dragDrop);
			this.addEventListener(NativeDragEvent.NATIVE_DRAG_EXIT, dragExit);
			var clipboard:Clipboard = nde.clipboard;
			var files:Array = clipboard.getData(ClipboardFormats.FILE_LIST_FORMAT) as Array;
			var testFile:MediaFile = new MediaFile(files[0].url);
			if(testFile.readyMedia() || testFile.isDirectory){
				NativeDragManager.acceptDragDrop(nde.target as InteractiveObject);
			}
			else{
				NativeDragManager.dropAction = NativeDragActions.NONE;
			}
		}
		private function dragDrop(nde:NativeDragEvent):void
		{
			//trace("drop");
			NativeDragManager.dropAction = "play";
			this.addEventListener(NativeDragEvent.NATIVE_DRAG_ENTER, dragEnter);
			this.removeEventListener(NativeDragEvent.NATIVE_DRAG_DROP, dragDrop);
			this.removeEventListener(NativeDragEvent.NATIVE_DRAG_EXIT, dragExit);
			dropArea.visible = false;
			var clipboard:Clipboard = nde.clipboard;
			var files:Array = clipboard.getData(ClipboardFormats.FILE_LIST_FORMAT) as Array;
			if(!files[0].isDirectory && files[0].extension.toLowerCase() == PlaylistControl.EXTENSION){
				playlistCtrl.loadPlaylist(files[0]);
			}
			else{
				playlistCtrl.loadPlaylistItems(files);
			}
			if(!playlistCtrl.isPlaying()){
				//trace("main play");
				playlistCtrl.play();
			}
		}
		private function dragExit(nde:NativeDragEvent):void
		{
			//trace("exit");
			NativeDragManager.dropAction = "play";
			this.addEventListener(NativeDragEvent.NATIVE_DRAG_ENTER, dragEnter);
			this.removeEventListener(NativeDragEvent.NATIVE_DRAG_DROP, dragDrop);
			this.removeEventListener(NativeDragEvent.NATIVE_DRAG_EXIT, dragExit);
			dropArea.visible = false;
		}
		
		private function loadSettings():void {
			//trace(settingsFile.url);
			//settingsFile.load()
			//settingsFile.addEventListener(Event.COMPLETE, settingsLoaded);
			settingsLoader = new URLLoader(new URLRequest(settingsFile.url));
			settingsLoader.addEventListener(Event.COMPLETE, settingsLoaded);
			settingsFile = new File(File.applicationStorageDirectory.nativePath + File.separator + "Settings.xml");
		}
		
		private function settingsLoaded(e:Event):void {
			settings = new XML(e.target.data);
			settingsNamespace = settings.namespace();
			//trace("settings loaded");
			stage.nativeWindow.width = settings.settingsNamespace::initialWindow.settingsNamespace::width;
			stage.nativeWindow.height = settings.settingsNamespace::initialWindow.settingsNamespace::height;
			minimizeToTray = Default.parseBoolean(settings.settingsNamespace::initialWindow.settingsNamespace::minimizeToTray.toString());
			stage.nativeWindow.alwaysInFront = Default.parseBoolean(settings.settingsNamespace::initialWindow.settingsNamespace::alwaysInFront.toString());
			
			playerCtrl.volBtn.setState(Number(Default.parseBoolean(settings.settingsNamespace::initialPlayer.settingsNamespace::mute.toString())));
			ctrlListeners();
			playerCtrl.volCtrl.setVolume(Number(settings.settingsNamespace::initialPlayer.settingsNamespace::volume.toString()));
			//trace("volume:",settings.settingsNamespace::initialPlayer.settingsNamespace::volume.toString());
			playerCtrl.loopBtn.setState(Number(settings.settingsNamespace::initialPlayer.settingsNamespace::loop.toString()));
			playerCtrl.shuffleBtn.setState(Number(Default.parseBoolean(settings.settingsNamespace::initialPlayer.settingsNamespace::shuffle.toString())));
			playlistCtrl.setSize(Number(settings.settingsNamespace::initialPlaylist.settingsNamespace::width.toString()), stage.stageHeight - playerCtrl.getHeight());
			playlistCtrl.visible = Default.parseBoolean(settings.settingsNamespace::initialPlaylist.settingsNamespace::visible.toString())
			resizeHandler(e);
			
			displayCtrl.setVisualisation(settings.settingsNamespace::initialDisplay.settingsNamespace::visualisation.toString(), "0");
			displayCtrl.setScale(settings.settingsNamespace::initialDisplay.settingsNamespace::scale.toString());
		}
		
		private function menuLoaded(e:Event):void {
			menuListeners();
			menu.getItemByName("Playback").submenu.getItemByName("PlayPause").label = playerCtrl.ppBtn.getState();
			menu.getItemByName("Playback").submenu.getItemByName("Mute").checked = Boolean(playerCtrl.volBtn.state);
			menu.getItemByName("Playback").submenu.getItemByName("Shuffle").checked = Boolean(playerCtrl.shuffleBtn.state);
			
			var loopMenu:NativeMenu = menu.getItemByName("Playback").submenu.getItemByName("Loop").submenu;
			var loopItem:NativeMenuItem = menu.getItemByName("Playback").submenu.getItemByName("Loop").submenu.getItemAt(playlistCtrl.getLoop());
			menu.selectOnlyFrom(loopItem, loopMenu);
			
			updateAbilityMinimizeToTray();
			menu.getItemByName("Edit").submenu.getItemByName("Settings").submenu.getItemByName("Show Playlist").checked = playlistCtrl.visible;
			menu.getItemByName("Edit").submenu.getItemByName("Settings").submenu.getItemByName("Always in front").checked = stage.nativeWindow.alwaysInFront;
			//trace("visualisation:",settings.settingsNamespace::initialDisplay.settingsNamespace::visualisation.toString());
			var visualisationMenu:NativeMenu = menu.getItemByName("Edit").submenu.getItemByName("Settings").submenu.getItemByName("Audio Visualisation").submenu;
			var visualisationItem:NativeMenuItem = menu.getItemByName("Edit").submenu.getItemByName("Settings").submenu.getItemByName("Audio Visualisation").submenu.getItemByName(settings.settingsNamespace::initialDisplay.settingsNamespace::visualisation.toString());
			menu.selectOnlyFrom(visualisationItem, visualisationMenu);
			
			//trace("scale:",settings.settingsNamespace::initialDisplay.settingsNamespace::scale.toString());
			var scaleMenu:NativeMenu = menu.getItemByName("Edit").submenu.getItemByName("Settings").submenu.getItemByName("Video Scale").submenu;
			var scaleItem:NativeMenuItem = menu.getItemByName("Edit").submenu.getItemByName("Settings").submenu.getItemByName("Video Scale").submenu.getItemByName(settings.settingsNamespace::initialDisplay.settingsNamespace::scale.toString());
			menu.selectOnlyFrom(scaleItem, scaleMenu);
			
			this.contextMenu = menu.getItemByName("Edit").submenu.getItemByName("Settings").submenu;
			//displayCtrl.getVideo().contextMenu = contextMenu = menu.getItemByName("Edit").submenu.getItemByName("Settings").submenu;
		}
		
		private function trayMenuLoaded(e:Event):void{
			trayMenuListeners();
			trayMenu.getItemByName("PlayPause").label = playerCtrl.ppBtn.getState();
			trayMenu.getItemByName("Mute").checked = Boolean(playerCtrl.volBtn.state);
			trayMenu.getItemByName("Shuffle").checked = Boolean(playerCtrl.shuffleBtn.state);
			
			var loopMenu:NativeMenu = trayMenu.getItemByName("Loop").submenu;
			var loopItem:NativeMenuItem = trayMenu.getItemByName("Loop").submenu.getItemAt(playlistCtrl.getLoop());
			trayMenu.selectOnlyFrom(loopItem, loopMenu);
		}
		private function trayIconLoaded(e:Event):void{
			trayIconLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, trayIconLoaded);
			trayIconImage = Bitmap(trayIconLoader.content);
			trayIconImage.smoothing = true;
		}
		
		private function ctrlListeners(e:Event = null):void {
			displayCtrl.addEventListener(DisplayEvent.UPDATE, update);
			displayCtrl.addEventListener(DisplayEvent.COMPLETE, playlistCtrl.next);
			displayCtrl.addEventListener(MouseEvent.MOUSE_DOWN, function (me:MouseEvent):void{
										 if(me.clickCount > 1) playerCtrl.fullScrnBtn.toggleState(me);
										 else displayCtrl.shuffleSimulation(me);
										 });
			//displayCtrl.addEventListener(MouseEvent.CLICK, displayCtrl.shuffleSimulation);
			//displayCtrl.addEventListener(MouseEvent.DOUBLE_CLICK, playerCtrl.fullScrnBtn.toggleState);
			playerCtrl.seekCtrl.addEventListener(PlayerEvent.UPDATE, playerSeekHandler);
			playerCtrl.loopBtn.addEventListener(PlayerEvent.UPDATE, playerLoopHandler);
			playerCtrl.shuffleBtn.addEventListener(PlayerEvent.UPDATE, playerShuffleHandler);
			playerCtrl.prevBtn.addEventListener(PlayerEvent.UPDATE, playlistCtrl.previous);
			playerCtrl.stopBtn.addEventListener(PlayerEvent.STOP, playlistCtrl.stop);
			playerCtrl.ppBtn.addEventListener(PlayerEvent.PLAY, playlistCtrl.play);
			playerCtrl.ppBtn.addEventListener(PlayerEvent.PAUSE, playlistCtrl.pause);
			playerCtrl.nxtBtn.addEventListener(PlayerEvent.UPDATE, playlistCtrl.next);
			playerCtrl.volBtn.addEventListener(PlayerEvent.UPDATE, playerVolumeHandler);
			playerCtrl.volCtrl.addEventListener(PlayerEvent.UPDATE, playerVolumeHandler);
			playerCtrl.fullScrnBtn.addEventListener(PlayerEvent.CHECKED, fullScreen);
			playerCtrl.fullScrnBtn.addEventListener(PlayerEvent.UNCHECKED, normal);
			playlistCtrl.addEventListener(PlaylistEvent.PLAY, displayCtrl.play);
			playlistCtrl.addEventListener(PlaylistEvent.PAUSE, displayCtrl.pause);
			playlistCtrl.addEventListener(PlaylistEvent.STOP, displayCtrl.stop);
			playlistCtrl.addEventListener(PlaylistEvent.UPDATE, mediaUpdate);
			playlistCtrl.divider.addEventListener(MouseEvent.MOUSE_DOWN, startMove);
			stage.addEventListener(Event.RESIZE, resizeHandler);
		}
		
		private function menuListeners(e:Event = null):void{
			menu.getItemByName("File").submenu.getItemByName("New").addEventListener(Event.SELECT, playlistCtrl.newPlaylist);
			menu.getItemByName("File").submenu.getItemByName("Open").addEventListener(Event.SELECT, playlistCtrl.openMediaFile);
			menu.getItemByName("File").submenu.getItemByName("Add").submenu.getItemByName("Files").addEventListener(Event.SELECT, playlistCtrl.addMediaFiles);
			menu.getItemByName("File").submenu.getItemByName("Add").submenu.getItemByName("Folder").addEventListener(Event.SELECT, playlistCtrl.addMediaFolder);
			menu.getItemByName("File").submenu.getItemByName("Remove").addEventListener(Event.SELECT, playlistCtrl.deletePlaylistItem);
			menu.getItemByName("File").submenu.getItemByName("Save").addEventListener(Event.SELECT, playlistCtrl.savePlaylist);
			menu.getItemByName("File").submenu.getItemByName("Exit").addEventListener(Event.SELECT, exit);
			
			menu.getItemByName("Playback").submenu.getItemByName("PlayPause").addEventListener(Event.SELECT, playlistCtrl.play);
			menu.getItemByName("Playback").submenu.getItemByName("Stop").addEventListener(Event.SELECT, playlistCtrl.stop);
			menu.getItemByName("Playback").submenu.getItemByName("Next").addEventListener(Event.SELECT, playlistCtrl.next);
			menu.getItemByName("Playback").submenu.getItemByName("Previous").addEventListener(Event.SELECT, playlistCtrl.previous);
			menu.getItemByName("Playback").submenu.getItemByName("Mute").addEventListener(Event.SELECT, menuVolumeHandler);
			menu.getItemByName("Playback").submenu.getItemByName("Shuffle").addEventListener(Event.SELECT, menuShuffleHandler);
			menu.getItemByName("Playback").submenu.getItemByName("Loop").submenu.items.forEach(setLoopListener);
			
			menu.getItemByName("Edit").submenu.getItemByName("Fullscreen").addEventListener(Event.SELECT, fullScreen);
			menu.getItemByName("Edit").submenu.getItemByName("Settings").submenu.getItemByName("Show Playlist").addEventListener(Event.SELECT, showPlaylistHandler);
			menu.getItemByName("Edit").submenu.getItemByName("Settings").submenu.getItemByName("Always in front").addEventListener(Event.SELECT, alwaysInFrontHandler);
			menu.getItemByName("Edit").submenu.getItemByName("Settings").submenu.getItemByName("Minimize to tray").addEventListener(Event.SELECT, minimizeToTrayHandler);
			menu.getItemByName("Edit").submenu.getItemByName("Settings").submenu.getItemByName("Sort Playlist").submenu.items.forEach(setSortListener);
			menu.getItemByName("Edit").submenu.getItemByName("Settings").submenu.getItemByName("Audio Visualisation").submenu.items.forEach(setVisualisationListener);
			menu.getItemByName("Edit").submenu.getItemByName("Settings").submenu.getItemByName("Video Scale").submenu.items.forEach(setScaleListener);
			
			menu.getItemByName("Help").submenu.getItemByName("About Developer").addEventListener(Event.SELECT, about);
			menu.getItemByName("Help").submenu.getItemByName("Instructions").addEventListener(Event.SELECT, instruct);
		}
		
		private function trayMenuListeners(e:Event = null):void{			
			trayMenu.getItemByName("PlayPause").addEventListener(Event.SELECT, playlistCtrl.play);
			trayMenu.getItemByName("Stop").addEventListener(Event.SELECT, playlistCtrl.stop);
			trayMenu.getItemByName("Next").addEventListener(Event.SELECT, playlistCtrl.next);
			trayMenu.getItemByName("Previous").addEventListener(Event.SELECT, playlistCtrl.previous);
			trayMenu.getItemByName("Mute").addEventListener(Event.SELECT, menuVolumeHandler);
			trayMenu.getItemByName("Shuffle").addEventListener(Event.SELECT, menuShuffleHandler);
			trayMenu.getItemByName("Loop").submenu.items.forEach(setLoopListener);
			
			trayMenu.getItemByName("About Developer").addEventListener(Event.SELECT, about);
			trayMenu.getItemByName("Instructions").addEventListener(Event.SELECT, instruct);
			
			trayMenu.getItemByName("Exit").addEventListener(Event.SELECT, exit);
		}
		
		private function mediaUpdate(ple:PlaylistEvent):void{
			if(playlistCtrl.isPlaying() && playlistCtrl.getPlayItem() && !stage.nativeWindow.closed){
				var tipit:String = playlistCtrl.getPlayItem().title;
				if(playlistCtrl.getPlayItem().artist && playlistCtrl.getPlayItem().artist.length > 1) tipit += " • " + playlistCtrl.getPlayItem().artist;
				if(true && /*stage.nativeWindow.visible && */stage.nativeWindow.title != tipit){
					stage.nativeWindow.title = tipit;
				}
				if(trayIcon) trayIcon.tooltip = tipit;
				//stage.nativeWindow.title = ple.getSecondaryTarget().title;
				//if(ple.getSecondaryTarget().artist && ple.getSecondaryTarget().artist.length > 1) stage.nativeWindow.title += " • " + ple.getSecondaryTarget().artist;
				if(stage.nativeWindow.displayState == NativeWindowDisplayState.MINIMIZED){
					var maxChars:int = 30;
					//var tt:String = (ple.getSecondaryTarget().title.length > maxChars) ? ple.getSecondaryTarget().title.substr(0,maxChars-3)+"..." : ple.getSecondaryTarget().title;
					//var at:String = (ple.getSecondaryTarget().artist.length > maxChars) ? ple.getSecondaryTarget().artist.substr(0,maxChars-3)+"..." : ple.getSecondaryTarget().artist;
					var tt:String = (playlistCtrl.getPlayItem().title.length > maxChars) ? playlistCtrl.getPlayItem().title.substr(0,maxChars-3)+"..." : playlistCtrl.getPlayItem().title;
					var at:String = (playlistCtrl.getPlayItem().artist.length > maxChars) ? playlistCtrl.getPlayItem().artist.substr(0,maxChars-3)+"..." : playlistCtrl.getPlayItem().artist;
					if(noticeWindow != null && !noticeWindow.closed){
						noticeWindow.exit();
						noticeWindow = null;
					}
					noticeWindow = new NoticeWindow(tt + "\n" + at);
					noticeWindow.ctrl.prevBtn.addEventListener(PlayerEvent.UPDATE, playlistCtrl.previous, false, 0, true);
					noticeWindow.ctrl.stopBtn.addEventListener(PlayerEvent.STOP, playlistCtrl.stop, false, 0, true);
					noticeWindow.ctrl.ppBtn.addEventListener(PlayerEvent.PLAY, playlistCtrl.play, false, 0, true);
					noticeWindow.ctrl.ppBtn.addEventListener(PlayerEvent.PAUSE, playlistCtrl.pause, false, 0, true);
					noticeWindow.ctrl.nxtBtn.addEventListener(PlayerEvent.UPDATE, playlistCtrl.next, false, 0, true);
				}
			}
			else{
				stage.nativeWindow.title = "MediaPlayer";
			}
			trayIcon.tooltip = stage.nativeWindow.title;
		}
		
		private function update(e:Event):void {
			if(playlistCtrl.getPlayItem() && !stage.nativeWindow.closed){
				var tipit:String = playlistCtrl.getPlayItem().title;
				if(playlistCtrl.getPlayItem().artist && playlistCtrl.getPlayItem().artist.length > 1) tipit += " • " + playlistCtrl.getPlayItem().artist;
				if(playlistCtrl.isPlaying() /*&& stage.nativeWindow.visible*/ && stage.nativeWindow.title != tipit){
					stage.nativeWindow.title = tipit;
				}
				if(trayIcon) trayIcon.tooltip = tipit;
				currentMedia.visible = (playlistCtrl.getPlayItem().getMediaFile().getType() == MediaFileType.AUDIO);
				currentMedia.title.text = playlistCtrl.getPlayItem().title;
				currentMedia.artist.text = playlistCtrl.getPlayItem().artist;
				currentMedia.album.text = playlistCtrl.getPlayItem().album;
				currentMedia.year.text = playlistCtrl.getPlayItem().year;
			}
			updateControl();
		}
		
		private function updateControl():void {
			if (displayCtrl.getCurrentMedia() != null && playerCtrl.seekCtrl.editing == false) {
				//trace(displayCtrl.getPosition(), displayCtrl.getLength());
				playerCtrl.seekCtrl.setPosition(displayCtrl.getPosition(), displayCtrl.getLength());
			}
			playerCtrl.ppBtn.setState(Number(displayCtrl.isPlaying()));
			if(playerCtrl.stopBtn.enabled != displayCtrl.isPlaying()){
				playerCtrl.stopBtn.enabled = displayCtrl.isPlaying();
				if(!displayCtrl.isPlaying() && displayCtrl.getPosition() != 0) playerCtrl.stopBtn.enabled = true;
			}
			if(noticeWindow){
				noticeWindow.ctrl.ppBtn.setState(playerCtrl.ppBtn.currentFrame-1);
				noticeWindow.ctrl.stopBtn.enabled = playerCtrl.stopBtn.enabled;
			}
			if (playlistCtrl.getPlayItem() != null) {
				playerCtrl.seekCtrl.enabled = true;
			}
			else {
				playerCtrl.seekCtrl.enabled = false;
			}
			if(menu.getItemByName("File").submenu.getItemByName("Save").enabled == playlistCtrl.getCurrentStatus()){
				menu.getItemByName("File").submenu.getItemByName("Save").enabled = !playlistCtrl.getCurrentStatus();
			}
			if(menu.getItemByName("File").submenu.getItemByName("Save").checked != playlistCtrl.getSaveStatus()){
				menu.getItemByName("File").submenu.getItemByName("Save").checked = playlistCtrl.getSaveStatus();
			}
			if(menu.getItemByName("Playback").submenu.getItemByName("PlayPause").label != playerCtrl.ppBtn.getState()){
				menu.getItemByName("Playback").submenu.getItemByName("PlayPause").label = playerCtrl.ppBtn.getState();
				trayMenu.getItemByName("PlayPause").label = playerCtrl.ppBtn.getState();
			}
			if(menu.getItemByName("Playback").submenu.getItemByName("Stop").enabled != playerCtrl.stopBtn.enabled){
				menu.getItemByName("Playback").submenu.getItemByName("Stop").enabled = playerCtrl.stopBtn.enabled;
				trayMenu.getItemByName("Stop").enabled = playerCtrl.stopBtn.enabled;
			}
		}
		
		private function playerSeekHandler(ce:CustomEvent):void {
			displayCtrl.jumpTo(playerCtrl.seekCtrl.position);
		}
		
		private function playerLoopHandler(ce:CustomEvent):void {
			settings.settingsNamespace::initialPlayer.settingsNamespace::loop = playerCtrl.loopBtn.state;
			loop = playerCtrl.loopBtn.state;
			playlistCtrl.setLoop(loop);
			var loopMenu:NativeMenu, loopItem:NativeMenuItem;
			try{
				loopMenu = menu.getItemByName("Playback").submenu.getItemByName("Loop").submenu;
				loopItem = menu.getItemByName("Playback").submenu.getItemByName("Loop").submenu.getItemAt(playlistCtrl.getLoop());
				menu.selectOnlyFrom(loopItem, loopMenu);
				loopMenu = trayMenu.getItemByName("Loop").submenu;
				loopItem = trayMenu.getItemByName("Loop").submenu.getItemAt(playlistCtrl.getLoop());
				trayMenu.selectOnlyFrom(loopItem, loopMenu);
			}
			catch(e:Error){
				//trace("cutom menu not loaded:",e);
			}
			saveSettings();
			//trace("loop:", loop);
		}
		
		private function playerShuffleHandler(ce:CustomEvent):void {
			settings.settingsNamespace::initialPlayer.settingsNamespace::shuffle = Boolean(playerCtrl.shuffleBtn.state);
			shuffle = Boolean(playerCtrl.shuffleBtn.state);
			playlistCtrl.setShuffle(shuffle);
			try{
			menu.getItemByName("Playback").submenu.getItemByName("Shuffle").checked = Boolean(playerCtrl.shuffleBtn.state);
			}
			catch(e:Error){
				//trace("cutom menu not loaded:",e);
			}
			saveSettings();
			//trace("shuffle:", shuffle);
		}
		
		private function playerVolumeHandler(ce:CustomEvent):void {
			if (!Boolean(playerCtrl.volBtn.state)) {
				settings.settingsNamespace::initialPlayer.settingsNamespace::volume = playerCtrl.volCtrl.volume;
				displayCtrl.setVolume(playerCtrl.volCtrl.volume);
			}
			else {
				displayCtrl.setVolume(0);
			}
			settings.settingsNamespace::initialPlayer.settingsNamespace::mute = Boolean(playerCtrl.volBtn.state);
			try{
			menu.getItemByName("Playback").submenu.getItemByName("Mute").checked = Boolean(playerCtrl.volBtn.state);
			}
			catch(e:Error){
				//trace("cutom menu not loaded:",e);
			}
			saveSettings();
			//trace("volume:", displayCtrl.getVolume());
		}
		
		private function fullScreen(e:Event):void {
			stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
			resizeHandler(e);
		}
		
		private function normal(e:Event):void {
			stage.displayState = StageDisplayState.NORMAL;
			resizeHandler(e);
		}
		
		private function startMove(me:MouseEvent):void {
			var dragArea:Rectangle = new Rectangle(0,0,stage.stageWidth - Playlist.PlaylistControl.MINWIDTH,0);
			playlistCtrl.divider.removeEventListener(MouseEvent.MOUSE_DOWN, startMove);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, resizing);
			stage.addEventListener(MouseEvent.MOUSE_UP, stopMove);
			playlistCtrl.startDrag(false, dragArea);
		}
		
		private function stopMove(me:MouseEvent):void {
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, resizing);
			stage.removeEventListener(MouseEvent.MOUSE_UP, stopMove);
			playlistCtrl.divider.addEventListener(MouseEvent.MOUSE_DOWN, startMove);
			playlistCtrl.stopDrag();
			playlistCtrl.setSize(stage.stageWidth - playlistCtrl.x, playlistCtrl.getHeight());
			resizeHandler(me);
		}
		
		private function resizing(me:MouseEvent):void {
			playlistCtrl.setSize(stage.stageWidth - playlistCtrl.x, playlistCtrl.getHeight());
			//resizeHandler(me);
		}
		
		private function resizeHandler(e:Event):void {
			//trace("resize handler");
			playerCtrl.setWidth(stage.stageWidth);
			playerCtrl.setOrientation();
			var playlistWidth:Number = playlistCtrl.getWidth();
			if(playlistWidth >= stage.stageWidth - 40) playlistWidth = stage.stageWidth;
			playlistCtrl.setSize(playlistWidth, stage.stageHeight - playerCtrl.getHeight());
			playlistCtrl.setOrientation();
			try{
				settings.settingsNamespace::initialPlaylist.settingsNamespace::width = playlistCtrl.getWidth();
			}
			catch(e:Error){
				//trace("settings file not loaded",e);
			}
			if (stage.displayState == StageDisplayState.FULL_SCREEN_INTERACTIVE) {
				//playlistCtrl.setAutoFade(true);
				playerCtrl.setAutoFade(true);
				playlistCtrl.visible = false;
				try{
					menu.getItemByName("Edit").submenu.getItemByName("Settings").submenu.getItemByName("Show Playlist").enabled = false;
					menu.getItemByName("Edit").submenu.getItemByName("Settings").submenu.getItemByName("Show Playlist").checked = playlistCtrl.visible;
				}
				catch(e:Error){
					//trace("custom menu not loaded:",e);
				}
				//playerCtrl.visible = false;
				playerCtrl.fullScrnBtn.setState(1);
				stage.nativeWindow.menu = null;
				displayCtrl.setSize(stage.stageWidth, stage.stageHeight);
			}
			else if (stage.displayState == StageDisplayState.NORMAL) {
				//playlistCtrl.setAutoFade(false);
				playerCtrl.setAutoFade(false);
				playerCtrl.alpha = 1;
				try{
					playlistCtrl.visible = Default.parseBoolean(settings.settingsNamespace::initialPlaylist.settingsNamespace::visible.toString());
				}
				catch(e:Error){
					//trace("settings file not loaded",e);
				}
				//playerCtrl.visible = true;
				playerCtrl.fullScrnBtn.setState(0);
				stage.nativeWindow.menu = menu;
				if(playlistCtrl.visible){
					displayCtrl.setSize(stage.stageWidth - playlistCtrl.getWidth(), stage.stageHeight - playerCtrl.getHeight());
				}
				else{
					displayCtrl.setSize(stage.stageWidth, stage.stageHeight - playerCtrl.getHeight());
				}
				if (stage.displayState == StageDisplayState.NORMAL && stage.nativeWindow.displayState == NativeWindowDisplayState.NORMAL) {
					try{
						settings.settingsNamespace::initialWindow.settingsNamespace::width = stage.nativeWindow.width;
						settings.settingsNamespace::initialWindow.settingsNamespace::height = stage.nativeWindow.height;
					}
					catch(e:Error){
						//trace("settings file not loaded",e);
					}
				}
				try{
					menu.getItemByName("Edit").submenu.getItemByName("Settings").submenu.getItemByName("Show Playlist").enabled = true;
					menu.getItemByName("Edit").submenu.getItemByName("Settings").submenu.getItemByName("Show Playlist").checked = playlistCtrl.visible;
				}
				catch(e:Error){
					//trace("custom menu not loaded:",e);
				}
			}
			dropArea.graphics.clear();
			dropArea.graphics.beginFill(color, .5);
			dropArea.graphics.drawRect(0,0,stage.stageWidth, stage.stageHeight);
			dropArea.graphics.endFill();
			saveSettings();
		}
		
		private function showPlaylistHandler(e:Event):void{
			playlistCtrl.visible = toggleMenuItem(e.target as NativeMenuItem);
			settings.settingsNamespace::initialPlaylist.settingsNamespace::visible = playlistCtrl.visible;
			resizeHandler(e);
			saveSettings();
		}
		
		private function alwaysInFrontHandler(e:Event):void{
			stage.nativeWindow.alwaysInFront = toggleMenuItem(e.target as NativeMenuItem);
			settings.settingsNamespace::initialWindow.settingsNamespace::alwaysInFront = stage.nativeWindow.alwaysInFront;
			saveSettings();
		}
		
		private function minimizeToTrayHandler(e:Event):void{
			minimizeToTray = toggleMenuItem(e.target as NativeMenuItem);
			updateAbilityMinimizeToTray();
			settings.settingsNamespace::initialWindow.settingsNamespace::minimizeToTray = minimizeToTray;
			saveSettings();
		}
		private function updateAbilityMinimizeToTray():void{
			menu.getItemByName("Edit").submenu.getItemByName("Settings").submenu.getItemByName("Minimize to tray").enabled = NativeApplication.supportsSystemTrayIcon;
			if(!NativeApplication.supportsSystemTrayIcon){
				minimizeToTray = false;
			}
			menu.getItemByName("Edit").submenu.getItemByName("Settings").submenu.getItemByName("Minimize to tray").checked = minimizeToTray;
		}
		private function showWindow(sme:ScreenMouseEvent):void{
			trayIcon.bitmaps = [];
			stage.nativeWindow.restore();
			stage.nativeWindow.orderToFront();
			stage.nativeWindow.notifyUser("informational");
		}
		private function displayStateHandler(nwdse:NativeWindowDisplayStateEvent):void{
			updateAbilityMinimizeToTray();
			if(minimizeToTray && nwdse.afterDisplayState == NativeWindowDisplayState.MINIMIZED){
				trayIcon.bitmaps = new Array(trayIconImage);
				trayIcon.tooltip = stage.nativeWindow.title;
				//trayIcon.menu = new NativeMenu();
				//trayIcon.menu.addSubmenu(menu.getItemByName("File").submenu, "File");
				//trayIcon.menu.addSubmenu(menu.getItemByName("Playback").submenu, "Playback");
				trayIcon.addEventListener(ScreenMouseEvent.MOUSE_UP, showWindow);
				stage.nativeWindow.visible = false;
			}
			else{
				trayIcon.bitmaps = [];
				stage.nativeWindow.visible = true;
			}
		}
		
		private function menuVolumeHandler(e:Event):void{
			playerCtrl.volBtn.setState(Number(toggleMenuItem(e.target as NativeMenuItem)));
		}
		
		private function menuShuffleHandler(e:Event):void{
			playerCtrl.shuffleBtn.setState(Number(toggleMenuItem(e.target as NativeMenuItem)));
		}
		
		private function setLoopListener(item:NativeMenuItem, index:int, array:Array){
			item.addEventListener(Event.SELECT, menuLoopHandler);
		}
		private function menuLoopHandler(e:Event):void{
			var loopItem:NativeMenuItem = e.target as NativeMenuItem;
			var loopMenu:NativeMenu = menu.getItemByName("Playback").submenu.getItemByName("Loop").submenu;
			playerCtrl.loopBtn.setState(loopMenu.getItemIndex(loopItem));
		}
		
		private function setSortListener(item:NativeMenuItem, index:int, array:Array){
			item.addEventListener(Event.SELECT, sortHandler);
		}
		private function sortHandler(e:Event):void{
			var sortItem:NativeMenuItem = e.target as NativeMenuItem;
			var sortMenu:NativeMenu = menu.getItemByName("Edit").submenu.getItemByName("Settings").submenu.getItemByName("Sort Playlist").submenu;
			menu.selectOnlyFrom(sortItem, sortMenu);
			playlistCtrl.orderBy(sortItem.name.toLowerCase());
		}
		
		private function setVisualisationListener(item:NativeMenuItem, index:int, array:Array){
			item.addEventListener(Event.SELECT, visualisationHandler);
		}
		private function visualisationHandler(e:Event):void{
			var visualisationItem:NativeMenuItem = e.target as NativeMenuItem;
			var visualisationMenu:NativeMenu = menu.getItemByName("Edit").submenu.getItemByName("Settings").submenu.getItemByName("Audio Visualisation").submenu;
			menu.selectOnlyFrom(visualisationItem, visualisationMenu);
			displayCtrl.setVisualisation(visualisationItem.name, "0");
			settings.settingsNamespace::initialDisplay.settingsNamespace::visualisation = visualisationItem.name;
			saveSettings();
		}
		
		private function setScaleListener(item:NativeMenuItem, index:int, array:Array){
			item.addEventListener(Event.SELECT, scaleHandler);
		}
		private function scaleHandler(e:Event):void{
			var scaleItem:NativeMenuItem = e.target as NativeMenuItem;
			var scaleMenu:NativeMenu = menu.getItemByName("Edit").submenu.getItemByName("Settings").submenu.getItemByName("Video Scale").submenu;
			menu.selectOnlyFrom(scaleItem, scaleMenu);
			displayCtrl.setScale(scaleItem.name);
			settings.settingsNamespace::initialDisplay.settingsNamespace::scale = scaleItem.name;
			saveSettings();
		}
		
		private function toggleMenuItem(item:NativeMenuItem):Boolean{
			if(item.checked){
				item.checked = false;
			}
			else{
				item.checked = true;
			}
			return item.checked;
		}
		
		private function saveSettings():void {
			try{
				var fileStream:FileStream = new FileStream();
				fileStream.open(settingsFile, FileMode.WRITE);
				fileStream.writeUTFBytes(settings.toXMLString());
				fileStream.close();
			}
			catch(e:Error){
				//trace("cannot save:",e);
			}
		}
		
		private function about(e:Event):void{
			var initOpt:NativeWindowInitOptions = new NativeWindowInitOptions();
			initOpt.maximizable = false;
			initOpt.minimizable = false;
			initOpt.resizable = false;
			if((aboutWin && aboutWin.closed) || aboutWin == null){
				aboutWin = null;
				aboutWin = new InfoWindow(initOpt, "About.xml", "Logo");
			}
			aboutWin.alwaysInFront = true;
			aboutWin.activate();
		}
		
		private function instruct(e:Event):void{
			var initOpt:NativeWindowInitOptions = new NativeWindowInitOptions();
			initOpt.maximizable = false;
			initOpt.minimizable = false;
			initOpt.resizable = false;
			if((helpWin && helpWin.closed) || helpWin == null){
				helpWin = null;
				helpWin = new InfoWindow(initOpt, "Instructions.xml", "Help");
			}
			helpWin.alwaysInFront = true;
			helpWin.activate();
		}
		
		private function exit(e:Event):void{
			stage.nativeWindow.removeEventListener(Event.CLOSE, exit, false);
			if(noticeWindow && !noticeWindow.closed) noticeWindow.close();
			noticeWindow = null;
			if(aboutWin && !aboutWin.closed) aboutWin.close();
			aboutWin = null;
			if(helpWin && !helpWin.closed) helpWin.close();
			helpWin = null;
			NativeApplication.nativeApplication.exit();
			//stage.nativeWindow.close();
		}
	}
}