package Media {
	
	public class MediaFileEvent extends CustomEvent{
		
		public static const NOT_EXISTING:String = new String("not_existing");
		public static const INCORRECT_FORMAT:String = new String("incorrect_format");
		public static const READY:String = new String("ready");
		public static const LOADED:String = new String("loaded");
		public static const UNLOADED:String = new String("unloaded");

		public function MediaFileEvent(type:String, secondaryTarget:Object = null) {
			super(type, secondaryTarget);
		}

	}
	
}
