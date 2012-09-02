/*

This creates an animated visual rotator display object

*/

package cn.zoul.display
{
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	public class Rotator extends Sprite
	{
		private var holder: Sprite
		
		public function Rotator(fill: uint = 0x666666, scale: Number = 1) : void
		{
			var n:Number = 0;
			holder = new Sprite();
			for (var i: int = 0; i < 10; i++)
			{
				var pc: RotatorComponent = new RotatorComponent(fill);
				pc.rotation = n;
				pc.alpha = i * .1;
				n += 36;
				holder.addChild(pc);
			}
			holder.scaleX = holder.scaleY = scale;
			addChild(holder);
			
			start();
		}
		
		public function start() : void
		{
			addEventListener(Event.ENTER_FRAME, update);
		}
		
		public function stop() : void
		{
			removeEventListener(Event.ENTER_FRAME, update);
		}
		
		private function update(event: Event) : void
		{
			holder.rotation += 15;
		}
	}
}

import flash.display.Shape;

internal class RotatorComponent extends Shape
{
	public function RotatorComponent(color:uint) : void
	{
		graphics.beginFill(color);
		graphics.moveTo(0, 10);
		graphics.curveTo(-3, 10, -3, 15);
		graphics.lineTo(-6, 20);
		graphics.curveTo(-6, 20, 0, 25);
		graphics.curveTo(6, 20, 6, 20);
		graphics.lineTo(3, 15);
		graphics.curveTo(3, 10, 0, 10);
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