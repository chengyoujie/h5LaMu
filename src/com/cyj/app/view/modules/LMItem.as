package com.cyj.app.view.modules
{
	import com.cyj.app.ToolsApp;
	import com.cyj.app.data.lamu.LaMuItemData;
	import com.cyj.app.utils.binddata.BindData;
	import com.cyj.app.utils.binddata.IBindData;
	import com.cyj.app.view.ui.laMuUI.LMListItemUI;
	
	import morn.core.handlers.Handler;
	
	public class LMItem extends LMListItemUI
	{
		private var _data:LaMuItemData;
		private var _bindList:Vector.<IBindData> = new Vector.<IBindData>();
		
		public function LMItem()
		{
			super();
			
		}
		
		override protected function initialize():void
		{
			_bindList.push(new BindData(inputID, "id"));
			_bindList.push(new BindData(inputName, "name"));
			
			
//			_bindList.push(new BindData(combTask, "value", "selectedIndex"));
			_bindList.push(new BindData(combState, "value2", "selectedIndex"));
			_bindList.push(new BindData(inputLevel, "value"));
			_bindList.push(new BindData(inputEvent, "value"));
			_bindList.push(new BindData(inputEndSendEvent, "endSendEvent"));
			
			combType.selectHandler = new Handler(handleTypeChange);	
			handleTypeChange(combType.selectedIndex);
			combTask.selectHandler = new Handler(handleTaskChange);
			combGuanKa.selectHandler = new Handler(handleGuanKaChange);
		}
		
		override public function set dataSource(value:Object):void
		{
			_data = value as LaMuItemData;
			if(_data == null)
				return;
//			inputID.text = _data.id+"";
//			inputName.text = _data.name;
			for(var i:int=0; i<_bindList.length; i++)
			{
				_bindList[i].bind(_data);
				_bindList[i].initData();
			}
			combTask.dataSource = ToolsApp.curProjectData.taskDataSource;
			combGuanKa.dataSouceExt = ToolsApp.curProjectData.guanKaData;
			combType.selectedIndexFoce = _data.type;
//			combTask.selectedIndexFoce = _data.
//			handleTypeChange(combType.selectedIndex);
//			boxEvent.visible = false;
//			boxLevel.visible = false;
		}
		
		
		
		private function handleTypeChange(index:int):void
		{
			boxTask.visible = index == LaMuItemData.TYPE_TASK;
			boxLevel.visible = index==LaMuItemData.TYPE_LEVEL;
			boxEvent.visible = index == LaMuItemData.TYPE_EVENT;
			boxGuanKa.visible = index == LaMuItemData.TYPE_GUANKA;
			if(_data)
			{
				if(boxTask.visible)
				{
					combTask.selectedIndexFoce = ToolsApp.curProjectData.getTaskIndexById(_data.value);
					combState.selectedIndexFoce = _data.value2;
				}else if(boxLevel.visible)
				{
					inputLevel.text = _data.value;
				}else if(boxEvent.visible)
				{
					inputEvent.text = _data.value;
				}else if(boxGuanKa.visible)
				{
					combGuanKa.selectedIndex = combGuanKa.getIndexById(_data.value);
				}
				_data.type = index;
			}
		}
		
		
		private function handleTaskChange(index:int):void
		{
			if(_data == null)return;
			if(index<0)return;
			_data.value =  ToolsApp.curProjectData.getTaskIdByIndex(index);
		}
		
		private function handleGuanKaChange(index:int):void
		{
			if(_data == null)return;
			if(index<0)return;
			_data.value =  combGuanKa.getIdByIndex(index);
		}
		
		override public function dispose():void
		{
			_data = null;
		}
		
		
	}
}