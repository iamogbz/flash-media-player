package Notice  {
	
	import flash.display.MovieClip;
	import flash.filters.DropShadowFilter;
	
	
	public class NoticeControl extends MovieClip {
		
		public function NoticeControl() {
			this.filters = [new DropShadowFilter(0,0,0,.1,10,10,1,10,true)];
		}
		
	}
	
}
