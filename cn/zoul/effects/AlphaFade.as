/*

Class for scripted alpha tweening

*/

package cn.zoul.effects
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	
	public class AlphaFade
	{
		private static var fadeList: Array =  new Array();
		private static var clearList: Array = new Array();
		
		private static var timer: Timer = new Timer(33);
		timer.start();
		timer.addEventListener(TimerEvent.TIMER, runFade);
		
		// this is the function used to start the tween, such as AlphaFade.fadeTo(this, .5, 6);
		// that will fade to .5 alpha
		public static function fadeTo(obj: DisplayObject, alpha: Number, ease: int = 10) : void
		{			
			removeDuplicates(obj as DisplayObject);
			
			fadeList.push(new Array(obj as DisplayObject, alpha, ease));
		}
		
		// this will fade the object out AND then remove it from the display list
		public static function fadeOut(obj: DisplayObject, ease: int = 10) : void
		{
			clearList.push(obj);
			fadeTo(obj, 0, ease);
		}
		
		// this sets an object to an alpha of 0, then fades it in
		public static function fadeIn(obj: DisplayObject, ease: int = 10) : void
		{
			obj.alpha = 0;
			fadeTo(obj, 1.01, ease);
		}
		
		// if there is an active tween on the object, this will kill it
		public static function killFade(obj: DisplayObject) : void
		{
			removeDuplicates(obj);
		}
		
		private static function runFade(event:TimerEvent) : void
		{
			var removeList: Array = new Array();
			
			var total:int = fadeList.length;
			for (var i: int = 0; i < total; i++)
			{
				var obj:DisplayObject = fadeList[i][0];
				var goal:Number = fadeList[i][1];
				var ease:int = fadeList[i][2];
				var current:Number = obj.alpha;
				
				if (current > goal-.01 && current < goal+.01)
				{
					obj.alpha = goal;
					removeList.push(i);
					var clearInt: int = clearList.indexOf(obj);
					if (clearInt != -1)
					{
						clearList.splice(clearInt, 1);
						if(obj.parent) obj.parent.removeChild(obj);
					}
					continue;
				}
				
				obj.alpha -= (current - goal) / ease;
			}
			
			total = removeList.length;
			removeList.sort(Array.NUMERIC);
			removeList.reverse();
			for (i = 0; i < total; i++)
				fadeList.splice(removeList[i], 1);
		}
		
		private static function removeDuplicates(obj:DisplayObject) : void
		{
			var total:int = fadeList.length;
			for (var i: int = 0; i < total; i++)
			{
				if (fadeList[i][0] as DisplayObject == obj)
				{
					fadeList.splice(i, 1);
					break;
				}
			}
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