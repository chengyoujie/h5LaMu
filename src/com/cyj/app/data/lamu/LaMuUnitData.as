package com.cyj.app.data.lamu
{
	public class LaMuUnitData
	{
		public var name:String;
		public var ucloth:String;
		public var upst:String;
		public var uweapon:String;
		public var uwing:String;
		public var umount:String;
		public var say:String;
		public var face:int;
		public var action:int;
		public var x:int;
		public var y:int;
		public var tox:int;
		public var toy:int;
		public var moveTime:int;
		
		
		//add later
		public static const RES_TYPE_NPC:int = 0;
		public static const RES_TYPE_MONSTER:int= 1;
		public static const RES_TYPE_ROLE:int= 2;
		public static const RES_TYPE_PAK:int = 3;
		public static const RES_TYPE_ANI:int = 4;
		public static const RES_TYPE_OTHER:int = 5;
		
		public static const OPER_TYPE_NONE:int = 0;
		public static const OPER_TYPE_MOVE:int = 1;
		public static const OPER_TYPE_JUMP:int = 2;
		
		public var resType:int = 0;
		public var resParam:* = -1;//编辑器中用到的字段
		public var rotation:Number = 0;
		public var operType:int = 0;
		public var jumpHeight:int;
		public var id:int;
		
		
		public var showFace:Boolean;
		public var faceLeft:Boolean;
		public var faceImg:String;
		
		
		public function LaMuUnitData()
		{
		}
	}
}