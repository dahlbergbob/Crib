/**
 * User: Bob Dahlberg
 * Date: 2012-06-21
 * Time: 07:11
 */
package
{
	import com.boblu.crib.ICrib;
	import com.boblu.crib.ICribHost;
	import flash.display.Graphics;
	import flash.display.Stage;

	public class Renderer implements ICribHost
	{
		private var _crib:ICrib;
		
		public function set crib( value:ICrib ):void
		{
			_crib = value;
		}

		public function init():void
		{
			trace( "init of Renderer" );
		}

		public function render( graphics:Graphics ):void
		{
			/* Renderer doesn't have the stage reference itself but thanks to Crib it can require and use it. */
			var s:Stage = _crib.require( Stage );
			graphics.beginFill( 0xff0099 );
			graphics.drawRect( 0, 0, s.stageWidth, s.stageHeight );
			graphics.endFill();
		}
	}
}
