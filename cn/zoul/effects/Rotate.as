/*

Class for scripted rotation tweening

*/


package cn.zoul.effects
{
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.display.DisplayObject;
	
	public class Rotate
	{
		private static var moveList: Array =  new Array();
		
		private static var timer: Timer = new Timer(33);
		timer.start();
		timer.addEventListener(TimerEvent.TIMER, runRotate);
		
		// this is the function used to start the tween, such as Rotate.to(this, 45, 6);
		// that will rotate to 45 degrees
		public static function to(obj:DisplayObject, R:Number, ease:int = 10) : void
		{
			removeDuplicates(obj);
			
			moveList.push(new Array(obj, R, ease));
		}
		
		// if there is an active tween on the object, this will kill it
		public static function killRotate(obj: DisplayObject) : void
		{
			removeDuplicates(obj);
		}
		
		private static function runRotate(event:TimerEvent) : void
		{
			var removeList: Array = new Array();
			
			var total:int = moveList.length;
			for (var i: int = 0; i < total; i++)
			{
				var obj:DisplayObject = moveList[i][0];
				var goal:Number = moveList[i][1];
				var ease:int = moveList[i][2];
				var current:Number = obj.rotation;

				
				if (current > goal-1 && current < goal+1)
				{
					removeList.push(i);
					continue;
				}
				
				var R: Number = current - ((current - goal) / ease);
				
				obj.rotation = R;
			}
			
			total = removeList.length;
			removeList.sort(Array.NUMERIC);
			removeList.reverse();
			for (i = 0; i < total; i++)
				moveList.splice(removeList[i], 1);
		}
		
		private static function removeDuplicates(obj:DisplayObject) : void
		{
			var total:int = moveList.length;
			for (var i: int = 0; i < total; i++)
			{
				if (moveList[i][0] as DisplayObject == obj)
				{
					moveList.splice(i, 1);
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