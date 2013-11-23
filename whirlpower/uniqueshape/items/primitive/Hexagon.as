package whirlpower.uniqueshape.items.primitive
{
  import whirlpower.uniqueshape.data.*;
  import flash.display.Shape;
  
  public class Hexagon extends ShapeSouce
  {
    public function Hexagon():void
    {
      var data:PathItemData;
      
      data = new PathItemData();
      data.type = "PathItem";
      data.name = "";
      data.closed = true;
      data.line = -1;
      data.fill = 0x009245;
      data.alpha = 1;
      data.points = [
        new BP( 36.59, 21.625, 36.59, 21.625, 36.59, 21.625 ),
        new BP( 0, 42.75, 0, 42.75, 0, 42.75 ),
        new BP( -36.59, 21.625, -36.59, 21.625, -36.59, 21.625 ),
        new BP( -36.59, -20.625, -36.59, -20.625, -36.59, -20.625 ),
        new BP( 0, -41.75, 0, -41.75, 0, -41.75 ),
        new BP( 36.589, -20.625, 36.589, -20.625, 36.589, -20.625 ),
      ];
      pathItems.push( data );
      
    }
  }
}
