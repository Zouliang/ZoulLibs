/*

This makes a global static class that can be accessed from anywhere, so that the
stage can be accessed easily. Even though Flash AS3 documentation says the stage
object of every DisplayObject will reference the stage, what I have found is that
that is not always true, and this is rather helpfull.

*/

package cn.zoul.utils
{
	import flash.display.Stage;
	
	public class Global
	{
		public static var stage: Stage = null;
	}
}