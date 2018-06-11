package com.cyj.app.data.map
{
	public class ADKey
	{
		public function ADKey()
		{
		}
		
		/**
		 * 得到 A(动作)D(方向)的标识
		 * 
		 * @static
		 * @param {Number} action A(动作)标识
		 * @param {Number} direction D(方向)标识
		 * @returns {Number} A(动作)D(方向)的标识
		 */
		public static function get(action: Number, direction: Number): Number {
			return action << 8 | direction;
		}
		
		/**
		 * 从A(动作)D(方向)的标识中获取 A(动作)标识
		 * 
		 * @static
		 * @param {ADKey} adKey A(动作)D(方向)的标识
		 * @returns {Number} A(动作)标识
		 */
		public static function getAction(adKey: Number): Number {
			return adKey >> 8;
		}
		
		/**
		 * 从A(动作)D(方向)的标识中获取 D(方向)标识
		 * 
		 * @static
		 * @param {ADKey} adKey A(动作)D(方向)的标识
		 * @returns {Number} D(方向)标识
		 */
		public static function getDirection(adKey: Number): Number {
			return adKey & 0xff;
		}
		
	}
}