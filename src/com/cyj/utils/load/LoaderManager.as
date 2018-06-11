package com.cyj.utils.load
{
	import flash.utils.Dictionary;

	public class LoaderManager
	{
		private var _loadNum:int = 10;// 生成多少个加载器
		private var _loader:Vector.<ResLoader> = new Vector.<ResLoader>();
		private var _cacheContent:Dictionary = new Dictionary();//资源缓存池
		
		public function LoaderManager()
		{
			init();
		}
		
		private function init():void
		{
			for(var i:int=0; i<_loadNum; i++)
			{
				_loader.push(new ResLoader());
			}
		}
		
		public function clearnAllCache():void
		{
			var loader:ResLoader;
			for(var i:int=0, len:int=_loader.length; i<len; i++)
			{
				loader = _loader[i];
				loader.clearnAllCache();
			}
		}
		
		private function get notBusyLoader():ResLoader
		{
			var unBusyLoader:ResLoader;
			var minSize:int = _loader.length;
			var size:int = 0;
			var loader:ResLoader;
			for(var i:int=0, len:int=_loader.length; i<len; i++)
			{
				loader = _loader[i];
				if(loader.waitResSize==0)return loader;
				size = loader.waitResSize + loader.curLastByte<0.6?1:0;//当前字节大于500k的算是一个
				if(size < minSize)
				{
					unBusyLoader = loader;
					minSize = size;
				}
			}
			return unBusyLoader;
		}
		
		public function getCache(url:String):ResData
		{
			return _cacheContent[url];
		}
		
		public function stopAllLoad():void
		{
			for(var i:int=0, len:int=_loader.length; i<len; i++)
			{
				_loader[i].stopLoad();
			}
		}
		
		public function get waitSize():Number
		{
			var num:Number = 0;
			for(var i:int=0, len:int=_loader.length; i<len; i++)
			{
				num += _loader[i].waitResSize;
			}
			return num;
		}
		
		public function loadSingleRes(url:String, type:int, completeFun:Function, processFun:Function=null, errorFun:Function=null, param:Object=null, isCache:Boolean=true):void
		{
			notBusyLoader.addItem(url, type, loadFun, errFun, proFun, param, isCache);
			function loadFun(res:ResData):void
			{
				if(isCache)
				{
					_cacheContent[url] = res;
				}
				if(completeFun==null)return;
				completeFun.apply(null, [res]);
			}
			
			function proFun(res:ResData, value:Number):void
			{
				if(processFun==null)return;
				processFun.apply(null, [res, value]);
			}
			function errFun(res:ResData, msg:String):void
			{
				if(errorFun==null)return;
				errorFun.apply(null, [res, msg]);
			}
		}
		
		/***urls string [{url, type, isCache, param}]***/ 
		public function loadManyRes(urls:Array, complete:Function, processFun:Function=null, errorFun:Function=null, loadItemComplete:Function=null):void
		{
			var totalNum:int = 0;
			var item:*;
			var curLoadedNum:int;
			for(var i:int=0; i<urls.length; i++)
			{
				item = urls[i];
				totalNum++;
				if(item is String)
				{
					loadSingleRes(item, getFileType(item), loadComplete, loadProcess, loadError);
				}else{
					loadSingleRes(item.url, item.type?item.type:ResLoader.IMG, loadComplete, loadProcess, loadError, item.param?item.param:null,  item.isCache?item.isCache:false);
				}
			}
			
			function loadComplete(res:ResData):void
			{
				if(loadItemComplete!=null)
					loadItemComplete(res);
				if(complete==null)return;
				curLoadedNum++;
				if(curLoadedNum>=totalNum)
				{
					complete.apply();
				}
			}
			
			function loadProcess(res:*, value:Number):void
			{
				if(processFun==null)return;
				processFun.apply(null, [curLoadedNum/totalNum]);
			}
			
			function loadError(res:*, msg:String):void
			{
				if(complete!=null)
				{
					curLoadedNum++;
					if(curLoadedNum>=totalNum)
					{
						complete.apply();
					}
				}
				if(errorFun!=null)
					errorFun.apply(null, [msg]);
			}
		}
		
		private function getFileType(url:String):int
		{
			var type:String = url.substr(url.lastIndexOf(".")+1);
			switch(type)
			{
				case "jpg":
				case "png":
				case "JPG":
				case "PNG":
				case "jpeg":
				case "JPEG":
					return ResLoader.IMG;
				case "swf":
				case "SWF":
					return ResLoader.SWF;
				case "txt":
				case "text":
				case "xml":
					return ResLoader.TXT;
				case "byte":
				case "data":
					return ResLoader.BYT;
				default:
					return ResLoader.TXT;
			}
		}
		
	}
}