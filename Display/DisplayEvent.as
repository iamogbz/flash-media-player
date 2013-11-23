package Display {
	
	public class DisplayEvent extends CustomEvent{
		
		public static const FULL_SCREEN:String = new String("fullscreen");
		public static const PAUSE:String = new String("pause");
		public static const PLAY:String = new String("play");
		public static const READY:String = new String("ready");
		public static const COMPLETE:String = new String("complete");
		public static const RESIZING:String = new String("resizing");
		public static const STOP:String = new String("stop");
		public static const NORMAL:String = new String("normal");
		public static const UPDATE:String = new String("update");
		
		public function DisplayEvent(type:String, secondaryTarget:Object = null) {
			super(type, secondaryTarget);
		}

	}
	
}
