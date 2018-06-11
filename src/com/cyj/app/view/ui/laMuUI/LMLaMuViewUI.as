/**Created by the Morn,do not modify.*/
package com.cyj.app.view.ui.laMuUI {
	import morn.core.components.*;
	public class LMLaMuViewUI extends View {
		public var imgLaMuBg:Image = null;
		public var imgLaMuFace:Image = null;
		public var txtSay:Label = null;
		protected static var uiXML:XML =
			<View width="785" height="240">
			  <Image skin="png.comp.blank" y="49" sizeGrid="3,3,3,3,1" width="785" height="190" var="imgLaMuBg" x="0"/>
			  <Image skin="png.comp.image" x="630" var="imgLaMuFace" y="-14"/>
			  <Label text="说话内容" x="30" y="89" width="599" height="138" color="0xffcc33" var="txtSay"/>
			</View>;
		public function LMLaMuViewUI(){}
		override protected function createChildren():void {
			super.createChildren();
			createView(uiXML);
		}
	}
}