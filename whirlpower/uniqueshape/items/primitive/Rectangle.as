package whirlpower.uniqueshape.items.primitive
{
  import whirlpower.uniqueshape.data.*;
  import flash.display.Shape;
  
  public class Rectangle extends ShapeSouce
  {
    public function Rectangle():void
    {
      var data:PathItemData;
      
      data = new PathItemData();
      data.type = "PathItem";
      data.name = "circle";
      data.closed = true;
      data.line = -1;
      data.fill = 0x8CC63F;
      data.alpha = 1;
      data.points = [
        new BP( 36.717, 36.717, 36.717, 36.717, 36.717, 36.717 ),
        new BP( -36.716, 36.717, -36.716, 36.717, -36.716, 36.717 ),
        new BP( -36.716, -36.717, -36.716, -36.717, -36.716, -36.717 ),
        new BP( 36.716, -36.717, 36.716, -36.717, 36.716, -36.717 ),
      ];
      pathItems.push( data );
      
    }
  }
}
