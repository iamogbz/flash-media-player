package Visualisation.Particle {
	import flash.events.Event;
	
	public class ParticleEvent extends Event{
		
		public static const CREATE:String = new String("create");
		public static const DESTROY:String = new String("destroy");
		
		public function ParticleEvent(type:String){
			super(type);
		}
		
	}
	
}
