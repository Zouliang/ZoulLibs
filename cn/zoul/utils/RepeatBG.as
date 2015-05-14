/*
	重复背景类
*/
package cn.zoul.utils
{
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.display.Sprite;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	
	public class RepeatBG extends Sprite
	{
		private var FillBitmap: BitmapData;
		private var matrix:Matrix = new Matrix();

		public function RepeatBG(fillBitmapDate: BitmapData){
			FillBitmap = fillBitmapDate;
			this.addEventListener(Event.ADDED_TO_STAGE, onAddToStage);
		}

		private function onAddToStage(evt:Event):void{
            
           	this.stage.addEventListener(Event.RESIZE, resizeHandler);
           	resizeHandler();
		}

		private function resizeHandler(evt:Event = null):void{

			var StageWidth:Number = this.stage.stageWidth;
			var StageHeight:Number = this.stage.stageHeight;
			RedrawBG(0, 0, StageWidth, StageHeight);

		}

		private function RedrawBG(x:Number, y:Number, width:Number, height:Number){

			this.graphics.beginBitmapFill(FillBitmap, matrix, true);
            this.graphics.drawRect(x, y, width, height);
            this.graphics.endFill();

		}

	}
}