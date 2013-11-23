package whirlpower.uniqueshape
{
	import flash.display.Shape;
	import flash.display.Sprite;
	
	import whirlpower.uniqueshape.*;
	import whirlpower.uniqueshape.data.*;
	import whirlpower.uniqueshape.drawer.*;
	
	/**
	 * 一つ一つ独立しているShapeグループ
	 * TODO : センターをシェイプの中心にそろえる
	 */
    public class MultiShape extends Sprite
    {
        public function MultiShape( data:ShapeSouce, _option:DrawOption = null ):void
        {
			var pointGene	:DrawPointsGenerator = new DrawPointsGenerator();
			var shapeDrawer	:ShapeDrawer = new ShapeDrawer();
			var pathItems	:Array = data.pathItems;
			var option		:DrawOption = _option || new DrawOption();
			var shapes		:Array = new Array();
			
			for each( var p:PathItemData in pathItems ) 
			{
				// 描画位置を取得する。
				var points:Array = pointGene.getDrawPoint( p, option );
				
				var shape:Shape = new Shape();
				shapes.push( shape );
				
				// カラーを描画
				if ( p.fill != -1 )
					shapeDrawer.drawFill( shape.graphics, points, p, option );
					
				// ラインを描画
				if ( p.line != -1 || option.lineColor != -1 )
					shapeDrawer.drawLine( shape.graphics, points, p, option );
					
				addChild( shape );
			}
			
			for (var i:int = shapes.length-1; i >= 0; i--) 
			{
				addChild( shapes[i] );
			}
        }
	}
}