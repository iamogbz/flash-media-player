package {
	import flash.utils.ByteArray;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.DisplayObject;

	public class Default {

		public function Default() {
		}
		
		public static function parseBoolean(value:String):Boolean{
			if(value.toLowerCase() == "true"){
				return true;
			}
			return false;
		}
		
		public static function encodePNG(img:BitmapData):ByteArray {
			// Create output byte array
			var png:ByteArray = new ByteArray  ;
			// Write PNG signature
			png.writeUnsignedInt(0x89504e47);
			png.writeUnsignedInt(0x0D0A1A0A);
			// Build IHDR chunk
			var IHDR:ByteArray = new ByteArray  ;
			IHDR.writeInt(img.width);
			IHDR.writeInt(img.height);
			IHDR.writeUnsignedInt(0x08060000);
			// 32bit RGBA;
			IHDR.writeByte(0);
			writeChunk(png,0x49484452,IHDR);
			// Build IDAT chunk
			var IDAT:ByteArray = new ByteArray  ;
			for (var i:int = 0; i < img.height; i++) {
				// no filter
				IDAT.writeByte(0);
				var p:uint;
				var j:int;
				if (! img.transparent) {
					for (j = 0; j < img.width; j++) {
						p = img.getPixel(j,i);
						IDAT.writeUnsignedInt(uint(p & 0xFFFFFF << 8 | 0xFF));
					}
				}
				else {
					for (j = 0; j < img.width; j++) {
						p = img.getPixel32(j,i);
						IDAT.writeUnsignedInt(uint(p & 0xFFFFFF << 8 | p >>> 24));
					}
				}
			}
			IDAT.compress();
			writeChunk(png,0x49444154,IDAT);
			// Build IEND chunk
			writeChunk(png,0x49454E44,null);
			// return PNG
			return png;
		}

		private static function writeChunk(png:ByteArray,type:uint,data:ByteArray):void {
			
			var crcTable:Array;
			var crcTableComputed:Boolean = false;
			
			if (! crcTableComputed) {
				crcTableComputed = true;
				crcTable = [];
				var c:uint;
				for (var n:uint = 0; n < 256; n++) {
					c = n;
					for (var k:uint = 0; k < 8; k++) {
						if (c & 1) {
							c = uint(uint(0xedb88320) ^ uint(c >>> 1));
						}
						else {
							c = uint(c >>> 1);
						}
					}
					crcTable[n] = c;
				}
			}
			var len:uint = 0;
			if (data != null) {
				len = data.length;
			}
			png.writeUnsignedInt(len);
			var p:uint = png.position;
			png.writeUnsignedInt(type);
			if (data != null) {
				png.writeBytes(data);
			}
			var e:uint = png.position;
			png.position = p;
			c = 0xffffffff;
			for (var i:int = 0; i < e - p; i++) {
				c = uint(crcTable[c ^ png.readUnsignedByte() & uint(0xff)] ^ uint(c >>> 8));
			}
			c = uint(c ^ uint(0xffffffff));
			png.position = e;
			png.writeUnsignedInt(c);
		}
		
		public static function getBitmapData(initialData:ByteArray):DisplayObject{
			var finalData:ByteArray = new ByteArray();
			var byteCon:Loader = new Loader();
			var found:Boolean = false;
			var offset:int;
			var length:int;
			
			initialData.position = 0;
			//get offset and length
			while(!found){
				var pos:int = initialData.readUnsignedInt();
				if(pos == 0x41504943){
					offset = initialData.position + 20;
				}
				if(pos == 0){
					if (!found){
						length = initialData.position - 1 - offset;
						if(length > 5000){
							found = true;
						}
					}
				}
				initialData.position = initialData.position - 3;
			}
		
			finalData.writeBytes(initialData, offset, length);
			finalData.position = 0;
			byteCon.loadBytes(finalData);
			return byteCon.content;
		}
		
	}

}