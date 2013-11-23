package whirlpower.uniqueshape.items.primitive
{
  import whirlpower.uniqueshape.data.*;
  import flash.display.Shape;
  
  public class Pentagon extends ShapeSouce
  {
    public function Pentagon():void
    {
      var data:PathItemData;
      
      data = new PathItemData();
      data.type = "PathItem";
      data.name = "";
      data.closed = true;
      data.line = -1;
      data.fill = 0x39B54A;
      data.alpha = 1;
      data.points = [
        new BP( 0, -43.816, 0, -43.816, 0, -43.816 ),
        new BP( -41.607, -13.588, -41.607, -13.588, -41.607, -13.588 ),
        new BP( -25.714, 35.322, -25.714, 35.322, -25.714, 35.322 ),
        new BP( 25.713, 35.322, 25.713, 35.322, 25.713, 35.322 ),
        new BP( 41.605, -13.588, 41.605, -13.588, 41.605, -13.588 ),
      ];
      pathItems.push( data );
      
    }
  }
}
