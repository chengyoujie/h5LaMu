package com.cyj.app.config
{
	import flash.filesystem.File;

	public class ToolsConfig
	{
		
		public var title:String;
		public var appName:String;
		public var version:String;
		
		public var projectpath:String;
		public var versionconfig:String;
		
		private var _logpath:String;
		public function set logpath(value:String):void
		{
			_logpath = value;
			_logpath = _logpath.replace(/\$apppath/gi, File.applicationDirectory.nativePath+"/");
		}
		public function get logpath():String
		{
			return _logpath;
		}
		
		

		public function ToolsConfig()
		{
		}
	}
}