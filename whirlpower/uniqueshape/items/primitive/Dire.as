package whirlpower.uniqueshape.items.primitive
{
  import whirlpower.uniqueshape.data.*;
  import flash.display.Shape;
  
  public class Dire extends ShapeSouce
  {
    public function Dire():void
    {
      var data:PathItemData;
      
      data = new PathItemData();
      data.type = "PathItem";
      data.name = "circle";
      data.closed = true;
      data.line = -1;
      data.fill = 0xC1272D;
      data.alpha = 1;
      data.points = [
        new BP( 32.493, -0.001, 32.493, -0.001, 32.493, -0.001 ),
        new BP( 0.001, 45.42, 0.001, 45.42, 0.001, 45.42 ),
        new BP( -32.491, -0.001, -32.491, -0.001, -32.491, -0.001 ),
        new BP( 0.001, -45.422, 0.001, -45.422, 0.001, -45.422 ),
      ];
      pathItems.push( data );
      
    }
  }
}
