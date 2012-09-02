package cn.zoul.loading{

	import flash.display.Sprite;
	import flash.display.Loader;
	import flash.display.Bitmap;
	import flash.net.URLRequest;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import cn.zoul.BatchLoaderEvent;

	public class BatchLoader extends Sprite {

		// Constants:
		// Public Properties:
		// Private Properties:

		// Initialization:
		private var _loadIndex:int = new int  ;// 记录当前批量载入的序号
		private var _objArr:Array = new Array  ;// 需要批量载入的对象数组
		private var _urlArr:Array = new Array  ;// 批量载入的地址
		private var _loader:Loader = new Loader  ;// 装载工
		private var _loadType:int = new int(0);// 装载的类型代号，0为Bitmap（暂为0，待加）
		private var _stop:Boolean = new Boolean;  //批量载入的中断开关


		public function BatchLoader(loadType:int=0) {
			if (loadType is int) {
				_loadType = loadType;
				_loadIndex = 0;
				_urlArr.length = 0;
				_objArr.length = 0;
			} else {
				trace("初始化类型错误！");
			}
		}

		// Public Methods:
		// Protected Methods:
		// 添加一个加载项
		public function addOne(_loadObject,_loadUrl) {
			_objArr.push(_loadObject);
			_urlArr.push(_loadUrl);
		}

		public function start() {
			
			_stop = false; //设置标记为不停止批量装载
			_loader.contentLoaderInfo.addEventListener(Event.INIT,this.onComplete);
			this.allLoad(_objArr,_urlArr);
			
		}
		
		public function stop(){
			
			_stop = true; //设置批量转载参数停止，在异步循环载入时会判断是否停止
			
		}

		public function set loadType(_type:int) {
			_loadType = _type;
		}

		public function get loadType() {
			return _loadType;
		}

		// 载入完成，清空重置,移除载入事件监听，并把批量载入完成事件加入系统监听循环
		private function clear() {
			_loader.contentLoaderInfo.removeEventListener(Event.INIT,this.onComplete);
			_loadIndex = 0;
			_urlArr.length = 0;
			_objArr.length = 0;
			//var _BatchLoaderEvent:BatchLoaderEvent = new BatchLoaderEvent(BatchLoaderEvent.LOAD_COMPLETE);
			//_BatchLoaderEvent.message = "Batch load complete!";
			var _BatchLoaderEvent:Event = new Event(Event.COMPLETE);
			this.dispatchEvent(_BatchLoaderEvent);
		}

		private function allLoad(_ArrObj:Array,_ArrUrl:Array) {
			if (_loadIndex < _ArrObj.length) {
				_loader.load(new URLRequest(_ArrUrl[_loadIndex]));
			}
		}

		private function onComplete(event:Event) {
			if (_loader.content != null  && !_stop) {
				if (_loadType == 0) {
					//严谨编译模式下需要显示转换数据类型
					_objArr[_loadIndex].bitmapData = Bitmap(_loader.content).bitmapData;
					_objArr[_loadIndex].smoothing = true;
					_loadIndex++;
					this.dispatchEvent(new BatchLoaderEvent(BatchLoaderEvent.LOAD_PERCENT,_loadIndex/_objArr.length));
				}
			}
			if (_loadIndex < _objArr.length && !_stop) {
				this.allLoad(_objArr,_urlArr);
			} else {
				this.clear();
			}
		}


	}

}