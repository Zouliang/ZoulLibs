/*

This class is for handling fluid screen movement of flash GUI objects.

*/

package cn.zoul.utils
{
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	
	public class FluidScreen
	{
		private static var stg: Stage;
		private static var _staticWatch: Array = new Array();
		private static var _tempWatch: Array = new Array();
		
		// You MUST set the stage property to Flash's stage
		public static function set stage(s: Stage) : void
		{
			stg = s;
			stg.scaleMode = StageScaleMode.NO_SCALE;
			stg.align = StageAlign.TOP_LEFT;
			s.addEventListener(Event.RESIZE, resizeHandler);
		}
		
		// this will manually dispatch the resizing
		public static function resize() : void
		{
			resizeHandler(null);
		}
		
		// will add an item to the static watch list
		public static function staticWatch(obj: Object) : void
		{
			_staticWatch.push(obj);
		}
		
		// will add an item to the temporary watch list
		public static function tempWatch(obj: Object) : void
		{
			_tempWatch.push(obj);
		}
		
		// will clear the temporary watch list
		public static function purge() : void
		{
			_tempWatch = new Array();
		}
		
		// will clear all watch lists
		public static function clearAll() : void
		{
			_tempWatch = new Array();
			_staticWatch = new Array();
		}
		
		// PRIVATE --------
		
		private static function resizeHandler(event: Event) : void
		{
			var obj: Object;
			var pointer: DisplayObject;
			var prop: Number;
			
			var length:int = _staticWatch.length;
			
			for (var i:int = 0; i < length; i++)
			{
				obj = _staticWatch[i] as Object;
				pointer = obj.value as DisplayObject;
				
				prop = obj.x;
				if (!isNaN(prop))
					 evalX(pointer, prop);
				
				prop = obj.y;
				if (!isNaN(prop))
					 evalY(pointer, prop);
						
				prop = obj.width;
				if (!isNaN(prop))
					 evalW(pointer, prop);
						
				prop = obj.height;
				if (!isNaN(prop))
					 evalH(pointer, prop);
						
				prop = obj.scaleX;
				if (!isNaN(prop))
					evalSX(pointer, prop);
					 
				prop = obj.scaleY;
				if (!isNaN(prop))
					evalSY(pointer, prop);

				prop = obj.centerX;
				if (!isNaN(prop))
					centerX(pointer, prop);

				prop = obj.centerY;
				if (!isNaN(prop))
					centerY(pointer, prop);

				prop = obj.fitIn;
				if (!isNaN(prop))
					fitIn(pointer, prop);

				prop = obj.fitOut;
				if (!isNaN(prop))
					fitOut(pointer, prop);
				
				//可视对象注册点不在几何中心时的居中
				prop = obj.objCenterX;
				if (!isNaN(prop))
					objCenterX(pointer, prop);
				
				prop = obj.objCenterY;
				if (!isNaN(prop))
					objCenterY(pointer, prop);
			}
			
			length = _tempWatch.length;
			
			for (i = 0; i < length; i++)
			{
				obj = _tempWatch[i] as Object;
				pointer = obj.value as DisplayObject;
				
				prop = obj.x;
				if (!isNaN(prop))
					 evalX(pointer, prop);
				
				prop = obj.y;
				if (!isNaN(prop))
					 evalY(pointer, prop);
						
				prop = obj.width;
				if (!isNaN(prop))
					 evalW(pointer, prop);
						
				prop = obj.height;
				if (!isNaN(prop))
					 evalH(pointer, prop);
						
				prop = obj.scaleX;
				if (!isNaN(prop))
					evalSX(pointer, prop);
					 
				prop = obj.scaleY;
				if (!isNaN(prop))
					evalSY(pointer, prop);

				prop = obj.centerX;
				if (!isNaN(prop))
					centerX(pointer, prop);

				prop = obj.centerY;
				if (!isNaN(prop))
					centerY(pointer, prop);

				prop = obj.fitIn;
				if (!isNaN(prop))
					fitIn(pointer, prop);

				prop = obj.fitOut;
				if (!isNaN(prop))
					fitOut(pointer, prop);
				
				//可视对象注册点不在几何中心时的居中
				prop = obj.objCenterX;
				if (!isNaN(prop))
					objCenterX(pointer, prop);
				
				prop = obj.objCenterY;
				if (!isNaN(prop))
					objCenterY(pointer, prop);
			}
		}
		
		private static function  evalX(obj: DisplayObject, def:Number) : void
		{
			obj.x = stg.stageWidth * def;
		}
		
		private static function  evalY(obj: DisplayObject, def:Number) : void
		{
			obj.y = stg.stageHeight * def;
		}
		
		private static function  evalW(obj: DisplayObject, def:Number) : void
		{
			obj.width = stg.stageWidth * def;
		}
		
		private static function  evalH(obj: DisplayObject, def:Number) : void
		{
			obj.height = stg.stageHeight * def;
		}
		
		private static function evalSX(obj: DisplayObject, def:Number) : void
		{
			obj.scaleX = obj.scaleY * def;
		}
		
		private static function evalSY(obj: DisplayObject, def:Number) : void
		{
			obj.scaleY = obj.scaleX * def;
		}

		private static function fitIn(obj: DisplayObject, def:Number) : void
		{
			//2012.09.02 Zoul.cn
			//def 表示（内）充满适应后的边距，数值为像素
			var objRate:Number = obj.width/obj.height;
			var stgRate:Number = stg.stageWidth/stg.stageHeight;
			if(objRate >= stgRate)
			{
				obj.width = stg.stageWidth - def*2;
				obj.scaleY = obj.scaleX;
				obj.x = def;
				obj.y = (stg.stageHeight - obj.height)/2;
			}
			else
			{
				obj.height = stg.stageHeight - def*2;
				obj.scaleX = obj.scaleY;
				obj.y = def;
				obj.x = (stg.stageWidth - obj.width)/2;
			}
			
		}

		private static function fitOut(obj: DisplayObject, def:Number) : void
		{
			//2012.09.02 Zoul.cn
			//def 表示（外）充满适应后的边距，数值为像素
			var objRate:Number = obj.width/obj.height;
			var stgRate:Number = stg.stageWidth/stg.stageHeight;
			if(objRate <= stgRate)
			{
				obj.width = stg.stageWidth - def*2;
				obj.scaleY = obj.scaleX;
				obj.x = def;
				obj.y = (stg.stageHeight - obj.height)/2;
			}
			else
			{
				obj.height = stg.stageHeight - def*2;
				obj.scaleX = obj.scaleY;
				obj.y = def;
				obj.x = (stg.stageWidth - obj.width)/2;
			}
			
		}

		private static function centerX(obj: DisplayObject, def:Number) : void
		{
			//def表示原始场景大小
			obj.x = (stg.stageWidth-def)/2;
		}

		private static function centerY(obj: DisplayObject, def:Number) : void
		{
			//def表示原始场景大小
			obj.y = (stg.stageHeight-def)/2;
		}
		
		private static function objCenterX(obj: DisplayObject, def:Number) : void
		{
			//def表示原始场景大小
			obj.x = stg.stageWidth/2 - def/2;
		}
		
		private static function objCenterY(obj: DisplayObject, def:Number) : void
		{
			//def表示原始场景大小
			obj.y = stg.stageHeight/2 - def/2;
		}

	}
}

/*

Copyright under the MIT open-source license to Bryan Grezeszak,
therefore cannot be re-sold, etc. But you may use it in your projects,
as long as you leave the commenting, and credits.

This class by Bryan Grezeszak | madbunny.us | bryan@madbunny.us

(\___/)
(='.'=) <------ Mad Bunny Skills
(")_(")

*/