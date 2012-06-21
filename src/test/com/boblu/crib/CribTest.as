/**
 * User: Bob Dahlberg
 * Date: 2012-02-23
 * Time: 09:33
 */
package com.boblu.crib
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import org.hamcrest.assertThat;
	import org.hamcrest.core.not;
	import org.hamcrest.object.IsInstanceOfMatcher;
	import org.hamcrest.object.equalTo;
	import org.hamcrest.object.nullValue;

	public class CribTest
	{
		private var _crib:CribExtended;
		private var _instance:ICribMockImplementation;
		
		[Before] public function setUp():void
		{
			_crib = new CribExtended();
			_crib.add( CribMockImplementation, ICribMockImplementation );
		}

		[After] public function tearDown():void
		{
			_crib = null;
			_instance = null;
		}


		[Test(description="Forcing an object to be initialized.")]
		public function testForceInit():void
		{
			assertThat( _crib.instanceMapLength, equalTo( 0 ) );
			_crib.forceInit( ICribMockImplementation );
			assertThat( _crib.instanceMapLength, equalTo( 1 ) );
		}
		
		[Test(description="Make sure that it's the same instance that is delivered each time require is used.")]
		public function testRequireDeliversSame():void
		{
			assertThat( _instance, nullValue() );
			_instance = _crib.require( ICribMockImplementation );
			
			assertThat( _instance, new IsInstanceOfMatcher( CribMockImplementation ) );
			assertThat( _instance, equalTo( _crib.require( ICribMockImplementation ) ) );
			
			_crib.require( ICribMockImplementation );
			_crib.require( ICribMockImplementation );
			_crib.require( ICribMockImplementation );
			_crib.require( ICribMockImplementation );
			
			assertThat( _instance, equalTo( _crib.require( ICribMockImplementation ) ) );
		}
		
		[Test(description="Test that only one representation of each 'Marker' can be used in one particular crib-instance.")]
		public function testFailMultipleConnections():void
		{
			var errorIsThrown:Boolean = false;
			try
			{
				_crib.add( Sprite, ICribMockImplementation );
			}
			catch( e:Error )
			{
				assertThat( e.message, equalTo( "Can't map an Alias/Interface to more than one implementation" ) );
				errorIsThrown = true;
			}
			assertThat( errorIsThrown, equalTo( true ) );
		}

		[Test(description="Testing to create multiple instances of the same implementation with different 'Markers'.")]
		public function testAddMultipleImplementations():void
		{
			_crib = null;
			_crib = new CribExtended();
			_crib.add( CribMockImplementation, ICribMockImplementation );
			_crib.add( CribMockImplementation, ICribMockImplementationTwo );
			_crib.add( CribMockImplementation, ICribMockImplementationThree );
			
			var instanceOne:ICribMockImplementation 		= _crib.require( ICribMockImplementation );
			var instanceTwo:ICribMockImplementationTwo 		= _crib.require( ICribMockImplementationTwo );
			var instanceThree:ICribMockImplementationThree 	= _crib.require( ICribMockImplementationThree );
			
			assertThat( instanceOne, not( equalTo( instanceTwo ) ) );
			assertThat( instanceOne, not( equalTo( instanceThree ) ) );
			assertThat( instanceTwo, not( equalTo( instanceThree ) ) );
		}

		[Test(description="Testing to add an already created instance to the crib.")]
		public function testAddInstance():void
		{
			var instance:Sprite = new Sprite();
			_crib.addInstance( instance, Sprite );
			assertThat( instance, equalTo( _crib.require( Sprite ) ) );
		}

		[Test(description="Testing that each instance is handled separately.")]
		public function testAddMultipleInstanceOfSame():void
		{
			var instance:Sprite = new Sprite();
			var secondInstance:Sprite = new Sprite();

			_crib.addInstance( instance, Sprite );
			_crib.addInstance( secondInstance, DisplayObjectContainer );

			assertThat( instance, equalTo( _crib.require( Sprite ) ) );
			assertThat( secondInstance, equalTo( _crib.require( DisplayObjectContainer ) ) );
		}

		[Test(description="Test that when an already created instance is added, it also get notified about the crib if it implements ICribHost.")]
		public function testCribDecoratesCribHosts():void
		{
			var lazyInstance:CribMockImplementation;
			var instance:CribMockImplementation = new CribMockImplementation();
			
			assertThat( instance.crib, equalTo( null ) );
			_crib.addInstance( instance, Sprite );
			
			lazyInstance = _crib.require( ICribMockImplementation );
			
			assertThat( instance.crib, equalTo( _crib ) );
			assertThat( lazyInstance.crib, equalTo( _crib ) );
		}

		[Test(description="That init is only called once per instance.")]
		public function testInitialization():void
		{
			var mock:CribMockImplementation;
			mock = _crib.require( ICribMockImplementation );
			assertThat( mock.initCount, equalTo( 1 ) );
			mock = _crib.require( ICribMockImplementation );
			mock = _crib.require( ICribMockImplementation );
			mock = _crib.require( ICribMockImplementation );
			assertThat( mock.initCount, equalTo( 1 ) );
		}
	}
}
