package cn.zoul.iOS
{
	import flash.display.Sprite;
	import flash.utils.getTimer;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import com.greensock.*;
	
	/**
	 * 2012.7.25
	 * @author zouliang
	 * 模拟苹果滑动界面的类，缓动库使用TweenLite
	 */
	public class AppleSlip extends Sprite
	{
		public var maskWidth:int = 640; //滑动一屏的宽度
		public var maskHeight:int = 480; //滑动一屏的高度
		public var initX:int = 0; //初始位置
		public var initY:int = 0;
		
		public var tweenTime:Number = 0.35; //缓动时间，单位：秒
		
		private var mouseXDown:Number; //鼠标按下去的场景坐标
		private var mouseXUp:Number;
		
		private var downTime:Number = 0; //鼠标按下去的时间
		private var upTime:Number = 0;
		
		private var oldX:Number;
		private var isEdge:Boolean;
		
		public var isClick:Boolean; //判断是点击还是滑动
		
		public function AppleSlip()
		{
			this.addEventListener(Event.ADDED_TO_STAGE, onStage);
		}
		
		private function onStage(evt:Event):void
		{
			initX = this.x; //原始位置
			this.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDownHandle);
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUpHandle); //滑动方向			
		}
		
		private function onMouseDownHandle(evt:MouseEvent):void
		{
			mouseXDown = stage.mouseX;
			downTime = getTimer();
			oldX = this.x;
			if (this.mask != null)
			{
				maskWidth = mask.width;
				maskHeight = mask.height;
			}
			stage.addEventListener(Event.ENTER_FRAME, onDragHandle);
		}
		
		private function onMouseUpHandle(evt:MouseEvent):void
		{
			var targetX:Number; //目标坐标点
			var moveSpeed:Number; //滑动的速度，当滑动速度大于某个值时直接划入下一个页面
			mouseXUp = stage.mouseX;
			upTime = getTimer();
			moveSpeed = (mouseXUp - mouseXDown) / (upTime - downTime);
			stage.removeEventListener(Event.ENTER_FRAME, onDragHandle);
			if ((Math.abs(moveSpeed) > 0.5) && (!isEdge) && Math.abs(mouseXUp - mouseXDown) < maskWidth / 2)
			{
				if (moveSpeed > 0)
				{
					
					targetX = initX + Math.round((this.x - initX) / maskWidth) * maskWidth + maskWidth; //向右移动，增加一格
					if (targetX > initX) {
						targetX = initX;
					}
					
				}
				else
				{
					
					targetX = initX + Math.round((this.x - initX) / maskWidth) * maskWidth - maskWidth; //向左移动，减少一格
					if (targetX < initX - (Math.ceil(this.width/maskWidth)-1)*maskWidth) {
						targetX = initX - (Math.ceil(this.width/maskWidth)-1)*maskWidth;
					}
					
				}
				//trace("高速移动", mouseXUp - mouseXDown);
				TweenLite.to(this, tweenTime, {x: targetX, y: this.y});
			}
			else
			{
				//trace("低速移动");
				targetX = initX + Math.round((this.x - initX) / maskWidth) * maskWidth;
				TweenLite.to(this, tweenTime, {x: targetX, y: this.y});
			}
			trace(this.x);
			//trace("MouseUP",(mouseXUp-mouseXDown)/(upTime-downTime),isEdge);
		}
		
		private function onDragHandle(evt:Event):void
		{
			if (stage.mouseX > mouseXDown)
			{
				//trace("向右拖动");
				isClick = false;
				if (this.x >= initX)
				{
					//trace("到达左边缘");
					isEdge = true;
					if ((this.x - oldX) < maskWidth / 3)
					{
						this.x = oldX + (stage.mouseX - mouseXDown) / 2;
					}
				}
				else
				{
					//trace("向右正常拖动");
					isEdge = false;
					this.x = oldX + (stage.mouseX - mouseXDown);
				}
			}
			else if (stage.mouseX < mouseXDown)
			{
				//trace("向左拖动");
				isClick = false;
				//trace((initX-this.x) - ((Math.ceil(this.width/maskWidth)-1)*maskWidth));
				if ((initX - this.x) >= ((Math.ceil(this.width / maskWidth) - 1) * maskWidth))
				{
					//trace("到达右边缘");
					isEdge = true;
					if ((oldX - this.x) < maskWidth / 3)
					{
						this.x = oldX + (stage.mouseX - mouseXDown) / 2;
					}
				}
				else
				{
					//trace("向左正常拖动");
					isEdge = false;
					this.x = oldX + (stage.mouseX - mouseXDown);
				}
			}
			else
			{
				//trace("未移动");
				isClick = true;
			}
		/*if ((stage.mouseX>mouseXDown) && ((initX - this.x) < 0) )//向右拖动并且在左边缘
		   {
		   //边缘拖拽不超过1/3
		   if ((this.x - oldX) < maskWidth / 3)
		   {
		   this.x = oldX + (stage.mouseX - mouseXDown) / 2;
		   }
		   if ((this.x - initX) > maskWidth / 3)
		   {
		   this.x = initX + maskWidth / 3;
		   }
		   trace("右拉");
		   }
		   else if((stage.mouseX<mouseXDown)  && (this.width - (initX - this.x) < maskWidth))
		   {
		   if ((oldX - this.x) < maskWidth / 3)
		   {
		   this.x = oldX + (stage.mouseX - mouseXDown) / 2;
		   }
		   if ((initX - this.x) > (this.width-(maskWidth *2 / 3)))
		   {
		   this.x = initX - this.width + maskWidth*2 / 3;
		   }
		   trace("左拉");
		   }else
		   {
		   this.x = oldX + (stage.mouseX - mouseXDown);
		   trace("中间");
		   }
		   if (((this.x - initX) < maskWidth)&&(this.x - initX)>0){
		   isEdge = true;
		   trace("左");
		   }else if (Math.abs(this.x - initX) > (this.width-maskWidth)) {
		   isEdge = true;
		   trace("右");
		   }else {
		   isEdge = false;
		   trace("中");
		 }*/
		}
		
		public function resizeTouchBG():void
		{
			//重新设定滑动容器的宽度
		}
	}
}