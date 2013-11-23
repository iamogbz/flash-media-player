package whirlpower.uniqueshape.items.primitive
{
  import whirlpower.uniqueshape.data.*;
  import flash.display.Shape;
  
  public class Octagon extends ShapeSouce
  {
    public function Octagon():void
    {
      var data:PathItemData;
      
      data = new PathItemData();
      data.type = "PathItem";
      data.name = "";
      data.closed = true;
      data.line = -1;
      data.fill = 0x22B573;
      data.alpha = 1;
      data.points = [
        new BP( -1, -40, -1, -40, -1, -40 ),
        new BP( 27.285, -28.284, 27.285, -28.284, 27.285, -28.284 ),
        new BP( 39, 0, 39, 0, 39, 0 ),
        new BP( 27.285, 28.284, 27.285, 28.284, 27.285, 28.284 ),
        new BP( -1, 40, -1, 40, -1, 40 ),
        new BP( -29.284, 28.284, -29.284, 28.284, -29.284, 28.284 ),
        new BP( -41, 0, -41, 0, -41, 0 ),
        new BP( -29.284, -28.284, -29.284, -28.284, -29.284, -28.284 ),
      ];
      pathItems.push( data );
      
    }
  }
}
