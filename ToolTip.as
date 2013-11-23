package  {
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.filters.DropShadowFilter;
	
	public class ToolTip extends Sprite{
		
		public static const TOP:String = new String("top");
		public static const BOTTOM:String = new String("bottom");
		public static const LEFT:String = new String("left");
		public static const RIGHT:String = new String("right");
		public static const TOP_LEFT:String = new String("top_left");
		public static const TOP_RIGHT:String = new String("top_right");
		public static const BOTTOM_LEFT:String = new String("bottom_left");
		public static const BOTTOM_RIGHT:String = new String("bottom_right");
		
		private var pointerHeight:Number;
		private var pointerSize:Number;
		private var pointer:Sprite;
		private var points:Array;
		private var degrees:Number;
		private var color:Number;
		private var info:String;
		public var cont:TextField;
		private var targetX:Number;
		private var targetY:Number;
		private var orientation:String;
		private var font:String;
		
		public function ToolTip(color:Number = 0, info:String = "", pointerSize:Number = 12, targetX:Number = 0, targetY:Number = 0, orientation:String = "bottom", font:String = "Arial") {
			this.color = color;
			this.info = info;
			this.pointerSize = pointerSize;
			init();
			this.targetX = targetX;
			this.targetY = targetY;
			this.font = font;
			setOrientation(orientation);
		}
		private function init():void{
			degrees = 60;
			var radians:Number = degrees * Math.PI/180;
			pointerHeight = Math.sin(radians) * pointerSize;
			points = new Array(new Array());
			points = [[-pointerSize/2, -pointerHeight],[pointerSize/2, -pointerHeight],[0,0]];
			pointer = new Sprite();
			initPointer();
			addChild(pointer);
			cont = new TextField();
			initCont();
			addChild(cont);
			filters = [new DropShadowFilter(2,45,0,.7,4,4,1,10)];
		}
		private function initPointer():void{
			pointer.graphics.clear();
			pointer.graphics.beginFill(color);
			pointer.graphics.moveTo(points[0][0], points[0][1]);
			for(var i:int = 1; i < points.length; i++){
				pointer.graphics.lineTo(points[i][0], points[i][1]);
			}
			pointer.graphics.lineTo(points[0][0], points[0][1]);
			pointer.graphics.endFill();
		}
		private function initCont():void{
			var textFormat:TextFormat = new TextFormat(this.font,pointerSize,0xffffff-color,true,false,false,null,null,"center");
			cont.autoSize = TextFieldAutoSize.LEFT;
			cont.width = 50;
			cont.background = true;
			cont.backgroundColor = color;
			cont.border = false;
			cont.borderColor = color;
			cont.defaultTextFormat = textFormat;
			cont.multiline = true;
			cont.selectable = false;
			cont.text = info;
			//drawBackground();
		}
		public function getFont():String{
			return this.font;
		}
		public function setFont(value:String):void{
			this.font = value;
			initCont();
		}
		private function drawBackground():void{
			this.graphics.clear();
			this.graphics.beginFill(color);
			this.graphics.drawRoundRect(cont.x, cont.y, cont.width, cont.height, pointerSize);
			this.graphics.endFill();
		}
		public function setOrientation(orientation:String = "bottom"){
			this.orientation = orientation;
			if(orientation == TOP){
				pointer.scaleX = 1;
				pointer.scaleY = -1;
				pointer.rotation = 0;
				cont.x = -cont.width/2;
				cont.y = pointerHeight/2;
			}
			else if(orientation == BOTTOM){
				pointer.scaleX = 1;
				pointer.scaleY = 1;
				pointer.rotation = 0;
				cont.x = -cont.width/2;
				cont.y = -(cont.height + pointerHeight/2);
			}
			else if(orientation == RIGHT){
				pointer.scaleX = 1;
				pointer.scaleY = -1;
				pointer.rotation = 90;
				cont.x = -(cont.width + pointerHeight/2);
				cont.y = -cont.height/2;
			}
			else if(orientation == LEFT){
				pointer.scaleX = 1;
				pointer.scaleY = 1;
				pointer.rotation = 90;
				cont.x = pointerHeight/2;
				cont.y = -cont.height/2;
			}
			else if(orientation == TOP_LEFT){
				pointer.scaleX = 1;
				pointer.scaleY = 1;
				pointer.rotation = 135;
				cont.x = pointerHeight/4;
				cont.y = pointerHeight/4;
			}
			else if(orientation == TOP_RIGHT){
				pointer.scaleX = 1;
				pointer.scaleY = 1;
				pointer.rotation = -135;
				cont.x = -(pointerHeight/4 + cont.width);
				cont.y = pointerHeight/4;
			}
			else if(orientation == BOTTOM_LEFT){
				pointer.scaleX = 1;
				pointer.scaleY = 1;
				pointer.rotation = 45;
				cont.x = pointerHeight/4;
				cont.y = -(pointerHeight/4 + cont.height);
			}
			else if(orientation == BOTTOM_RIGHT){
				pointer.scaleX = 1;
				pointer.scaleY = 1;
				pointer.rotation = -45;
				cont.x = -(pointerHeight/4 + cont.width);;
				cont.y = -(pointerHeight/4 + cont.height);
			}
			pointer.x = 0;
			pointer.y = 0;
			this.x = targetX;
			this.y = targetY;
		}
		public function setContInfo(info:String):void{
			this.info = info;
			initCont();
			if(cont.width < pointerSize){
				cont.autoSize = TextFieldAutoSize.NONE;
				cont.width = pointerSize;
			}
			setOrientation(orientation);
		}
		public function getTargetX():Number{
			return this.targetX;
		}
		public function setTargetX(targetX:Number):void{
			this.targetX = targetX;
			this.setOrientation(orientation);
		}
		public function getTargetY():Number{
			return this.targetY;
		}
		public function setTargetY(targetY:Number):void{
			this.targetY = targetY;
			this.setOrientation(orientation);
		}
	}
	
}