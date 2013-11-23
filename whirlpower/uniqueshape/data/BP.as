package whirlpower.uniqueshape.data
{
	import flash.geom.Point;

	/**
	 * ３次ベジェハンドルのポイントデータ保持オブジェクト
	 */
	public class BP
	{
		public var anchor		:Point;
		public var rightHandle	:Point;
		public var leftHandle	:Point;
		
		public function BP( p0:Number,  p1:Number,  p2:Number,  p3:Number,  p4:Number,  p5:Number ):void
		{
			anchor		= new Point( p0, p1 );
			rightHandle	= new Point( p2, p3 );
			leftHandle	= new Point( p4, p5 );
		}
	}
}