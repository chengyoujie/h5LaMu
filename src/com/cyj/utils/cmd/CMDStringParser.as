package com.cyj.utils.cmd
{
	import flash.utils.ByteArray;

	public class CMDStringParser implements ICMDParser
	{
		public function CMDStringParser()
		{
		}
		
		public function parser(data:ByteArray):*
		{
			return data.readMultiByte(data.bytesAvailable, "gb2312");
		}
	}
}