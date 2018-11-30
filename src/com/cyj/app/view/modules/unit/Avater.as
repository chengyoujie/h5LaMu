package com.cyj.app.view.modules.unit
{
	import com.cyj.app.ToolsApp;
	import com.cyj.app.data.lamu.LaMuUnitData;
	import com.cyj.app.data.map.ADKey;
	import com.cyj.app.data.map.PstInfo;
	import com.cyj.app.utils.ShareUtils;
	import com.cyj.app.view.modules.LMSayPanel;
	import com.cyj.utils.load.ResData;
	import com.cyj.utils.load.ResLoader;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.utils.getTimer;

	public class Avater extends Sprite
	{
		public static const UNIT_DIR_NAME:String = "u/";
		public static const ANI_DIR_NAME:String = "a/";
		private var _data:LaMuUnitData;
		private var _pst:String;
		private var _pak:String;
		private var _resKey:String;
		private var _pstInfo:PstInfo;
		private var _aniInfo:Object;
		private var _preDicName:String="u";
		private var _splitImgData:Object;
		private var _mod:Shape;
		private var _bigBd:BitmapData;
		private var _dataurl:String;
		private var _imgurl:String;
		
		private var _sayPanel:LMSayPanel;
		
//		private static var _sayPanelPool:Vector.<LMSayPanel> = new Vector.<LMSayPanel>();
		
		
		public function Avater(unitData:LaMuUnitData)
		{
			_data = unitData;
			_mod = new Shape();
			this.addChild(_mod);
			this.mouseChildren = this.mouseEnabled = false;
			
			_sayPanel = /*_sayPanelPool.length>0?_sayPanelPool.shift():*/new LMSayPanel();
			this.addChild(_sayPanel);
			refushSayPanel();
			
		}
		
		public function refushCloth():void
		{
			if(ToolsApp.curProjectData==null)return;
			
			_splitImgData = null;
			drawBlockAvater();
			
			_pak = "";
			_pst = "";
			_pstInfo = null;
			_aniInfo= null;
//			if(_data.resType == LaMuUnitData.RES_TYPE_MONSTER || _data.resType == LaMuUnitData.RES_TYPE_NPC || _data.resType == LaMuUnitData.RES_TYPE_PAK || _data.resType == LaMuUnitData.RES_TYPE_ROLE)
//			{
//			}
			if(_data.resType == LaMuUnitData.RES_TYPE_ANI)
			{
				
				var anis:Object = ToolsApp.curProjectData.aniCfgs;
				_pak = _data.ucloth;
				_preDicName = ANI_DIR_NAME;
//				_aniInfo = anis[_pak];
			}else {
				var psts:Object = ToolsApp.curProjectData.pstCfgs;
				if(_data.resType == LaMuUnitData.RES_TYPE_ROLE)
				{
					var juse:Object = ToolsApp.curProjectData.cfgs.JueSe;
					var obj:Object = juse[ToolsApp.curPorjectConfig.mainroleindex];
					if(obj)
					{
						_pst = obj.pst;
						_pak = obj.cloth;
					}else{
						_pst = _data.upst;
						_pak = _data.ucloth;
					}
				}else{
					_pst = _data.upst;
					_pak = _data.ucloth;
				}
				_pstInfo= psts[_pst];
				if(_pstInfo==null)return;
				if(_data.resType == LaMuUnitData.RES_TYPE_OTHER)
				{
					_preDicName = "";
				}else{
					_preDicName = UNIT_DIR_NAME;
				}
			}
			
			if(_preDicName)
				_dataurl = ToolsApp.curPorjectConfig.resurl+"/"+_preDicName+"/"+_pak+"/d.json";
			else
				_dataurl = ToolsApp.curPorjectConfig.resurl+""+_pak+"/d.json";
				
			
			ToolsApp.loader.loadSingleRes(_dataurl, ResLoader.TXT, handleSplitDataLoaded);
		}
		
		
		public function refushAction():void
		{
			_bigBd = null;
			drawBlockAvater();
			if(_data.resType == LaMuUnitData.RES_TYPE_ANI)
			{
				_resKey = "a0";
			}else{
				if(_pstInfo == null)return;
				var d:int = _data.face;
				if (d > 4) {
					d = 8 - d;
				}
				var resKey:String = _pstInfo.splitInfo.getResName(_data.action, d);
				if(!resKey)return;
				_resKey = resKey;
			}
			_frameIndex = 0;
			_imgurl = ToolsApp.curPorjectConfig.resurl+"/"+_preDicName+"/"+_pak+"/"+_resKey+".png";
			ToolsApp.loader.loadSingleRes(_imgurl, ResLoader.IMG, handleImgLoaded);
		}
		
		private function  handleSplitDataLoaded(res:ResData):void
		{
			if(res.resPath != _dataurl)return;
			_splitImgData = JSON.parse(res.data);//[动作] [方向] [帧数]
			if(_data.resType == LaMuUnitData.RES_TYPE_ANI)
			{
				_aniInfo = _splitImgData[0];
				_splitImgData = _splitImgData[1];
			}
			refushAction();
		}
		
		
//		private function getTextureFromImageData(data) {
//			var texture = new egret.Texture();
//			var sx: number = data[0]; 
//			var sy: number = data[1];
//			texture.tx = data[2] || 0;
//			texture.ty = data[3] || 0;
//			var width: number = data[4];
//			var height: number = data[5];
//			texture.$initData(sx, sy, width, height, 0, 0, width, height, width, height);
//			return texture;
//		}
		
		private function handleImgLoaded(res:ResData):void
		{
			if(res.resPath != _imgurl)return;
			_bigBd = res.data;
			_renderTime = 0;
			render();
			refushSayPanel();
		}
		
		private var _frameIndex:int;
		private var _renderTime:int;
		public function render():void
		{
			if(_splitImgData==null || _bigBd == null || _data == null)return;
			if(getTimer()<=_renderTime)return;
			
			var action:int = _data.action;
			var d:int = _data.face;
			if(_data.resType == LaMuUnitData.RES_TYPE_ANI)
			{
				_renderTime = getTimer()+100;
				action = 0;
				d = 0;
			}
			var actData:Array = _splitImgData[action];
			if(actData==null)return;
			var scale:int= 1;
			if (d > 4) {
				scale = -1;
				d = 8 - d;
			}
			var faceData:Array = actData[d];
			if(faceData == null)return;
			_frameIndex ++;
			if(_frameIndex>=faceData.length)_frameIndex=0;
			var data:Array = faceData[_frameIndex] as Array;
			if(data == null)return;
			ShareUtils.MATRIX.identity();
//			ShareUtils.MATRIX.scale(scale, 1);
			ShareUtils.MATRIX.tx = (-data[0]-data[2]);
			ShareUtils.MATRIX.ty =  -data[1]-data[3];
//			ShareUtils.MATRIX.a = scale;
			_mod.graphics.clear();
			_mod.graphics.beginBitmapFill(_bigBd, ShareUtils.MATRIX, false, false);
			_mod.graphics.drawRect(-data[2],-data[3], data[4], data[5]);
			_mod.graphics.endFill();
			_mod.scaleX= scale;
			if(_data.resType != LaMuUnitData.RES_TYPE_ANI)
			{
				if(_pstInfo &&   _pstInfo.frames[_data.action] && _pstInfo.frames[_data.action].frames.length>_frameIndex)
				{
					_renderTime = getTimer()+_pstInfo.frames[_data.action].frames[_frameIndex].t;
				}else{
					_renderTime = getTimer()+250;
				}
			}else{
				if(_aniInfo &&   _aniInfo[2][action] && _aniInfo[2][action][0].length>_frameIndex)
				{
					_renderTime = getTimer()+_aniInfo[2][action][0][_frameIndex][2];
				}else{
					_renderTime = getTimer()+250;
				}
			}
		}
		
		private function drawBlockAvater():void
		{
			_mod.graphics.clear();
			ShareUtils.MATRIX.identity();
			ShareUtils.MATRIX.tx = -ToolsApp.BLOCK_AVATER.width/2;
			ShareUtils.MATRIX.ty = -ToolsApp.BLOCK_AVATER.height;
			_mod.graphics.beginBitmapFill(ToolsApp.BLOCK_AVATER, ShareUtils.MATRIX, false);
			_mod.graphics.drawRect(-ToolsApp.BLOCK_AVATER.width/2, -ToolsApp.BLOCK_AVATER.height, ToolsApp.BLOCK_AVATER.width, ToolsApp.BLOCK_AVATER.height);
			_mod.graphics.endFill();
			refushSayPanel();
		}
		
		
		public function refushSayPanel():void
		{
			if(_data.say)
			{
				_sayPanel.say(_data.say);
				_sayPanel.visible = true;
				_sayPanel.x = -_mod.width/2-50;
				_sayPanel.y = -_mod.height-_sayPanel.height;
				_sayPanel.refushSayPanelType(_data.showFace);
			}else{
				
				_sayPanel.visible = false;	
			}
		}
		
		
		public function recyle():void
		{
			
			if(this.parent)
			{
				this.parent.removeChild(this);
			}
			if(_sayPanel)
			{
				_sayPanel.recyle();
				_sayPanel.visible = false;
//				if(_sayPanelPool.length<10)
//				{
//					_sayPanelPool.push(_sayPanel);
//				}
			}
			
		}
	}
}