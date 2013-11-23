package  {
	import flash.events.Event;
	
	public class CustomEvent extends Event{
		
		public static const UPDATE:String = new String("update");
		public static const NOT_EXISTING:String = new String("not_existing");
		public static const LOADED:String = new String("loaded");
		
		protected var primaryTarget:Object;
		protected var secondaryTarget:Object;

		public function CustomEvent(type:String, secondaryTarget:Object = null) {
			super(type);
			this.primaryTarget = currentTarget;
			this.secondaryTarget = secondaryTarget;
		}
		
		public function getPrimaryTarget():Object{
			return this.primaryTarget;
		}
		public function getSecondaryTarget():Object{
			return this.secondaryTarget;
		}

	}
	
}
