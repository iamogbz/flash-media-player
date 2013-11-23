package whirlpower.uniqueshape.items.primitive
{
  import whirlpower.uniqueshape.data.*;
  import flash.display.Shape;
  
  public class SixStar extends ShapeSouce
  {
    public function SixStar():void
    {
      var data:PathItemData;
      
      data = new PathItemData();
      data.type = "PathItem";
      data.name = "";
      data.closed = true;
      data.line = -1;
      data.fill = 0xF7931E;
      data.alpha = 1;
      data.points = [
        new BP( 25.815, 0.32, 25.815, 0.32, 25.815, 0.32 ),
        new BP( 38.761, -22.104, 38.761, -22.104, 38.761, -22.104 ),
        new BP( 12.869, -22.104, 12.869, -22.104, 12.869, -22.104 ),
        new BP( -0.078, -44.527, -0.078, -44.527, -0.078, -44.527 ),
        new BP( -13.023, -22.104, -13.023, -22.104, -13.023, -22.104 ),
        new BP( -38.915, -22.104, -38.915, -22.104, -38.915, -22.104 ),
        new BP( -25.969, 0.318, -25.969, 0.318, -25.969, 0.318 ),
        new BP( -38.917, 22.742, -38.917, 22.742, -38.917, 22.742 ),
        new BP( -13.022, 22.742, -13.022, 22.742, -13.022, 22.742 ),
        new BP( -0.077, 45.166, -0.077, 45.166, -0.077, 45.166 ),
        new BP( 12.87, 22.742, 12.87, 22.742, 12.87, 22.742 ),
        new BP( 38.761, 22.742, 38.761, 22.742, 38.761, 22.742 ),
      ];
      pathItems.push( data );
      
    }
  }
}
