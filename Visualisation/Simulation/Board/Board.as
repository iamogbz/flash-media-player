package Visualisation.Simulation.Board{
	import Visualisation.Simulation.Simulation;
	import flash.display.Sprite;
	import flash.utils.ByteArray;

	public class Board extends Simulation {

		private var num:Number,numFloat:int;
		private var color:uint = 0xffffff;

		public function Board(_width:Number, _height:Number, type:String) {
			super(_width, _height, type);
			this.numFloat = 256;
		}

		public override function step(ba:ByteArray):void {
			graphics.clear();
			graphics.moveTo(0, ba.readFloat() * 100 + _height / 2);
			if (type == BoardType.FILL) {
				graphics.beginFill(color);
			}
			for (var i:uint=0; i<=numFloat; i++) {
				num = ba.readFloat();
				graphics.lineStyle(2,num*color);
				graphics.lineTo(_width*i/(numFloat-2), num * 100 + _height / 2);
				graphics.lineStyle();
			}
			graphics.lineTo(_width, _height);
			graphics.lineTo(0, _height);
		}

	}

}