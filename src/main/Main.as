/**
 * User: Bob Dahlberg
 * Date: 2012-06-13
 * Time: 14:01
 */
package
{
	import com.boblu.crib.Crib;
	import com.boblu.crib.ICrib;

	import flash.display.Graphics;

	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;

	public class Main extends Sprite
	{
		private var _crib:ICrib;
		/**
		 * Constructor makes sure the application has stage before proceeding
		 */
		public function Main()
		{
			if( stage == null )
				addEventListener( Event.ADDED_TO_STAGE, init );
			else
				init();
		}

		/**
		 * Starting the application 
		 */
		private function init( e:Event = null ):void
		{
			trace( ".: Running crib example :." );
			
			_crib = new Crib();
			_crib.addInstance( stage, Stage );
			_crib.add( Renderer, Renderer );
			
			trace( "Renderer not initialized yet" );
			retrieveCrib();
		}
		
		private function retrieveCrib():void
		{
			var renderer:Renderer = _crib.require( Renderer );
			renderer.render( graphics );
		}
	}
}
