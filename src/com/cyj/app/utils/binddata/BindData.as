package com.cyj.app.utils.binddata
{
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.text.TextField;
	
	import morn.core.components.TextInput;

	public class BindData implements IBindData
	{
		private var _bindUI:*;
		private var _uiProp:String;
		private var _data:Object;
		private var _prop:String;
		private var binded:Boolean = false;
		private var _onChangeFun:Function;
		
		
		public function BindData(bindUI:*, prop:String, uiProp:String="text", onChangeFun:Function=null)
		{
			_bindUI = bindUI;
			_uiProp = uiProp;
			_prop = prop;
			_onChangeFun = onChangeFun;
		}
		
		public function bind(data:Object):void
		{
			if(binded)
				unBind();
			_data = data;
			binded = true;
//			_text.addEventListener(FocusEvent.FOCUS_OUT, handleFouceOut);
			_bindUI.addEventListener(Event.CHANGE, handleFouceOut);
		}
		
		public function initData():void
		{
			if(_data==null)return;
			_bindUI[_uiProp] = _data[_prop];
		}
		
		public function unBind():void
		{
			if(_bindUI)
			{
//				_text.removeEventListener(FocusEvent.FOCUS_OUT, handleFouceOut);
				_bindUI.removeEventListener(Event.CHANGE, handleFouceOut);
			}
			_data = null;
			binded = false;
//			_onChangeFun = null;
		}
		
		private function handleFouceOut(e:Event):void
		{
			if(_data ==null)return;
			_data[_prop] = _bindUI[_uiProp]; 
			if(_onChangeFun !=null)
				_onChangeFun.apply();
		}
	}
}