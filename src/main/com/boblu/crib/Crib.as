/*
 * Crib 1.0
 * Copyright (C) 2012 Bob Dahlberg
 * 
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 */
package com.boblu.crib
{
	import flash.utils.Dictionary;

	/**
	 * Crib - Centralized housing of Resource and Inversion of control with lazy Binding
     */
    public class Crib implements ICrib
    {
		protected var _instanceMap:Dictionary;
		protected var _aliasMap:Dictionary;

		/** Constructs a new Crib */
        public function Crib()
        {
			initialize();
        }

		/** Initialization moved from constructor */
		private function initialize():void
		{
			_aliasMap = new Dictionary();
			_instanceMap = new Dictionary();
		}
		
		/**
		 * Add an implementation class and the aliases to connect to it.
		 * If the implementation class implements ICribHost it will receive a reference to this Crib and an init call when the instance is first required.
		 * @param implementation	The class that should be used to create the implementation later on.
		 * @param aliases			1 to N number of aliases that should be used to require the implementation.
		 */
		public function add( implementation:Class, ... aliases ):void
		{
			for each( var Alias:Class in aliases )
			{
				if( _aliasMap[Alias] != null )
					throw new Error( "Can't map an Alias/Interface to more than one implementation" );

				_aliasMap[Alias] = implementation;
			}
		}

		/**
		 * Add an instance of a class and the implementation and the aliases to connect to it.
		 * If the instance implements ICribHost it will receive a reference to this Crib and an init call when the instance is first required.
		 * @param instance	A specific instance of any class.
		 * @param aliases	1 to N number of aliases that should be used to require the instance
		 */
		public function addInstance( instance:*, ... aliases ):void
		{
			for each( var Alias:Class in aliases )
			{
				if( _aliasMap[Alias] != null )
					throw new Error( "Can't map an Alias/Interface to more than one implementation" );
				
				initializeInstance( Alias, instance );
			}
		}

		/**
		 * Require the instance mapped to the specific alias sent in.
		 * If the instance is not created yet this function first creates it and then returns it, all other requests for the same alias will be served with the same instance.
		 * @param 	alias	The alias that you would like to retrieve the implementation instance of.
		 * @return			The only instance created for this implementation (if it's only housed by this class).
		 */
        public function require( alias:Class ):*
        {
			var instance:* = _aliasMap[alias];
			
			if( instance == null )
				return null;
			
			if( _instanceMap[instance] == null )
			{
				var Implementation:Class = _aliasMap[alias];
				instance = initializeInstance( alias, new Implementation() );
			}
			
			return instance as alias;
        }
		
		/**
		 * Force initialization of classes mapped to tha aliases sent in.
		 * @param aliases	1 to N number of aliases to force initialization of.
		 */
        public function forceInit( ... aliases ):void
        {
            for each( var alias:Class in aliases )
            {
				require( alias );
            }
        }

		/**
		 * Maps all dependencies for the new instance and gives it a reference to it's crib if the implementation is a cribhost.
		 * @param 	alias
		 * @param 	instance
		 * @return	The newly mapped instance
		 */
		private function initializeInstance( alias:Class, instance:* ):*
		{
			_aliasMap[alias] = instance;
			_instanceMap[instance] = instance;
			if( instance is ICribHost )
			{
				ICribHost( instance ).crib = this;
				ICribHost( instance ).init();
			}
			return instance;
		}
    }
}
