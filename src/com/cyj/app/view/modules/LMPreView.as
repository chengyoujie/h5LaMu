package com.cyj.app.view.modules
{
	import com.cyj.app.view.ui.laMuUI.LMPreViewUI;
	
	public class LMPreView extends LMPreViewUI
	{
		public function LMPreView()
		{
			super();
		}
		
		
		public function  initProject():void
		{
			uiMapView.initProject();
			uiLaMuView.initProject();
		}
		
		public function setViewSize(w:int, h:int):void
		{
			uiMapView.setViewSize(w,h);
			uiLaMuView.setViewSize(w,h);
		}
		
	}
}