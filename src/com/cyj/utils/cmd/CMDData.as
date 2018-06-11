package com.cyj.utils.cmd
{
	public class CMDData
	{
		public var parser:ICMDParser;
		public var handle:Function;
		public function CMDData($parser:ICMDParser, $handle:Function)
		{
			parser = $parser;
			handle = $handle;
		}
		
		public function exec(type:int, data:*):void
		{
			if(handle !=null)
			{
				handle.apply(this, [type, data]);
			}
		}
	}
}