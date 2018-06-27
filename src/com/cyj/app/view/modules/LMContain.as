package com.cyj.app.view.modules
{
	import com.cyj.app.ToolsApp;
	import com.cyj.app.data.ProjectData;
	import com.cyj.app.data.lamu.LaMuData;
	import com.cyj.app.data.lamu.LaMuItemData;
	import com.cyj.app.data.lamu.LaMuStepData;
	import com.cyj.app.data.lamu.LaMuUnitData;
	import com.cyj.app.utils.binddata.BindData;
	import com.cyj.app.view.common.Alert;
	import com.cyj.app.view.ui.laMuUI.LMContainUI;
	import com.cyj.utils.load.ResData;
	import com.cyj.utils.load.ResLoader;
	
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import morn.core.handlers.Handler;
	
	public class LMContain extends LMContainUI
	{
		private var _bindStepList:Vector.<BindData> = new Vector.<BindData>();
		private var _bindUnitList:Vector.<BindData> = new Vector.<BindData>();
		/**actionId->index  ... **/
		private var actionId2IndexDic:Dictionary = new Dictionary();
		
		/**index ->actionId ... **/
		private var actionIndex2IdDic:Dictionary = new Dictionary();
//		private var npcList:Array  = [];
//		private var monsterList:Array = [];
//		private var npcId2IndexDic:Dictionary;
//		private var npcIndex2Id:Dictionary;
//		private var monsterId2Index:Dictionary;
//		private var monsterIndex2Id:Dictionary;
		
		public function LMContain()
		{
			super();
			init();
		}
		private function init():void{
			_bindStepList.push(new BindData(inputId, "id", "text", refushStepBaseInfo));
			_bindStepList.push(new BindData(inputStepName, "name", "text", refushStepBaseInfo));
			_bindStepList.push(new BindData(inputCameraPosX, "camerax"));
			_bindStepList.push(new BindData(inputCameraPosY, "cameray"));
			_bindStepList.push(new BindData(inputCameraMoveTime, "cameraMoveTime"));
			_bindStepList.push(new BindData(inputEndCondition, "endParam"));
			_bindStepList.push(new BindData(inputStepEndEvent, "stepEndEvent"));
			_bindStepList.push(new BindData(checkUnitShowBorder, "showBorder", "selected"));
			_bindStepList.push(new BindData(checkUnitShowUI, "showUI", "selected"));
			_bindStepList.push(new BindData(checkUnitShowOther, "showOther", "selected"));
			
			_bindUnitList.push(new BindData(inputUnitName, "name", "text", refushUnitBaseInfo));
			_bindUnitList.push(new BindData(inputUnitId, "id", "text", refushUnitBaseInfo));
			_bindUnitList.push(new BindData(inputUnitPak, "ucloth", "text",refushUnitCloth));
			_bindUnitList.push(new BindData(inputUnitPst, "upst", "text",refushUnitCloth));
			_bindUnitList.push(new BindData(inputUnitPosX, "x", "text",refushUnitPos ));
			_bindUnitList.push(new BindData(inputUnitPosY, "y", "text",refushUnitPos));
			_bindUnitList.push(new BindData(inputUnitToX, "tox"));
			_bindUnitList.push(new BindData(inputUnitToY, "toy"));
			_bindUnitList.push(new BindData(inputUnitWeapon, "uweapon"));
			_bindUnitList.push(new BindData(inputUnitWing, "uwing"));
			_bindUnitList.push(new BindData(inputUnitMount, "umount"));
			_bindUnitList.push(new BindData(inputUnitMoveTime, "moveTime"));
			_bindUnitList.push(new BindData(combUnitOper, "operType", "selectedIndex"));
			_bindUnitList.push(new BindData(combUnitDir, "face", "selectedIndex", refushUnitFace));// unit.face;
			_bindUnitList.push(new BindData(inputUnitRotation, "rotation", "text",refushUnitRotation));
			_bindUnitList.push(new BindData(inputUnitJumpHeight, "jumpHeight"));
			_bindUnitList.push(new BindData(inputUnitSay, "say", "text",refushUnitSay ));
			_bindUnitList.push(new BindData(checkUnitShowFace, "showFace", "selected",handleCheckShowFace ));
			_bindUnitList.push(new BindData(inputUnitFace, "faceImg", "text",handleCheckShowFace));
			_bindUnitList.push(new BindData(checkFaceLeft, "faceLeft", "selected",handleCheckShowFace));
			 
			combCoordinate.selectHandler = new Handler(handleCoordinateChange);
			combCameraOper.selectHandler= new Handler(handleCameraOperChange);
			btnCameraCurPos.clickHandler = new Handler(handleCameraCurPos);
			combEndType.selectHandler = new Handler(handleEndTypeChange);
			//Unit Control
			combUnitType.selectHandler = new Handler(handleUnitResTypeChange);
			combUnitType.selectedIndex = 0;
			handleUnitResTypeChange(combUnitType.selectedIndex);
			
			combUnitNPCList.selectHandler = new Handler(handleNpcSelectChange);
			combUnitMonsterList.selectHandler = new Handler(handleMonsterSelectChange);
			combUnitAction.selectHandler = new Handler(handleUnitActionChange);
			btnUnitDefPos.clickHandler = new Handler(handleUnitCenterPos);
			btnUnitLastPos.clickHandler = new Handler(handlerUnitLastPos);
			btnStepLastPos.clickHandler = new Handler(handlerStepLastPos);
			btnUnitMoveToCenter.clickHandler= new Handler(handleUnitMoveToCenterPos);
			combUnitOper.selectHandler = new Handler(handleUnitOperChange);
			btnFaceUseMain.clickHandler = new Handler(handleUseFaceMain);
			handleCameraOperChange(0);
			handleUnitOperChange(0);
			handleCheckShowFace();
		}
		
		
		
		public function  initProject():void
		{
			var npcCfgs:Object = ToolsApp.curProjectData.cfgs.Npc;
//			var datasource:Array= [];
//			npcList.length = 0;
//			for(var id:String in npcCfgs)
//			{
//				datasource.push(id+"-"+npcCfgs[id].name);
//				npcList.push(npcCfgs[id]);
//			}
//			combUnitNPCList.dataSource= datasource;
			combUnitNPCList.dataSouceExt = npcCfgs;
			
			//将NPC类型的标志改为怪物id
//			var cpdic:Dictionary = new Dictionary();
//			var cpndic:Dictionary = new Dictionary();
//			for(var mp:String in npcCfgs)
//			{
//				var mo:Object = npcCfgs[mp];
//				cpdic[mo.cloth+"_"+mo.pst] = mo.id;
//				cpndic[mo.cloth+"_"+mo.pst+"_"+"$"+mo.name] = mo.id;
//			}
//			
//			var laMu:LaMuData = ToolsApp.curProjectData.curLaMu;
//			var item:LaMuItemData;
//			for(var i:int=0; i<laMu.data.length; i++)
//			{
//				var items:Vector.<LaMuStepData> = laMu.data[i].steps;
//				for(var j:int=0; j<items.length; j++)
//				{
//					var step:LaMuStepData = items[j];
//					for(var m:int=0; m<step.unitInfo.length; m++)
//					{
//						var unit:LaMuUnitData = step.unitInfo[m];
//						if(unit.resType == LaMuUnitData.RES_TYPE_NPC)
//						{ 
//							var id:String = cpdic[unit.ucloth+"_"+unit.upst];
//							if(id)
//							{
//								var tid = cpndic[unit.ucloth+"_"+unit.upst+"_"+unit.name];
//								if(tid)
//									id = tid;
//								unit.resParam = id;
//							}else{
//								unit.resType = LaMuUnitData.RES_TYPE_PAK;
//							}
//							
//						}
//					}
//				}
//			}
			
			
			actionId2IndexDic = new Dictionary();
			var arr:Array = ToolsApp.curPorjectConfig.actionlist.split(",");
			for(var i:int=0; i<arr.length; i++)
			{
				var info:Array = arr[i].split(".");
				if(info && info.length>1)
				{
					actionId2IndexDic[info[0]]= i;
					actionIndex2IdDic[i] = info[0];
				}
			}
			combUnitAction.dataSource = arr;
			initMonsterList();
		}
		
		private function initMonsterList():void
		{
			var monsterData:Object = ToolsApp.curProjectData.monsterData;
//			var datasource:Array= [];
//			monsterList.length = 0;
//			for(var id:String in monsterData)
//			{
//				datasource.push(monsterData[id].id+"-"+monsterData[id].name);
//				monsterList.push(monsterData[id]);
//			}
//			combUnitMonsterList.dataSource= datasource;
//			combUnitMonsterList.selectedIndex = -1;
			combUnitMonsterList.dataSouceExt = monsterData;
			
			
			//将怪物类型的标志改为怪物id
//			var cpdic:Dictionary = new Dictionary();
//			var cpndic:Dictionary = new Dictionary();
//			for(var mp:String in monsterData)
//			{
//				var mo:Object = monsterData[mp];
//				cpdic[mo.cloth+"_"+mo.pst] = mo.id;
//				cpndic[mo.cloth+"_"+mo.pst+"_"+"$"+mo.name] = mo.id;
//			}
//			
//			var laMu:LaMuData = ToolsApp.curProjectData.curLaMu;
//			var item:LaMuItemData;
//			for(var i:int=0; i<laMu.data.length; i++)
//			{
//				var items:Vector.<LaMuStepData> = laMu.data[i].steps;
//				for(var j:int=0; j<items.length; j++)
//				{
//					var step:LaMuStepData = items[j];
//					for(var m:int=0; m<step.unitInfo.length; m++)
//					{
//						var unit:LaMuUnitData = step.unitInfo[m];
//						if(unit.resType == LaMuUnitData.RES_TYPE_MONSTER)
//						{ 
//							var id:int = cpdic[unit.ucloth+"_"+unit.upst];
//							if(id)
//							{
//								var tid = cpndic[unit.ucloth+"_"+unit.upst+"_"+unit.name];
//								if(tid)
//									id = tid;
//								unit.resParam = id;
//							}else{
//								unit.resType = LaMuUnitData.RES_TYPE_PAK;
//							}
//							
//						}
//					}
//				}
//			}
			
			
		}
		
		
		public function refushStepChange():void
		{
			if(ToolsApp.curProjectData.curLaMuStep==null)return;
			var item:LaMuStepData = ToolsApp.curProjectData.curLaMuStep;
			for(var i:int=0;i<_bindStepList.length; i++)
			{
				_bindStepList[i].bind(item);
				_bindStepList[i].initData();
			}
			combEndType.selectedIndex = item.endType;
			combCoordinate.selectedIndex= item.coordinateType;
			combCameraOper.selectedIndex = item.cameraOper;
		}
		
		private function handleCoordinateChange(index:int):void
		{
			if(ToolsApp.curProjectData.curLaMuStep==null)return;
			if(ToolsApp.curProjectData.curLaMuStep.coordinateType == index)return;
			ToolsApp.curProjectData.curLaMuStep.coordinateType = index;
			ToolsApp.view.ndPreView.uiMapView.changeCoordinateType();
		}
		
		
		public function refushUnit():void
		{
			if(ToolsApp.curProjectData.curLaMuUnit==null){return};
			var unit:LaMuUnitData = ToolsApp.curProjectData.curLaMuUnit;
			for(var i:int=0;i<_bindUnitList.length; i++)
			{
				_bindUnitList[i].bind(unit);
				_bindUnitList[i].initData();
			}
			combUnitType.selectedIndex = unit.resType;
			if(unit.resType == LaMuUnitData.RES_TYPE_NPC)
			{
				combUnitNPCList.selectedIndexFoce = combUnitNPCList.getIndexById(unit.resParam, 0);
			}else if(unit.resType == LaMuUnitData.RES_TYPE_MONSTER)
			{
				combUnitMonsterList.selectedIndexFoce = combUnitMonsterList.getIndexById(unit.resParam, 0);
			}
			combUnitAction.selectedIndexFoce = actionId2IndexDic[unit.action];
			handleCheckShowFace();
//			combUnitDir.selectedIndex = unit.face;
			
			
		}
		
		private function handleCameraOperChange(index:int):void
		{
			boxCameraOper.visible = index==LaMuStepData.CAMERA_OPER_MOVE || index == LaMuStepData.CAMERA_OPER_SKIP;
			boxCameraMoveTime.visible = index==LaMuStepData.CAMERA_OPER_MOVE;
			if(ProjectData.checkLaMuData(ProjectData.LAMU_STEP, false)==false)return;
			if(index<0)index = 0;
			ToolsApp.curProjectData.curLaMuStep.cameraOper = index;
		}
		
		private function handleCameraCurPos():void
		{
			inputCameraPosX.text = ToolsApp.view.ndPreView.uiMapView.screen2MapPosX(0)+"";
			inputCameraPosY.text = ToolsApp.view.ndPreView.uiMapView.screen2MapPosY(0)+"";
		}
		
		private function handleEndTypeChange(index:int):void
		{
			if(ProjectData.checkLaMuData(ProjectData.LAMU_STEP, false)==false)return;
			if(index<0)index = 0;
			ToolsApp.curProjectData.curLaMuStep.endType = index;
		}
		
		
		//Unit Control
		private function handleUnitResTypeChange(index:int):void
		{
			if(index==-1)return;

			boxUnitNpc.visible = index == LaMuUnitData.RES_TYPE_NPC;
			boxUnitMonster.visible = index == LaMuUnitData.RES_TYPE_MONSTER;
			boxUnitRes.visible= (index==LaMuUnitData.RES_TYPE_ANI || index==LaMuUnitData.RES_TYPE_PAK || index == LaMuUnitData.RES_TYPE_OTHER);
			boxUnitPst.visible = (index==LaMuUnitData.RES_TYPE_PAK|| index == LaMuUnitData.RES_TYPE_OTHER);
			boxUnitActionDir.visible = index!=LaMuUnitData.RES_TYPE_ANI;
			boxUnitRole.visible = index==LaMuUnitData.RES_TYPE_ROLE||index == LaMuUnitData.RES_TYPE_PAK||index == LaMuUnitData.RES_TYPE_MONSTER;
			if(ToolsApp.curProjectData && ToolsApp.curProjectData.curLaMuUnit)
			{
				ToolsApp.curProjectData.curLaMuUnit.resType = index;
				if(boxUnitNpc.visible)
				{
//					handleNpcSelectChange(combUnitNPCList.selectedIndex);
					combUnitNPCList.selectedIndexFoce = combUnitNPCList.getIndexById(ToolsApp.curProjectData.curLaMuUnit.resParam, 0);
//					ToolsApp.curProjectData.curLaMuUnit.resParam = combUnitNPCList.selectedIndex;
				}
				if(boxUnitMonster.visible)
				{
//					handleMonsterSelectChange(combUnitMonsterList.selectedIndex);
//					ToolsApp.curProjectData.curLaMuUnit.resParam = combUnitMonsterList.selectedIndex;
					combUnitMonsterList.selectedIndexFoce =  combUnitMonsterList.getIndexById(ToolsApp.curProjectData.curLaMuUnit.resParam, 0);
				}
				if(index == LaMuUnitData.RES_TYPE_ANI)
				{
					changeName("ani");
				}else if(index == LaMuUnitData.RES_TYPE_ROLE)
				{
					changeName("主角");
				}else if(index == LaMuUnitData.RES_TYPE_OTHER)
				{
					changeName("Other");
				}
				refushUnitCloth();
				
			}
		}
		
		private function handleNpcSelectChange(index:int):void
		{
			if(index<0)return;
			if(ProjectData.checkLaMuData(ProjectData.LAMU_UNIT)==false)return;
			var item:Object = combUnitNPCList.getDataByIndex(index);//(index>=0&&index<npcList.length)?npcList[index]:null;
			ToolsApp.curProjectData.curLaMuUnit.resParam = combUnitNPCList.getIdByIndex(index);
			if(item)
			{
				inputUnitPak.text = item.cloth;
				inputUnitPst.text = item.pst;
				changeName(item.name);
			}else{
				inputUnitPak.text = "";
				inputUnitPst.text = "";
			}
		}
		private function handleMonsterSelectChange(index:int):void
		{
			if(index<0)return;
			if(ProjectData.checkLaMuData(ProjectData.LAMU_UNIT)==false)return;
			var item:Object = combUnitMonsterList.getDataByIndex(index);//(index>=0&&index<monsterList.length)?monsterList[index]:null;
			ToolsApp.curProjectData.curLaMuUnit.resParam = combUnitMonsterList.getIdByIndex(index);
			if(item)
			{
				inputUnitPak.text = item.cloth;
				inputUnitPst.text = item.pst;
				changeName(item.name);
			}else{
				inputUnitPak.text = "";
				inputUnitPst.text = "";
			}
		}
		
		private function changeName(name:String):void
		{
			if(!inputUnitName.text || inputUnitName.text.charAt(0) == "$")
			{
				inputUnitName.text = "$"+name;
			}
		}
		
		private function handleUnitActionChange(index:int):void
		{
			if(index<0)return;
			if(ProjectData.checkLaMuData(ProjectData.LAMU_UNIT)==false)return;
			ToolsApp.curProjectData.curLaMuUnit.action = actionIndex2IdDic[index];
			ToolsApp.view.ndPreView.uiMapView.refushUnitAction();
		}
		
		private function handleUnitCenterPos():void
		{
			if(ProjectData.checkLaMuData(ProjectData.LAMU_UNIT)==false)return;
			if(ToolsApp.curProjectData.curLaMuStep.coordinateType == LaMuStepData.COORDINATE_MAP)
			{
				inputUnitPosX.text = ToolsApp.view.ndPreView.uiMapView.screen2MapPosX(0)+"";
				inputUnitPosY.text = ToolsApp.view.ndPreView.uiMapView.screen2MapPosY(0)+"";
			}else{
				inputUnitPosX.text = "0";
				inputUnitPosY.text = "0";
			}
			
		}
		private function handlerUnitLastPos():void
		{
			if(ProjectData.checkLaMuData(ProjectData.LAMU_UNIT)==false)return;
			var steps:Vector.<LaMuStepData> = ToolsApp.curProjectData.curLaMuItem.steps;
			var curStep:LaMuStepData = ToolsApp.curProjectData.curLaMuStep;
			var index:int = steps.indexOf(curStep);
			if(index <=0)return;
			var lastStep:LaMuStepData = steps[index-1];
			var lastUnit:LaMuUnitData;
			var curUnit:LaMuUnitData = ToolsApp.curProjectData.curLaMuUnit; 
			for(var i:int=0; i<lastStep.unitInfo.length; i++)
			{
				var u:LaMuUnitData = lastStep.unitInfo[i];
				if(u.id == curUnit.id)
				{
					lastUnit = u;
					break;
				}
			}
			if(lastUnit==null)return;
			if(curStep.coordinateType == lastStep.coordinateType)
			{
				inputUnitPosX.text = lastUnit.x+"";
				inputUnitPosY.text = lastUnit.y+"";
			}else{
				if(ToolsApp.curProjectData.curLaMuStep.coordinateType == LaMuStepData.COORDINATE_MAP)
				{
					inputUnitPosX.text = ToolsApp.view.ndPreView.uiMapView.screen2MapPosX(lastUnit.x)+"";
					inputUnitPosY.text = ToolsApp.view.ndPreView.uiMapView.screen2MapPosY(lastUnit.y)+"";
				}else{
					inputUnitPosX.text = ToolsApp.view.ndPreView.uiMapView.map2ScreenPosX(lastUnit.x)+"";
					inputUnitPosY.text = ToolsApp.view.ndPreView.uiMapView.map2ScreenPosY(lastUnit.y)+"";
				}
			}
		}
		
		private function handlerStepLastPos():void
		{
			if(ProjectData.checkLaMuData(ProjectData.LAMU_UNIT)==false)return;
			var steps:Vector.<LaMuStepData> = ToolsApp.curProjectData.curLaMuItem.steps;
			var curStep:LaMuStepData = ToolsApp.curProjectData.curLaMuStep;
			var index:int = steps.indexOf(curStep);
			if(index <=0)return;
			var lastStep:LaMuStepData = steps[index-1];
			if(lastStep)
				ToolsApp.view.ndPreView.uiMapView.setCenterPos(lastStep.centerMapX, lastStep.centerMapY);
		}
		
		private function handleUnitMoveToCenterPos():void
		{
			if(ProjectData.checkLaMuData(ProjectData.LAMU_UNIT)==false)return;
			if(ToolsApp.curProjectData.curLaMuStep.coordinateType == LaMuStepData.COORDINATE_MAP)
			{
				inputUnitToX.text = ToolsApp.view.ndPreView.uiMapView.screen2MapPosX(0)+"";
				inputUnitToY.text = ToolsApp.view.ndPreView.uiMapView.screen2MapPosY(0)+"";
			}else{
				inputUnitToX.text = "0";
				inputUnitToY.text = "0";
			}
		}
		
		private function handleUnitOperChange(index:int):void
		{
			boxUnitMove.visible = index != LaMuUnitData.OPER_TYPE_NONE;
		}
		
		public function refuseUnitInputTextPos():void
		{
			if(ProjectData.checkLaMuData(ProjectData.LAMU_UNIT)==false)return;
			inputUnitPosX.text = ToolsApp.curProjectData.curLaMuUnit.x+"";
			inputUnitPosY.text = ToolsApp.curProjectData.curLaMuUnit.y+"";
			inputUnitToX.text = ToolsApp.curProjectData.curLaMuUnit.tox+"";
			inputUnitToY.text = ToolsApp.curProjectData.curLaMuUnit.toy+"";
		}
		
		private function refushUnitPos():void
		{
			if(ProjectData.checkLaMuData(ProjectData.LAMU_UNIT)==false)return;
			ToolsApp.view.ndPreView.uiMapView.refushUnitPos();
		}
		private function refushUnitSay():void
		{
			if(ProjectData.checkLaMuData(ProjectData.LAMU_UNIT)==false)return;
			ToolsApp.view.ndPreView.uiMapView.refushUnitSay();
			if(ToolsApp.curProjectData.curLaMuUnit.showFace)
			{
				ToolsApp.view.ndPreView.uiLaMuView.setSay(ToolsApp.curProjectData.curLaMuUnit.say, inputUnitFace.text, ToolsApp.curProjectData.curLaMuUnit.faceLeft);
			}
		}
		private function refushUnitCloth():void
		{
			if(ProjectData.checkLaMuData(ProjectData.LAMU_UNIT)==false)return;
			ToolsApp.view.ndPreView.uiMapView.refushUnitCloth();
		}
		private function refushUnitRotation():void
		{
			if(ProjectData.checkLaMuData(ProjectData.LAMU_UNIT)==false)return;
			ToolsApp.view.ndPreView.uiMapView.refushUnitRotation();
		}
		
		private function refushUnitFace():void
		{
			if(ProjectData.checkLaMuData(ProjectData.LAMU_UNIT)==false)return;
			ToolsApp.view.ndPreView.uiMapView.refushUnitAction();
		}
		private function refushStepBaseInfo():void
		{
			if(ProjectData.checkLaMuData(ProjectData.LAMU_STEP)==false)return;
			ToolsApp.view.refushStepBaseInfo();
		}
		private function refushUnitBaseInfo():void
		{
			if(ProjectData.checkLaMuData(ProjectData.LAMU_UNIT)==false)return;
			ToolsApp.view.refushUnitBaseInfo();
		}
		
		
		private function handleCheckShowFace():void
		{
			if(checkUnitShowFace.selected)
			{
				if(ProjectData.checkLaMuData(ProjectData.LAMU_UNIT, false)==false)return;
				ToolsApp.view.ndPreView.uiLaMuView.setSay(ToolsApp.curProjectData.curLaMuUnit.say, inputUnitFace.text, ToolsApp.curProjectData.curLaMuUnit.faceLeft);
				boxUnitFace.visible = true;
			}else{
				ToolsApp.view.ndPreView.uiLaMuView.hide();
				boxUnitFace.visible = false;
			}
			refushUnitSay();
		}
		
		
		private function handleUseFaceMain():void
		{
			inputUnitFace.text = "{$main}";
		}
	}
}