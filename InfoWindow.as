package {
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.NativeWindow;
	import flash.display.NativeWindowInitOptions;
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.filters.BevelFilter;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.text.TextFieldAutoSize;

	public class InfoWindow extends NativeWindow {
		public var padding:int = 10,defWidth:int = 500,defHeight:int = 400;
		public var xmlURL:String,logoURL:String,xmlLoader:URLLoader,logoLoader:Loader,logo:Bitmap,info:XML,body:TextField,base:TextField,bodyTextFormat:TextFormat,baseTextFormat:TextFormat;

		public function InfoWindow(initOptions:NativeWindowInitOptions, xml:String, logo:String = "") {
			super(initOptions);
			width = defWidth;
			height = defHeight;
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			bodyTextFormat = new TextFormat();
			bodyTextFormat.align = TextFormatAlign.JUSTIFY;
			bodyTextFormat.color = 0xaaaaaa;
			bodyTextFormat.font = "Arial";
			bodyTextFormat.size = 13;
			baseTextFormat = new TextFormat();
			baseTextFormat.bold = true;
			baseTextFormat.color = 0x555555;
			baseTextFormat.font = "Arial";
			baseTextFormat.size = 11;

			xmlURL = xml;
			logoURL = logo;
			if (logoURL != "") {
				logoLoader = new Loader();
				logoLoader.load(new URLRequest(logoURL));
				logoLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, logoLoaded);
			}
			else {
				xmlLoader = new URLLoader(new URLRequest(xmlURL));
				xmlLoader.addEventListener(Event.COMPLETE, xmlLoaded);
			}
		}
		public function logoLoaded(e:Event):void {
			logo = Bitmap(e.target.content);
			logo.smoothing = true;
			var scale = stage.stageWidth / logo.width;
			logo.scaleX = scale;
			logo.scaleY = scale;
			stage.addChild(logo);
			xmlLoader = new URLLoader(new URLRequest(xmlURL));
			xmlLoader.addEventListener(Event.COMPLETE, xmlLoaded);
		}
		public function xmlLoaded(e:Event):void {
			info = new XML(e.target.data);
			title = info. @ title;
			
			body = new TextField();
			body.autoSize = TextFieldAutoSize.LEFT;
			body.defaultTextFormat = bodyTextFormat;
			body.selectable = false;
			body.htmlText = info. @ information;
			body.width = stage.stageWidth - padding * 2;
			body.wordWrap = true;
			body.x = padding;
			if (stage.numChildren != 0) {
				body.y = logo.y + logo.height + padding;
			}
			else {
				body.y = padding;
			}
			stage.addChild(body);
			//body.height = stage.stageHeight - padding*2;
			//body.backgroundColor = 0;
			body.background = true;

			base = new TextField();
			base.autoSize = TextFieldAutoSize.LEFT;
			base.defaultTextFormat = baseTextFormat;
			base.selectable = false;
			base.htmlText = "Written by: " + info. @ developer + ". Visit <font color=\"#4080f0\"><a href=\"http://about.me/emmanuel.ogbizi.ugbe\">Mee!</a></font>.";
			base.x = padding;//stage.stageWidth - base.width - padding;
			base.y = body.y + body.height + padding;
			stage.addChild(base);
			var bf:BevelFilter = new BevelFilter(0,0,0xffffff,1,0x000000,1,4,4,1,100,"outer",false);
			base.filters = [bf];

			height = base.y + base.height + padding * 3;
		}

	}

}