package whirlpower.uniqueshape
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	
	import whirlpower.uniqueshape.*;
	import whirlpower.uniqueshape.data.*;
	import whirlpower.uniqueshape.drawer.*;
	
	public class DrawingShape extends Sprite
	{
		private var pointGene : DrawPointsGenerator;
		private var pathItems : Array;
		private var option : DrawOption;
		private var points : Array;
		
		public var currentPoint : Point;
		
		
		// 現在の描画の状態
		public var shapeStatue	:String = "none";
		
		public static const ALL_DRAWED	:String = "all_drawed";		// 
		public static const SHAPE_START	:String = "shape_start";	
		public static const SHAPE_DRAWED:String = "shape_drawed";	
		public static const DRAW		:String = "draw";			
		
		/**
		 * 少しずつ描画していきます。nextを実行していくことで描画されます。
		 * ラインのみ描画します
		 * @param	data
		 * @param	_param
		 */
		public function DrawingShape( data:ShapeSouce, _option:DrawOption = null ):void
		{	
			pointGene	= new DrawPointsGenerator();
			pathItems	= data.pathItems;
			option		= _option || new DrawOption();
			option.divisionLine = 20;
			points = new Array();
			
			var d:PathItemData;
			var leng:int = data.pathItems.length;		
			
			for (var i:int = 0; i < leng; i++) 
			{
				d = pathItems[i];
				
				// 描画位置を取得する。
				points.push( pointGene.getDrawPoint( d, option ) );
			}
		}
		
		private var cntI	:int = 0;
		private var cntJ	:int = 0;
		
		public function next( count:int ):void
		{
			var i	:int = 0;
			var j	:int = 0;
			var cnt	:int = 0;
			
			for ( i = cntI; i < points.length; i++ )
			{
				if ( cntJ == 0 )
				{
					if ( option.lineColor != -1 )
						graphics.lineStyle( option.lineThickness, option.lineColor, option.lineAlpha );	// TODO:　ラインの太さを取得
					else
						graphics.lineStyle( 1, pathItems[cntI].line, pathItems[cntI].alpha );	// TODO:　ラインの太さを取得
						
					graphics.moveTo( points[i][0].p1.x, points[i][0].p1.y );
					shapeStatue = SHAPE_START;
				}
				for ( j = cntJ; j < points[i].length; j++ )
				{
					
					if ( count == cnt )
						return;
					
					draw( points[i][j] );
					currentPoint = points[i][j].p2 || points[i][j].p1;
					shapeStatue = DRAW;
					
					cnt++;
					cntJ++;
				}
				if ( cntJ >= points[i].length )
				{
					cntJ = 0;
					dispatchEvent( new Event( SHAPE_DRAWED ) );
					shapeStatue = SHAPE_DRAWED
				}
				cntI++;
			}
			
			if ( cntI >= points.length )
				shapeStatue = ALL_DRAWED;
		}
		
		/**
		 * 点が１つのときは直線。点が２つのときは曲線
		 * @param	p
		 */
		private function draw( p:Point2 ):void
		{
			// Bezier2
			if ( p.p2 )
				graphics.curveTo( p.p1.x, p.p1.y, p.p2.x, p.p2.y );
			// line
			else
				graphics.lineTo( p.p1.x, p.p1.y );
		}
		
		private function reset():void
		{
			cntI = 0;
			cntJ = 0;
		}
	}
}
