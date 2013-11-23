package Visualisation.Simulation.Burst {
	import flash.display.MovieClip;
	import flash.display.Graphics;
	import flash.utils.ByteArray;
	import flash.filters.GlowFilter;
	import flash.filters.DropShadowFilter;
	import Visualisation.Simulation.Simulation;
	import Visualisation.Particle.Particle;
	import Visualisation.Particle.ParticleEvent;
	import Visualisation.Particle.ParticleTrail;
	
	public class Burst extends Simulation{
		
		private var angleSpd:Number = .1,transSpd:int = 5, lifeSpan:int = 2, threshold:Number;
		private var dd:Number = 5,dx:Number = 0,dy:Number = 0,ndx:Number = 0,ndy:Number = 0;
		private var papers:Vector.<ParticleTrail> = new Vector.<ParticleTrail>();
		
		public function Burst(_width:Number, _height:Number, type:String = "", threshold:Number = 20) {
			super(_width, _height, type);
			this.threshold = threshold;
			this.resize();
		}
		
		public override function step(ba:ByteArray):void{
			var num:Number = ba.readFloat()*100;
			if(num > threshold || num < -threshold){
				if(type == BurstType.CLEAN || papers.length < 10)addParticle(num);
			}
			if(num < 0){num = -num;}
			for (var i:int = 0; i < papers.length; i++) {
				if(getChildAt(i) is Particle)
				{
					var ts:Number = transSpd;
					ts = transSpd * lifeSpan;
					(getChildAt(i) as Particle).setPhaseRate(num/ts);
					//(getChildAt(i) as Particle).setTranstionSpeed(transSpd - num/10);
					
					if(num > threshold){
						var gf:GlowFilter = new GlowFilter((getChildAt(i) as Particle).color, 1, 5, 5, 5, 10);
						//(getChildAt(i) as Particle).filters = [gf];
						//papers[i].filters = [gf];
					}
					else{
						(getChildAt(i) as Particle).filters = [];
						papers[i].filters = [];
					}
					//papers[i].graphics.lineStyle(3/*(getChildAt(i) as Particle).width*/,(getChildAt(i) as Particle).color,(getChildAt(i) as Particle).alpha);
					//papers[i].graphics.moveTo((getChildAt(i) as Particle).x, (getChildAt(i) as Particle).y);
					(getChildAt(i) as Particle).step();
					if(type == BurstType.DRAW){
						papers[i].auto = true;
						//papers[i].graphics.lineTo((getChildAt(i) as Particle).x, (getChildAt(i) as Particle).y);
					}
					else papers[i].auto = false;
					//papers[i].graphics.lineStyle();
				}
			}
		}
		
		protected override function resize():void{
			this.graphics.clear();
			this.graphics.beginFill(0x111111,1);
			this.graphics.drawCircle(_width/2,_height/2,dd);
			this.graphics.endFill();
		}
		
		public function setThreshold(threshold:Number):void{
			this(_width, _height, threshold);
		}
		public function getThreshold(threshold:Number):Number{
			return this.threshold;
		}
		
		public function addParticle(num:Number):void{
			var exp:Particle = new Particle(Math.random() * lifeSpan + lifeSpan, Math.random() * dd + dd, dd / 2, dd * 2, Math.random() * transSpd + transSpd, Math.random() * angleSpd + angleSpd);
			
			exp.color = num*0xffffff;
			/*exp.graphics.beginFill(exp.color);
			exp.graphics.drawCircle(0,0,dd/2);
			exp.graphics.endFill();
			exp.graphics.lineStyle(2, exp.color);
			exp.graphics.moveTo(0,0);
			//--exp.graphics.lineTo(0,5);
			exp.graphics.lineStyle();
			//--exp.setAuto(false);*/
			
			exp.drawShape();
			exp.blendMode = "add";
			exp.setPosition([_width/2, _height/2]);
			exp.addEventListener(ParticleEvent.DESTROY, removeParticle);
			this.addChildAt(exp, papers.length);
			papers.push(this.addChild(new ParticleTrail("add", .05, exp, (type == BurstType.DRAW))));
		}
		public function removeParticle(pe:ParticleEvent):void{
			var p:Particle = pe.target as Particle;
			var pn:int = this.getChildIndex(p);
			papers[pn].kill();
			papers.splice(pn,1);
			p.destroy();
		}
		
	}
	
}
