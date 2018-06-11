package com.cyj.app.view.modules
{
	import com.cyj.app.view.ui.laMuUI.ComListItemUI;
	
	public class LaMuComItem extends ComListItemUI
	{
		private var _data:Object;
		
		public function LaMuComItem()
		{
			super();
		}
		
		override public function set dataSource(value:Object):void
		{
			_data = value;
			if(_data == null)return;
			if(_data.hasOwnProperty("id"))
			{
				txtId.text = _data["id"];
			}
			if(_data.hasOwnProperty("name"))
			{
				txtName.text = _data["name"];
			}
		}
		
		
		public function refush():void
		{
			if(_data == null)return;
			if(_data.hasOwnProperty("id"))
			{
				txtId.text = _data["id"];
			}
			if(_data.hasOwnProperty("name"))
			{
				txtName.text = _data["name"];
			}
		}
		
	}
}