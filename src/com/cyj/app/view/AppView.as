package com.cyj.app.view
{
	import com.cyj.app.ToolsApp;
	import com.cyj.app.config.ProjectConfig;
	import com.cyj.app.data.ProjectData;
	import com.cyj.app.data.lamu.LaMuData;
	import com.cyj.app.data.lamu.LaMuItemData;
	import com.cyj.app.data.lamu.LaMuStepData;
	import com.cyj.app.data.lamu.LaMuUnitData;
	import com.cyj.app.utils.ConfigParserUtils;
	import com.cyj.app.utils.ShareUtils;
	import com.cyj.app.view.common.Alert;
	import com.cyj.app.view.modules.LaMuComItem;
	import com.cyj.app.view.modules.unit.Unit;
	import com.cyj.app.view.ui.laMuUI.LMMainUI;
	import com.cyj.utils.Log;
	import com.cyj.utils.ObjectUtils;
	import com.cyj.utils.cmd.CMDManager;
	import com.cyj.utils.load.ResData;
	import com.cyj.utils.load.ResLoader;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	
	import morn.core.components.List;
	import morn.core.handlers.Handler;

	public class AppView extends LMMainUI
	{
		
		private var copybordData:*;
		private var fouceTarget:*;
		
		public function AppView()
		{
		}
		
		/** 初始化界面  **/		
		public function initView():void
		{
			txtAppName.text = ToolsApp.config.appName;
			var tempEmptyArr:Array = [];
			listNd.dataSource = tempEmptyArr;
			listStep.dataSource = tempEmptyArr;
			listUnit.dataSource = tempEmptyArr;
			listNd.selectHandler = new Handler(handleLaMuItemChange);
			listStep.selectHandler = new Handler(handleSetpSelect);
			listUnit.selectHandler = new Handler(handleUnitChange);
			btnAddItem.clickHandler = new Handler(handleAddItem);
			btnRemoveItem.clickHandler = new Handler(handleRemoveItem);
			
			btnAddStep.clickHandler = new Handler(handleAddStep);
			btnReomveStep.clickHandler = new Handler(handleRemoveStep);
			btnAddUnit.clickHandler = new Handler(handleAddUnit);
			btnReomveUnit.clickHandler = new Handler(handleRemoveUnit);
			btnStepIndexUp.clickHandler= new Handler(handleStepIndexUp);
			btnStepIndexDown.clickHandler= new Handler(handleStepIndexDown);
			btnUnitCengUp.clickHandler= new Handler(handleUnitIndexUp);
			btnUnitCengDown.clickHandler= new Handler(handleUnitIndexDown);
			btnItemIndexUp.clickHandler= new Handler(handleItemIndexUp);
			btnItemIndexDown.clickHandler= new Handler(handleItemIndexDown);
			
			listNd.addEventListener(MouseEvent.CLICK, handleClickListItem);
			listStep.addEventListener(MouseEvent.CLICK, handleClickListStep);
			listUnit.addEventListener(MouseEvent.CLICK, handleFindUnitPos);
			
			var list:Vector.<ProjectConfig> = ToolsApp.projectlist;
			var datasouce:Array = [];
			for(var i:int=0; i<list.length; i++)
			{
				datasouce.push(list[i].name);	
			}
			var selectIndex:int = ToolsApp.localCfg.lastProject;
			if(selectIndex>=datasouce.length || selectIndex<0)selectIndex = 0;
			combProjectList.dataSource= datasouce;
			combProjectList.selectedIndex = -1;
			combProjectList.selectHandler = new Handler(handleProjectChange);
			combProjectList.selectedIndex = selectIndex;
			//发布相关
			btnOpenGame.clickHandler = new Handler(openGame);
			btnPulish.clickHandler = new Handler(publishGame);
			btnSave.clickHandler = new Handler(handleSave);
			btnLoadNew.clickHandler = new Handler(handleLoadNew);
			App.stage.addEventListener(KeyboardEvent.KEY_UP, handleKeyUp);
			App.stage.addEventListener(Event.RESIZE, handleStageSizeChange);
			handleStageSizeChange();
		}
		
		private function handleProjectChange(index:int):void
		{
			if(index<0)return;
			if(index>=ToolsApp.projectlist.length)return;
			
			if(ToolsApp.checkProjectDataSave(handleCheckChangeProject, "保存", "不保存", true))
			{
				ToolsApp.changeProject(ToolsApp.projectlist[index]);
				ToolsApp.localCfg.lastProject = index;
			}
			
		}
		
		private function handleCheckChangeProject(isChange:Boolean):void
		{
			if(isChange)
			{
				handleSave();
			}
			ToolsApp.changeProject(ToolsApp.projectlist[combProjectList.selectedIndex]);
			ToolsApp.localCfg.lastProject = combProjectList.selectedIndex;
		}
		
		
		
		public function initPorject(data:LaMuData):void
		{
			if(ToolsApp.curPorjectConfig==null)return;
			ToolsApp.curProjectData = new ProjectData();
			ToolsApp.curProjectData.initProject(data);
			txtAppName.text = ToolsApp.config.appName+"-"+ToolsApp.curPorjectConfig.name;
			var f:File = new File(ToolsApp.curPorjectConfig.bindata);
			if(f.exists==false){Alert.show("请通知 程有杰 检查路径配置是否正确  bindata"+ToolsApp.curPorjectConfig.bindata);return;};
			ToolsApp.loader.loadSingleRes(f.url, ResLoader.BYT, handleParserCfgData, null, handleLoadError,null, false);
		
		}
		
		private function handleStageSizeChange(e:Event=null):void
		{
			var w:int = App.stage.stageWidth;
			var h:int = App.stage.stageHeight;
			ndContian.x = w-ndContian.width;
			ndContian.imgContentBg.height = Math.max(800, h);
			ndPreView.setViewSize(Math.max(100, w-listNd.width-ndContian.width), Math.max(100,h-ndPreView.y-txtLog.height));
			txtLog.y = h-txtLog.height;
			boxStepList.y = txtLog.y-boxStepList.height;
			boxUnitList.y = txtLog.y - boxUnitList.height;
			listNd.height = Math.max(115, h-listNd.y-( h-boxStepList.y));
			listNd.repeatY = listNd.height/110;
			txtAuth.y = h-txtAuth.height;
			txtAuth.x = ndContian.x-txtAuth.width;
			boxAppOper.x = ndContian.x -boxAppOper.width;
			txtAppName.width = Math.max(300, ndContian.x - btnItemIndexDown.x);
			
//			boxStepList.y = Math.min(listNd.y+listNd.height, boxStepList.y);
//			boxUnitList.y = Math.min(listNd.y+listNd.height, boxUnitList.y);
//			txtLog.y = Math.min(boxStepList.y+boxStepList.height, txtLog.y);
			
		}
		
		
		private function handleParserCfgData(res:ResData):void
		{
			var byte:ByteArray = res.data;
			ConfigParserUtils.parser(byte);
			ToolsApp.curProjectData.allCfgs= ConfigParserUtils.allCfgs;
			ToolsApp.curProjectData.cfgs = ConfigParserUtils.cfgData;
			ToolsApp.curProjectData.mapInfos = ConfigParserUtils.mapInfos;
			
			ToolsApp.loader.loadSingleRes(ToolsApp.curPorjectConfig.chengjiucfg, ResLoader.BYT, handleParserChengJiuData, null, handleLoadError);
			
		}
		
		private function handleParserChengJiuData(res:ResData):void
		{
			if(ProjectData.checkLaMuData(ProjectData.LAMU_DATA, false)==false)return;
			var byte:ByteArray = res.data;
			var chengjiu:Object = byte.readObject();
			ToolsApp.curProjectData.chengJiuData = chengjiu as Array;
			ToolsApp.curProjectData.initTaskList();
			ToolsApp.loader.loadSingleRes(ToolsApp.curPorjectConfig.monstercfg, ResLoader.BYT, handleReadMonsterCfg);
		}
		
		
		
		
		private function handleReadMonsterCfg(res:ResData):void
		{
			if(ProjectData.checkLaMuData(ProjectData.LAMU_DATA, false)==false)return;
			var byte:ByteArray = res.data;
			var monsterData:Object = byte.readObject();
			ToolsApp.curProjectData.monsterData = monsterData;

			initStartProject();
		}
		
		private function initStartProject():void
		{
			
			listNd.dataSource = ToolsApp.curProjectData.curLaMu.data;
			
			ndPreView.initProject();
			ndContian.initProject();
			listNd.selectedIndex = 0;
		}
		
		
		private function handleLoadError(res:ResData, msg:String):void
		{
			Alert.show("配置加载错误"+res.resPath+" Error:"+msg);
			Log.log("配置加载错误"+res.resPath+" Error:"+msg);
		}
		
		private function handleLaMuItemChange(index:int):void
		{
//			if(index == -1)return;
			var data:LaMuItemData = listNd.selectedItem as LaMuItemData;
			ToolsApp.curProjectData.curLaMuItem = data;
			if(data)
			{
				listStep.dataSource = data.steps;
				listStep.selectedIndex = 0;
				handleSetpSelect(listStep.selectedIndex);
			}else{
				ToolsApp.curProjectData.curLaMuStep = null;
			}
		}
		
		private function handleSetpSelect(index:int):void
		{
//			if(index == -1)return;
			var data:LaMuStepData = listStep.selectedItem as LaMuStepData;
			ToolsApp.curProjectData.curLaMuStep = data;
			if(data)
			{
				listUnit.dataSource = data.unitInfo;
				listUnit.selectedIndex = 0;
				handleUnitChange(listUnit.selectedIndex);
				ndPreView.uiMapView.refushStepChange();
			}else{
				ToolsApp.curProjectData.curLaMuUnit = null;
				listUnit.dataSource = ShareUtils.EMPTY_ARRAY;
			}
		}
		
		private function handleUnitChange(index:int):void
		{
//			if(index == -1)return;
			var data:LaMuUnitData = listUnit.selectedItem as LaMuUnitData;
			ToolsApp.curProjectData.curLaMuUnit = data;
		}
		
		public function changeUnit(unit:LaMuUnitData):void
		{
			var arr:* = listUnit.dataSource;
			if(arr==null)return;
			for(var i:int=0; i<arr.length; i++)
			{
				if(arr[i] == unit)
				{
					listUnit.selectedIndex = i;
					fouceTarget = listUnit.selectedItem;
					Log.log("当前选择了  单元"+(listUnit.selectedItem?listUnit.selectedItem.id+"-"+listUnit.selectedItem.name:listUnit.selectedIndex));
					break;
				}
			}
		}
		
		private function handleClickListItem(e:Event):void
		{
			fouceTarget = listNd.selectedItem;
			Log.log("当前选择了  项"+(listNd.selectedItem?listNd.selectedItem.id+"-"+listNd.selectedItem.name:listNd.selectedIndex));
		}
		private function handleClickListStep(e:Event):void
		{
			fouceTarget = listStep.selectedItem;
			Log.log("当前选择了  步骤"+(listStep.selectedItem?listStep.selectedItem.id+"-"+listStep.selectedItem.name:listStep.selectedIndex));
		}
		
		private var _lastClickTime:int = 0;
		private function handleFindUnitPos(e:Event=null):void
		{
			fouceTarget = listUnit.selectedItem;
			Log.log("当前选择了  单元"+(listUnit.selectedItem?listUnit.selectedItem.id+"-"+listUnit.selectedItem.name:listUnit.selectedIndex));
			if(getTimer() - _lastClickTime < 300)
				ndPreView.uiMapView.findUnitPos();
			_lastClickTime = getTimer();
		}
		
		public function refushStepBaseInfo():void
		{
			var item:LaMuComItem = listStep.selection as LaMuComItem;
			if(item)item.refush();
		}
		public function refushUnitBaseInfo():void
		{
			var item:LaMuComItem = listUnit.selection as LaMuComItem;
			if(item)item.refush();
		}
		
		public function handleAddItem():void
		{
			doAddSomeThing(ProjectData.LAMU_ITEM, LaMuItemData, listNd, false);
		}
		public function handleRemoveItem():void
		{
			doRemoveSomeThing(ProjectData.LAMU_ITEM, LaMuItemData, listNd);
		}
		
		public function handleAddStep():void
		{
			doAddSomeThing(ProjectData.LAMU_STEP, LaMuStepData, listStep);
			if(ProjectData.checkLaMuData(ProjectData.LAMU_STEP, false))
			{
				ToolsApp.curProjectData.curLaMuStep.mapId = int(ToolsApp.view.ndPreView.uiMapView.mapId);
			}
		}
		public function handleRemoveStep():void
		{
			doRemoveSomeThing( ProjectData.LAMU_STEP, LaMuStepData, listStep);
		}
		public function handleAddUnit():void
		{
			doAddSomeThing(ProjectData.LAMU_UNIT, LaMuUnitData, listUnit, true, ToolsApp.view.ndPreView.uiMapView.refushStepChange);
		}
		public function handleRemoveUnit():void
		{
			doRemoveSomeThing(ProjectData.LAMU_UNIT, LaMuUnitData, listUnit,ToolsApp.view.ndPreView.uiMapView.refushStepChange);
		}
		private function handleStepIndexDown():void
		{
			doSwapSomeThing(ProjectData.LAMU_STEP, listStep, 1);
		}
		private function handleStepIndexUp():void
		{
			doSwapSomeThing(ProjectData.LAMU_STEP, listStep, -1);
		}
		private function handleUnitIndexDown():void
		{
			doSwapSomeThing(ProjectData.LAMU_UNIT, listUnit, 1);
		}
		private function handleUnitIndexUp():void
		{
			doSwapSomeThing(ProjectData.LAMU_UNIT, listUnit, -1);
		}
		private function handleItemIndexDown():void
		{
			doSwapSomeThing(ProjectData.LAMU_ITEM, listNd, 1);
		}
		private function handleItemIndexUp():void
		{
			doSwapSomeThing(ProjectData.LAMU_ITEM, listNd, -1);
		}
		
		
		
		private function doAddSomeThing(dataId:int, cls:Class, list:List, iscopy:Boolean=true, selectPreDo:Function=null):void
		{
			var data:* = ProjectData.getLaMuDatas(dataId, true);
			if(data==null)return;
			var item:* = new cls();
			if(iscopy && data.length>0)
			{
				ObjectUtils.copyObject(data[data.length-1], item);	
				if(item is LaMuStepData)//添加下一步时候直接把当前步中的角色动作执行到下一步
				{
					var step:LaMuStepData = LaMuStepData(item);
					for(var i:int=0; i<step.unitInfo.length; i++)
					{
						var u:LaMuUnitData = step.unitInfo[i];
						if(u.operType == LaMuUnitData.OPER_TYPE_MOVE || u.operType == LaMuUnitData.OPER_TYPE_JUMP)//如果是移动的话，添加后直接让单元移动到后一帧
						{
							u.x = u.tox;
							u.y = u.toy;
							u.action = LaMuUnitData.OPER_TYPE_NONE;
						}
					}
					if(step.cameraOper == LaMuStepData.CAMERA_OPER_MOVE || step.cameraOper == LaMuStepData.CAMERA_OPER_SKIP)
					{
						step.centerMapX = step.camerax;
						step.centerMapY = step.cameray;
						step.cameraOper = LaMuStepData.CAMERA_OPER_LAST;
					}
				}
			}
			addSomeThingData(dataId, item, list, selectPreDo);
		}
		
		private function addSomeThingData(dataId:int, itemData:*, list:List, selectPreDo:Function=null):void
		{
			var data:* = ProjectData.getLaMuDatas(dataId, true);
			if(data==null)return;
			itemData.id = getMaxId(data)+1;
			data.push(itemData);
			list.dataSource = data;
			if(selectPreDo != null)
			{
				selectPreDo.apply();
			}
			list.selectedIndex = data.length-1;
		}
		
		private function doRemoveSomeThing(dataId:int, cls:Class, list:List, selectPreDo:Function=null):void
		{
			var index:int=list.selectedIndex;
			if(index<0)
			{
				Alert.show("请先选择一个要删除的项");
				return ;
			}
			var data:* = ProjectData.getLaMuDatas(dataId, true);
			if(data==null)return;
			data.splice(index,1);
			list.dataSource = data;
			if(selectPreDo != null)
			{
				selectPreDo.apply();
			}
			list.selectedIndex = index<data.length-1?index:data.length-1;
		}
		
		private function getMaxId(data:*, prop:String="id"):int
		{
			var maxid:int= 0;
			for(var i:int=0;i<data.length; i++)
			{
				if(data[i][prop]>maxid)
					maxid = data[i][prop];
			}
			return maxid;
		}
		
		private function doSwapSomeThing(dataId:int, list:List, swapDepth:int=1):void
		{
			var index:int=list.selectedIndex;
			if(index<0)
			{
				Alert.show("请先选择一个要删除的项");
				return ;
			}
			var data:* = ProjectData.getLaMuDatas(dataId, true);
			if(data==null)return;
			if(data.length==0)
			{
				Alert.show("当前没有数据");
				return;
			}
			var toIndex:int = index+swapDepth;
			if(toIndex<0)
			{
				Alert.show("当前已经到达最顶层了");
				return;
			}
			if(toIndex>=data.length)
			{
				Alert.show("当前已经到达最底层了");
				return;
			}
			var temp:* = data[index];
			data[index] = data[toIndex];
			data[toIndex] = temp;
			list.dataSource = data;
			list.selectedIndex = toIndex;
		}
		
		
		private function handleKeyUp(e:KeyboardEvent):void
		{
			if(e.ctrlKey)//ctr键按下
			{
				var foc:DisplayObject = stage.focus;
				var canPase:Boolean = true;
				var des:String ="";
				if(foc is TextField&& TextField(foc).type==TextFieldType.INPUT)
				{
					canPase = false;
				}
				if(e.keyCode == 83)//ctr+s
				{
					stage.focus = null;
					handleSave();
				}else if(e.keyCode == 67 && canPase)//ctr+c
				{
//					handleCopyList();
					if(fouceTarget)
					{
						if(fouceTarget  is LaMuItemData)
						{
							copybordData = new LaMuItemData();
							des = "拉幕  项";
						}else if(fouceTarget is LaMuStepData)
						{
							copybordData = new LaMuStepData();
							des = "拉幕  步骤";
						}else if(fouceTarget is LaMuUnitData)
						{
							copybordData = new LaMuUnitData();
							des = "拉幕  单元";
						}
						if(copybordData)
						{
							ObjectUtils.copyObject(fouceTarget, copybordData);
							Log.log("当前剪贴板上数据"+des);
						}else{
							Log.log("当前没有选择任何有效数据");
						}
					}
				}else if(e.keyCode == 86 && canPase)//ctr+v
				{
//					handlePastList();
					if(copybordData  is LaMuItemData)
					{
						addSomeThingData(ProjectData.LAMU_ITEM, copybordData, listNd);
						des = "拉幕  项";
					}else if(copybordData is LaMuStepData)
					{
						addSomeThingData(ProjectData.LAMU_STEP, copybordData, listStep);
						des = "拉幕  步骤";
					}else if(copybordData is LaMuUnitData)
					{
						addSomeThingData(ProjectData.LAMU_UNIT, copybordData, listUnit, ToolsApp.view.ndPreView.uiMapView.refushStepChange);
						des = "拉幕  单元";
					}
					if(des)
					{
						Log.log("粘贴成功"+des);
						copybordData = null;
					}
				}else if(e.keyCode == 81)//ctr+q
				{
//					handleUpLoad();
					openGame();
				}else if(e.keyCode == 87)//ctr+w
				{
//					handleSvnUpdata();
					publishGame();
				}else if(e.keyCode== 68)//ctr + d
				{
					
				}
			}
		}
		
		public function handleSave():void
		{
			if(ToolsApp.curPorjectConfig && ToolsApp.curProjectData && ToolsApp.curProjectData.curLaMu)
			{
				var str:String= JSON.stringify(ToolsApp.curProjectData.curLaMu);
				ToolsApp.lastSaveData = new LaMuData();
				ObjectUtils.copyObject(ToolsApp.curProjectData.curLaMu, ToolsApp.lastSaveData);
				ToolsApp.file.saveFile(ToolsApp.curPorjectConfig.path, str);
				Log.log("保存完毕");
			}else{
				Log.log("保存失败,没有项目或者数据");	
			}
		}
		
		private function openGame():void
		{
			if(ToolsApp.curPorjectConfig)
			{
				CMDManager.runStringCmd("explorer "+ToolsApp.curPorjectConfig.gameurl);
				Log.log("打开游戏"+ToolsApp.curPorjectConfig.gameurl);
			}else{
				Alert.show("没有项目配置");
			}
		}
		
		private function publishGame():void
		{
			if(ToolsApp.curPorjectConfig==null){Alert.show("当前没有选择项目");return;};
			if(ToolsApp.checkProjectDataSave(toDoPublish, "保存", "不保存", true))
			{
				newpublish();
			}
		}
		
		private function toDoPublish(isChange:Boolean):void
		{
			if(ToolsApp.curPorjectConfig)
			{
				if(isChange)
				{
					handleSave();
				}
				newpublish();
//				CMDManager.runStringCmd("copy /y "+ToolsApp.curPorjectConfig.path.replace(/\//gi, "\\") +" "+ToolsApp.curPorjectConfig.jsoncopyto);
//				Alert.show("上传完毕");
			}else{
				Alert.show("没有项目配置");
			}
		}
		
		
		//下载最新的配置
		private function handleLoadNew():void
		{
			Alert.show("是否使用远程文件覆盖本地文件？  慎重操作 ","提示", Alert.ALERT_OK_CANCLE, handleIsLoadNew);
			
		}
	
		private function handleIsLoadNew(del:int):void
		{
			if(ToolsApp.curPorjectConfig==null){Alert.show("当前没有选择项目");return;};
			if(del == Alert.ALERT_OK)
			{
				ToolsApp.loadNewRemoteData(ToolsApp.curPorjectConfig);
			}
		}
		
		private var _isPublishing:Boolean = false;
		private function newpublish():void
		{
			var f:File = new File(ToolsApp.curPorjectConfig.bindata);
			if(f.exists==false){Alert.show("请通知 程有杰 检查路径配置是否正确  bindata"+ToolsApp.curPorjectConfig.bindata);return;};
			if(_isPublishing){Alert.show("当前正在发布中， 不要急。。。等会再发布");return;};
			_isPublishing = true;
			ToolsApp.loader.loadSingleRes(f.url, ResLoader.BYT, handleLoadedNewCfg, null, null, null, false);
		}
		
		private function handleLoadedNewCfg(res:ResData):void
		{
			var byte:ByteArray = res.data;
			var str:String= JSON.stringify(ToolsApp.curProjectData.curLaMu);
			var thinData = thinData(str);
			var testByte:ByteArray = ConfigParserUtils.writeStroy(byte, thinData, ToolsApp.curPorjectConfig.filename);
			testByte.position = 0;
//			ConfigParserUtils.parser(testByte);
			ToolsApp.file.saveByteFile(ToolsApp.curPorjectConfig.bindata, testByte);
			//检查是否相同
			ToolsApp.file.saveFile(ToolsApp.curPorjectConfig.jsonpublishto, thinData);//写到  raw/client/中
			ToolsApp.file.saveFile(ToolsApp.curPorjectConfig.jsoncopyto, str);//写到 raw/story/中
//			CMDManager.runStringCmd("copy /y "+ToolsApp.curPorjectConfig.path.replace(/\//gi, "\\") +" "+ToolsApp.curPorjectConfig.jsoncopyto);
			Alert.show("上传完毕");
			_isPublishing = false;
		}
		
		
		/**
		 *精简不必要的数据   能从415k缩减到171k 
		 * @param jsonstr
		 * @return 
		 * 
		 */		
		private function thinData(jsonstr:String):String
		{
			var obj:Object = JSON.parse(jsonstr);
			var ladata:Object = obj.data;
			var outdata:Array = [];
			if(ladata)
			{
				for(var item:String in ladata)
				{
					var idata:Object = ladata[item];
					if(idata.type == LaMuItemData.TYPE_NOTUSE)
					{
						continue;
					}
					delete idata["name"];//编辑器中用到的字段	
					var steps:Object = idata.steps;
					if(steps)
					{
						for(var key:String in steps)
						{
							var step:Object = steps[key];
							delete step["centerMapX"];//编辑器中用到的字段
							delete step["centerMapY"];//编辑器中用到的字段
							delete step["name"];//编辑器中用到的字段
							var unit:Object = steps[key].unitInfo;
							if(unit)
							{
								for(var u:String in unit)
								{
									var udata:Object=unit[u];
									if(udata)
									{
										if(!udata.say)
										{
											delete udata["name"];//如果不说话这个字段也无用
										}else{
											if(udata.name)udata.name = udata.name.replace(/\$/gi, "");
										}
										delete udata["resParam"];//编辑器中用到的字段
									}
								}
							}
						}
					}
					
					outdata.push(ladata[item]);
				}
			}
			obj.data = outdata;
			thinNoData(obj);
			return JSON.stringify(obj);
		}
		
		private function thinNoData(obj:Object):Object
		{
			for(var key:String in obj)
			{
				if(!obj[key] )
				{
					delete obj[key];
				}else if(obj[key] is Number || obj[key] is String || obj[key] is Boolean){
					
				}else{
					thinNoData(obj[key]);
				}
			}
			return obj;
		}
		
	}
}