package com.cyj.app
{
	import com.cyj.app.config.LocalConfig;
	import com.cyj.app.config.ProjectConfig;
	import com.cyj.app.config.ToolsConfig;
	import com.cyj.app.data.ProjectData;
	import com.cyj.app.data.lamu.LaMuData;
	import com.cyj.app.view.AppView;
	import com.cyj.app.view.common.Alert;
	import com.cyj.app.view.ui.common.AlertUI;
	import com.cyj.utils.Log;
	import com.cyj.utils.ObjectUtils;
	import com.cyj.utils.XML2Obj;
	import com.cyj.utils.cmd.CMDManager;
	import com.cyj.utils.cmd.CMDStringParser;
	import com.cyj.utils.file.FileManager;
	import com.cyj.utils.ftp.SimpleFTP;
	import com.cyj.utils.load.LoaderManager;
	import com.cyj.utils.load.ResData;
	import com.cyj.utils.load.ResLoader;
	import com.cyj.utils.md5.MD5;
	
	import flash.desktop.Clipboard;
	import flash.desktop.ClipboardFormats;
	import flash.desktop.NativeApplication;
	import flash.desktop.NativeDragManager;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.NativeDragEvent;
	import flash.filesystem.File;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	import morn.core.components.CheckBox;
	import morn.core.events.UIEvent;
	
	public class ToolsApp
	{
		
		public static var view:AppView;
		public static var alertView:Sprite;
		public static var loader:LoaderManager = new LoaderManager();
		public static var file:FileManager = new FileManager();
		public static var config:ToolsConfig;
		public static var event:EventDispatcher = new EventDispatcher();
		public static var projectlist:Vector.<ProjectConfig> = new Vector.<ProjectConfig>();
		public static var curPorjectConfig:ProjectConfig;
		public static var curProjectData:ProjectData;
		public static var localCfg:LocalConfig = new LocalConfig();
		public static var lastSaveData:Object;
		
		public static var VERSION:String = "1.0.1";
		
		
		private static const BLOCK_AVATER_URL:String = "png.guidecomp.roleblock";
		public static var BLOCK_AVATER:BitmapData;
		
		public function ToolsApp()
		{
		}
		
		public static  function start():void
		{
			loader.loadManyRes(["res/assets/comp.swf", "res/assets/guidecomp.swf"], handleSwfLoaded, null, handleLoadError);
		}
		
		private static function handleSwfLoaded():void
		{
			view = new AppView();
			App.stage.addChild(view);
			
			alertView = new Sprite();
			App.stage.addChild(alertView);
			startDoDrag();
			exitAppEvent();
			
			BLOCK_AVATER = App.asset.getBitmapData(BLOCK_AVATER_URL);
			
			loader.loadSingleRes("res/config.xml", ResLoader.TXT, handleConfigLoaded, null, handleLoadError);
		}
		
		
		private static function handleConfigLoaded(res:ResData):void
		{
			XML2Obj.registerClass("toolsconfig", ToolsConfig);
			XML2Obj.registerClass("project", ProjectConfig);
			XML2Obj.registerClass("local", LocalConfig);
			config = XML2Obj.readXml(res.data) as ToolsConfig;
			VERSION = config.version;
			
			try{
				CMDManager.startCmd();
				CMDManager.addParser(new CMDStringParser(), handleCmdResult);
				
				CMDManager.runStringCmd("net use \\\\192.168.2.61 jie123456 /user:1137815160@qq.com");
			}catch(e:*){
//				Alert.show("当前不支持CMD命令行\n"+e);
			}
			loader.loadSingleRes(config.projectpath, ResLoader.TXT, handleProjectConfigLoaded, null, handleLoadError);
			App.stage.nativeWindow.title = config.title+"@"+VERSION;
		}
		
		private static function handleProjectConfigLoaded(res:ResData):void
		{
			
			var pros:XML = new XML(res.data);
			var plist:XMLList = pros.project;
			for(var i:int=0; i<plist.length(); i++)
			{
				projectlist.push(XML2Obj.readXml(plist[i]));
			}
			for(i=0; i<projectlist.length; i++)
			{
				projectlist[i].initVar();
			}
//			if(projectlist.length == 0)
//			{
//				Alert.show("当前没有配置任何项目，检查下配置"+res.resPath);
//			}else{
//				changeProject(projectlist[0]);
//			}
			loader.loadSingleRes("res/local.xml", ResLoader.TXT, handleLocalConfigLoaded, null, handleLoadError);
			
		}
		
		/**更新本地文件**/
		public static function loadNewRemoteData(project:ProjectConfig):void
		{
			var f:File = new File(project.jsoncopyto);
			if(f.exists)
				loader.loadSingleRes(f.url, ResLoader.TXT, handleLoadNewRemoteData, null, handleLoadError, project);
			else
				Alert.show("远程文件不存在"+project.jsoncopyto);
		}
		private static function handleLoadNewRemoteData(res:ResData):void
		{
			var project:ProjectConfig = res.param;
			if(project==null)return;
//			file.saveFile(project.path, res.data);//为了防止有些人操作失误先不保存
			Alert.show("更新完成");
			handleProjectLoaded(res);
		}
		
		
		public static function changeProject(project:ProjectConfig):void
		{
			_tempLocalParam = null;
			var f:File = new File(project.jsoncopyto);
			if(f.exists)
				loader.loadSingleRes(f.url, ResLoader.TXT, handleRemoteDataLoaded, null, handleLoadError, project);
			else
				Alert.show("远程文件不存在"+project.jsoncopyto);
		}
		
		private static function handleRemoteDataLoaded(res:ResData):void
		{
			var project:ProjectConfig = res.param;
			if(project==null)return;
			
			var f:File = new File(project.path);
			if(f.exists)
			{
				//加载本地的文件
				loader.loadSingleRes(project.path, ResLoader.TXT, handleLoaclConfigLoaded, null, handleLoadError,{remote:res.data,project:  project}, false);
			}else{
				file.saveFile(project.path, res.data);
				Alert.show("首次启动，系统自动配置完成");
				handleProjectLoaded(res);
			}
		}
		
		
		private static var _tempLocalParam:Object;
		private static function handleLoaclConfigLoaded(res:ResData):void
		{
			var remoteData:String = res.param.remote;
			var project:Object = res.param.project;
			_tempLocalParam = res;
			try{
				var rdata:Object = JSON.parse(remoteData);
				var cdata:Object = JSON.parse(res.data);
				if(ObjectUtils.checkIsSame(rdata, cdata)==false)
				{
					Alert.show("本地配置与远程配置不同， 是否使更新至最新?  慎重操作 ", "提示", Alert.ALERT_OK_CANCLE, handleUseLoalOrRemote, "更新", "取消", true);
				}else{
					res.param = project;
					_tempLocalParam = null;
					handleProjectLoaded(res);
				}
			}catch(e:*){
				Alert.show(e);
			}
		}
		
		private static function handleUseLoalOrRemote(del:int):void
		{
			if(_tempLocalParam==null)
			{
				Alert.show("当前没有可用数据");
				return;
				
			}
			var remoteData:String = _tempLocalParam.param.remote;
			var project:Object = _tempLocalParam.param.project;
			if(del == Alert.ALERT_OK)
			{
//				file.saveFile(project.path,remoteData);//为了防止有些人操作失误先不保存
				Alert.show("更新完成");
				_tempLocalParam.param = project;
				_tempLocalParam.data = remoteData;
				handleProjectLoaded(_tempLocalParam as ResData);
			}else{
				_tempLocalParam.param = project;
				handleProjectLoaded(_tempLocalParam as ResData);
			}
			_tempLocalParam = null;
		}
		
		
		
		private static function handleProjectLoaded(res:ResData):void
		{
			var json:Object;
			try{
				 json = JSON.parse(res.data);
			}catch(e:*){
				Alert.show("JSON格式错误"+res.resPath);
				return;
			}
			var data:LaMuData = new LaMuData();
			ObjectUtils.copyObject(json, data);
					
			
			curPorjectConfig = res.param;
//			trace(JSON.stringify(data));
			lastSaveData = new LaMuData();
			ObjectUtils.copyObject(data, lastSaveData);
			view.initPorject(data);
		}
		
		private static function handleLocalConfigLoaded(res:ResData):void
		{
			
			localCfg = XML2Obj.readXml(res.data) as LocalConfig;
			Log.initLabel(view.txtLog);
			view.initView();
			Log.log("系统启动成功");
			loader.loadSingleRes(config.versionconfig, ResLoader.TXT, handleVersionConfigLoaded, null, null);
		}
		private static var _catchCmd:String = "";
		private static function handleCmdResult(type:int, cmd:String):void
		{
			Log.log(cmd);
			_catchCmd += cmd;
		}
		
		private static var _versionInfo:Object;
		private static function handleVersionConfigLoaded(res:ResData):void
		{
			var versiontxt:String = res.data;
			var versionReg:RegExp = /[\n\r]*\[(.*?)\][\n\r]*/gi;
			var obj:Object= {};
			var arr:Array= versionReg.exec(versiontxt);
			var lastIndex:int = 0;
			var lastProp:String;
			while(arr)
			{
				if(lastProp)
				{
					obj[lastProp] = versiontxt.substring(lastIndex, versionReg.lastIndex-arr[0].length);
					lastIndex = versionReg.lastIndex;
				}
				lastProp = arr[1];
				lastIndex = versionReg.lastIndex;
				arr = versionReg.exec(versiontxt);
			}
			if(lastProp)
			{
				obj[lastProp] = versiontxt.substring(lastIndex, versiontxt.length);
			}
			_versionInfo = obj;
			if(obj.version != VERSION)
			{
				Alert.show("<font color='#FF0000'>当前版本<font color='#00FF00'>"+VERSION+"</font>最新版本:<font color='#00FF00'>"+obj.version+"</font></font>\n<p align='left'><font color='#FFFF00'>更新内容</font>\n"+obj.desc.replace(/\r\n/gi, "\n")+"</p>", "更新提醒", Alert.ALERT_OK_CANCLE, handleUpdateVersion, "更新", "暂不更新");
			}
			
		}
		
		
		private static function handleUpdateVersion(del:int):void
		{
			if(del == Alert.ALERT_OK)
			{
				if(_versionInfo)
				{
					file.openFile(handleSaveLastVersion, true, File.desktopDirectory.nativePath);
				}else{
					file.openDir("\\192.168.2.50\ftp\tool");
				}
			}
		}
		
		private static function handleSaveLastVersion(dir:String):void
		{
			if(_versionInfo==null)return;
			var url:String = _versionInfo.url;
			url=url.replace(/[\r\n]/gi, "");
			url = url.replace(/\//gi, "\\");
			var fileName:String;
			if(url.indexOf("\\")!=-1)
				fileName= url.substr(url.lastIndexOf("\\")+1);
			if(!fileName)
				fileName = "拉幕工具"+_versionInfo.version+".rar";
			var file:File = new File(url);
			if(file.exists)
				url = file.url;
			loader.loadSingleRes(url, ResLoader.BYT, handleSaveVersionFile, handleProgress, handleLoadError, dir+"/"+fileName,false);
			Log.log("开始加载"+url);
		}
		
		private static function handleSaveVersionFile(res:ResData):void
		{
			file.saveByteFile(res.param, res.data);
			Alert.show("更新完毕");
		}
		
		private static function handleProgress(res:ResData,  value:Number):void
		{
			Log.log("更新进度："+(value*100).toFixed(2)+"%");
		}
		
		
		public static function handleLoadError(res:ResData, msg:String):void
		{
//			Alert.show("资源加载错误"+res.resPath+"\nerror : "+res.param, "加载错误");
			Alert.show("资源加载错误"+res.resPath);
		}
		
		private static function startDoDrag():void
		{
			App.stage.addEventListener(NativeDragEvent.NATIVE_DRAG_ENTER, handleDragEnter);
			App.stage.addEventListener(NativeDragEvent.NATIVE_DRAG_DROP, handleDropEvent);
			App.stage.addEventListener(NativeDragEvent.NATIVE_DRAG_EXIT, handleDropExit);
		}
		
		private static function handleDragEnter(e:NativeDragEvent):void
		{
			var clipBoard:Clipboard = e.clipboard;
			if(clipBoard.hasFormat(ClipboardFormats.FILE_LIST_FORMAT))
			{
				NativeDragManager.acceptDragDrop(App.stage);
			}
		}
		
		private static  function handleDropEvent(e:NativeDragEvent):void
		{
			var clip:Clipboard = e.clipboard;
			if(clip.hasFormat(ClipboardFormats.FILE_LIST_FORMAT))
			{
				var arr:Array = clip.getData(ClipboardFormats.FILE_LIST_FORMAT) as Array;
				var file:File;
				for(var i:int=0; i<arr.length; i++)
				{
					file = arr[i];
					if(file.isDirectory==false)
					{
						var type:String = file.name.substr(file.name.lastIndexOf("."));
						if(type == ".dat")
						{
							
						}
					}
					//					trace("拖入文件"+file.name);
					//file.namefile.name.lastIndexOf(".")
				}
			}
		}
		
		private static  function handleDropExit(e:NativeDragEvent):void
		{
			//trace("Exit Drop");
		}
		
		private static function exitAppEvent():void
		{
			App.stage.nativeWindow.addEventListener(Event.CLOSING, handleCloseApp);
		}
		
		
		private static function handleCloseApp(e:Event):void
		{
			Log.log("退出系统");
			Log.refushLog();
			file.saveFile(File.applicationDirectory.nativePath+"/res/local.xml", XML2Obj.readObj(localCfg, "local"));
			
			
			
			if(checkProjectDataSave(saveAndExit, "保存并退出", "直接退出"))
			{
				//关闭
				App.stage.nativeWindow.close();
				
			}else{//取消默认关闭
				e.preventDefault();
				NativeApplication.nativeApplication.activeWindow.visible = true;
			}
			//取消默认关闭
			//			e.preventDefault();
			//			NativeApplication.nativeApplication.activeWindow.visible = true;
		}
		
		
		private static function saveAndExit(isOk:Boolean):void
		{
			if(isOk)
			{
				view.handleSave();
			}
			//关闭
			App.stage.nativeWindow.close();
			
		}
		
		
		public static function checkProjectDataSave(onOkCall:Function, okLabel:String="保存", cancleLabel:String="退出", noclose:Boolean=false):Boolean
		{
			if(lastSaveData && curProjectData)
			{
				if(ObjectUtils.checkIsSame(lastSaveData, curProjectData.curLaMu)==false)
				{
					Alert.show("当前数据还没有保存，是否保存一下了？ ctr+s 哦~", "提示", Alert.ALERT_OK_CANCLE, function(dowhat:int):void{
						if(dowhat == Alert.ALERT_OK)
						{
							onOkCall(true);
						}else{
							onOkCall(false);
						}
					}, okLabel, cancleLabel, noclose);
					return false;
				}
			}
			return true;
		}
		
	}
}