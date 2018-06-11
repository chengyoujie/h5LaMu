package com.cyj.app.data
{
	import com.cyj.app.ToolsApp;
	import com.cyj.app.data.lamu.LaMuData;
	import com.cyj.app.data.lamu.LaMuItemData;
	import com.cyj.app.data.lamu.LaMuStepData;
	import com.cyj.app.data.lamu.LaMuUnitData;
	import com.cyj.app.data.map.PstInfo;
	import com.cyj.app.view.common.Alert;
	
	import flash.geom.Point;
	import flash.utils.Dictionary;

	public class ProjectData
	{
		private var _cfgs:Object;
		private var _allCfgs:Object;
		public var mapInfos:Object;
		
		public var monsterData:Object;
		public var chengJiuData:Array;
		public var chengJiuIdDic:Dictionary;
		private var _pstCfgs:Object;
		private var _aniCfgs:Object;
		
		private var _mapList:Array;
		
		
		
		
		public function set cfgs(value:Object):void
		{
			_cfgs = value;
			initMapList(_cfgs["DiTu"]);
		}
		
		public function get cfgs():Object
		{
			return _cfgs;
		}
		
		public function set allCfgs(value:Object):void
		{
			_allCfgs = value;
			if(_allCfgs)
			{
				var psts:Object = _allCfgs["pst"];
				_pstCfgs = {};
				for(var key:String in psts)
				{
					var pst:PstInfo = new PstInfo();
					pst.parser(key, psts[key]);
					_pstCfgs[key] = pst;
				}
				_aniCfgs = _allCfgs["ani"];
			}
		}
		
		public function get allCfgs():Object
		{
			return _allCfgs;
		}
		
		public function get pstCfgs():Object
		{
			return _pstCfgs;
		}
		
		public function get aniCfgs():Object
		{
			return _aniCfgs;
		}
		
		public function get mapList():Array
		{
			return _mapList;
		}
		
		private function initMapList(dic:Object):void
		{
			_mapList = [];
			for(var key:String in dic)
			{
				_mapList.push(dic[key]);
			}
		}
		
		
		private var _taskList:Array;
		private var _taskIndex2Id:Dictionary;
		private var _taskId2Index:Dictionary;
		public var taskDataSource:Array;
		public function initTaskList():void
		{
			_taskList = [];
			_taskIndex2Id  = new Dictionary();
			_taskId2Index = new Dictionary();
			taskDataSource = [];
			var renwu:Object = ToolsApp.curProjectData.cfgs["ChengJiuRenWu"];
			var renwuye:Object = ToolsApp.curProjectData.cfgs["ChengJiuYe"];
			var index:int = 0;
			var des:String = "";
			chengJiuIdDic = new Dictionary();
			
			for(var i:int=0; i<chengJiuData.length; i++)
			{
				chengJiuIdDic[chengJiuData[i].type+"_"+chengJiuData[i].id] = chengJiuData[i];
			}
			for(var id:String in renwu)
			{
				var rw:Object = renwu[id];
				if(rw==null)continue;
				var rwye:Object = renwuye[rw.type];
				if(rwye==null)continue;
				var cj:Object = chengJiuIdDic[rw.type+"_"+rw.id];
				if(cj==null)continue;
				des = rw.order+"-"+getTaskDes(rw.type,rwye.des, cj.data);//rwye.des.replace("{0}", cj.data);
				taskDataSource.push(des);
				_taskList.push(rw);
				_taskIndex2Id[index] = rw.order; 
				_taskId2Index[rw.order] = index;
				index ++;
			}
			
		}
		
		private function getTaskDes(type:int , des:String, data:String):String
		{
			if(!data)return des;
			var arr:Array = data.split(":");
			if(!arr)return des;
			if(type == 3)
			{
				var gkcfg:Object = cfgs["GuanKa"][arr[0]];
				if(gkcfg)
					arr[0] = gkcfg.name;
			}
			return getDes(des, arr);
		}
		
		
		private function getDes(des:String, arr:Array):String
		{
			var reg:RegExp;
			for(var i:int=0; i<arr.length; i++)
			{
				reg = new RegExp("\\{"+i+"\\}", "gi");
				des = des.replace(reg, "<font color='#00ff00'>"+arr[i]+"</font>");
			}
			return des;
		}
		
		public function getTaskIndexById(id:int):int
		{
			return _taskId2Index[id];
		}
		public function getTaskIdByIndex(index:int):int
		{
			return _taskIndex2Id[index];
		}
		
		
		
		
		public function initProject(data:LaMuData):void
		{
			_curLaMuItem = null;
			_curLaMuStep = null;
			_curLaMuUnit = null;
			_curLaMu = data;
		}
		
		private var _curLaMu:LaMuData;
		private var _curLaMuItem:LaMuItemData;
		private var _curLaMuStep:LaMuStepData;
		private var _curLaMuUnit:LaMuUnitData;
		public var centerPos:Point = new Point();
		
		public function set curLaMuItem(value:LaMuItemData):void
		{
			_curLaMuItem = value;
		}
		
		public function set curLaMuStep(value:LaMuStepData):void
		{
			_curLaMuStep = value;
			ToolsApp.view.ndPreView.uiMapView.refushStepChange();
			ToolsApp.view.ndContian.refushStepChange();
			
		}
		
		public function get curLaMuItem():LaMuItemData
		{
			return _curLaMuItem;
		}
		
		public function get curLaMuStep():LaMuStepData
		{
			return _curLaMuStep;
		}
		
		public function set curLaMuUnit(value:LaMuUnitData):void
		{
			_curLaMuUnit = value;
			ToolsApp.view.ndContian.refushUnit();
			ToolsApp.view.ndPreView.uiMapView.refushUnitChange();
		}
		
		public function get curLaMuUnit():LaMuUnitData
		{
			return _curLaMuUnit;
		}
		public function get curLaMu():LaMuData
		{
			return _curLaMu;
		}
		
		public function ProjectData()
		{
		}
		public static const LAMU_DATA:int = 0;
		public static const LAMU_ITEM:int = 1;
		public static const LAMU_STEP:int = 2;
		public static const LAMU_UNIT:int = 3;
		public function _checkLaMuData(step:int, showAlert:Boolean=true):Boolean
		{
			if(step>=LAMU_DATA && _curLaMu==null)
			{
				if(showAlert)Alert.show("当前没有选择项目");
				return false;
			}
			if(step>=LAMU_ITEM && _curLaMuItem==null)
			{
				if(showAlert)Alert.show("当前没有选择拉幕列表");
				return false;
			}
			if(step>=LAMU_STEP && _curLaMuStep==null)
			{
				if(showAlert)Alert.show("当前没有选择步骤");
				return false;
			}
			if(step>=LAMU_UNIT&& _curLaMuUnit==null)
			{
				if(showAlert)Alert.show("当前没有选择要操作的角色");
				return false;
			}
			return true;
		}
		
		
		public static function checkLaMuData(step:int, showAlert:Boolean=true):Boolean
		{
			if(ToolsApp.curProjectData==null)
			{
				if(showAlert)Alert.show("当前没有选择项目");
				return false;
			}else{
				return ToolsApp.curProjectData._checkLaMuData(step, showAlert);
			}
		}
		
		public function _getLaMuDatas(step:int, showAlert:Boolean=false):*
		{
//			if(step==LAMU_DATA && _curLaMu!=null)
//			{
//				if(showAlert)Alert.show("当前没有选择项目");
//				return _curLaMu.data;
//			}
			if(step==LAMU_ITEM )
			{
				if(showAlert && _curLaMu==null){Alert.show("当前没有选择拉幕列表");return};
				return _curLaMu.data;
			}
			else if(step==LAMU_STEP)
			{
				if(showAlert && _curLaMuItem==null){Alert.show("当前没有选择步骤");return};
				return _curLaMuItem.steps;
			}
			else if(step==LAMU_UNIT)
			{
				if(showAlert && _curLaMuStep==null){Alert.show("当前没有选择要操作的角色");return};
				return _curLaMuStep.unitInfo;
			}
			return null;
		}
		
		public static function getLaMuDatas(step:int, showAlert:Boolean=false):*
		{
			if(ToolsApp.curProjectData==null)
			{
				if(showAlert)Alert.show("当前没有选择项目");
				return null;
			}else{
				return ToolsApp.curProjectData._getLaMuDatas(step, showAlert);
			}
		}
	}
}