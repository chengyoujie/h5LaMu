package com.cyj.app.view.modules
{
	import com.cyj.app.ToolsApp;
	import com.cyj.app.data.ProjectData;
	import com.cyj.app.data.lamu.LaMuStepData;
	import com.cyj.app.data.lamu.LaMuUnitData;
	import com.cyj.app.data.map.MapInfo;
	import com.cyj.app.utils.ShareUtils;
	import com.cyj.app.view.modules.map.MapContain;
	import com.cyj.app.view.modules.unit.CenterCoordinate;
	import com.cyj.app.view.modules.unit.Unit;
	import com.cyj.app.view.ui.laMuUI.LMMapViewUI;
	import com.cyj.utils.load.ResData;
	import com.cyj.utils.load.ResLoader;
	
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import morn.core.handlers.Handler;
	
	public class LMMapView extends LMMapViewUI
	{
		private var mapContain:MapContain;
		private var _lastPoint:Point=new Point();
		private var _stagePos:Point = new Point();
		private var _mapInfo:MapInfo;
		private var _unitCache:Dictionary = new Dictionary();
		private var _centerPos:CenterCoordinate = new CenterCoordinate();
		private var _mapId2Index:Dictionary = new Dictionary();
		private var _mapIndex2Id:Dictionary = new Dictionary();
		
		private var _selectUnit:Unit;
		
		public function LMMapView()
		{
			super();
			init();
		}
		
		private function init():void
		{
			boxUnitBg.removeAllChild();
			boxMapContain.removeAllChild();
			
			mapContain = new MapContain();
			boxMapContain.addChild(mapContain);
			
			this.addChild(_centerPos);
			
			var tempEmptyArr:Array = [];
			combMapList.dataSource = tempEmptyArr;//ShareUtils.EMPTY_ARRAY:
			combMapList.selectHandler = new Handler(handleMapChange);
			
			panelUnitScene.vScrollBar.touchScrollEnable = panelUnitScene.hScrollBar.touchScrollEnable = false;
			panelUnitScene.addEventListener(MouseEvent.RIGHT_MOUSE_DOWN, handleStartDragMap);
			panelUnitScene.vScrollBar.addEventListener(Event.CHANGE, handleScrollChange);
			panelUnitScene.hScrollBar.addEventListener(Event.CHANGE, handleScrollChange);
			
			btnMapInfoHide.clickHandler = new Handler(showHideMapInfo, [false]);
			btnMapInfoShow.clickHandler = new Handler(showHideMapInfo, [true]);
			
			this.addEventListener(MouseEvent.MOUSE_MOVE, handleMouseMove);
			panelUnitScene.addEventListener(MouseEvent.CLICK, handleMapGridClick);
			
			refushCenterPos();
			this.addEventListener(Event.ENTER_FRAME, handleRender);
			showHideMapInfo(true);
		}
		
		public function  initProject():void
		{
			var maps:Array = ToolsApp.curProjectData.mapList;
			var datasource:Array = [];
			_mapId2Index = new Dictionary();
			_mapIndex2Id = new Dictionary();
			for(var i:int=0;i<maps.length; i++)
			{
				datasource.push(maps[i].id+"-"+maps[i].name);
				_mapId2Index[maps[i].id] = i;
				_mapIndex2Id[i] = maps[i].id;
			}
			_stagePos = this.localToGlobal(new Point(this.x, this.y));
			combMapList.selectedIndex = -1;
			combMapList.dataSource = datasource;
//			combMapList.selectedIndex= 0;
		}
		
		private function showHideMapInfo(value:Boolean):void
		{
			boxMapPosInfo.visible = value;
			btnMapInfoHide.visible = value;
			btnMapInfoShow.visible = !value;
			imgMapInfoBg.height = value?134:35;
		}
		
		
		private function handleMapChange(index:int):void
		{
			if(index<0)return;       
			var mapcfg:Object = ToolsApp.curProjectData.mapList[index];
			if(mapcfg==null)return;
			var mapid:int = /*mapcfg.path?mapcfg.path:*/mapcfg.id;
			var centerX:int = -1;
			var centerY:int = -1;
			var step:LaMuStepData;
			if(ProjectData.checkLaMuData(ProjectData.LAMU_STEP, false))
			{
				step = ToolsApp.curProjectData.curLaMuStep;
				centerX = step.centerMapX;
				centerY = step.centerMapY;
			}
			if(_mapInfo==null || _mapInfo.id != mapid)//地图不同则刷新
			{
				_mapInfo = ToolsApp.curProjectData.mapInfos[mapid];
				if(_mapInfo==null)return;
				mapContain.setMiniImg(null,1,1);
				ToolsApp.loader.loadSingleRes(ToolsApp.curPorjectConfig.mappath+""+_mapInfo.id+"/mini.jpg", ResLoader.IMG, handleMiniLoaded, null, null, _mapInfo.id);
				mapContain.initMap(ToolsApp.curPorjectConfig.mappath+""+_mapInfo.id+"/", _mapInfo, 0, 0, panelUnitScene.width, panelUnitScene.height);
				panelUnitScene.setContentWH(_mapInfo.width, _mapInfo.height);
				panelUnitScene.refresh();
			}
			if(ProjectData.checkLaMuData(ProjectData.LAMU_STEP, false))
			{
				step = ToolsApp.curProjectData.curLaMuStep;
				centerX = centerX===-1?step.centerMapX:centerX;
				centerY = centerY==-1?step.centerMapY:centerY;
				step.mapId = _mapIndex2Id[index];	
				mapContain.setCameraPos(Math.max(centerX-panelUnitScene.width/2, 0), Math.max(centerY-panelUnitScene.height/2, 0));
				panelUnitScene.scrollTo(mapContain.viewRect.x, mapContain.viewRect.y);
//				panelUnitScene.refresh();
			}
//			refushStep();
		}
		
		public function setViewSize(w:int, h:int):void
		{
			panelUnitScene.width = w;
			panelUnitScene.height = h;
			mapContain.setCameraSize(w, h);
			if(ProjectData.checkLaMuData(ProjectData.LAMU_STEP, false)==false)return;
			var step:LaMuStepData= ToolsApp.curProjectData.curLaMuStep;
			{
				panelUnitScene.scrollTo(Math.max(0, step.centerMapX-panelUnitScene.width/2), Math.max(0, step.centerMapY-panelUnitScene.height/2));
			}//), Math.max(0, unit.y));
			refushCenterPos();
		}
		
		public function viewRect():Rectangle
		{
			return mapContain.viewRect;
		}
		
		
		public function get mapInfo():MapInfo
		{
			return _mapInfo;
		}
		public function get mapId():String
		{
			return _mapInfo?_mapInfo.id+"":"";
		}
		//不想对外开放，自己去管理
//		public function getUnit(unitData:LaMuUnitData):Unit
//		{
//			return _unitCache[unitData];
//		}
		
		public function refushStepChange():void
		{
			var unit:Unit;
			for(var unitid:* in _unitCache)
			{
				unit = _unitCache[unitid];
				unit.recyle();
				delete _unitCache[unitid];
			}
			
			boxUnitBg.removeAllChild();
			if(ProjectData.checkLaMuData(ProjectData.LAMU_STEP, false)==false)return;
			var step:LaMuStepData= ToolsApp.curProjectData.curLaMuStep;
			combMapList.selectedIndexFoce = _mapId2Index[step.mapId];
			var units:Vector.<LaMuUnitData> = step.unitInfo;
			if(units)
			{
				for(var i:int=0; i<units.length; i++)
				{
					addUnit(units[i]);
				}
			}
			refushCenterPos();
		}
		
		public function refushUnitChange():void
		{
			if(_selectUnit)
			{
				_selectUnit.select = false;
				_selectUnit = null;
			}
			if(ProjectData.checkLaMuData(ProjectData.LAMU_UNIT, false)==false)return;
			_selectUnit = _unitCache[ToolsApp.curProjectData.curLaMuUnit];
			if(_selectUnit)
				_selectUnit.select = true;
		}
		
		public function findUnitPos():void
		{
			if(ProjectData.checkLaMuData(ProjectData.LAMU_UNIT, false)==false)return;
			if(ToolsApp.curProjectData.curLaMuStep.coordinateType == LaMuStepData.COORDINATE_SCREEN)return;//屏幕坐标双击不处理
			var unit:Unit = _unitCache[ToolsApp.curProjectData.curLaMuUnit];
			if(unit)
			{
//				panelUnitScene.scrollTo(Math.max(0, unit.x-panelUnitScene.width/2), Math.max(0, unit.y-panelUnitScene.height/2));
				setCenterPos(unit.x, unit.y);
			}
		}
		
		public function setCenterPos(mapx:Number, mapy:Number):void
		{
			if(_mapInfo==null)return;
			panelUnitScene.scrollTo(Math.min(_mapInfo.width, Math.max(0, mapx-panelUnitScene.width/2)), Math.min(_mapInfo.height, Math.max(0, mapy-panelUnitScene.height/2)));
		}
		
		
		public function changeCoordinateType():void
		{
			if(ToolsApp.curProjectData.curLaMuStep==null)return;
			var unit:Unit;
			if(ToolsApp.curProjectData.curLaMuStep.coordinateType == LaMuStepData.COORDINATE_MAP)//地图坐标
			{
				for each(unit in _unitCache)
				{
					unit.data.x = screen2MapPosX(unit.data.x);
					unit.data.y = screen2MapPosY(unit.data.y);
					unit.data.tox = screen2MapPosX(unit.data.tox);
					unit.data.toy = screen2MapPosY(unit.data.toy);
				}
			}else{
				for each(unit in _unitCache)
				{
					unit.data.x = map2ScreenPosX(unit.data.x);
					unit.data.y = map2ScreenPosY(unit.data.y);
					unit.data.tox = map2ScreenPosX(unit.data.tox);
					unit.data.toy = map2ScreenPosY(unit.data.toy);
				}
			}
			ToolsApp.view.ndContian.refuseUnitInputTextPos();
		}
		
		
		public function screen2MapPosX(screenX:Number):int
		{
			return screenX+mapContain.viewRect.x+ToolsApp.curProjectData.centerPos.x;
		}
		public function screen2MapPosY(screenY:Number):int
		{
			return screenY+mapContain.viewRect.y+ToolsApp.curProjectData.centerPos.y;
		}
		public function map2ScreenPosX(mapX:Number):int
		{
			return mapX-mapContain.viewRect.x-ToolsApp.curProjectData.centerPos.x;
		}
		public function map2ScreenPosY(mapY:Number):int
		{
			return mapY-mapContain.viewRect.y-ToolsApp.curProjectData.centerPos.y;
		}
		
		
		
		private function handleMiniLoaded(res:ResData):void
		{
			if(_mapInfo==null)return;
			if(_mapInfo.id == res.param)
			{
				var bd:BitmapData = res.data;
				mapContain.setMiniImg(bd, _mapInfo.width/bd.width, _mapInfo.height/bd.height);
			}
		}
		

		private function handleMouseMove(e:MouseEvent):void
		{
			if(_mapInfo)
			{
				txtPosCellMouse.text = "x:"+int((e.stageX-_stagePos.x+panelUnitScene.content.scrollRect.x)/_mapInfo.gridWidth)  +" y:"+int((e.stageY-_stagePos.y+panelUnitScene.content.scrollRect.y)/_mapInfo.gridHeight);
			}else{
				txtPosCellMouse.text = "没有地图信息";
			}
			txtPosCenterGap.text = "x:"+(e.stageX-_stagePos.x-_centerPos.x)+" y:"+(e.stageY-_stagePos.y-_centerPos.y);
			txtPosMapMouse.text = "x:"+(e.stageX-_stagePos.x+panelUnitScene.content.scrollRect.x)+" y:"+(e.stageY-_stagePos.y+panelUnitScene.content.scrollRect.y);
		}
		private var _tempPos:Point = new Point();
		private function handleMapGridClick(e:MouseEvent):void
		{
//			if(!_isEditModel || _mapInfo==null)return;
//			var rect:Rectangle = panelUnitScene.content.scrollRect;
//			_tempPos.x = rect.x+e.stageX-_stagePos.x;
//			_tempPos.y = rect.y+e.stageY-_stagePos.y;
//			TBGEngine.convertPixelToGridPoint(_tempPos);
//			var id:int = getCellId(_tempPos.x, _tempPos.y);
//			if(_cellDic[id]!=undefined)
//			{
//				_cellDic[id] = null;
//				delete _cellDic[id];
//			}
//			else
//				_cellDic[id] = 1;
//			//			TBGEngine.drawSingleGrid(TBGEngine.shadowContainer, _clickPos.x, _clickPos.y);
//			callLater(renderCell);
		}
		
		
		public function addUnit(unitData:LaMuUnitData):void
		{
			if(ProjectData.checkLaMuData(ProjectData.LAMU_STEP, false)==false)return;
			var unit:Unit = new Unit(unitData);
			if(ToolsApp.curProjectData.curLaMuStep.coordinateType == LaMuStepData.COORDINATE_MAP)//地图坐标
			{
				unit.x = unitData.x;
				unit.y =unitData.y;
			}else{
				unit.x = screen2MapPosX(unitData.x);
				unit.y = screen2MapPosY(unitData.y);
			}
			boxUnitBg.addChild(unit);
			_unitCache[unitData] = unit;
		}
		
		
		public function refushUnitPos():void
		{
			if(ProjectData.checkLaMuData(ProjectData.LAMU_UNIT, false)==false)return;
			var unitData:LaMuUnitData = ToolsApp.curProjectData.curLaMuUnit;
			var unit:Unit = _unitCache[unitData];
			if(unit == null)return;
			if(ToolsApp.curProjectData.curLaMuStep.coordinateType == LaMuStepData.COORDINATE_MAP)//地图坐标
			{
				unit.x = unitData.x;
				unit.y =unitData.y;
			}else{
				unit.x = screen2MapPosX(unitData.x);
				unit.y = screen2MapPosY(unitData.y);
			}
		}
		
		public function refushUnitCloth():void
		{
			if(ProjectData.checkLaMuData(ProjectData.LAMU_UNIT, false)==false)return;
			var unitData:LaMuUnitData = ToolsApp.curProjectData.curLaMuUnit;
			var unit:Unit = _unitCache[unitData];
			if(unit == null)return;
			unit.refushCloth();
		}
		
		public function refushUnitRotation():void
		{
			if(ProjectData.checkLaMuData(ProjectData.LAMU_UNIT, false)==false)return;
			var unitData:LaMuUnitData = ToolsApp.curProjectData.curLaMuUnit;
			var unit:Unit = _unitCache[unitData];
			if(unit == null)return;
			unit.refushRotation();
		}
		
		public function refushUnitSay():void
		{
			if(ProjectData.checkLaMuData(ProjectData.LAMU_UNIT, false)==false)return;
			var unitData:LaMuUnitData = ToolsApp.curProjectData.curLaMuUnit;
			var unit:Unit = _unitCache[unitData];
			if(unit == null)return;
			unit.refushSayPanel();
		}
		
		public function refushUnitAction():void
		{
			if(ProjectData.checkLaMuData(ProjectData.LAMU_UNIT, false)==false)return;
			var unitData:LaMuUnitData = ToolsApp.curProjectData.curLaMuUnit;
			var unit:Unit = _unitCache[unitData];
			if(unit == null)return;
			unit.refushAction();
		}
		
		private function handleRender(e:Event):void
		{
			var unit:Unit;
			for(var unitid:* in _unitCache)
			{
				unit = _unitCache[unitid];
				unit.render();
			}
		}
		
		
		
		
		
		
		private function handleStartDragMap(e:MouseEvent):void
		{
			_lastPoint.x = e.stageX;
			_lastPoint.y = e.stageY;
			App.stage.addEventListener(MouseEvent.RIGHT_MOUSE_UP, handleStopDragMap);
			App.stage.addEventListener(MouseEvent.MOUSE_MOVE, handleMapMove);
		}
		
		private function handleMapMove(e:MouseEvent):void
		{
			panelUnitScene.scrollTo(panelUnitScene.hScrollBar.value-e.stageX+_lastPoint.x, panelUnitScene.vScrollBar.value-e.stageY+_lastPoint.y);
			_lastPoint.x = e.stageX;
			_lastPoint.y = e.stageY;
			handleScrollChange(e);
		}
		
		private function handleStopDragMap(e:MouseEvent):void
		{
			_lastPoint.x = e.stageX;
			_lastPoint.y = e.stageY;
			App.stage.removeEventListener(MouseEvent.MOUSE_MOVE, handleMapMove);
			App.stage.removeEventListener(MouseEvent.RIGHT_MOUSE_UP, handleStopDragMap);
		}
		
		private function handleScrollChange(e:Event=null):void
		{
			var rect:Rectangle = panelUnitScene.content.scrollRect;
				mapContain.setCameraPos(rect.x, rect.y);
				//刷新ui位置
				refushAllPos();
			
		}
		
		
		private function renderCell():void
		{
//			var g:Graphics=TBGEngine.shadowContainer.graphics;
//			if(!_isEditModel)
//			{
//				g.clear();
//				return;
//			}
//			if(_mapInfo==null)return;
//			g.clear();
//			g.lineStyle(0, 0xff0000, 0.3) //把网格的透明度减低；
//			g.beginFill(0xffcc00);
//			var id:int;
//			var temparr:Array;
//			for (var i:int=0; i < _mapInfo.gwidth; i++)
//			{
//				for (var j:int=0; j < _mapInfo.gheight; j++)
//				{
//					_tempPos.x=i
//					_tempPos.y=j
//					//drawBlock(floor_doc.assist.graphics,pt,mapModel.path.getInt(i, j))
//					//					TBGEngine.getXYbyGridPotint(_tempPos)
//					id = getCellId(i, j);
//					temparr = getCellColor(id);
//					g.beginFill(temparr[0], temparr[1]);
//					TBGEngine.convertGridToPixelPoint(_tempPos);
//					TBGEngine.drawSingleGrid(g, _tempPos.x, _tempPos.y);
//				}
//			}
		}
		
		//中心点坐标类型改变时， 刷新全部坐标
		public function refushAllPos(isChange:Boolean=false):void
		{
			if(ProjectData.checkLaMuData(ProjectData.LAMU_STEP, false)==false)return;
			var step:LaMuStepData = ToolsApp.curProjectData.curLaMuStep;
			step.centerMapX = screen2MapPosX(0);
			step.centerMapY = screen2MapPosY(0);
			var unit:Unit;
			if(step.coordinateType == LaMuStepData.COORDINATE_MAP)//地图坐标
			{
			
				for each(unit in _unitCache)
				{
					unit.x =unit.data.x;
					unit.y = unit.data.y;
				}
			}else{
				for each(unit in _unitCache)
				{
//					unit = _unitCache[unitKey];
					unit.x = screen2MapPosX(unit.data.x);
					unit.y = screen2MapPosY(unit.data.y);
				}
			}
		}
		
		private function refushCenterPos():void
		{
			_centerPos.x = panelUnitScene.width/2;
			_centerPos.y = panelUnitScene.height/2;
			if(ToolsApp.curProjectData)
			{
				ToolsApp.curProjectData.centerPos.x = _centerPos.x;
				ToolsApp.curProjectData.centerPos.y = _centerPos.y;
				refushAllPos();
			}
		}
		
	}
}