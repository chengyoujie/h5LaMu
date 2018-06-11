package com.cyj.utils
{
	
	import com.cyj.app.ToolsApp;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import morn.core.components.Label;
	

	public class Log
	{
		private static var _log:String = "";
		public function Log()
		{
		}
		
		public static function alert(value:String):void
		{
			trace("Alert::"+value);
			_log += "[提示]"+value+"\r\n"; 
			if(_logTxt)
				_logTxt.text = value+"";
		}
		
		public static function error(value:String):void
		{
			trace("Error::"+value);
			_log += "[错误]"+value+"\r\n";
			if(_logTxt)
				_logTxt.text = value+"";
		}
		
		private static var _refushEvent:Event = new Event(Event.RENDER);
		private static var _delayMarkTimeId:int = 0;
		public static function log(value:String):void
		{
			trace("Log::"+value);
			if(_logTxt)
			{
				_logTxt.text = value+"";
				_logTxt.dispatchEvent(_refushEvent);
			}
			_log += "[记录]"+value+"\r\n";
			if(_delayMarkTimeId == 0)
				_delayMarkTimeId = setTimeout(refushLog, 5000);
		}
		
		public static function refushLog():void
		{
			if(_delayMarkTimeId)
				clearTimeout(_delayMarkTimeId);
			_delayMarkTimeId = 0;
			ToolsApp.file.saveFile(ToolsApp.config.logpath, content);
		}
		
		public static function get content():String
		{
			return _log;
		}
		
		public static function clear():void
		{
			_log = "";
		}
		
		private static var _logTxt:Label;
		public static function init(stage:DisplayObjectContainer, x:Number=11, y:Number=780, w:int=370, h:int=19, color:int=0xff0000):void
		{
			_logTxt = new Label();
			stage.addChild(_logTxt);
			_logTxt.x = x;
			_logTxt.y = y;
			_logTxt.width = w;
			_logTxt.height = h;
			_logTxt.color = color;
//			_logTxt.stroke = 0+"";
		}
		
		public static function initLabel(label:Label):void
		{
			_logTxt = label;
		}
								   
	}
}