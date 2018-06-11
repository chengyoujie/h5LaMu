package com.cyj.utils.load
{
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;

	/**
	 *资源加载<br/>
	 * additem()<br/>
	 * additem()<br/>
	 *  ..... .....<br/>
	 * startLoad()<br/> 
	 * 不能再一个资源加载完毕的处理函数中写另一个资源加载startLoad()
	 * @author cyj
	 * 
	 */	
	public class ResLoader
	{
		public static const SWF:int = 0;
		public static const IMG:int = 1;
		public static const TXT:int = 2;
		public static const BYT:int = 3;//bytearray
		
		public static const WAIT_LOAD:String = "@WAIT@";
		public static const ERROR_LOAD:String = "@ERROR@";
		private var _txtLoad:URLLoader;
		private var _imgLoad:Loader;
		private var _loadedRes:Dictionary;//[url] = id
		private var _waitForLoadResItem:Vector.<ResInfo>;
		private var _currentResInfo:ResInfo;
		private var _isRuning:Boolean = false;
		private var _context:LoaderContext = new LoaderContext(false, ApplicationDomain.currentDomain);
		private var _lastUrl:String = "";//上次加载的url
		private var _lastTime:int = 0;//上次开始加载的时间
		
		public function ResLoader()
		{
			init();
		}
		
		private function init():void
		{
			_txtLoad = new URLLoader();
			_txtLoad.addEventListener(Event.COMPLETE, handleComplete);
			_txtLoad.addEventListener(IOErrorEvent.IO_ERROR, handleIOError);
			_txtLoad.addEventListener(SecurityErrorEvent.SECURITY_ERROR, handleIOError);
			_txtLoad.addEventListener(ProgressEvent.PROGRESS, handleProgress);
			
			_imgLoad = new Loader();
			_imgLoad.contentLoaderInfo.addEventListener(Event.COMPLETE, handleComplete);
			_imgLoad.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, handleIOError);
			_imgLoad.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, handleProgress);
			
			_loadedRes = new Dictionary();
//			_context.applicationDomain = ApplicationDomain.currentDomain;
			_context.allowCodeImport = true;
//			_context.allowLoadBytesCodeExecution = true;
			_waitForLoadResItem = new Vector.<ResInfo>();
		}
		
		private function handleComplete(e:Event):void
		{
			if(_currentResInfo.type == TXT)
			{
				_currentResInfo.resData.data = _txtLoad.data;
			}else if(_currentResInfo.type == IMG)
			{
				_currentResInfo.resData.data = Bitmap(_imgLoad.content).bitmapData;
			}else if(_currentResInfo.type == SWF)
			{
//				if(_txtLoad.data != null)
//				{
//					_imgLoad.loadBytes(_txtLoad.data, _context);
//					_txtLoad.data = null;
//				}else{
					_currentResInfo.resData.data = _imgLoad.contentLoaderInfo.applicationDomain;
//				}
			}else if(_currentResInfo.type == BYT)
			{
				_currentResInfo.resData.data = _txtLoad.data;
			}
//			trace(_currentResInfo.url + "加载完毕");
			if(_currentResInfo.isCache)
				_loadedRes[_currentResInfo.url] = _currentResInfo.resData;
			else
				_loadedRes[_currentResInfo.url] = null;
			_currentResInfo.execComplete();
			_isRuning = false;
			loadNext();
		}
		
		private function handleProgress(e:ProgressEvent):void
		{
			if(e.bytesTotal>0)
			{
				_currentResInfo.execProgress(e.bytesLoaded/e.bytesTotal);
			}
		}
		
		private function loadNext():void
		{
			if(_waitForLoadResItem.length == 0)
			{
//				_currentResInfo = null;
				return;
			}
			if(_isRuning)
			{
				if(_currentResInfo.url == _lastUrl)
				{
//					if(getTimer() - _lastTime > 60000)//超过一分钟则提示加载超时  
//					{
//						trace("资源"+_currentResInfo.url + "加载超时");
//						_currentResInfo.execError("加载超时");
//						_loadedRes[_currentResInfo.url] = ERROR_LOAD;
//						deleteRes(_currentResInfo.url);
//						_isRuning = false;//跳过此条加载下一个
//						loadNext();
//					}
				}
				return;
			}
			_currentResInfo = _waitForLoadResItem.shift();
			if(_currentResInfo)
			{
//				trace("开始加载", _currentResInfo.url);
				_lastUrl = _currentResInfo.url;
				_lastTime = getTimer();
				_isRuning = true;
				if(_currentResInfo.type == IMG)
				{
					_imgLoad.load(new URLRequest(_currentResInfo.url));
				}else if(_currentResInfo.type == TXT)
				{
					_txtLoad.dataFormat = URLLoaderDataFormat.TEXT;
					_txtLoad.load(new URLRequest(_currentResInfo.url));
				}else if(_currentResInfo.type == SWF)
				{
//					_txtLoad.dataFormat = URLLoaderDataFormat.BINARY;
//					_txtLoad.load(new URLRequest(_currentResInfo.url));
					if(_currentResInfo.param && _currentResInfo.param.hasOwnProperty("contex")  && _currentResInfo.param.contex)
					{
						var context:LoaderContext = _currentResInfo.param.contex;
						_imgLoad.load(new URLRequest(_currentResInfo.url), context);
					}else{
						_imgLoad.load(new URLRequest(_currentResInfo.url), _context);
					}
				}else if(_currentResInfo.type == BYT)
				{
					_txtLoad.dataFormat = URLLoaderDataFormat.BINARY;
					_txtLoad.load(new URLRequest(_currentResInfo.url));
				}
			}else{
				loadNext();
			}
		}

		
		/**根据url获取资源*/
		public function getRes(url:String):*
		{
			if(_loadedRes[url] == WAIT_LOAD || _loadedRes[url] == ERROR_LOAD)
				return null;
			return _loadedRes[url];
		}
		
		/**删除资源**/
		public function deleteRes(url:String):void
		{
			if(_loadedRes[url])
			{
				if(_loadedRes[url] == WAIT_LOAD)
				{
					trace("删除失败    ：   资源"+url+"正在加载中");
				}else{
					if(_loadedRes[url] is Bitmap)
					{
						if(_loadedRes[url].bitmapData)
							_loadedRes[url].bitmapData.dispose();
					}else if(_loadedRes[url] is BitmapData)
					{
						_loadedRes[url].dispose();
					}
					_loadedRes[url] = null;
					delete _loadedRes[url];
				}
			}
		}
		
		public function clearnAllCache():void
		{
			for(var url:String in _loadedRes)
			{
				deleteRes(url);
			}
		}
		
		private function handleIOError(e:IOErrorEvent):void
		{
			trace(_currentResInfo.url + " 加载错误");
			_currentResInfo.execError();
			_currentResInfo.execProgress(1);
			_loadedRes[_currentResInfo.url] = ERROR_LOAD;
			deleteRes(_currentResInfo.url);
			_isRuning = false;
			loadNext();
		}
		
		/**当前队列的大小**/
		public function get waitResSize():int
		{
			return _waitForLoadResItem.length;
		}
		
		/**当前加载剩余的字节数**/		
		public function get curLastByte():Number
		{
			if(_currentResInfo==null)return 0;
			return _currentResInfo.progress;
			return 0;
		}
		
		public function stopLoad():void
		{
			_imgLoad.unloadAndStop();
			_txtLoad.close();
		}
		
		public function addItem(url:String, type:int, complete:Function=null, error:Function=null, progress:Function=null, param:*=null, isCache:Boolean=true):void
		{
//			isCache = false;
			if(_loadedRes[url])
			{
				if(_loadedRes[url] == WAIT_LOAD)
				{
//					trace("资源" + url +"等待加载中... ...");
					var info:ResInfo = getWaitResInfo(url);
					if(info)
					{
						info.param = param;//覆盖上次的参数
						info.addHandle(complete, error, progress);
					}
					else
						trace("Error: ResLoader->addItem 程序错误", url+"在等待列表中但在等待列表中没有找到");
				}else if(_loadedRes[url] == ERROR_LOAD)
				{
					trace("资源"+url+"已经加载过但加载错误了");
				}else{
					var res:ResInfo = new ResInfo(url, type, complete, error, progress, param);
					res.resData.data = _loadedRes[url].data;
					if(res.resData.data is ByteArray)
					{
						ByteArray(res.resData.data).position = 0;
					}
					res.execComplete();
					res.execProgress(1);
				}
				loadNext();
				return;
			}
			_waitForLoadResItem.push(new ResInfo(url, type, complete, error, progress, param, isCache));
			_loadedRes[url] = WAIT_LOAD;
			loadNext();
		}
		
		private function getWaitResInfo(url:String):ResInfo
		{
			for(var i:int=0; i<_waitForLoadResItem.length; i++)
			{
				if(_waitForLoadResItem[i].url == url)
					return _waitForLoadResItem[i];
			}
			if(_currentResInfo.url == url)
				return _currentResInfo;
			return null;
		}
		/**添加文本型加载项**/
		public function addTxtItem(url:String, complete:Function=null, error:Function=null, progress:Function=null,param:*=null, isCache:Boolean=true):void
		{
			addItem(url, TXT, complete, error, progress,param, isCache);
		}
		/**添加图片型加载项**/
		public function addImgItem(url:String, complete:Function=null, error:Function=null, progress:Function=null,param:*=null, isCache:Boolean=true):void
		{
			addItem(url, IMG, complete, error, progress,param, isCache);
		}
		/**添加SWF型加载项  @return LoaderInfo 以便获取当前的子域**/
		public function addSwfItem(url:String, complete:Function=null, error:Function=null, progress:Function=null,context:*=null, isCache:Boolean=true):void
		{
			addItem(url, SWF, complete, error, progress, context, isCache);
		}
		/**添加字节型加载项**/
		public function addBytItem(url:String, complete:Function=null, error:Function=null, progress:Function=null,param:*=null, isCache:Boolean=true):void
		{
			addItem(url, BYT, complete, error, progress, param, isCache);
		}
	}
}
import com.cyj.utils.load.ResData;

import flash.utils.Dictionary;


class ResInfo{

	private var _url:String;
	private var _type:int;
	private var _id:String;
	public var content:*;
	public var _param:*;
	public var packageName:String;
	public var progress:Number;
	private var _handleResult:Array;
	private var _resultData:ResData;
	private var _errormsg:String;
	private var _isCache:Boolean=true;
	
	public function ResInfo(url:String, type:int, complete:Function,error:Function=null,  progress:Function=null, param:*=null, iscache:Boolean=false)
	{
		_url = url;
		_type = type;
		_id = id;
		_param = param;
		_handleResult = new Array();
		_resultData = new ResData();
		_resultData.resPath = _url;
		_resultData.param = _param;
		_isCache = iscache;
		addHandle(complete, error, progress);
	}
	public function get url():String{return _url;}
	public function get type():int{return _type;}
	public function get id():String{return _id;}
	public function get param():*{return _param;}
	public function set param(value:*):void{_param=value}
	public function get isCache():Boolean{return _isCache;}
	/**增加一个侦听**/
	public function addHandle(complete:Function,error:Function=null,  progress:Function=null):void
	{
		_handleResult.push({"complete":complete, "error":error, "progress":progress});
	}
	public function execComplete():void
	{
		progress = 1;
		for each(var handle:Object in _handleResult)
		{
			if(handle["complete"])
				handle["complete"].apply(null, [_resultData]);
		}
		_handleResult = [];
	}
	public function execError(errorMsg:String=""):void
	{
		for each(var handle:Object in _handleResult)
		{
			if(handle["error"])
				handle["error"].apply(null, [_resultData, errorMsg]);
		}
		_handleResult = [];
	}
	public function execProgress(value:Number):void
	{
		progress = value;
		for each(var handle:Object in _handleResult)
		{
			if(handle["progress"])
				handle["progress"].apply(null, [_resultData, progress]);
		}
	}
	
	public function get resData():ResData
	{
		return _resultData;
	}
	
}
