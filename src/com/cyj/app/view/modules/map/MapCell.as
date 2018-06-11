package com.cyj.app.view.modules.map
{
	import com.cyj.app.ToolsApp;
	import com.cyj.app.utils.ShareUtils;
	import com.cyj.utils.load.ResData;
	import com.cyj.utils.load.ResLoader;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	
	public class MapCell
	{
		private var _mapBp:BitmapData;
//		private var _refushKey:int;
		private var _url:String;
		private var _posx:Number;
		private var _posy:Number;
		private var _isLoading:Boolean = false;
		private var _miniImg:BitmapData;
		private var _miniScale:Point = new Point();
//		private var loader:Loader;
		
		public function MapCell()
		{
			super();
//			loader = new Loader();
//			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, handleImageLoaded);
//			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, handleIoError);
		}
		
		public function changeCell(url:String, mapBp:BitmapData, posx:Number, posy:Number):void
		{
			_mapBp = mapBp;
			_posx = posx;
			_posy = posy;
//			_refushKey = Math.random()*100000;//refushKey;
			//.replace(/\/\//gi, "/");
//			ToolsApp.loader.loadSingleRes(_url, ResLoader.IMG, handleImgLoaded);
			_isLoading = true;
			renderMini();
			
//			loader.unloadAndStop();
//			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, handleImageLoaded);
//			loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, handleIoError);
//			
//			
//			loader = new Loader();
//			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, handleImageLoaded);
//			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, handleIoError);
//			
//			loader.unload();
//			if(url)
//			{
//				loader.load(new URLRequest(url));
//			}else{
//				handleIoError(null);
//			}
//			if(url != _url)
//			{
				_url = url;
				if(url)
					ToolsApp.loader.loadSingleRes(_url, ResLoader.IMG, handleImageLoaded, null, handleIoError);
				else
					handleIoError();
//			}
		}
		
		public function setMiniMap(mini:BitmapData, miniScaleX:Number, miniScaleY:Number):void
		{
			_miniImg = mini;
			if(_miniImg)
			{
				_miniScale.x = miniScaleX;
				_miniScale.y = miniScaleY;
				renderMini();
			}
		}
		private function renderMini():void
		{
			if(_isLoading==false)return;
			if(_mapBp==null)return;
			if(_miniImg==null)return;
			ShareUtils.MATRIX.identity();
			ShareUtils.MATRIX.scale(_miniScale.x, _miniScale.y);
			var rect:Rectangle = ToolsApp.view.ndPreView.uiMapView.viewRect();
			if(rect)
			{
				ShareUtils.MATRIX.tx = -rect.x;
				ShareUtils.MATRIX.ty = -rect.y;
			}
			
			ShareUtils.RECT.x = _posx;
			ShareUtils.RECT.y = _posy;
			ShareUtils.RECT.width = MapContain.DEFUALT_PIC_SIZE;
			ShareUtils.RECT.height = MapContain.DEFUALT_PIC_SIZE;
			_mapBp.lock();
			_mapBp.draw(_miniImg, ShareUtils.MATRIX, null, null, ShareUtils.RECT, true); 
			_mapBp.unlock();
		}
		
		public function get url():String
		{
			return _url;
		}
//		public function get refushKey():int
//		{
//			return _refushKey;
//		}
		private function handleImageLoaded(res:ResData):void
		{
			if(_mapBp ==null)return;
//			trace("Check:::"+_refushKey+"   url:"+res.resPath);
//			if(_refushKey != res.param)return;
			if(_url != res.resPath)return;
//			var bd:BitmapData = Bitmap(loader.content).bitmapData;
			var bd:BitmapData = res.data;
			ShareUtils.POINT.x = _posx;
			ShareUtils.POINT.y = _posy;
			ShareUtils.RECT.x = 0;
			ShareUtils.RECT.y = 0;
			ShareUtils.RECT.width = bd.width;
			ShareUtils.RECT.height = bd.height;
			_mapBp.lock();
			_mapBp.copyPixels(bd, ShareUtils.RECT, ShareUtils.POINT);
			_mapBp.unlock();
			_isLoading = false;
		}
		private function handleIoError(res:ResData=null, msg:String=null):void
		{
			if(_mapBp ==null)return;
			ShareUtils.RECT.x = 0;
			ShareUtils.RECT.y = 0;
			ShareUtils.RECT.width = MapContain.DEFUALT_PIC_SIZE;
			ShareUtils.RECT.height = MapContain.DEFUALT_PIC_SIZE;
			_mapBp.lock();
			_mapBp.fillRect(ShareUtils.RECT, 0);
			_mapBp.unlock();
			_isLoading = false;
		}
		
		
//		private function handleImgLoaded(res:ResData):void
//		{
////			_bmd.bitmapData = res.data;
//			if(_mapBp ==null)return;
//			var bd:BitmapData = res.data;
//			ShareUtils.POINT.x = _posx;
//			ShareUtils.POINT.y = _posy;
//			ShareUtils.RECT.x = 0;
//			ShareUtils.RECT.y = 0;
//			ShareUtils.RECT.width = bd.width;
//			ShareUtils.RECT.height = bd.height;
//			_mapBp.copyPixels(bd, ShareUtils.RECT, ShareUtils.POINT); 
//		}
//		
		public function recyle():void
		{
			_mapBp = null;
			_url = null;
			_miniImg = null;
		
//			loader.unload();
		}
		
		public function dispose():void
		{
			recyle();
//			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, handleImageLoaded);
//			loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, handleIoError);
//			loader = null;
		}
		
		
	}
}