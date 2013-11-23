package whirlpower.uniqueshape.items.primitive
{
  import whirlpower.uniqueshape.data.*;
  import flash.display.Shape;
  
  public class Circle extends ShapeSouce
  {
    public function Circle():void
    {
      var data:PathItemData;
      
      data = new PathItemData();
      data.type = "PathItem";
      data.name = "circle";
      data.closed = true;
      data.line = -1;
      data.fill = 0x0071BC;
      data.alpha = 1;
      data.points = [
        new BP( 40.073, -0.001, 40.073, 22.132, 40.073, -22.132 ),
        new BP( 0.001, 40.071, -22.131, 40.071, 22.133, 40.071 ),
        new BP( -40.072, -0.001, -40.072, -22.132, -40.072, 22.132 ),
        new BP( 0.001, -40.073, 22.133, -40.073, -22.131, -40.073 ),
      ];
      pathItems.push( data );
      
    }
  }
}
