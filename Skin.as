package  {
	
	import flash.display.Sprite;
	import flash.display.Loader;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.net.URLRequest;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	
	
	public class Skin extends Sprite {
		
		private var fill:BitmapData;
		
		public function Skin() {
			loadSkin("Skin");
		}
		
		private function loadSkin(url:String):void{
			var loader:Loader = new Loader();
			loader.load(new URLRequest(url));
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, skinLoaded);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, loadDefaultSkin);
		}
		
		private function loadDefaultSkin(ioee:IOErrorEvent):void{
			//trace("skin not found");
		}
		
		private function skinLoaded(e:Event):void{
			//trace("skin loaded");
			this.fill = Bitmap(e.target.content).bitmapData;
			this.dispatchEvent(new CustomEvent(CustomEvent.LOADED, this.fill));
		}
	}
	
}
