package com.cyj.app.data.lamu
{
	public class LaMuStepData
	{
		
		public static const CAMERA_OPER_PLAYER:int=0;
		public static const CAMERA_OPER_MOVE:int=1;
		public static const CAMERA_OPER_SKIP:int=2;
		public static const CAMERA_OPER_LAST:int=3;
			
		
		public var id:int;
		public var mapId:int;
		public var cameraOper:int;
		public var camerax:int;
		public var cameray:int;
		public var cameraMoveTime:int;
		public var name:String;//编辑器用   步骤的名字
		//场景对话剧情相关
		public var unitInfo:Vector.<LaMuUnitData> = new Vector.<LaMuUnitData>();
		
		
		public static const COORDINATE_SCREEN:int = 0;//屏幕坐标
		public static const COORDINATE_MAP:int = 1;//地图坐标
		
		
		public static const END_TYPE_CLICK_OR_TIME:int = 0;
		public static const END_TYPE_TIME:int = 1;
		public static const END_TYPE_CLICK:int = 2;
		public static const END_TYPE_EVENT:int = 3;
		
		//add new 
		public var coordinateType:int = 0;
		public var endType:int = 0;
		public var endParam:*;
		public var showBorder:Boolean = false;
		public var showUI:Boolean = false;
		public var showOther:Boolean = false;
		public var centerMapX:int;//编辑器用   当前显示的中心点坐标X（地图坐标)
		public var centerMapY:int;//编辑器用   当前显示的中心点坐标Y（地图坐标)
		
		public function LaMuStepData()
		{
		}
	}
}