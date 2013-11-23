package whirlpower.uniqueshape.items.primitive
{
  import whirlpower.uniqueshape.data.*;
  import flash.display.Shape;
  
  public class Cross extends ShapeSouce
  {
    public function Cross():void
    {
      var data:PathItemData;
      
      data = new PathItemData();
      data.type = "PathItem";
      data.name = "";
      data.closed = true;
      data.line = -1;
      data.fill = 0x2E3192;
      data.alpha = 1;
      data.points = [
        new BP( -37.559, 32.411, -37.559, 32.411, -37.559, 32.411 ),
        new BP( 32.215, -37.364, 32.215, -37.364, 32.215, -37.364 ),
        new BP( 37.014, -32.565, 37.014, -32.565, 37.014, -32.565 ),
        new BP( -32.761, 37.21, -32.761, 37.21, -32.761, 37.21 ),
      ];
      pathItems.push( data );
      
      data = new PathItemData();
      data.type = "PathItem";
      data.name = "";
      data.closed = true;
      data.line = -1;
      data.fill = 0x2E3192;
      data.alpha = 1;
      data.points = [
        new BP( 32.215, 37.209, 32.215, 37.209, 32.215, 37.209 ),
        new BP( -37.56, -32.565, -37.56, -32.565, -37.56, -32.565 ),
        new BP( -32.761, -37.364, -32.761, -37.364, -32.761, -37.364 ),
        new BP( 37.014, 32.411, 37.014, 32.411, 37.014, 32.411 ),
      ];
      pathItems.push( data );
      
    }
  }
}
