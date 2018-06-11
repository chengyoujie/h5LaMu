package com.cyj.app.view.modules
{
	import com.cyj.app.ToolsApp;
	import com.cyj.app.config.ToolsConfig;
	import com.cyj.app.view.ui.laMuUI.LMLaMuViewUI;
	import com.cyj.utils.load.ResData;
	import com.cyj.utils.load.ResLoader;
	
	import flash.geom.Point;
	
	public class LMLaMuView extends LMLaMuViewUI
	{
		public function LMLaMuView()
		{
			super();
		}
		
		public function initProject():void
		{
			this.visible = false;
		}
		
		private var _curFace:String;
		private var _size:Point = new Point();
		private var _isLeft:Boolean;
		public function setViewSize(w:int, h:int):void
		{
			_size.x = w-20;
			_size.y  = h-18;
			imgLaMuBg.width = _size.x;
			imgLaMuBg.x = 0;
//			imgLaMuBg.height = h;
			this.y = _size.y - this.height;
			txtSay.width = _size.x/3*2;
			refushFacePos();
		}
		
		
		public function setSay(say:String, facePic:String, isLeft:Boolean):void
		{
			txtSay.text = say;
			_isLeft = isLeft;
			_curFace = facePic;
			this.visible = true;
			imgLaMuFace.bitmapData = null;
			
			
			if(_curFace)
			{
				if(_curFace=="{$main}")
					_curFace = ToolsApp.curPorjectConfig.mainface;
				ToolsApp.loader.loadSingleRes(ToolsApp.curPorjectConfig.facepath+"/"+_curFace+".png", ResLoader.IMG, handleFaceLoaded, null, null, _curFace);
			}
		}
		
		public function hide():void
		{
			this.visible = false;
			imgLaMuFace.bitmapData = null;
		}
		
		
		private function refushFacePos():void
		{
			if(_isLeft)
			{
				imgLaMuFace.x =0;
				txtSay.x = _size.x - txtSay.width-30;
			}else{
				imgLaMuFace.x = imgLaMuBg.width-imgLaMuFace.width;
				txtSay.x = 30;
			}
			
				imgLaMuFace.y = this.height -imgLaMuFace.height;
//			txtSay.width = 
		}
		
		private function handleFaceLoaded(res:ResData):void
		{
			if(_curFace != res.param)return;
			imgLaMuFace.bitmapData = res.data;
			refushFacePos();
		}
		
		
	}
}
