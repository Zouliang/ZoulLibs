/*

Class for scripted tweening of a property

*/


package cn.zoul.effects
{
	import flash.display.DisplayObject;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	
	public class Tween
	{
		private static var tweenList: Array =  new Array();
		
		private static var timer: Timer = new Timer(33);
		timer.start();
		timer.addEventListener(TimerEvent.TIMER, runTween);
		
		// this is the function used to start the tween, such as Tween.tween(this, "width", 100, 6);
		// that will tween the width to 100
		public static function tween(obj:DisplayObject, prop:String, to:Number, ease:int = 10) : void
		{			
			removeDuplicates(obj, prop);
			
			tweenList.push(new Array(obj, to, ease, prop));
		}
		
		// if there is an active tween on the object, this will kill it
		public static function killTween(obj:DisplayObject, prop:String) : void
		{
			removeDuplicates(obj, prop);
		}
		
		private static function runTween(event:TimerEvent) : void
		{
			var removeList: Array = new Array();
			
			var total:int = tweenList.length;
			for (var i: int = 0; i < total; i++)
			{
				var obj:DisplayObject = tweenList[i][0];
				var goal:Number = tweenList[i][1];
				var ease:int = tweenList[i][2];
				var prop:String = tweenList[i][3];
				var current:Number = obj[prop];
				
				if (current > goal-1 && current < goal+1)
				{
					removeList.push(i);
					continue;
				}
				
				obj[prop] = current - ((current - goal) / ease);
			}
			
			total = removeList.length;
			removeList.sort(Array.NUMERIC);
			removeList.reverse();
			for (i = 0; i < total; i++)
				tweenList.splice(removeList[i], 1);
		}
		
		private static function removeDuplicates(obj:DisplayObject, prop:String) : void
		{
			var total:int = tweenList.length;
			for (var i: int = 0; i < total; i++)
			{
				if (tweenList[i][3] as String == prop && tweenList[i][0] as DisplayObject == obj)
				{
					tweenList.splice(i, 1);
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