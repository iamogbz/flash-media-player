package Visualisation.Particle {
	import flash.display.Shape;
	import flash.events.Event;
	
	public class ParticleTrail extends Shape{
		
		public var deathRate:Number;
		private var _particle:Particle, _auto:Boolean, memSize:int, mem:Array;
		
		public function ParticleTrail(blendMode:String = "normal", deathRate:Number = .1, particle:Particle = null, auto:Boolean =  false, memSize:int = 20) {
			this.blendMode = blendMode;
			this.deathRate = deathRate;
			this._particle = particle;
			this._auto = auto;
			this.memSize = memSize;
			this.mem = [];
			for(var i:int = 1; i < memSize; i++){
				//this.mem.push({x:particle.x, y:particle.y, width:particle.width, height:particle.height});
			}
			if(this._particle && this._auto){
				this.addEventListener(Event.ENTER_FRAME, drawTrail);
			}
		}
		
		private function drawTrail(e:Event = null):void{
			mem.push({x:particle.x, y:particle.y, width:particle.width, height:particle.height});
			this.graphics.clear();
			//if(mem.length > 0){
				this.graphics.lineStyle(mem[0].width, particle.color);
				this.graphics.moveTo(mem[0].x ,mem[0].y);
			//}
			for(var i:int = 1; i < mem.length; i++){
				this.graphics.lineStyle(mem[i].width * i/mem.length, particle.color, i/mem.length);
				this.graphics.lineTo(mem[i].x, mem[i].y);
			}
			if(mem.length > memSize)mem.shift();
		}
		
		public function kill():void{
			this.addEventListener(Event.ENTER_FRAME, fade);
		}
		private function fade(e:Event):void{
			this.alpha -= .1;
			if(this.alpha <= 0){
				this.graphics.clear();
				this.removeEventListener(Event.ENTER_FRAME, fade);
				parent.removeChild(this);
			}
		}
		public function save(alpha:Number = 1):void{
			this.removeEventListener(Event.ENTER_FRAME, fade);
			this.alpha = alpha;
		}
		
		public function get auto():Boolean{
			return this._auto;
		}
		public function set auto(value:Boolean):void{
			this._auto = auto;
			if((!this._auto || !this._particle) && this.hasEventListener(Event.ENTER_FRAME)) this.removeEventListener(Event.ENTER_FRAME, drawTrail);
			else if(this._auto && this._particle) this.addEventListener(Event.ENTER_FRAME, drawTrail);
		}
		public function get particle():Particle{
			return this._particle;
		}
		public function set particle(value:Particle):void{
			this._particle = particle;
			if((!this._auto  || !this._particle) && this.hasEventListener(Event.ENTER_FRAME)) this.removeEventListener(Event.ENTER_FRAME, drawTrail);
			else if(this._auto && this._particle) this.addEventListener(Event.ENTER_FRAME, drawTrail);
		}
		
	}
	
}
