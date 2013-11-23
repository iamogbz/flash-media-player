package Visualisation.Simulation {
	import flash.display.Sprite;
	import flash.utils.ByteArray;
	import flash.events.Event;
	
	public class Simulation extends Sprite{
		
		protected var _width:Number,_height:Number, type:String, paused:Boolean;
		
		public function Simulation(_width:Number, _height:Number, type:String){
			this._width = _width;
			this._height = _height;
			this.type = type;
			this.paused = false;
		}
		
		public function step(ba:ByteArray):void{}

		public function setSize(_width:Number, _height:Number):void {
			this.x = 0;
			this.y = 0;
			this.scaleX = 1;
			this.scaleY = 1;
			this._width = _width;
			this._height = _height;
			resize();
		}
		public function getSize():Array {
			return [this._width, this._height];
		}
		protected function resize():void{}
		
		public function setType(type:String):void{
			this.type = type;
		}
		public function getType():String{
			return this.type
		}
		
		public function pause():void{
			this.paused = true;
		}
		public function isPaused():Boolean{
			return this.paused;
		}
		public function resume():void{
			this.paused = false;
		}
	}
	
}
