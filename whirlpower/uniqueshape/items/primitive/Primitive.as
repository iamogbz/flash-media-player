// uniqueShape primitiveを手軽に使うクラス

package whirlpower.uniqueshape.items.primitive
{
	import flash.display.Shape;
    import whirlpower.uniqueshape.items.primitive.*;
	
	public class Primitive
	{
		public static function draw( type:String = "Circle", param:Object = null ):Shape
		{
			var shape = new Shape();
			
			switch( type )
			{
				case "Circle":
					shape = UsPrimitive_Circle.draw( param );
					break;
				case "Clover":
					shape = UsPrimitive_Clover.draw( param );
					break;
				case "Cross":
					shape = UsPrimitive_Cross.draw( param );
					break;
				case "Dire":
					shape = UsPrimitive_Dire.draw( param );
					break;
				case "FourStar":
					shape = UsPrimitive_FourStar.draw( param );
					break;
				case "Hart":
					shape = UsPrimitive_Hart.draw( param );
					trace( "[!]" );
					break;
				case "Hexagon":
					shape = UsPrimitive_Hexagon.draw( param );
					break;
				case "Pentagon":
					shape = UsPrimitive_Pentagon.draw( param );
					break;
				case "Rectangle":
					shape = UsPrimitive_Rectangle.draw( param );
					break;
				case "SixStar":
					shape = UsPrimitive_SixStar.draw( param );
					break;
				case "Spade":
					shape = UsPrimitive_Spade.draw( param );
					break;
				case "Star":
					shape = UsPrimitive_Star.draw( param );
					break;
				case "Thorn":
					shape = UsPrimitive_Thorn.draw( param );
					break;
				case "Torus":
					shape = UsPrimitive_Torus.draw( param );
					break;
				case "Triangle":
					shape = UsPrimitive_Triangle.draw( param );
					break;
				case "Water":
					shape = UsPrimitive_Water.draw( param );
					break;
				default:
					shape = UsPrimitive_Circle.draw( param );
			}
			return shape;
		}
	}
}