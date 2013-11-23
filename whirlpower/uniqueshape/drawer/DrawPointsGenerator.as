package whirlpower.uniqueshape.drawer
{
    import flash.geom.Point;
	import whirlpower.uniqueshape.*;
    import whirlpower.uniqueshape.data.*;
	import whirlpower.uniqueshape.drawer.*;
	
	/**
	 * ベジェ描画の基本クラス
	 * 
	 * 複合パスがillustratorがわから出力されていない不具合があります。
	 */
	public class DrawPointsGenerator
	{
		// ２次ベジェのステップ数
		private var at : Number = 1/8;	
		
		protected var p0:Point = new Point(0,0);
		protected var p1:Point = new Point(0,0);
		protected var p2:Point = new Point(0,0);
		protected var p3:Point = new Point(0,0);
		protected var p4:Point = new Point(0,0);
		protected var p5:Point = new Point(0,0);
		protected var p6:Point = new Point(0,0);
		protected var p7:Point = new Point(0,0);
		protected var p8:Point = new Point(0,0);
		
		protected var r1:Point = new Point(0,0);
		protected var r2:Point = new Point(0,0);
		protected var r3:Point = new Point(0,0);
		
		public function DrawPointsGenerator():void
		{
		}
		
		private var points	:Array = [];
		
		/**
		 * 描画パラメータを計算する。
		 * @param	data
		 * @param	param
		 */
		public function getDrawPoint( data:PathItemData, option:DrawOption = null ):Array
		{
			points = new Array();
			
			at = 1 / ( option.bezieStep || 8 );
			p0 = data.points[0].anchor;				// 初期位置の設定
			
			points.push( new Point2( new Point( p0.x, p0.y ), null ) );
			
			var leng:uint = data.points.length;
			if ( !data.closed ) leng -= 1;			// クローズドパスでは無い場合は、ループ回数を減らす。
			for ( var i:uint = 0; i < leng; i++ )
			{
				setPoints( data, i, leng );				
				
				if ( option.divisionLine )
				{
					drawDivLine( option.divisionLine );
				}
				else
				{
					var drawType:String = selectDrawType( data, i );
					
					switch( drawType )
					{
						case "line":
							distanceDrawLine();
							break;
							
						case "Bezier2_front":
							distanceDrawBezier2Front();
							break;
							
						case "Bezier2_back":
							distanceDrawBezier2Back();
							break;
							
						case "Bezier3":
							distanceDrawBezier3( at );
							break;
					}
				}
			}
			
			return points;
		}
		
		
		/**
		 * 処理を行う２点を決める
		 * @param	data
		 * @param	i
		 * @param	leng
		 */
		protected function setPoints( data:PathItemData, i:int, leng:uint ):void
		{
			p0 = data.points[i].anchor;
			p1 = data.points[i].rightHandle;
			
			if ( data.closed && i+1 == leng )  	// クローズドパスの場合は最後に始点に戻す
			{
				p2 = data.points[0].leftHandle;
				p3 = data.points[0].anchor;
			}
			else
			{
				p2 = data.points[i + 1].leftHandle;
				p3 = data.points[i + 1].anchor;
			}		
		}
		
		/**
		 * ２点間の描画タイプの判定
		 * @param	data
		 * @param	i
		 * @return
		 */
		protected function selectDrawType( data:PathItemData, i:uint ):String
		{
			if ( p0.x == p1.x && p0.y == p1.y )
				if ( p2.x == p3.x && p2.y == p3.y )
					return "line";
				else
					return "Bezier2_back";
			else if ( p2.x == p3.x && p2.y == p3.y )
				return "Bezier2_front";
			else
				return "Bezier3";
		}
		
		/**
		 * 次のポイントを直線で結ぶ
		 */
		protected function distanceDrawLine():void
		{
			points.push( new Point2( new Point( p3.x, p3.y ), null ) );
		}
		
		/**
		 * ２点間を手前のハンドルで２次ベジェで結ぶ
		 */
		protected function distanceDrawBezier2Front():void
		{
			points.push( new Point2( new Point( p1.x, p1.y ), new Point( p3.x, p3.y ) ) );
		}
		
		/**
		 * ２点間を後のハンドルで２次ベジェで結ぶ
		 */
		protected function distanceDrawBezier2Back():void
		{
			points.push( new Point2( new Point( p2.x, p2.y ), new Point( p3.x, p3.y ) ) );
		}
		
		/**
		 * ２点間の３次ベジェをラインで結ぶ
		 * @param	lineStep
		 */
		protected function drawDivLine( lineStep:Number = 20 ):void
		{
			var t:Number;
			
			for( t = 0.0; t <= 1.0; t += 1/lineStep )
			{
				getPoint( r1, t );
				points.push( new Point2( new Point( r1.x, r1.y ), null ) );
			}
		}
		
		/**
		 * ２点間の３次ベジェを２次ベジェで結ぶ
		 * @param	at
		 */
		protected function distanceDrawBezier3( at:Number = 0.25 ):void
		{
			var t:Number;
			for( t = at * 2; t <= 1.0; t += at * 2 )
			{
				getPoint( r1, t);
				getPoint( r2, t - at);
				getPoint( r3, t - 2 * at);
				
				r2.x = 2 * r2.x - (r1.x + r3.x) / 2;
				r2.y = 2 * r2.y - (r1.y + r3.y) / 2;
				
				points.push( new Point2( new Point( r2.x, r2.y), new Point( r1.x, r1.y ) ) );
			}
		}
		
		/**
		 * 指定の４点から、描画の目標点を求める
		 * @param	rp
		 * @param	t
		 */
        private function getPoint( rp:Point, t:Number ):void
        {
           getInnerPoint( p4, p0, p1, t);
           getInnerPoint( p5, p1, p2, t);
           getInnerPoint( p6, p2, p3, t);
           getInnerPoint( p7, p4, p5, t);
           getInnerPoint( p8, p5, p6, t);
           getInnerPoint( rp, p7, p8, t);
        }
		
		/**
		 * 線上の点の位置を求める
		 * @param	rp
		 * @param	s0
		 * @param	s1
		 * @param	t
		 */
        private function getInnerPoint( rp:Point, s0:Point, s1:Point, t:Number):void
        {
            rp.x = s0.x * (1 - t) + s1.x * t;
            rp.y = s0.y * (1 - t) + s1.y * t;
        }
	}
}