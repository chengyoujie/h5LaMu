package com.cyj.utils.cmd
{
	import flash.desktop.NativeProcess;
	import flash.desktop.NativeProcessStartupInfo;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.filesystem.File;
	import flash.utils.ByteArray;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;

	/**
	 *用此命令需要设置 *-app.xml 中添加 <supportedProfiles>extendedDesktop</supportedProfiles>  <br/>
	 * 		CMDManager.startCmd();														<br/>
	 *		var parser:ICMDParser = new CMDStringParser();								<br/>
	 *		CMDManager.addParser(parser, handlePaser);									<br/>
	 * 		private function handlePaser(type:int, value:String):void					<br/>
	 * 		{																			<br/>
	 * 			trace(type+":"+value);													<br/>
	 * 		}																			<br/>
	 * @author cyj
	 * 
	 */	
	public class CMDManager
	{
		private static var nativeProcessStartupInfo:NativeProcessStartupInfo = new NativeProcessStartupInfo();
		private static var process:NativeProcess;
		private static var parserData:Vector.<CMDData>;
		public static const TYPE_OUTPUT:int = 0;
		public static const TYPE_ERROR:int = 1;
		
		public function CMDManager()
		{
		}
		
		public static function start(filePath:String):void
		{
			parserData = new Vector.<CMDData>();
			nativeProcessStartupInfo.executable = new File(filePath);
			process = new NativeProcess();
			process.addEventListener(ProgressEvent.STANDARD_ERROR_DATA, handleErrorData);
			process.addEventListener(IOErrorEvent.STANDARD_ERROR_IO_ERROR, handleIoError);
			process.addEventListener(IOErrorEvent.STANDARD_INPUT_IO_ERROR, handleIoError);
			process.addEventListener(IOErrorEvent.STANDARD_OUTPUT_IO_ERROR, handleIoError);
			process.addEventListener(ProgressEvent.STANDARD_OUTPUT_DATA, handleOutPutData);
			process.start(nativeProcessStartupInfo);
		}
		
		public static function startCmd():void
		{
			start("C:/Windows/System32/cmd.exe");
		}
		
		public static function stop():void
		{
			nativeProcessStartupInfo.executable = null;
			if(process)
			{
				process.removeEventListener(ProgressEvent.STANDARD_ERROR_DATA, handleErrorData);
				process.removeEventListener(IOErrorEvent.STANDARD_ERROR_IO_ERROR, handleIoError);
				process.removeEventListener(IOErrorEvent.STANDARD_INPUT_IO_ERROR, handleIoError);
				process.removeEventListener(IOErrorEvent.STANDARD_OUTPUT_IO_ERROR, handleIoError);
				process.removeEventListener(ProgressEvent.STANDARD_OUTPUT_DATA, handleOutPutData);
				process.closeInput();
				if(process.running)
					process.exit();
				parserData = null;
				process = null;
			}
		}
		
		public static function addParser(parser:ICMDParser, handle:Function):void
		{
			parserData.push(new CMDData(parser, handle));
		}
		
		public static function removeParser(handle:Function):CMDData
		{
			var index:int = -1;
			var parser:CMDData;
			for(var i:int=0; i<parserData.length; i++)
			{
				if(parserData[i].handle == handle)
				{
					index = i;
					parser = parserData[i];
					break;
				}
			}
			parserData.splice(i, 1);
			return parser;
		}
		
		private static function handleOutPutData(e:ProgressEvent):void
		{
			runParser(TYPE_OUTPUT, process.standardOutput);
		}
		
		private static function handleIoError(e:IOErrorEvent):void
		{
			trace("IOError");
		}
		
		private static function handleErrorData(e:ProgressEvent):void
		{
			runParser(TYPE_ERROR, process.standardError);
		}
		
		public static function runStringCmd(cmd:String, coding:String="gb2312"):void
		{
//			var byte:ByteArray = new ByteArray();
//			byte.writeUTFBytes(cmd);
//			process.standardInput.writeBytes(byte);
			process.standardInput.writeMultiByte(cmd+"\n", coding);
		}
		
		private static function runParser(type:int, data:IDataInput):void
		{
			var byte:ByteArray = new ByteArray();
			data.readBytes(byte);
			for(var i:int=0; i<parserData.length; i++)
			{
				parserData[i].exec(type, parserData[i].parser.parser(byte));
			}
		}
	}
}