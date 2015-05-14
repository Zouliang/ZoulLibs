package cn.zoul.loading{

	import flash.events.Event;

	public class BatchLoaderEvent extends Event {

		// Constants:
		// Public Properties:
		// Private Properties:

		// Initialization:
		public static const LOAD_COMPLETE:String = "load_complete";
		public static const LOAD_PERCENT:String = "load_percent"; //批量载入的百分比
		private var _message:String;
		public var data:*;//空对象，留做扩展

		public function BatchLoaderEvent(type:String,DispatchObj:*=null){
		super(type);
		if (DispatchObj != null) {
			data = DispatchObj;
		}
	}
	// Public Methods:
	// Protected Methods:
	public function get message() {
		return _message;
	}
	public function set message(a:String) {
		_message = a;
	}
}

}