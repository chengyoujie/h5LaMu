package com.cyj.app.view.modules.unit
{
	import com.cyj.app.ToolsApp;
	import com.cyj.app.data.ProjectData;
	import com.cyj.app.data.lamu.LaMuStepData;
	import com.cyj.app.data.lamu.LaMuUnitData;
	import com.cyj.app.view.common.Alert;
	import com.cyj.app.view.modules.LMSayPanel;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	public class Unit extends Sprite
	{
		public static const COLOR_NORMAL:int = 0xcbcbcb;
		public static const COLOR_SELECT:int = 0xc6ff00;
		public static const ALPHA_NORMAL:Number = 0.4;
		public static const ALPHA_OVER:Number = 0.6;
		
		private var _data:LaMuUnitData;
		private var _select:Boolean = false;
		private var _color:int = COLOR_NORMAL;
		private var _avater:Avater;
		
		
		
		public function Unit(unitData:LaMuUnitData)
		{
			_data = unitData;
			_avater = new Avater(_data);
			this.addChild(_avater);
			refushSayPanel();
			_avater.refushCloth();  
			_avater.rotation = _data.rotation;
			handleMouseOut();
			this.addEventListener(MouseEvent.ROLL_OVER, handleMouseOver);
			this.addEventListener(MouseEvent.ROLL_OUT, handleMouseOut);
			this.addEventListener(MouseEvent.MOUSE_DOWN, handleStartDrag);
		}
		
		
		public function get data():LaMuUnitData                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   
		{
			return _data;
		}
		
		public function drawCirle(color:int, alpha:Number):void
		{
			this.graphics.clear();
			this.graphics.beginFill(color, alpha);
			this.graphics.drawCircle(0, 0, 50);
			this.graphics.lineStyle(1, 0xFFff00, 0.2);
			this.graphics.moveTo(0, -50);
			this.graphics.lineTo(0, 50);
			this.graphics.moveTo(-50, 0);
			this.graphics.lineTo(50, 0);
			this.graphics.endFill();
		}
		
		private function handleMouseOver(e:MouseEvent=null):void
		{
			drawCirle(_color, ALPHA_OVER);
		}
		
		
		private function handleMouseOut(e:MouseEvent=null):void
		{
			drawCirle(_color, ALPHA_NORMAL);
		}
		
		
		public function set select(value:Boolean):void
		{
			_select = value;
			_color = _select?COLOR_SELECT:COLOR_NORMAL;
			drawCirle(_color, 0.6);
		}
		
		public function get select():Boolean
		{
			return _select;
		}
		
		public function refushCloth():void
		{
			if(_avater)
				App.render.callLater(_avater.refushCloth);
		}
		
		public function refushAction():void
		{
			if(_avater)
				App.render.callLater(_avater.refushAction);
		}
		
		public function refushSayPanel():void
		{
			if(_avater)
				App.render.callLater(_avater.refushSayPanel);
		}
		
		public function refushRotation():void
		{
			if(_avater)
				_avater.rotation = _data.rotation;
		}
		public function render():void
		{
			if(_avater)
				_avater.render();
		}
		
		
		
		private function handleStartDrag(e:MouseEvent):void
		{
//			dispatchEvent(new NDEvent(NDEvent.UNIT_CLICK, _data, true));
			ToolsApp.view.changeUnit(_data);
			this.startDrag();
			this.stage.addEventListener(MouseEvent.MOUSE_UP, handleStopDrag);			
		}
		
		private function handleStopDrag(e:MouseEvent):void
		{
			this.stopDrag();
			if(ProjectData.checkLaMuData(ProjectData.LAMU_STEP,true)==false)return;
			var stepData:LaMuStepData = ToolsApp.curProjectData.curLaMuStep;
			if(stepData.coordinateType == LaMuStepData.COORDINATE_MAP)//地图坐标
			{
				_data.x = this.x;
				_data.y = this.y;
			}else{
				_data.x = ToolsApp.view.ndPreView.uiMapView.map2ScreenPosX(this.x);
				_data.y = ToolsApp.view.ndPreView.uiMapView.map2ScreenPosY(this.y);
			}
			this.stage.removeEventListener(MouseEvent.MOUSE_UP, handleStopDrag);
			ToolsApp.view.ndContian.refuseUnitInputTextPos();
//			dispatchEvent(new NDEvent(NDEvent.UNIT_POS_CHANGE, _data, true));
		}
		
		public function recyle():void
		{
			this.addEventListener(MouseEvent.ROLL_OVER, handleMouseOver);
			this.addEventListener(MouseEvent.ROLL_OUT, handleMouseOut);
			this.addEventListener(MouseEvent.MOUSE_DOWN, handleStartDrag);
			if(this.stage)
				this.stage.removeEventListener(MouseEvent.MOUSE_UP, handleStopDrag);
			if(this.parent)
			{
				this.parent.removeChild(this);
			}
			if(_avater)
				_avater.recyle();
			
		}
		
	}
}