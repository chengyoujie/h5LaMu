package com.cyj.app.view.modules.map
{
	import com.cyj.app.ToolsApp;
	import com.cyj.app.data.map.MapInfo;
	import com.cyj.app.utils.ShareUtils;
	import com.cyj.utils.ObjectUtils;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	public class MapContain extends Sprite
	{
		private var _rootPicUrl:String;
		private var _mapInfo:MapInfo;
		private var _viewRect:Rectangle = new Rectangle(0, 0, 500, 500);
		private var _mapContain:Bitmap;
		private var _gridContian:Sprite = new Sprite();
		private var _cellPool:Vector.<MapCell> = new Vector.<MapCell>();
		private var _cellUse:Vector.<MapCell> = new Vector.<MapCell>();
//		private var _cellCache:Dictionary = new Dictionary();
//		private var _refushKey:int = 0;
		private var _startPicTilePos:Point = new Point();
		private var _endPicTilePos:Point = new Point();
//		private var _fouceRefush:Boolean = false;
		public static const DEFUALT_PIC_SIZE:int = 256;
		
		
		public static const POOL_SIZE:int = 12;
		
		public function MapContain()
		{
			super();
			_mapContain = new Bitmap();
			
			this.addChild(_mapContain);
			this.addChild(_gridContian);
		}
		
		public function initMap(rootPicUrl:String, mapinfo:MapInfo, camerax:int=0, cameray:int=0, cameraWidth:int=500, cameraHeight:int=500):void
		{
			ToolsApp.loader.clearnAllCache();
			_rootPicUrl = rootPicUrl;//.replace(/\/\//gi, "/");
			_mapInfo = mapinfo;
			_viewRect.x = camerax;
			_viewRect.y = cameray;
//			_viewRect.width= cameraWidth;
//			_viewRect.height = cameraHeight;
//			if(_mapContain.bitmapData)
//			{
//				_mapContain.bitmapData.dispose();
//				_mapContain.bitmapData = null;
//			}
//			_mapContain.bitmapData = new BitmapData(_viewRect.width, _viewRect.height, true, 0);
			setCameraSize(cameraWidth, cameraHeight);
//			refushView();
//			_fouceRefush = true;
//			var cell:MapCell;
//			
//			for(var idx:String in _cellCache)
//			{
//				cell = _cellCache[idx];
//				cell.dispose();
//				cell = null;
//				delete _cellCache[idx];
//			}
			App.render.exeCallLater(refushView);
//			refushView();
		}
		
		
		public function setMiniImg(map:BitmapData, miniScaleX:Number, miniScaleY:Number):void
		{
			for(var i:int=0; i<_cellUse.length; i++)
			{
				_cellUse[i].setMiniMap(map,miniScaleX, miniScaleY);
			}
		}
		
		public function get viewRect():Rectangle
		{
			return _viewRect;
		}
		
		
		
		public function setCameraPos(cx:Number, cy:Number):void
		{
			_viewRect.x = cx;
			_viewRect.y = cy;
			App.render.callLater(refushView);
//			refushView();
		}
		
		public function setCameraSize(w:int, h:int):void
		{
			if(w<0||h<0)return;
			_viewRect.width= w;
			_viewRect.height = h;
			_mapContain.bitmapData = new BitmapData(_viewRect.width, _viewRect.height, true, 0);
			App.render.callLater(refushView);
//			refushView();
		}
		
		public function refushView():void
		{
			if(_mapInfo==null)return;
			if(_mapContain.bitmapData==null)return;
//			_refushKey ++;
			
//			ObjectUtils.removeAllChild(_mapContain);
//			ObjectUtils.removeAllChild(_gridContian);
			
			var startPicX:int = Math.max(0, _viewRect.x/_mapInfo.pWidth-1);
			var startPicY:int = Math.max(0,_viewRect.y/_mapInfo.pHeight-1);
			var endPicX:int = /*Math.min(_mapInfo.maxPicX, */Math.ceil((_viewRect.x+_viewRect.width)/_mapInfo.pWidth)/*)*/;
			var endPicY:int = /*Math.min(_mapInfo.maxPicY, */Math.ceil((_viewRect.y+_viewRect.height)/_mapInfo.pHeight)/*)*/;
//			if(_startPicTilePos.x == startPicX && startPicY == _startPicTilePos.y && endPicX == _endPicTilePos.x && endPicY == _endPicTilePos.y && _fouceRefush==true)
//			{
//				return;
//			}
//			_fouceRefush = false;
			_startPicTilePos.x = startPicX;
			_startPicTilePos.y = startPicY;
			_endPicTilePos.x = endPicX;
			_endPicTilePos.y = endPicY;
			
//			ShareUtils.RECT.x = 0;
//			ShareUtils.RECT.y = 0;
//			ShareUtils.RECT.width = _viewRect.width;
//			ShareUtils.RECT.height = _viewRect.height;
//			_mapContain.bitmapData.fillRect(ShareUtils.RECT, 0);
			
			var url:String;
			var cell:MapCell;
			var useIndex:int=0;
			for(var ix:int=startPicX; ix<endPicX; ix++)
			{
				for(var iy:int=startPicY; iy<endPicY; iy++)
				{
					if(useIndex>=_cellUse.length)
					{
						if(_cellPool.length>0)
							cell = _cellPool.shift();
						else
							cell = new MapCell();
						_cellUse.push(cell);
					}
					cell = _cellUse[useIndex];
					if(ix>_mapInfo.maxPicX || iy>_mapInfo.maxPicY)
					{
//						url = null;
						continue;
					}else{
						url = _rootPicUrl + getMapTileName(ix, iy);// ""+iy+"_"+ix+".jpg";
					}
					cell.changeCell(url, _mapContain.bitmapData,ix*_mapInfo.pWidth - _viewRect.x, iy*_mapInfo.pHeight - _viewRect.y);
					useIndex++;
//					if(endPicX>_mapInfo.maxPicX || endPicY>_mapInfo.maxPicY)
//					{
//						url = null;
//					}else{
//						url = _rootPicUrl + ""+iy+"_"+ix+".jpg";
//					}
//					var idx:String = iy+"_"+ix;
//					cell = _cellCache[idx];
//					if(cell == null)
//					{
//						cell = new MapCell();
//						cell.changeCell(url, _mapContain.bitmapData,ix*_mapInfo.pWidth - _viewRect.x, iy*_mapInfo.pHeight - _viewRect.y,  _refushKey);
//						_cellCache[idx] = cell;
//					}
					
				}
			}
			while(_cellUse.length>useIndex)
			{
				cell = _cellUse.pop();
				if(_cellPool.length>POOL_SIZE)
				{
					cell.dispose();
				}else{
					cell.recyle();
					_cellPool.push(cell);
				}
			}
			
		}
		
		public function getMapTileName(ix:int, iy:int):String
		{
			var xstr:String = ix+"";
			var ystr:String = iy+"";
			while(xstr.length<3)
			{
				xstr = "0"+xstr;
			}
			while(ystr.length<3)
			{
				ystr = "0"+ystr;
			}
			return ystr+xstr+".jpg";
		}
		
		
		
		
		
	}
}