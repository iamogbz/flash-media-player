package whirlpower.uniqueshape.items.primitive
{
  import whirlpower.uniqueshape.data.*;
  import flash.display.Shape;
  
  public class Septagon extends ShapeSouce
  {
    public function Septagon():void
    {
      var data:PathItemData;
      
      data = new PathItemData();
      data.type = "PathItem";
      data.name = "";
      data.closed = true;
      data.line = -1;
      data.fill = 0x006837;
      data.alpha = 1;
      data.points = [
        new BP( 0, -41.953, 0, -41.953, 0, -41.953 ),
        new BP( 32.875, -26.124, 32.875, -26.124, 32.875, -26.124 ),
        new BP( 41.001, 9.454, 41.001, 9.454, 41.001, 9.454 ),
        new BP( 18.251, 37.988, 18.251, 37.988, 18.251, 37.988 ),
        new BP( -18.243, 37.993, -18.243, 37.993, -18.243, 37.993 ),
        new BP( -40.999, 9.462, -40.999, 9.462, -40.999, 9.462 ),
        new BP( -32.88, -26.117, -32.88, -26.117, -32.88, -26.117 ),
      ];
      pathItems.push( data );
      
    }
  }
}
