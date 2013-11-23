package whirlpower.uniqueshape
{
	
	/**
	 * 描画のオプション
	 * ...
	 * @author Tetsuya Chiba
	 */
	public class DrawOption 
	{
		// 塗りに上書きするカラー
		// アルファに値が入ったときに同時に有効化する。
		private var _fillColor : int = -1;
		public function get fillColor():int { return _fillColor; }
		public function set fillColor(value:int):void 
		{
			_fillColor = value < 0? 0:value;
			if ( !_fillAlpha ) _fillAlpha = 1;
		}
		
		// 塗りに上書きするアルファ
		// カラーに値が入ったときに同時に有効化する。
		private var _fillAlpha : int;
		public function get fillAlpha():int { return _fillAlpha; }
		public function set fillAlpha(value:int):void 
		{
			_fillAlpha = value < 0? 0:value;
			if ( !_fillColor ) _fillColor = 0x888888;
		}
		
		
		// ラインカラーを上書きする( ライン表示を有効にする )
		private var _lineColor : int = -1;
		public function get lineColor():int { return _lineColor; }
		public function set lineColor(value:int):void 
		{
			_lineColor = value;
			if ( !_lineAlpha ) _lineAlpha = 1;
			if ( !_lineThickness ) _lineThickness = 1;
		}
		
		// ラインの太さ( ライン表示を有効にする )
		private var _lineThickness : Number;
		public function get lineThickness():Number { return _lineThickness; }
		public function set lineThickness(value:Number):void 
		{
			_lineThickness = value;
			if ( !_lineColor ) _lineColor = 0x888888;
			if ( !_lineAlpha ) _lineAlpha = 1;
		}
		
		// ラインのアルファ( ライン表示を有効にする )
		private var _lineAlpha : Number;
		public function get lineAlpha():Number { return _lineAlpha; }
		public function set lineAlpha( value:Number ):void 
		{
			_lineAlpha = value;
			if ( !_lineColor ) _lineColor = 0x888888;;
			if ( !_lineThickness ) _lineThickness = 1;
		}
		
		
		// ベジエの分割数　２の倍数を指定する。
		// divisionLineが有効の場合無視されます。
		private var _bezieStep : int;
		public function get bezieStep():int { return _bezieStep; }
		public function set bezieStep(value:int):void 
		{
			_bezieStep = value;
		}
		
		// 曲線をラインで分割して描画する分割数。
		// 0以上で有効化。
		private var _divisionLine : int;
		public function get divisionLine():int { return _divisionLine; }
		public function set divisionLine(value:int):void
		{
			_divisionLine = ( value <= 0)? 0:value;
		}
		
		public function DrawOption():void
		{
			
		}
	}
}