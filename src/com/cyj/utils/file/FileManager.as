package com.cyj.utils.file
{
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.FileFilter;
	import flash.utils.ByteArray;

	public class FileManager
	{
		
		public static var TYPE_FILE_XLS:String = ".xls";
		public static var TYPE_FILE_XLSX:String = ".xlsx";
		public static var TYPE_FILE_CSV:String = ".csv";
		public static var TYPE_FILE_SWF:String = ".swf";
		
		public function FileManager()
		{
		}
		
		public function saveFile(path:String, content:String, isCheckExit:Boolean=false, charSet:String="utf-8"):Boolean
		{
			var file:File = new File(path);
			if(isCheckExit && file.exists)
			{
				return false;
			}
			if(content==null)
				content = "";
			var fileStream:FileStream = new FileStream();
			fileStream.open(file, FileMode.WRITE);
			fileStream.writeMultiByte(content, charSet);
			fileStream.close();
			return true;
		}
		
		public static function readDirFiles(file:File, allFiles:Array, filterTypes:Array=null):Array
		{
			if(file.isDirectory)
			{
				var files:Array = file.getDirectoryListing();
				for(var i:int=0; i<files.length; i++)
				{
					readDirFiles(files[i], allFiles, filterTypes);
				}
			}else{
				if(filterTypes && filterTypes.length>0)
				{
					var type:String = file.name.substring(file.name.lastIndexOf(".")+1);
					if(filterTypes.indexOf(type)>=0)
						allFiles.push(file);
				}else{
					allFiles.push(file);
				}
			}
			return allFiles;
		}
		
		public function openDir(path:String):void
		{
			try{
				var file:File = new File(path);
				file.openWithDefaultApplication();
			}catch(e:*){
				trace("打开目录"+path+"错误");
				
			}
		}
		
		public function saveByteFile(path:String, byte:ByteArray, isCheckExit:Boolean=false):Boolean
		{
			var file:File = new File();
			try{
				file.nativePath = path;
			}catch(e:*){
				trace(path+"导出路径设置错误");
				return false;
			}
			if(isCheckExit && file.exists)
			{
				return false;
			}
			var fileStream:FileStream = new FileStream();
			fileStream.open(file, FileMode.WRITE);
			fileStream.writeBytes(byte);
			fileStream.close();
			return true;
		}
		
		public function openFile(selectHandle:Function, isOpenDir:Boolean=false, defaultPath:String="", funargs:Array=null, isSave:Boolean = false, filterArr:Array=null):void
		{
			var file:File = new File();//(defaultPath==null?new File():new File(defaultPath));
			if(defaultPath)
			{
				try{
					file.nativePath = defaultPath;
				}catch(e:*){
					trace(defaultPath+"默认路径设置错误");
				}
			}
			file.addEventListener(Event.SELECT, handleSelect);
			if(isOpenDir)
				file.browseForDirectory("选择文件夹");
			else if(isSave)
				file.browseForSave("选择文件");
			else
			{
				if(filterArr==null)
				{
					file.browseForOpen("选择文件");
				}else{
					file.browseForOpen("选择文件", filterArr);
				}
			}
			function handleSelect(e:Event):void
			{
				if(selectHandle!=null)
				{
					var args:Array = [file.nativePath.replace(/\\/gi, "/")];
					if(funargs && funargs.length>0)
					{
						args = args.concat(funargs);
					}
					selectHandle.apply(this, args);
				}
			}
		}
		
		
		public function isImage(fileName:String):Boolean
		{
			if(!fileName || fileName.indexOf(".")==-1)return false;
			
			switch(fileName.substr(fileName.lastIndexOf(".")+1).toLowerCase())
			{
				case "jpg":
				case "png":
				case "jpeg":
				case "atf":
					return true;
			}
			return false;
		}
		
	}
}