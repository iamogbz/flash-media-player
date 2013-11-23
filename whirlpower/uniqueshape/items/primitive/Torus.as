package whirlpower.uniqueshape.items.primitive
{
  import whirlpower.uniqueshape.data.*;
  import flash.display.Shape;
  
  public class Torus extends ShapeSouce
  {
    public function Torus():void
    {
      var data:PathItemData;
      
      data = new PathItemData();
      data.type = "PathItem";
      data.name = "";
      data.closed = true;
      data.line = -1;
      data.fill = 0xC1272D;
      data.alpha = 1;
      data.points = [
        new BP( 0.001, -40.073, 0.001, -40.073, 22.133, -40.073 ),
        new BP( 0.001, -33.295, 18.389, -33.295, 0.001, -33.295 ),
        new BP( 33.295, -0.001, 33.295, 18.388, 33.295, -18.389 ),
        new BP( 0.001, 33.293, -18.386, 33.293, 18.389, 33.293 ),
        new BP( -33.292, -0.001, -33.292, -18.389, -33.292, 18.388 ),
        new BP( 0.001, -33.295, 0.001, -33.295, -18.386, -33.295 ),
        new BP( 0.001, -40.073, -22.13, -40.073, 0.001, -40.073 ),
        new BP( -40.071, -0.001, -40.071, 22.132, -40.071, -22.132 ),
        new BP( 0.001, 40.071, 22.133, 40.071, -22.13, 40.071 ),
        new BP( 40.073, -0.001, 40.073, -22.132, 40.073, 22.132 ),
      ];
      pathItems.push( data );
      
    }
  }
}
