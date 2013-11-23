package whirlpower.uniqueshape.items.primitive
{
  import whirlpower.uniqueshape.data.*;
  import flash.display.Shape;
  
  public class Triangle extends ShapeSouce
  {
    public function Triangle():void
    {
      var data:PathItemData;
      
      data = new PathItemData();
      data.type = "PathItem";
      data.name = "circle";
      data.closed = true;
      data.line = -1;
      data.fill = 0x00A99D;
      data.alpha = 1;
      data.points = [
        new BP( 41.064, 25.172, 41.064, 25.172, 41.064, 25.172 ),
        new BP( -41.062, 25.172, -41.062, 25.172, -41.062, 25.172 ),
        new BP( 0.001, -42.246, 0.001, -42.246, 0.001, -42.246 ),
      ];
      pathItems.push( data );
      
    }
  }
}
