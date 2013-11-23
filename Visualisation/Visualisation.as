package Visualisation{

	import flash.display.Sprite;
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
	import Visualisation.Simulation.Simulation;
	import Visualisation.Simulation.SimulationType;
	import Visualisation.Simulation.Bars.Bars;
	import Visualisation.Simulation.Bars.BarsType;
	import Visualisation.Simulation.Board.Board;
	import Visualisation.Simulation.Board.BoardType;
	import Visualisation.Simulation.Burst.Burst;
	import Visualisation.Simulation.Burst.BurstType;
	import Visualisation.Simulation.Fire.Fire;
	import Visualisation.Simulation.Trail.Trail;
	import Visualisation.Simulation.Trail.TrailType;
	import Visualisation.Simulation.Wave.Wave;
	import Visualisation.Simulation.Wave.WaveType;
	import Visualisation.Simulation.Art.Art;


	public class Visualisation extends Sprite {
		
		private var _width:Number, _height:Number, type:String, setting:String, simulation:Simulation;
		
		public function Visualisation(_width:Number = 0, _height:Number = 0, type:String = "art", setting:String = "0") {
			this._width = _width;
			this._height = _height;
			this.type = type;
			this.setting = setting;
			this.setSimulation(type, setting);
		}

		public function step(ba:ByteArray):void {
			//trace("step visualisation");
			if(!simulation.isPaused()){
				simulation.step(ba);
			}
		}
		
		public function setSimulation(type:String, setting:String = "0"){
			simulation = null;
			while(this.numChildren>0){
				this.removeChildAt(0);
			}
			if(type == SimulationType.ART){
				simulation = new Art(_width, _height, setting);
			}
			else if(type == SimulationType.BARS){
				simulation = new Bars(_width, _height, setting);
			}
			else if(type == SimulationType.BOARD){
				simulation = new Board(_width, _height, setting);
			}
			else if(type == SimulationType.BURST){
				simulation = new Burst(_width, _height, setting);
			}
			else if(type == SimulationType.FIRE){
				simulation = new Fire(_width, _height);
			}
			else if(type == SimulationType.TRAIL){
				simulation = new Trail(_width, _height, setting);
			}
			else if(type == SimulationType.WAVE){
				simulation = new Wave(_width, _height, setting,4);
			}
			if(simulation != null){
				//trace("simulation success");
				this.addChild(simulation);
			}
			else{
				//trace("simulation failure");
			}
		}
		
		public function setSize(_width:Number, _height:Number):void {
			this._width = _width;
			this._height = _height;
			/*if(){
				simulation.scaleX = this.getSize()[0]/simulation.getSize()[0];
				simulation.scaleY = simulation.scaleX;
				simulation.x = 0;
				simulation.y = (this.getSize()[1]-simulation.getSize()[1]*simulation.scaleY)/2;
				//setSimulation(type, setting);
			}
			else{*/
				simulation.setSize(_width, _height);
			//}
			this.graphics.clear()
			this.graphics.lineStyle(0, 0);
			this.graphics.beginFill(0x111111,.01);
			this.graphics.drawRect(0,0,_width,_height);
			this.graphics.endFill();
		}
		public function getSize():Array {
			return [this._width, this._height];
		}

	}

}