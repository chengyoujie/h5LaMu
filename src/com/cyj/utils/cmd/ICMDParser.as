package com.cyj.utils.cmd
{
	import flash.utils.ByteArray;

	public interface ICMDParser
	{
		function parser(data:ByteArray):*;
	}
}