package Player {
	
	import flash.display.MovieClip;
	import fl.transitions.Tween;
	import fl.transitions.easing.*;
	import flash.events.MouseEvent;
	import Media.MediaFile;
	import flash.display.BitmapData;
	import flash.filters.DropShadowFilter;
	
	public class PlayerControl extends MovieClip {
		
		public static const HEIGHT:int = new int(80);
		
		private var _width:Number;
		private var _height:Number;
		private var color:uint, padding:int;
		private var autoFade:Boolean;
		private var tooltip:ToolTip;
		private var tweenFade:Tween;
		private var tweenSpd:int = new int(4);
		
		public function PlayerControl(_width:Number) {
			init();
			initListeners();
			setWidth(_width);
		}
		public function init():void{
			color = 0x101010;
			padding = 5;
			autoFade = false;
			prevBtn.setAsPrev();
			nxtBtn.setAsNxt();
			volBtn.init();
			tooltip = new ToolTip(0xffffff);
			//tooltip.setFont("Segoe UI Regular");
			this.addChild(tooltip);
			tooltip.visible = false;
			this.filters = [new DropShadowFilter(0,0,0,1,2,2,1,10)];
		}
		public function initListeners():void{
			seekCtrl.addEventListener(MouseEvent.MOUSE_MOVE, seekToolTip);
			loopBtn.addEventListener(MouseEvent.MOUSE_MOVE, showToolTip);
			shuffleBtn.addEventListener(MouseEvent.MOUSE_MOVE, showToolTip);
			prevBtn.addEventListener(MouseEvent.MOUSE_MOVE, showToolTip);
			stopBtn.addEventListener(MouseEvent.MOUSE_MOVE, showToolTip);
			ppBtn.addEventListener(MouseEvent.MOUSE_MOVE, showToolTip);
			nxtBtn.addEventListener(MouseEvent.MOUSE_MOVE, showToolTip);
			fullScrnBtn.addEventListener(MouseEvent.MOUSE_MOVE, showToolTip);
			volBtn.addEventListener(MouseEvent.MOUSE_MOVE, showToolTip);
			volCtrl.addEventListener(MouseEvent.MOUSE_MOVE, volToolTip);
			this.addEventListener(MouseEvent.MOUSE_WHEEL, volCtrl.scroll);
		}
		private function seekToolTip(me:MouseEvent):void{
			var soundPosition:Number = seekCtrl.getPosition(seekCtrl.mouseX);
			var timePosition:String = MediaFile.normaliseLength(soundPosition);
			tooltip.setOrientation(ToolTip.BOTTOM);
			tooltip.setContInfo(timePosition);
			tooltip.setTargetX(mouseX);
			tooltip.setTargetY(seekCtrl.y);
			tooltip.visible = true;
			testToolTip(tooltip);
			seekCtrl.addEventListener(MouseEvent.MOUSE_OUT, hideToolTip);
		}
		private function showToolTip(me:MouseEvent):void{
			tooltip.setOrientation(ToolTip.BOTTOM);
			var contInfo:String = "?";
			if(me.target.getState != null){
				contInfo = me.target.getState();
			}
			else if(me.currentTarget.getState != null){
				contInfo = me.currentTarget.getState();
			}
			tooltip.setContInfo(contInfo);
			tooltip.setTargetX(mouseX);
			tooltip.setTargetY(mouseY - padding);
			tooltip.visible = true;
			testToolTip(tooltip);
			me.target.addEventListener(MouseEvent.MOUSE_OUT, hideToolTip);
		}
		private function volToolTip(me:MouseEvent):void{
			var volPosition:int = volCtrl.getVolume(volCtrl.mouseX);
			tooltip.setOrientation(ToolTip.BOTTOM);
			tooltip.setContInfo(volPosition.toString());
			tooltip.setTargetX(mouseX);
			tooltip.setTargetY(volCtrl.y - padding);
			tooltip.visible = true;
			testToolTip(tooltip);
			volCtrl.addEventListener(MouseEvent.MOUSE_OUT, hideToolTip);
		}
		private function hideToolTip(me:MouseEvent):void{
			tooltip.visible = false;
		}
		private function testToolTip(tooltip:ToolTip):void{
			if(stage.nativeWindow.height < 160){
				tooltip.setTargetY(tooltip.getTargetY() + padding*2);
				if(tooltip.x + tooltip.width/2 > _width/2){
					tooltip.setOrientation(ToolTip.TOP_RIGHT);
				}
				else if(tooltip.x - tooltip.width/2 < -_width/2){
					tooltip.setOrientation(ToolTip.TOP_LEFT);
				}
				else{
					tooltip.setOrientation(ToolTip.TOP);
				}
			}
			else if(tooltip.x + tooltip.width/2 > _width/2){
				tooltip.setOrientation(ToolTip.BOTTOM_RIGHT);
			}
			else if(tooltip.x - tooltip.width/2 < -_width/2){
				tooltip.setOrientation(ToolTip.BOTTOM_LEFT);
			}
			else{
				tooltip.setOrientation(ToolTip.BOTTOM);
			}
		}
		public function getHeight():Number{
			return this._height;
		}
		public function getWidth():Number{
			return this._width;
		}
		public function setWidth(_width:Number):void{
			this._width = _width;
			this._height = HEIGHT;
			seekCtrl.setWidth(_width);
			this.getSkin();
		}
		public function setOrientation():void{
			this.x = _width/2;
			this.y = stage.stageHeight - _height/2 + padding;
			seekCtrl.setOrientation();
			fullScrnBtn.x = _width/2 - fullScrnBtn.width*1.5;
		}
		private function getSkin():void{
			var skin:Skin = new Skin();
			skin.addEventListener(CustomEvent.LOADED, drawBackground);
		}
		private function drawBackground(ce:CustomEvent):void{
			this.graphics.clear();
			//this.graphics.beginFill(color, .5);
			this.graphics.beginBitmapFill(ce.getSecondaryTarget() as BitmapData);
			this.graphics.drawRect(-_width/2, -_height/2 - padding, _width, _height);
			this.graphics.endFill();
		}
		public function getAutoFade():Boolean{
			return this.autoFade;
		}
		public function setAutoFade(autoFade:Boolean):void{
			if(autoFade && !this.autoFade){
				this.addEventListener(MouseEvent.MOUSE_OVER, fadeIn);
				this.addEventListener(MouseEvent.MOUSE_OUT, fadeOut);
			}
			else if(!autoFade && this.autoFade){
				this.removeEventListener(MouseEvent.MOUSE_OVER, fadeIn);
				this.removeEventListener(MouseEvent.MOUSE_OUT, fadeOut);
			}
			this.autoFade = autoFade;
			this.alpha = Number(!autoFade);
		}
		private function fadeIn(me:MouseEvent):void{
			tweenFade = new Tween(this, "alpha", Strong.easeOut, this.alpha, 1, tweenSpd, false);
		}
		private function fadeOut(me:MouseEvent):void{
			tweenFade = new Tween(this, "alpha", Strong.easeOut, this.alpha, .01, tweenSpd, false);
		}
	}
	
}
