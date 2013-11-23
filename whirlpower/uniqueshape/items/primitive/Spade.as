package whirlpower.uniqueshape.items.primitive
{
  import whirlpower.uniqueshape.data.*;
  import flash.display.Shape;
  
  public class Spade extends ShapeSouce
  {
    public function Spade():void
    {
      var data:PathItemData;
      
      data = new PathItemData();
      data.type = "PathItem";
      data.name = "";
      data.closed = true;
      data.line = -1;
      data.fill = 0x000000;
      data.alpha = 1;
      data.points = [
        new BP( 0.001, -42.808, -13.253, -20.332, 13.747, -20.332 ),
        new BP( -37.704, 12.265, -37.704, 29.142, -37.704, -8.537 ),
        new BP( -3.208, 19.315, -4.397, 28.307, -13.401, 32.372 ),
        new BP( -13.902, 40.335, -13.902, 40.335, -7.233, 40.335 ),
        new BP( 13.729, 40.335, 7.451, 40.335, 13.729, 40.335 ),
        new BP( 3.199, 19.302, 13.385, 32.374, 4.516, 28.294 ),
        new BP( 37.705, 12.265, 37.705, -8.537, 37.705, 29.147 ),
      ];
      pathItems.push( data );
      
    }
  }
}
