package com.cyj.app.view.common
{
	import com.cyj.app.view.compont.AbstractPanel;
	import com.cyj.app.view.ui.common.AlertUI;

	public class AlertPanel extends AbstractPanel
	{
		public var ui:AlertUI = new AlertUI();
		
		public function AlertPanel()
		{
			super();
		}
		
		
		override protected function initView():void
		{
			super.initView();
			_dragImg = ui.bg;
			addChild(ui);
		}
	}
}