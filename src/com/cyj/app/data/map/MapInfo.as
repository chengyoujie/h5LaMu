package com.cyj.app.data.map
{
	import flash.utils.ByteArray;

	dynamic public class MapInfo
	{
		/**
		 * 图片扩展
		 */
		public static const ext = "jpg";
		public static const DefaultSize = 256;
		/**
		 * 地图唯一标识
		 */
		public var id: int;
		
		/**
		 * 地图路径
		 */
		public var path: String;
		
		/**
		 * 地图格子列数
		 */
		public var columns: int;
		
		/**
		 * 地图格子行数
		 */
		public var rows: int;
		
		/**
		 * 格子宽度
		 */
		public var gridWidth: int;
		
		/**
		 * 格子高度
		 */
		public var gridHeight: int;
		
		/**
		 * 地图像素宽度
		 */
		public var width: int;
		
		/**
		 * 地图像素高度
		 */
		public var height: int;
		
		/**
		 * 单张底图的宽度
		 */
		public var pWidth: int = DefaultSize;
		
		/**
		 * 单张底图的高度
		 */
		public var pHeight: int = DefaultSize;
		
		/**
		 * X轴最大图片坐标
		 * 000开始
		 */
		public var maxPicX: int;
		
		/**
		 * Y轴最大图片数量
		 * 000开始
		 */
		public var maxPicY: int;
		
//		public var getWalk?(x: int, y: int): int;
		
		/**
		 * 路径点信息 低版本WebView不支持 ArrayBuffer
		 */
		public var pathdata: ByteArray;

		public var prefix:String;
		public var hasFar:*;
		
	}
}