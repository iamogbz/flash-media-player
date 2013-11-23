package Visualisation.Simulation.Trail{

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
	import Visualisation.Particle.Particle;
	import Visualisation.Particle.ParticleEvent;
	import Visualisation.Simulation.Simulation;
	import flash.filters.GlowFilter;
	import Visualisation.Particle.ParticleTrail;


	public class Trail extends Simulation{

		private var anchors:Array;//main particles
		private var trails:Array;//particle array
		private var tracks:Array;//short memory array
		private var threshold:Number = 80;//reaction limit
		private var angleSpd:Number = .1,memSize:int = 40,numTrails:int = 0,numPoints:int = 20 ,numAnchors:int = 0,transSpd:int = 5;
		private var dd:Number = 5,dx:Number = 0,dy:Number = 0,ndx:Number = 0,ndy:Number = 0;

		public function Trail(_width:Number, _height:Number, type:String = "", numTrails:int = 2) {
			super(_width, _height, type);
			anchors = new Array();
			trails = new Array(new Array(new Array()));
			tracks = new Array(new Array(new Array()));
			while(this.numTrails < numTrails){
				createTrail();
			}
		}

		public override function step(ba:ByteArray):void {
			var num:Number = ba.readFloat()*100;
			if(num > threshold || num < -threshold){
				//createTrail();
			}
			if(num < 0){num = -num;}
			for (var i:int = 0; i < numTrails; i++) {
				(trails[i][0][0] as Particle).setType(this.type);
				(trails[i][0][0] as Particle).setPhaseRate(num/(transSpd*2));
				//(trails[i][0][0] as Particle).setTranstionSpeed(transSpd - num/10);
				
				//(trails[i][0][5] as ParticleTrail).graphics.lineStyle((trails[i][0][0] as Particle).width,(trails[i][0][0] as Particle).color);
				//(trails[i][0][5] as ParticleTrail).graphics.moveTo((trails[i][0][0] as Particle).x, (trails[i][0][0] as Particle).y);
				(trails[i][0][0] as Particle).step();
				//(trails[i][0][5] as ParticleTrail).graphics.lineTo((trails[i][0][0] as Particle).x, (trails[i][0][0] as Particle).y);
				//(trails[i][0][5] as ParticleTrail).graphics.lineStyle();
				
				for (var j:int = 1; j < numPoints; j++) {
					if(num > threshold){
						var gf:GlowFilter = new GlowFilter((trails[i][j][0] as Particle).color, 1, 5, 5, 2, 10);
						//(trails[i][j][0] as Particle).filters = [gf];
					}
					else{
						(trails[i][j][0] as Particle).filters = [];
					}
					(trails[i][j][0] as Particle).setType(this.type);
					(trails[i][j][0] as Particle).setPhaseRate(num/(transSpd*2));
					//(trails[i][j][0] as Particle).setTranstionSpeed(transSpd - num/10);
					
					//(trails[i][j][5] as ParticleTrail).graphics.lineStyle((trails[i][j][0] as Particle).width,(trails[i][j][0] as Particle).color,(trails[i][j][0] as Particle).alpha);
					//(trails[i][j][5] as ParticleTrail).graphics.moveTo((trails[i][j][0] as Particle).x, (trails[i][j][0] as Particle).y);
					(trails[i][j][0] as Particle).step(tracks[i]);
					//(trails[i][j][5] as ParticleTrail).graphics.lineTo((trails[i][j][0] as Particle).x, (trails[i][j][0] as Particle).y);
					//(trails[i][j][5] as ParticleTrail).graphics.lineStyle();
				}
				for (var k = memSize - 1; k > 0; k--) {
					tracks[i][k][0] = tracks[i][k - 1][0];
					tracks[i][k][1] = tracks[i][k - 1][1];
					tracks[i][k][2] = tracks[i][k - 1][2];
					tracks[i][k][3] = tracks[i][k - 1][3];
				}
				//tracks[i][0][0] = mouseX;
				//tracks[i][0][1] = mouseY;
				tracks[i][0][0] = (trails[i][0][0] as Particle).x;
				tracks[i][0][1] = (trails[i][0][0] as Particle).y;
				tracks[i][0][2] = (trails[i][0][0] as Particle).getDisplacement()[Visualisation.Particle.Particle.X];
				tracks[i][0][3] = (trails[i][0][0] as Particle).getDisplacement()[Visualisation.Particle.Particle.Y];
			}
		}

		private function newParticle(color:uint, w:Number, h:Number = 0, life:int = 0):Particle {
			var exp:Particle = new Particle(life,Math.random() * dd + dd, dd/2, dd*2, Math.random() * transSpd + transSpd, Math.random() * angleSpd + angleSpd);
			if (h == 0) {
				h = w;
			}
			exp.color = color;
			exp.graphics.clear();
			exp.graphics.beginFill(color);
			exp.graphics.drawEllipse(-w/2, -h/2, w, h);
			exp.graphics.endFill();
			exp.blendMode = "add";
			return exp;
		}
		public function createAnchor(obj:Object):Boolean{
			if(obj is Particle){
				obj.no = numTrails;
				//obj.setAuto(false);
				//obj.graphics.clear();
				obj.setPosition([this._width/2, this._height/2]);
				//obj.addEventListener(ParticleEvent.DESTROY, destroyTrail);
				if(this.type == TrailType.THREAD){
					//(obj as Particle).graphics.clear();
					(obj as Particle).drawShape()
				}
				return true;
			}
			return false;
		}
		public function createTrail():void{
			trails[numTrails] = [];
			for (var i:int = 0; i<numPoints; i++) {
				trails[numTrails][i] = [newParticle(Math.random() * 0xffffff,0),dx,dy,ndx,ndy];
				trails[numTrails][i].push(this.addChild(new ParticleTrail("add", .1, trails[numTrails][i][0], true)));
				trails[numTrails][i][0].setMemoryIndex(i*memSize/numPoints);
				trails[numTrails][i][0].x = _width / 2;
				trails[numTrails][i][0].y = _height / 2;
				//--------------
				//(trails[numTrails][i][0] as Particle).drawShape(2);
				//--------------
				addChildAt(trails[numTrails][i][0], 0);
			}
			trails[numTrails][0][5].visible = false;
			anchors[numTrails] = trails[numTrails][0][0];
			createAnchor(anchors[numTrails]);
			tracks[numTrails] = [];
			for (var j = 0; j < memSize; j++) {
				tracks[numTrails][j] = [_width / 2,_height / 2,0,0];
			}
			numTrails++;
		}
		public function destroyTrail(pe:ParticleEvent):void{
			this.pause();
			var p:Particle = pe.target as Particle;
			var idx:int = p.no;
			for (var i:int = 0; i<numPoints; i++) {
				trails[idx][i][5].die();
				trails[idx][i][0].destroy();
			}
			for (var j:int = idx + 1; j<numTrails; j++) {
				trails[j][0][0].no -= 1;
			}
			trails.splice(idx, 1);
			numTrails--;
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