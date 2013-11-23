package Visualisation.Simulation.Bars {
	import Visualisation.Simulation.Simulation;
	import Visualisation.Particle.ParticleTrail;
	import flash.display.Sprite;
	import flash.utils.ByteArray;
	import flash.filters.GlowFilter;
	
	public class Bars extends Simulation{
		
		private var board:Array;
		private var padding:int;
		private var size:Number;
		private var pt:ParticleTrail;
		private var numW:int, numH:int, numFloat:int;
		private var color:uint = 0;
		
		public function Bars(_width:Number, _height:Number, type:String, padding:int = 2, numW:int = 64) {
			super(_width, _height, type);
			this.padding = padding;
			this.numFloat = 512;
			this.numW = numW;
			init();
		}
		
		public function init():void{
			board = new Array(new Array());
			pt = new ParticleTrail();
			this.addChild(pt);
			this.resize();
		}
		
		public override function step(ba:ByteArray):void{
			var amp:Number, pos:Number, higher:int, lower:int;
			pt.graphics.clear();
			for(var i:int = 0; i < numW; i++){
				amp = ba.readFloat();
				pos = Math.round(numH/2 + (amp * 10));
				if(pos > numH/2){
					higher = pos;
					lower = numH/2;
				}
				else{
					higher = numH/2;
					lower = pos;
				}
				var cc:Number = amp * 0xffffff;
				for(var j:int = 0; j < numH; j++){
					var dx:Number = i*size;
					var dy:Number = j*size;
					if(j >= lower && j < higher){
						this.draw({x:dx, y:dy}, cc);
					}
					else{
						//this.draw({x:dx, y:dy}, color);
					}
				}
			}
		}
		
		public function draw(o:Object, color:uint):void{
			pt.graphics.beginFill(color);
			var pdn:Number = padding / scaleX;
			if(type == BarsType.CIRCLE){
				pt.graphics.drawEllipse(o.x + pdn/2,o.y + pdn/2,size - pdn,size - pdn);
			}
			else if(type == BarsType.SQUARE){
				pt.graphics.drawRect(o.x + pdn/2,o.y + pdn/2,size - pdn,size - pdn);
			}
			pt.graphics.endFill();
		}
		
		protected override function resize():void{
			this.size = _width/numW;
			this.numH = _height/size;
		}

	}
	
}