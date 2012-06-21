/**
 * User: Bob Dahlberg
 * Date: 2012-02-24
 * Time: 07:35
 */
package com.boblu.crib
{
	import com.boblu.crib.ICribHost;

	public class CribMockImplementation implements ICribHost, ICribMockImplementation, ICribMockImplementationTwo, ICribMockImplementationThree
	{
		private var _crib:ICrib;
		private var _initCount:int = 0;

		public function set crib( value:ICrib ):void	{	_crib = value;	}
		public function get crib():ICrib				{	return _crib;	}

		public function init():void
		{
			_initCount++;
		}

		public function get initCount():int
		{
			return _initCount;
		}
	}
}
