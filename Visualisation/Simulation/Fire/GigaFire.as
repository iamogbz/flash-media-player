package Visualisation.Simulation.Fire {
	import flash.display.BitmapData;
	import flash.display.GradientType;
	import flash.display.SpreadMethod;
	import flash.display.InterpolationMethod;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.DisplacementMapFilter;
	import flash.filters.DisplacementMapFilterMode;
	import flash.filters.DisplacementMapFilterMode;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class GigaFire extends Sprite {
		
		public static const X:int = 0;
		public static const Y:int = 1;
		public static const COLORS:Array = [0xFFCC00,0xE22D09,0xE22D09];
		public static const ALPHAS:Array = [1,1,0];
		public static const RATIOS:Array = [30,100,220];
		
		protected var phaseRateX:Number;
		protected var phaseRateY:Number;
		
		protected var matrix:Matrix = new Matrix();
		protected var offsets:Array= [new Point(),new Point()];
		protected var seed:Number = Math.random();
		protected var fireWidth:Number;
		protected var fireHeight:Number;

		protected var fireColerIn:uint = 0xFFCC00;
		protected var fireColerOut:uint = 0xE22D09;

		protected var ball:Sprite;
		protected var gradientImage:BitmapData;
		protected var displaceImage:BitmapData;

		protected var focalPointRatio:Number = 0.6;

		protected const margin:int = 10;
		protected var rdm:Number;

		public function GigaFire(x:Number=0, y:Number=0, fireWidth:Number=30, fireHeight:Number=90, auto:Boolean = true) {
			this.fireWidth = fireWidth;
			this.fireHeight = fireHeight;
			this.phaseRateX = 0;
			this.phaseRateY = 5;
			this.x = x;
			this.y = y;
			if(auto){
				this.addEventListener(Event.ENTER_FRAME,step);
			}
			
			matrix.createGradientBox(fireWidth,fireHeight,Math.PI/2,-fireWidth/2,-fireHeight*(focalPointRatio+1)/2);

			//var home:Sprite = new Sprite();
			ball = new Sprite();
			drawShape(COLORS, ALPHAS, RATIOS);
			addChild(ball);
			//addChild(home);
			
			//Bitmap
			displaceImage = new BitmapData(fireWidth + margin,fireHeight,false,0xFFFFFFFF);

			var matrix2:Matrix = new Matrix();
			matrix2.createGradientBox(fireWidth+margin,fireHeight,Math.PI/2,0,0);
			var gradient_mc:Sprite = new Sprite();
			gradient_mc.graphics.beginGradientFill(GradientType.LINEAR,[0x666666,0x666666], [0,1], [120,220], matrix2);
			gradient_mc.graphics.drawRect(0,0,fireWidth+margin,fireHeight);
			//draw;
			gradient_mc.graphics.endFill();
			gradientImage = new BitmapData(fireWidth + margin,fireHeight,true,0x00FFFFFF);
			gradientImage.draw(gradient_mc);
			//gradient_mc;
			
			rdm = Math.floor(Math.random() * 10);

			/*this.startDrag(true);
			import flash.display.Bitmap; 
			var bmp:Bitmap = new flash.display.Bitmap(displaceImage);
			bmp.x = -fireWidth/2;
			bmp.y = -fireHeight*(focalPointRatio+1)/2;
			home.addChild(bmp);
			bmp.alpha = 0.5;
			home.addChild(gradient_mc);*/
		}
		function drawShape(colors:Array, alphas:Array, ratios:Array):void{
			ball.graphics.clear();
			ball.graphics.beginGradientFill(GradientType.RADIAL,colors, alphas, ratios, matrix,SpreadMethod.PAD,InterpolationMethod.RGB,focalPointRatio);
			ball.graphics.drawEllipse(-fireWidth/2,-fireHeight*(focalPointRatio+1)/2,fireWidth,fireHeight);
			ball.graphics.endFill();

			ball.graphics.beginFill(0x000000,0);
			ball.graphics.drawRect(-fireWidth/2,0,fireWidth+margin,1);
			ball.graphics.endFill();
		}
		public function step(o:Object = null):void {			
			for (var i:int = 0; i < 2; ++i) {
				offsets[i].x +=  phaseRateX;
				offsets[i].y +=  phaseRateY;
			}

			displaceImage.perlinNoise(this.fireWidth+rdm, this.fireHeight+rdm, 2, seed, false, false, 7, true, offsets);

			displaceImage.copyPixels(gradientImage,gradientImage.rect,new Point(),null, null, true);
			var dMapFilt:DisplacementMapFilter = new DisplacementMapFilter(displaceImage, new Point(), 1, 1, 20, 10, DisplacementMapFilterMode.CLAMP);
			ball.filters = [dMapFilt];
		}
		public function automate(auto:Boolean = true):void{
			if(auto){
				this.addEventListener(Event.ENTER_FRAME,step);
			}
			else if(this.hasEventListener(Event.ENTER_FRAME)){
				this.removeEventListener(Event.ENTER_FRAME, step);
			}
		}
		public function setSize(dimensions:Array):void{
			this.fireWidth = dimensions[X];
			this.fireHeight = dimensions[Y];
			
			matrix.createGradientBox(fireWidth,fireHeight,Math.PI/2,-fireWidth/2,-fireHeight*(focalPointRatio+1)/2);

			//var home:Sprite = new Sprite();
			//ball = new Sprite();
			//drawShape(COLORS, ALPHAS, RATIOS);
			//addChild(ball);
			//addChild(home);
			
			//Bitmap
			displaceImage = new BitmapData(fireWidth + margin,fireHeight,false,0xFFFFFFFF);

			var matrix2:Matrix = new Matrix();
			matrix2.createGradientBox(fireWidth+margin,fireHeight,Math.PI/2,0,0);
			var gradient_mc:Sprite = new Sprite();
			gradient_mc.graphics.beginGradientFill(GradientType.LINEAR,[0x666666,0x666666], [0,1], [120,220], matrix2);
			gradient_mc.graphics.drawRect(0,0,fireWidth+margin,fireHeight);
			//draw;
			gradient_mc.graphics.endFill();
			gradientImage = new BitmapData(fireWidth + margin,fireHeight,true,0x00FFFFFF);
			gradientImage.draw(gradient_mc);
			//gradient_mc;
			
		}
		public function getSize():Array {
			return [this.fireWidth, this.fireHeight];
		}
		public function getPosition():Array {
			return [this.x, this.y];
		}
		public function setPosition(coordinates:Array):void {
			this.x = coordinates[X];
			this.y = coordinates[Y];
		}
		public function getRdm():Number{
			return this.rdm;
		}
		public function setRdm(rdm:Number):void{
			this.rdm = rdm;
		}
		public function getPhaseRates():Array {
			return [this.phaseRateX, this.phaseRateY];
		}
		public function setPhaseRates(phaseRate:Array):void {
			this.phaseRateX = phaseRate[X];
			this.phaseRateY = phaseRate[Y];
		}
		public function getColor():Array{
			return [this.fireColerIn, this.fireColerOut];
		}
		public function setColor(colors:Array, alphas:Array, ratios:Array):void{
			this.fireColerIn = colors[0];
			this.fireColerOut = colors[1];
			drawShape([this.fireColerIn,this.fireColerOut,this.fireColerOut], ALPHAS, RATIOS);
		}
	}
}
//DisplacementMapFilter