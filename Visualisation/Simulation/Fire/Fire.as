package Visualisation.Simulation.Fire {
	import Visualisation.Simulation.Simulation;
	import flash.utils.ByteArray;
	import flash.events.Event;
	import flash.display.Sprite;
	import flash.display.BlendMode;
	
	public class Fire extends Simulation{
		
		private const colorBase:Number = 0xffffff;
		private const colorDif:Number = 0x222222;
		private var fire:GigaFire;
		private var bg:Sprite;

		public function Fire(_width:Number, _height:Number) {
			super(_width, _height, type);
			fire = new GigaFire(_width/2, _height/2, _height/6, _height/2, false);
			fire.automate(true);
			fire.blendMode = BlendMode.ADD;
			this.addChild(fire);
		}
		
		public override function step(ba:ByteArray):void{
			var num:Number = 0, tempNum:Number;
			for(var i = 0; i < 1; i++){
				tempNum = ba.readFloat();
				if(tempNum > num || tempNum < num){
					num = tempNum;
				}
			}
			//fire.setColor([(num * colorBase),(num * colorBase)], GigaFire.ALPHAS, GigaFire.RATIOS);
			if(num < 0){
				num = -num;
			}
			else{
				
			}
			//fire.setRdm(num);
			fire.setPhaseRates([0,num*100]);
			//fire.step();
		}
		
		protected override function resize():void{
			trace("resize");
			fire.setSize([_height/6, _height/2]);
			fire.setPosition([_width/2, _height/2]);
		}
		
	}
	
}