package whirlpower.uniqueshape.items.primitive
{
  import whirlpower.uniqueshape.data.*;
  import flash.display.Shape;
  
  public class Clover extends ShapeSouce
  {
    public function Clover():void
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
        new BP( 19.587, -10.322, 17.505, -10.322, 29.853, -10.322 ),
        new BP( 13.64, -9.333, 16.702, -12.646, 15.51, -9.965 ),
        new BP( 18.588, -21.931, 18.588, -32.194, 18.588, -17.062 ),
        new BP( 0.001, -40.518, -10.264, -40.518, 10.267, -40.518 ),
        new BP( -18.586, -21.931, -18.586, -17.062, -18.586, -32.194 ),
        new BP( -13.637, -9.332, -15.507, -9.964, -16.699, -12.646 ),
        new BP( -19.587, -10.322, -29.851, -10.322, -17.503, -10.322 ),
        new BP( -38.174, 8.265, -38.174, 18.531, -38.174, -2.001 ),
        new BP( -19.587, 26.852, -12.314, 26.852, -29.851, 26.852 ),
        new BP( -2.981, 16.582, -3.968, 25.649, -6.035, 22.667 ),
        new BP( -13.964, 40.001, -13.964, 40.001, -6.679, 40.001 ),
        new BP( 13.667, 40.001, 6.693, 40.001, 13.667, 40.001 ),
        new BP( 2.756, 16.112, 5.717, 22.45, 3.844, 25.145 ),
        new BP( 19.587, 26.852, 29.853, 26.852, 12.13, 26.852 ),
        new BP( 38.174, 8.265, 38.174, -2.001, 38.174, 18.531 ),
      ];
      pathItems.push( data );
      
    }
  }
}
