package com.cyj.app.view.compont
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	public class AbstractPanel extends Sprite
	{
		protected var _dragImg:DisplayObject;
		protected var _closeBtn:DisplayObject;
		
		public function AbstractPanel()
		{
			initView();
			initEvent();
		}
		
		protected function initView():void
		{
			
		}
		
		protected function initEvent():void
		{
			if(_dragImg)
				_dragImg.addEventListener(MouseEvent.MOUSE_DOWN, handleStartDrag);
			if(_closeBtn)
				_closeBtn.addEventListener(MouseEvent.MOUSE_DOWN, handleClose);
		}
		
		private function handleStartDrag(e:MouseEvent):void
		{
			_dragImg.addEventListener(MouseEvent.MOUSE_UP, handleStopDrag);
			this.startDrag();
		}
		
		private function handleStopDrag(e:MouseEvent):void
		{
			this.stopDrag();
		}
		
		protected function handleClose(e:MouseEvent):void
		{
			close();
		}
		
		public function close():void
		{
			if(this.parent)
			{
				this.parent.removeChild(this);
			}
		}
		
		
	}
}