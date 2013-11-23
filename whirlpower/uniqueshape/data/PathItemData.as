// PathObjectを構成するオブジェクト
package whirlpower.uniqueshape.data
{
	public class PathItemData
	{
		// 外部定義プロパティ
		public var type		:String = "none";
		public var name		:String = "noName";
		public var alpha	:Number = 1;
		public var fill		:int = -1;
		public var thickness:Number = 1;
		public var line		:int = -1;
		public var closed	:Boolean = false;
		public var points	/*BP*/:Array = new Array();
		
		public function PathItemData():void
		{
		}
	}
}
