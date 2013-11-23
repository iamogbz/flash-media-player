package whirlpower.uniqueshape.items.primitive
{
  import whirlpower.uniqueshape.data.*;
  import flash.display.Shape;
  
  public class Water extends ShapeSouce
  {
    public function Water():void
    {
      var data:PathItemData;
      
      data = new PathItemData();
      data.type = "PathItem";
      data.name = "water";
      data.closed = true;
      data.line = -1;
      data.fill = 0x29ABE2;
      data.alpha = 1;
      data.points = [
        new BP( 26.727, 15.999, 26.727, 30.761, 26.727, 1.238 ),
        new BP( 0.001, 42.726, -14.76, 42.726, 14.762, 42.726 ),
        new BP( -26.726, 15.999, -26.726, 1.238, -26.726, 30.761 ),
        new BP( 0.001, -43.739, 0.001, -43.739, 0.001, -43.739 ),
      ];
      pathItems.push( data );
      
    }
  }
}
