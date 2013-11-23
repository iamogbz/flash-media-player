package Notice {
	import flash.display.NativeWindow;
	import flash.display.NativeWindowInitOptions;
	import flash.display.NativeWindowSystemChrome;
	import flash.display.NativeWindowType;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.display.Screen;
	import flash.text.TextFormatAlign;
	import flash.text.TextFieldAutoSize;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.display.Sprite;
	import flash.events.FocusEvent;
	import flash.filters.BlurFilter;

	public class NoticeWindow extends NativeWindow {
		public static const TOP_LEFT:String = new String("top_left");
		public static const TOP_RIGHT:String = new String("top_right");
		public static const BOTTOM_LEFT:String = new String("bottom_left");
		public static const BOTTOM_RIGHT:String = new String("bottom_right");
		public static var PADDING:int = 10,WIDTH:int = 180,HEIGHT:int = 46;
		private var body:TextField, bodyTextFormat:TextFormat;
		private var timer:Timer, bg:Sprite;
		public var ctrl:NoticeControl;
		
		public function NoticeWindow(notice:String, orientation:String = "bottom_right", font:String = "Arial") {
			var initOpt:NativeWindowInitOptions = new NativeWindowInitOptions();
			initOpt.systemChrome = NativeWindowSystemChrome.NONE;
			initOpt.type = NativeWindowType.LIGHTWEIGHT;
			initOpt.transparent = true;
			super(initOpt);
			alwaysInFront = true;
			width = Screen.mainScreen.bounds.width;
			height = Screen.mainScreen.bounds.height;
			bg = new Sprite();
			setOrientation(orientation);
			stage.addChild(bg);
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			bodyTextFormat = new TextFormat();
			bodyTextFormat.align = TextFormatAlign.LEFT;
			//bodyTextFormat.bold = true;
			bodyTextFormat.color = 0;
			bodyTextFormat.font = font;
			bodyTextFormat.size = 15;
			
			body = new TextField();
			body.defaultTextFormat = bodyTextFormat;
			body.autoSize = TextFieldAutoSize.LEFT;
			//body.blendMode = "overlay";
			body.selectable = false;
			body.htmlText = notice;
			//body.width = WIDTH;// - PADDING * 2;
			//body.height = HEIGHT;// - PADDING * 2;
			//body.wordWrap = true;
			//body.multiline = true;
			if(body.width > bg.width - PADDING*2) var scale:Number = (bg.width - PADDING*2)/body.width;
			else scale = 1;
			body.scaleX = scale;
			body.scaleY = scale;
			body.x = bg.x + (bg.width - body.width)/2;
			body.y = bg.y + (bg.height - body.height)/2;
			stage.addChild(body);
			
			ctrl = new NoticeControl();
			ctrl.x = bg.x + bg.width/2;
			ctrl.y = bg.y + bg.height/2;
			stage.addChild(ctrl);
			ctrl.closeBtn.addEventListener(MouseEvent.MOUSE_UP, exit, false, 0, true);
			ctrl.addEventListener(MouseEvent.MOUSE_OUT, hideCtrl, false, 0, true);
			this.addEventListener(Event.DEACTIVATE, hideCtrl, false, 0, true);
			stage.addEventListener(MouseEvent.MOUSE_OVER, showCtrl, false, 0, true);
			timer = new Timer(5000, 1);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, timerCompleteHandler);
			hideCtrl();
		}
		private function hideCtrl(e:Event = null):void{
			body.filters = [];
			ctrl.visible = false;
			if(timer && !timer.running){
				timer.start();
			}
		}
		private function showCtrl(e:Event):void{
			if(timer && timer.running){
				timer.stop();
				timer.reset();
			}
			this.activate();
			ctrl.visible = true;
			body.filters = [new BlurFilter(2,2,10)];
		}
		private function setOrientation(orientation:String):void{
			bg.graphics.clear();
			bg.graphics.lineStyle(1,0,.2,true);
			bg.graphics.beginFill(0x0088ff,.8);
			bg.graphics.drawRoundRect(0,0,WIDTH,HEIGHT,10);
			bg.graphics.endFill();
			if(orientation == TOP_LEFT){
				bg.x = PADDING;
				bg.y = PADDING;
			}
			else if(orientation == TOP_RIGHT){
				bg.x = Screen.mainScreen.bounds.width - bg.width - PADDING;
				bg.y = PADDING;
			}
			else if(orientation == BOTTOM_LEFT){
				bg.x = PADDING;
				bg.y = Screen.mainScreen.bounds.height - bg.height - PADDING;
			}
			else if(orientation == BOTTOM_RIGHT){
				bg.x = Screen.mainScreen.visibleBounds.width - bg.width - PADDING;
				bg.y = Screen.mainScreen.visibleBounds.height - bg.height - PADDING;
			}
			activate();
		}
		
		private function timerCompleteHandler(te:TimerEvent):void{
			exit();
		}
		public function exit(e:Event = null):void{
			timer.stop();
			timer.removeEventListener(TimerEvent.TIMER_COMPLETE, timerCompleteHandler);
			close();
		}
		
	}

}