package whirlpower.uniqueshape.items.primitive
{
  import whirlpower.uniqueshape.data.*;
  import flash.display.Shape;
  
  public class FourStar extends ShapeSouce
  {
    public function FourStar():void
    {
      var data:PathItemData;
      
      data = new PathItemData();
      data.type = "PathItem";
      data.name = "";
      data.closed = true;
      data.line = -1;
      data.fill = 0xD9E021;
      data.alpha = 1;
      data.points = [
        new BP( 11.986, -11.986, 11.986, -11.986, 11.986, -11.986 ),
        new BP( 0, -46.852, 0, -46.852, 0, -46.852 ),
        new BP( -11.984, -11.986, -11.984, -11.986, -11.984, -11.986 ),
        new BP( -46.851, -0.001, -46.851, -0.001, -46.851, -0.001 ),
        new BP( -11.984, 11.984, -11.984, 11.984, -11.984, 11.984 ),
        new BP( 0, 46.85, 0, 46.85, 0, 46.85 ),
        new BP( 11.986, 11.984, 11.986, 11.984, 11.986, 11.984 ),
        new BP( 46.852, -0.001, 46.852, -0.001, 46.852, -0.001 ),
      ];
      pathItems.push( data );
      
    }
  }
}
