package Player {
	
	public class PlayerEvent extends CustomEvent{
		
		public static const CHECKED:String = new String("checked");
		public static const PAUSE:String = new String("pause");
		public static const PLAY:String = new String("play");
		public static const READY:String = new String("ready");
		public static const RESIZING:String = new String("resizing");
		public static const STOP:String = new String("stop");
		public static const UNCHECKED:String = new String("unchecked");
		public static const UPDATE:String = new String("update");
		
		public function PlayerEvent(type:String, secondaryTarget:Object = null) {
			super(type, secondaryTarget);
		}

	}
	
}
