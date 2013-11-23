package whirlpower.uniqueshape.items.primitive
{
  import whirlpower.uniqueshape.data.*;
  import flash.display.Shape;
  
  public class Star extends ShapeSouce
  {
    public function Star():void
    {
      var data:PathItemData;
      
      data = new PathItemData();
      data.type = "PathItem";
      data.name = "star";
      data.closed = true;
      data.line = -1;
      data.fill = 0xFCEE21;
      data.alpha = 1;
      data.points = [
        new BP( 0.073, -47.27, 0.073, -47.27, 0.073, -47.27 ),
        new BP( 10.922, -15.229, 10.922, -15.229, 10.922, -15.229 ),
        new BP( 44.313, -15.128, 44.313, -15.128, 44.313, -15.128 ),
        new BP( 17.628, 5.408, 17.628, 5.408, 17.628, 5.408 ),
        new BP( 27.415, 36.879, 27.415, 36.879, 27.415, 36.879 ),
        new BP( 0.073, 18.162, 0.073, 18.162, 0.073, 18.162 ),
        new BP( -27.268, 36.879, -27.268, 36.879, -27.268, 36.879 ),
        new BP( -17.482, 5.408, -17.482, 5.408, -17.482, 5.408 ),
        new BP( -44.166, -15.128, -44.166, -15.128, -44.166, -15.128 ),
        new BP( -10.777, -15.229, -10.777, -15.229, -10.777, -15.229 ),
      ];
      pathItems.push( data );
      
    }
  }
}
