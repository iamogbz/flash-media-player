package Visualisation.Particle{
	import flash.display.Sprite;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import Visualisation.Simulation.Trail.TrailType;
	import Visualisation.Simulation.Simulation;
	import whirlpower.uniqueshape.DrawingShape;
	import whirlpower.uniqueshape.data.ShapeSouce;
	import whirlpower.uniqueshape.items.primitive.SixStar;

	public class Particle extends Sprite {

		public static const X:int = 0;
		public static const Y:int = 1;
		public var no:int;
		public var color:Number;
		public var iniDD:Number;
		protected var dd:Number,dx:Number,dy:Number,ndx:Number,ndy:Number;
		protected var newPhaseRate:Number, phaseRate:Number;//controls spd of particle
		protected var angle:Number,angleSpd:Number, iniAngleSpd:Number;
		public var iniTransSpd:Number;//transition speed(smaller is faster)
		protected var transSpd:Number;//transition speed(smaller is faster)
		protected var defScale:Number;//default scale
		protected var newScale:Number;//new scale
		protected var scale:Number;//current scale
		protected var defRadius:Number;//default radius
		protected var newRadius:Number;//new radius
		protected var radius:Number;//current radius
		protected var memIdx:int;//location in the memory block
		protected var type:String;//type of movement
		protected var auto:Boolean;//particle automation
		protected var lifeSpan:int;//how long the particle lives(in seconds) before dieing(0 means immortal)
		protected var ager:Timer;//timer to control aging;

		public function Particle(lifeSpan:int = 0, defaultDisplacement:Number = 5, defaultScale:Number = 2, defaultRadius:Number = 10, transitionSpeed:Number = 1.5, angularSpeed:Number = .1, type:String = "thread", auto:Boolean = true) {
			this.lifeSpan = lifeSpan;
			ager = new Timer(1000, lifeSpan);
			ager.start();
			ager.addEventListener(TimerEvent.TIMER_COMPLETE, die);
			this.iniDD = defaultDisplacement;
			this.dd = defaultDisplacement;
			this.ndx = 0;
			this.ndy = 0;
			this.dx = 0;
			this.dy = 0;
			this.defScale = defaultScale;
			this.newScale = Math.random()*defaultScale;
			this.scale = 1;
			this.defRadius = defaultRadius;
			this.newRadius = defaultRadius;
			this.radius = defaultRadius;
			this.iniTransSpd = transitionSpeed;
			this.transSpd = transitionSpeed;
			this.iniAngleSpd = angularSpeed;
			this.angleSpd = angularSpeed;
			this.angle = 0;
			this.type = type;
			this.auto = auto;
			this.color = 0xffffff;
			this.phaseRate = 0;
			this.newPhaseRate = 1;
			this.memIdx = -1;
		}

		public function step(track:Array = null):void {
			//var world:Simulation = this.parent as Simulation;
			var world = this.parent;
			phaseRate += (newPhaseRate - phaseRate)/transSpd;//interpolates phaseRate
			if (track != null) {
				if (Math.round(radius) == Math.round(newRadius)) {
					newRadius = Math.random() * defRadius;
				}
				radius += (newRadius - radius)/transSpd;
				angle +=  angleSpd*phaseRate;

				if (type == TrailType.ROTATE) {
					this.x = Math.cos(angle) * radius + track[memIdx][0];
					this.y = Math.sin(angle) * radius + track[memIdx][1];
				}
				if (type == TrailType.SAG) {
					this.x += (track[memIdx][0] - this.x)/transSpd;
					this.y += (track[memIdx][1] - this.y)/transSpd;
				}
				if (type == TrailType.THREAD) {
					this.x = track[memIdx][0];
					this.y = track[memIdx][1];
				}
				dx = track[memIdx][2];
				dy = track[memIdx][3];
			}
			else {
				if(auto){
					this.interpolate();
				}

				if (x + dx*phaseRate < 0) {
					ndx = dd;
				}
				else if (x + dx*phaseRate > world.getSize()[X]) {
					ndx = -dd;
				}
				else{
					x += dx*phaseRate;//dx
				}
				if (y + dy*phaseRate < 0) {
					ndy = dd;
				}
				else if (y + dy*phaseRate > world.getSize()[Y]) {
					ndy = -dd;
				}
				else{
					y += dy*phaseRate;//dy
				}
				
				if (x > world.getSize()[X]) {
					x = 0;
				}
				else if (x < 0) {
					x = world.getSize()[X];
				}
				if (y > world.getSize()[Y]) {
					y = 0;
				}
				else if (y < 0) {
					y = world.getSize()[Y];
				}
			}
			extra();
		}
		
		public function die(te:TimerEvent = null):void{
			this.dispatchEvent(new ParticleEvent(ParticleEvent.DESTROY));
			ager.stop();
			ager.removeEventListener(TimerEvent.TIMER_COMPLETE, die);
			if(!this.hasEventListener(ParticleEvent.DESTROY)){
				destroy();
			}
		}
		public function destroy(){
			parent.removeChild(this);
		}
		
		public function extra():void {
			if (Math.round(scale) == Math.round(newScale)) {
				newScale = Math.random() * defScale;
			}
			scale += (newScale - scale)/transSpd;
			this.scaleX = scale;
			this.scaleY = scale;
					
			var radians:Number = Math.atan2(dy, dx);// Calculates the angle in radians
			var degrees:Number = Math.round((radians*180/Math.PI));
			this.rotation = degrees+90;
		}
		
		public function interpolate():void{
			
			if (Math.round(dx) == Math.round(ndx)) {
				ndx = Math.random() * dd;
				if (Math.random() * 10 > 5) {
					ndx =  -  ndx;
				}
			}
			if (Math.round(dy) == Math.round(ndy)) {//newdy
				ndy = Math.random() * dd;
				if (Math.random() * 10 > 5) {
					ndy =  -  ndy;
				}
			}

			dx += (ndx - dx)/transSpd;//interpolates dx
			dy += (ndy - dy)/transSpd;//interpolates dy
		}

		public function setAuto(auto:Boolean):void {
			this.auto = auto;
		}
		public function getAuto():Boolean {
			return this.auto;
		}
		
		public function setPhaseRate(phaseRate:Number):void {
			this.newPhaseRate = phaseRate;
		}
		public function getPhaseRate():Number {
			return this.phaseRate;
		}

		public function setPosition(coordinates:Array):void {
			this.x = coordinates[X];
			this.y = coordinates[Y];
		}
		public function getPosition():Array {
			return [this.x, this.y];
		}

		public function setDefaultDisplacement(defaultDisplacement:Number):void {
			this.dd = defaultDisplacement;
		}
		public function getDefaultDisplacement():Number {
			return this.dd;
		}

		public function setDisplacement(displacement:Array):void {
			this.ndx = displacement[X];
			this.ndy = displacement[Y];
		}
		public function getDisplacement():Array {
			return [this.dx, this.dy];
		}

		public function setAngle(angle:Number):void {
			this.angle = angle;
		}
		public function getAngle():Number {
			return this.angle;
		}

		public function setAngleSpeed(angleSpeed:Number):void {
			this.angleSpd = angleSpeed;
		}
		public function getAngleSpeed():Number {
			return this.angleSpd;
		}

		public function setDefaultScale(defaultScale:Number):void {
			this.defScale = defaultScale;
		}
		public function getDefaultScale():Number {
			return this.defScale;
		}

		public function setDefaultRadius(defaultRadius:Number):void {
			this.defRadius = defaultRadius;
		}
		public function getDefaultRadius():Number {
			return this.defRadius;
		}

		public function setTranstionSpeed(transitionSpeed:Number):void {
			this.transSpd = transitionSpeed;
		}
		public function getTranstionSpeed():Number {
			return this.transSpd;
		}

		public function setScale(scale:Number):void {
			this.newScale = scale;
		}
		public function getScale():Number {
			return this.scale;
		}

		public function setType(type:String):void {
			this.type = type;
		}
		public function getType():String {
			return this.type;
		}

		public function setMemoryIndex(memoryIndex:int):void {
			this.memIdx = memoryIndex;
		}
		public function getMemoryIndex():int {
			return this.memIdx;
		}
		
		public function drawCircle(radius:Number = 0, color:Number = -1):void{
			this.color = (color < 0)?this.color : color ;
			this.defRadius = (radius <= 0)?this.defRadius : radius ;
			trace(this.defRadius);
			this.graphics.beginFill(this.color, this.alpha);
			this.graphics.drawCircle(0,0,this.defRadius/2);
			this.graphics.endFill();
		}
		public function drawSquare(radius:Number = 0, color:Number = -1):void{
			this.color = (color < 0)?this.color : color ;
			this.defRadius = (radius <= 0)?this.defRadius : radius ;
			trace(this.defRadius);
			this.graphics.beginFill(this.color, this.alpha);
			this.graphics.drawRect(-this.defRadius/2,-this.defRadius/2,this.defRadius,this.defRadius);
			this.graphics.endFill();
		}
		public function drawShape(radius:Number = 0, color:Number = -1):void{
			this.graphics.clear();
			this.color = (color < 0)?this.color : color ;
			this.defRadius = (radius <= 0)?this.defRadius : radius ;
			trace(this.defRadius);
			//var shape:DrawingShape = new DrawingShape(new SixStar());
			//addChild(shape);
			if(Math.random()*10 > 5) {
				drawCircle();
			}
			else {
				drawSquare();
			}
		}
		
	}

}