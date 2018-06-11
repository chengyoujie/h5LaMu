/**Created by the Morn,do not modify.*/
package com.cyj.app.view.ui.laMuUI {
	import morn.core.components.*;
	public class SayPanelUI extends View {
		public var bgSay:Image = null;
		public var txtSay:Label = null;
		protected static var uiXML:XML =
			<View width="234" height="123">
			  <Image skin="png.guidecomp.saypanel" x="0" y="0" width="234" height="123" sizeGrid="110,70,35,70" var="bgSay"/>
			  <Label text="说话内容" x="19" y="14" width="190" height="68" var="txtSay" color="0xff6600" wordWrap="true" multiline="true"/>
			</View>;
		public function SayPanelUI(){}
		override protected function createChildren():void {
			super.createChildren();
			createView(uiXML);
		}
	}
}