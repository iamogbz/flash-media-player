package Playlist {
	
	public class PlaylistEvent extends CustomEvent{
		
		public static const ADDED:String = new String("added");
		public static const CHECKED:String = new String("checked");
		public static const DELETE:String = new String("delete");
		public static const EMPTY:String = new String("empty");
		public static const INCORRECT_FORMAT:String = new String("incorrect_format");
		public static const LOADED:String = new String("loaded");
		public static const NOT_EXISTING:String = new String("not_existing");
		public static const PAUSE:String = new String("pause");
		public static const PLAY:String = new String("play");
		public static const NEXT:String = new String("next");
		public static const PREVIOUS:String = new String("previous");
		public static const READY:String = new String("ready");
		public static const REORDERING:String = new String("reordering");
		public static const RESIZING:String = new String("resizing");
		public static const STOP:String = new String("stop");
		public static const UNCHECKED:String = new String("unchecked");
		public static const UPDATE:String = new String("update");
		
		public function PlaylistEvent(type:String, secondaryTarget:Object = null) {
			super(type, secondaryTarget);
		}

	}
	
}
