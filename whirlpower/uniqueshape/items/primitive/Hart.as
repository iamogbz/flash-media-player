package whirlpower.uniqueshape.items.primitive
{
  import whirlpower.uniqueshape.data.*;
  import flash.display.Shape;
  
  public class Hart extends ShapeSouce
  {
    public function Hart():void
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
        new BP( 40.073, -19.001, 40.073, 3.132, 40.073, -41.13 ),
        new BP( 0.001, 38.071, 0.001, 38.071, 0.001, 38.071 ),
        new BP( -40.072, -19.001, -40.072, -41.129, -40.072, 3.132 ),
        new BP( 0.001, -18.073, 9.667, -41.999, -7, -41.999 ),
      ];
      pathItems.push( data );
      
    }
  }
}
