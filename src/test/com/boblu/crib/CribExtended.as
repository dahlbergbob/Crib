/**
 * User: Bob Dahlberg
 * Date: 2012-02-24
 * Time: 15:02
 */
package com.boblu.crib
{
	import flash.utils.Dictionary;

	public class CribExtended extends Crib
	{
		public function get instanceMapLength():int
		{
			var i:int = 0;
			for each( var o:Object in _instanceMap )
			{
				i++;
			}
			return i;
		}
	}
}
