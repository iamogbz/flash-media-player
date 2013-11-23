package Visualisation.Simulation.Art {
	import Visualisation.Simulation.Simulation;
	import Visualisation.Particle.ParticleTrail;
	import flash.display.Sprite;
	import flash.utils.ByteArray;
	import flash.filters.GlowFilter;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;
	import flash.display.Shape;
	
	public class Art extends Simulation{
		
		private var padding:int;
		private var size:Number;
		private var color:uint = 0;
		private var bitmap:Bitmap;
		private var bitmapData:BitmapData;
		private var shape:Shape;
		
		public function Art(_width:Number, _height:Number, type:String, size:int = 100, padding:int = 2) {
			super(_width, _height, type);
			this.size = size;
			this.padding = padding;
			init();
		}
		
		public function init():void{
			bitmapData = new BitmapData(size, size);
			bitmap = new Bitmap(bitmapData);
			center(addChild(bitmap));
			shape = new Shape();
			addChild(shape);
		}
		
		public override function step(ba:ByteArray):void{
			var rect:Rectangle = new Rectangle(bitmap.x, bitmap.y, bitmap.width, bitmap.height);
			bitmap.bitmapData.setPixels(rect, ba);
			//bitmap = Bitmap(Default.getBitmapData(ba));
			center(bitmap);
			if(type == ArtType.REFLECTED){
				drawBackground();
			}
			shape.alpha = .05;
		}
		
		public function center(dObj:DisplayObject):void{
			dObj.x = (this._width - dObj.width)/2;
			dObj.y = (this._height - dObj.height)/2;
		}
		
		public function drawBackground():void{
			shape.graphics.clear();
			shape.graphics.beginBitmapFill(bitmap.bitmapData);
			shape.graphics.drawRect(bitmap.x, bitmap.y + bitmap.height + padding, bitmap.width, bitmap.height);
			shape.graphics.endFill();
		}
		
		protected override function resize():void{
			this._width = _width;
			this._height = _height;
			center(bitmap);
			shape.x = 0;
			shape.y = 0;
			drawBackground();
		}
	}
	
}