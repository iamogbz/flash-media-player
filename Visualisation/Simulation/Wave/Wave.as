package Visualisation.Simulation.Wave{

	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.utils.ByteArray;
	import flash.media.Sound;
	import flash.media.SoundMixer;
	import flash.media.SoundChannel;
	import flash.net.URLRequest;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.display.Graphics;
	import flash.filters.GlowFilter;
	import Visualisation.Particle.Particle;
	import Visualisation.Particle.ParticleEvent;
	import Visualisation.Particle.ParticleTrail;
	import Visualisation.Simulation.Simulation;


	public class Wave extends Simulation{

		private var waves:Array;//main particles
		private var tracks:Array;//short memory array
		public var threshold:Number = 80;//reaction limit
		private var memSize:int = 20,iniWaves:int = 0, numWaves:int = 0,transSpd:int = 1.5;
		private var dd:Number = 5,dx:Number = 0,dy:Number = 0,ndx:Number = 0,ndy:Number = 0;

		public function Wave(_width:Number, _height:Number, type:String = "", numWaves:int = 2) {
			super(_width, _height, type);
			waves = new Array(new Array());
			tracks = new Array(new Array(new Array()));
			iniWaves = numWaves;
			while(this.numWaves < numWaves){
				createWave(Math.random());
			}
		}

		public override function step(ba:ByteArray):void {
			var num:Number = ba.readFloat()*100;
			if(num > threshold || num < -threshold){
				//createWave(num);
			}
			if(num < 0){num = -num;}
			for (var i:int = 0; i < numWaves; i++) {
				(waves[i][0] as Particle).setType(this.type);
				(waves[i][0] as Particle).setPhaseRate(num/memSize);
				//(waves[i][0][0] as Particle).setTranstionSpeed(transSpd - num/10);
				(waves[i][0] as Particle).step();
				if(type == WaveType.NEAR){
					if((waves[i][0] as Particle).y >= _height/2 + threshold){
						(waves[i][0] as Particle).setDisplacement([0, -dd]);
						(waves[i][0] as Particle).setPosition([0, _height/2 + threshold]);
					}
					if((waves[i][0] as Particle).y <= _height/2 - threshold){
						(waves[i][0] as Particle).setDisplacement([0, dd]);
						(waves[i][0] as Particle).setPosition([0, _height/2 - threshold]);
					}
				}
				(waves[i][0] as Particle).setPosition([0,(waves[i][0] as Particle).y]);
				
				if(num > threshold){
					var gf:GlowFilter = new GlowFilter((waves[i][0] as Particle).color, 1, 5, 5, 2, 10);
					//(waves[i][0] as Particle).filters = [gf];
				}
				else{
					(waves[i][0] as Particle).filters = [];
				}
				
				(waves[i][1] as ParticleTrail).graphics.clear();
				(waves[i][1] as ParticleTrail).graphics.beginFill((waves[i][0] as Particle).color,(waves[i][0] as Particle).alpha);
				(waves[i][1] as ParticleTrail).graphics.moveTo(_width, tracks[i][memSize-1][1]);
				(waves[i][1] as ParticleTrail).graphics.lineStyle((waves[i][0] as Particle).width,(waves[i][0] as Particle).color,(waves[i][0] as Particle).alpha);
				for (var k = memSize - 1; k > 0; k--) {
					tracks[i][k][0] = k*_width/memSize;
					var indx:int;
					indx = k - (memSize/k) * (i+1)/10;
					if(indx < 0)indx = 0;
					tracks[i][k][1] = tracks[i][indx][1];
					(waves[i][1] as ParticleTrail).graphics.lineTo(tracks[i][k][0], tracks[i][k][1]);
				}
				//tracks[i][0][0] = 0;
				//tracks[i][0][1] = mouseY;
				tracks[i][0][0] = (waves[i][0] as Particle).x;
				tracks[i][0][1] = (waves[i][0] as Particle).y;
				(waves[i][1] as ParticleTrail).graphics.lineTo(tracks[i][k][0], tracks[i][k][1]);
				(waves[i][1] as ParticleTrail).graphics.lineStyle();
				(waves[i][1] as ParticleTrail).graphics.lineTo(0, _height);
				(waves[i][1] as ParticleTrail).graphics.lineTo(_width, _height);
			}
		}
		
		public function createWave(num:Number):void{
			waves[numWaves] = [this.addChild(new Particle()),this.addChild(new ParticleTrail("add"))];
			waves[numWaves][0].x = 0;
			waves[numWaves][0].y = _height / 2;
			waves[numWaves][0].no = numWaves;
			waves[numWaves][0].alpha = 2/iniWaves;
			waves[numWaves][0].color = num*0xffffff;
			waves[numWaves][0].addEventListener(ParticleEvent.DESTROY, destroyWave);
			tracks[numWaves] = [];
			for (var j = 0; j < memSize; j++) {
				tracks[numWaves][j] = [j*_width/memSize,_height / 2];
			}
			numWaves++;
		}
		public function destroyWave(pe:ParticleEvent):void{
			this.pause();
			var p:Particle = pe.target as Particle;
			var idx:int = p.no;
			waves[idx][1].die();
			waves[idx][0].destroy();
			for (var j:int = idx + 1; j<numWaves; j++) {
				waves[j][0].no -= 1;
			}
			waves.splice(idx, 1);
			numWaves--;
			this.resume();
		}
		
		public override function setType(type:String):void{
			this.type = type;
		}
		public override function getType():String{
			return this.type
		}

	}

}