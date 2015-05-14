package cn.zoul.gallery {

	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.display.Sprite;

	import com.greensock.*;
	import com.greensock.easing.*;
	import com.greensock.TweenLite;
	import com.greensock.plugins.TweenPlugin;
	import com.greensock.plugins.AutoAlphaPlugin;

	public class PictureFlow extends Sprite {

		private var pictures: Array;
		private var planes: Array;
		private var planesX: Array =new Array();

		private var picWidth: uint;
		private var picHeight: uint;

		private var sceneWidth: uint;
		private var sceneHeight: uint;

		private var centerX: Number;
		private var centerY: Number;

		private var oldMouseX: Number;
		private var oldMouseY: Number;

		private var currentItem: int;

		public var maxShowNum: uint = 7;
		public var ShowSpeed:Number = 0.3; // 变换的速度，单位：秒
		public var ScaleRate:Number = 0.1; //缩放比率的系数
		private var planeDistance: Number = 0;

		private var isDraging:Boolean;

		public function PictureFlow(width: uint = 0, height: uint = 0, sceneWidth: uint = 0, sceneHeight: uint = 0, pictures: Array = null) {
			// constructor code
			picWidth = width;
			picHeight = height;

			this.sceneWidth = sceneWidth;
			this.sceneHeight = sceneHeight;

			this.pictures = pictures;

			TweenPlugin.activate([AutoAlphaPlugin]);//要先注册才能使用autoAlpha ，在TweenLite.as中有说明

			this.addEventListener(Event.ADDED_TO_STAGE, init);
			this.addEventListener(Event.REMOVED_FROM_STAGE,destroyEvt);
		}

		public function init(evt: Event = null): void {
			planes = new Array();
			for (var i: int = 0; i < pictures.length; i++) {
				var plane: Sprite = new Sprite();
				addChild(plane);
				plane.addChild(pictures[i]);
				pictures[i].x = -picWidth / 2;
				pictures[i].y = -picHeight / 2;
				planes.push(plane);
				plane.addEventListener(MouseEvent.CLICK,onPlanClick);
			}

			planeDistance = sceneWidth / (maxShowNum - 1);

			currentItem = (pictures.length % 2 == 0) ? (pictures.length / 2 - 1) : ((pictures.length + 1) / 2 - 1);
			trace(currentItem, planeDistance);

			this.stage.addEventListener(MouseEvent.MOUSE_DOWN, downHandler);
			
			this.stage.addEventListener(MouseEvent.MOUSE_UP, upHandler);

			render();
		}

		private function onPlanClick(evt:MouseEvent):void{
			if(!isDraging){
				for (var i: int = 0; i < planes.length; i++) {
					if(evt.currentTarget == planes[i]){
						currentItem = i;
						render();
						break;
					}
				}
				
			}
			trace("CLICK:  isDraging=",isDraging);
			isDraging = false;
		}

		private function downHandler(evt:MouseEvent):void{			

			oldMouseX = evt.stageX;
			planesX.length = 0; //重置位置数组
			for (var i: int = 0; i < planes.length; i++) {
				planesX[i] = planes[i].x;
			}
			this.stage.addEventListener(MouseEvent.MOUSE_MOVE, moveHandler);
		}

		private function moveHandler(evt:MouseEvent):void{
			var mouseDistance = evt.stageX - oldMouseX;
			isDraging = false;
			if(Math.abs(mouseDistance)>5){
				isDraging = true;
			}
			for (var i: int = 0; i < planes.length; i++) {
				planes[i].x = planesX[i] + mouseDistance;
				if(Math.abs(planes[i].x)<=(planeDistance-30)){
					if(mouseDistance<0){
						currentItem = i;
					}else{
						currentItem = i==0?i:i-1;
					}					
				}
				for (var j: int = 0; j < planes.length; j++) {
					if(j<=currentItem){
						this.addChild(planes[j]);
					}else{
						this.addChildAt(planes[j],0);
					}
				}
				var picScale = 1 - Math.abs(planes[i].x) * (ScaleRate/planeDistance); //建立距离与缩放的相关性
				var picAlpha = (Math.abs(i - currentItem)>((maxShowNum-1)/2))?0:1;
				TweenLite.to(planes[i], ShowSpeed, {
					scaleX: picScale,
					scaleY: picScale,
					autoAlpha:picAlpha
				});
			}
			trace("MOVE:  isDraging=",isDraging);
		}

		private function upHandler(evt:MouseEvent):void{
			this.stage.removeEventListener(MouseEvent.MOUSE_MOVE, moveHandler);
			render();
			trace("UP:  isDraging=",isDraging);
		}

		private function destroyEvt(evt:Event):void{
			this.stage.removeEventListener(MouseEvent.MOUSE_DOWN, downHandler);
			this.stage.removeEventListener(MouseEvent.MOUSE_MOVE, moveHandler);
			this.stage.removeEventListener(MouseEvent.MOUSE_UP, upHandler);
		}


		private function render() {
			for (var i: int = 0; i < planes.length; i++) {
				//重排显示列表
				if(i<=currentItem){
					this.addChild(planes[i]);
				}else{
					this.addChildAt(planes[i],0);
				}
				
				var picX = planeDistance * (i - currentItem);
				var picScale = 1 - Math.abs(picX) * (ScaleRate/planeDistance); //建立距离与缩放的相关性
				var picAlpha = (Math.abs(i - currentItem)>((maxShowNum-1)/2))?0:1;
				TweenLite.to(planes[i], ShowSpeed, {
					x: picX,
					scaleX: picScale,
					scaleY: picScale,
					autoAlpha:picAlpha
				});
			}
		}

	}

}