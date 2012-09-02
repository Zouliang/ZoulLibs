/*

class for color tint tweens

*/

package cn.zoul.effects
{
	import flash.display.DisplayObject;
	import flash.geom.ColorTransform;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	
	public class ColorFade
	{
		private static var fadeList: Array =  new Array();
		
		private static var timer: Timer = new Timer(33);
		timer.start();
		timer.addEventListener(TimerEvent.TIMER, runFade);
		
		// this is the function used to start the tween, such as ColorFade.fadeTo(this, 0, 0xFF, 0xFF, 0xFF, 6);
		// that will fade to a white tint
		public static function fadeTo(obj:DisplayObject, strength:Number = 1, R:Number = NaN, G:Number = NaN, B:Number = NaN, ease:int = 8)
		{			
			var object: DisplayObject = obj as DisplayObject;
			var currentColors: ColorTransform = object.transform.colorTransform;
			
			if (isNaN(R))
				R = currentColors.redOffset;
			if (isNaN(G))
				G = currentColors.greenOffset;
			if (isNaN(B))
				B = currentColors.blueOffset;
				
			removeDuplicates(object);
				
			fadeList.push(new Array(object, R, G, B, ease, strength));
		}
		
		// same as fadeTo, except you can just give it a hex code uint such as ColorFade.fadeTo(this, 0, 0xFFFFFF, 6);
		public static function fadeHex(obj:*, strength:Number = 1, _hex:uint = 0x000000, ease:int = 8) : void
		{
			var R: Number, G: Number, B: Number;
			
			var hex: String = _hex.toString(16);
			
			while (hex.length < 6)
				hex = "0"+hex;
			
			R = new uint("0x"+hex.substr(0,2));
			G = new uint("0x"+hex.substr(2,2));
			B = new uint("0x"+hex.substr(4,2));
			
			fadeTo(obj, strength, R, G, B, ease);
		}
		
		// clears any tint
		public static function clear(obj:*, ease:int = 8) : void
		{
			fadeTo(obj, 1, 0, 0, 0, ease);
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
				var goalR:Number = fadeList[i][1];
				var goalG:Number = fadeList[i][2];
				var goalB:Number = fadeList[i][3];
				var ease:int = fadeList[i][4];
				var goalMult:Number = fadeList[i][5];
				
				var currentColors: ColorTransform = obj.transform.colorTransform;
				var currentR:Number = currentColors.redOffset;
				var currentG:Number = currentColors.greenOffset;
				var currentB:Number = currentColors.blueOffset;
				var currentMult:Number = currentColors.redMultiplier;
				
				var oldAlpha: Number = obj.alpha;
				if (currentR > goalR-5 && currentR < goalR+5 &&
					currentG > goalG-5 && currentG < goalG+5 &&
					currentB > goalB-5 && currentB < goalB+5 &&
					currentMult > goalMult-.01 && currentMult < goalMult+.01)
				{
					obj.transform.colorTransform = new ColorTransform(goalMult,goalMult,goalMult,1, goalR, goalG, goalB, 1);
					obj.alpha = oldAlpha;
					removeList.push(i);
					continue;
				}
				
				var nextR:Number = Math.round(currentR - (currentR - goalR) / ease);
				var nextG:Number = Math.round(currentG - (currentG - goalG) / ease);
				var nextB:Number = Math.round(currentB - (currentB - goalB) / ease);
				var nextMult:Number = currentMult - (currentMult - goalMult) / ease;
				
				obj.transform.colorTransform = new ColorTransform(nextMult,nextMult,nextMult,1, nextR, nextG, nextB);
				obj.alpha = oldAlpha;
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