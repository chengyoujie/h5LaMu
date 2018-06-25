package com.cyj.app.data.lamu
{
	public class LaMuItemData
	{
		public var id:int;
		public var name:String;//编辑器中  
		public var type:int;
		public var value:*;
		public var steps:Vector.<LaMuStepData> = new Vector.<LaMuStepData>();
		
		//add later
		public static const TYPE_TASK:int =  0;
		public static const TYPE_LEVEL:int = 1;
		public static const TYPE_EVENT:int = 2;
		
		public static const TASK_ACCEPT:int = 0;
		public static const TASK_PROGRESS:int = 1;
		public static const TASK_COMPLETE:int = 2;
		
		
		public var value2:*;
		public var endSendEvent:String;
		
		public function LaMuItemData()
		{
		}
	}
}