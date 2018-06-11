package com.cyj.app.view.modules
{
	import com.cyj.app.view.ui.laMuUI.SayPanelUI;
	
	public class LMSayPanel extends SayPanelUI
	{
		private var isShowLaMu:Boolean = false;
		public function LMSayPanel()
		{
			super();
		}
		
		public function say(value:String):void
		{
			txtSay.text = value;
		}
		
		public function recyle():void
		{
			txtSay.text = "";
		}
		
		
		public function refushSayPanelType(isLaMu:Boolean):void
		{
			if(isShowLaMu == isLaMu)return;
			isShowLaMu = isLaMu;
			if(isLaMu)
				bgSay.skin=  "png.guidecomp.saylamu";
			else
				bgSay.skin = "png.guidecomp.saypanel";
		}
		
	}
}