package whirlpower.uniqueshape
{
	import flash.display.Shape;
	import whirlpower.uniqueshape.*;
	import whirlpower.uniqueshape.data.*;
	import whirlpower.uniqueshape.drawer.*;
	
	/**
	 * ひとつのShapeの塊として描画する。
	 */
	public class SingleShape extends Shape
	{
		public function SingleShape( data:ShapeSouce, _option:DrawOption = null ):void
		{	
			var pointGene	:DrawPointsGenerator = new DrawPointsGenerator();
			var shapeDrawer	:ShapeDrawer = new ShapeDrawer();
			var pathItems	:Array = data.pathItems;
			var option		:DrawOption = _option || new DrawOption();
			
			for each( var p:PathItemData in pathItems ) 
			{
				// 描画位置を取得する。
				var points:Array = pointGene.getDrawPoint( p, option );
				
				// カラーを描画
				if ( p.fill != -1 )
					shapeDrawer.drawFill( graphics, points, p, option );
					
				// ラインを描画
				if ( p.line != -1 || option.lineColor != -1 )
					shapeDrawer.drawLine( graphics, points, p, option );
			}
		}
	}
}