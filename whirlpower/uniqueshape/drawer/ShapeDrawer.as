package whirlpower.uniqueshape.drawer
{
	import flash.display.Graphics;
	import flash.display.Shape;
	
	import whirlpower.uniqueshape.*;
	import whirlpower.uniqueshape.data.*;
	
	/**
	 * ひとつのシェイプを描画するメソッドを持つ。
	 * ...
	 * @author Tetsuya Chiba
	 */
	public class ShapeDrawer 
	{
		public function ShapeDrawer():void
		{
			
		}
		
		/**
		 * 面を描画する。
		 * @param	points
		 * @param	data	
		 * @param	param	
		 */
		public function drawFill( graphics:Graphics, points:Array, data:PathItemData, option:DrawOption = null ):void
        {
			// カラーの上書き
			if( option.fillColor != -1 ){
				graphics.beginFill( option.fillColor, option.fillAlpha );
			}else {
				graphics.beginFill( data.fill, data.alpha );
			}
			
			// 初期位置を設定
			graphics.moveTo( points[0].p1.x, points[0].p1.y );
			
			var leng:int = points.length;
			for (var i:int = 1; i < leng; i++) 
			{
				if ( points[i].p2 )
					// Bezier2
					graphics.curveTo( points[i].p1.x, points[i].p1.y, points[i].p2.x, points[i].p2.y );
				else
					// line
					graphics.lineTo( points[i].p1.x, points[i].p1.y );				
			}
			
			graphics.endFill();
		}
		
		/**
		 * ラインを描画する
		 * @param	points
		 * @param	data
		 * @param	param
		 */
		public function drawLine( graphics:Graphics, points:Array, data:PathItemData, option:DrawOption = null ):void
		{
			// カラーの上書き
			var _thickness :Number = option.lineThickness | 1;
			var _color : int = option.lineColor | data.line | 0x000000;
			var _alpha : Number = option.lineAlpha | data.alpha | 1;
			graphics.lineStyle( _thickness, _color, _alpha );	// TODO:　ラインの太さを取得
			
			// 初期位置を設定
			graphics.moveTo( points[0].p1.x, points[0].p1.y );
			
			var leng:int = points.length;
			for (var i:int = 1; i < leng; i++) 
			{
				if ( points[i].p2 )
					// Bezier2
					graphics.curveTo( points[i].p1.x, points[i].p1.y, points[i].p2.x, points[i].p2.y );
				else
					// line
					graphics.lineTo( points[i].p1.x, points[i].p1.y );				
			}
		}
	}	
}