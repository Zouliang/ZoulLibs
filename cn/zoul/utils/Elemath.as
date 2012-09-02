/*

This class is where I normally have a ton of complex math equations. Since
this thing only uses one, a random number generator, it is the only one
that I left in.

*/


package cn.zoul.utils
{
	public class Elemath
	{
		// will return a random integer between the two provided arguments
		public static function random(min: int = 1, max: int = 100) : int
		{
			return int(Math.random() * (max - min + 1)) + min;
		}
	}
}