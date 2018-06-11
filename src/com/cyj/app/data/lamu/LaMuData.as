package com.cyj.app.data.lamu
{
	import com.cyj.utils.ObjectUtils;

	public class LaMuData
	{
		public var data:Vector.<LaMuItemData>;//= new Vector.<LaMuItemData>();
		public var version:int;
		
		public function LaMuData()
		{
		}
		
		public function parserData(data:Object):void
		{
			ObjectUtils.copyObject(data, this);
		}
	}
}