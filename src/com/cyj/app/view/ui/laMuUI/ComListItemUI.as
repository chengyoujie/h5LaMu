/**Created by the Morn,do not modify.*/
package com.cyj.app.view.ui.laMuUI {
	import morn.core.components.*;
	public class ComListItemUI extends View {
		public var txtId:Label = null;
		public var txtName:Label = null;
		protected static var uiXML:XML =
			<View width="138" height="26">
			  <Image skin="png.guidecomp.内框_圆角2" sizeGrid="10,10,10,10,1" width="144" height="27" x="0" y="0"/>
			  <Label text="1" x="11" y="3" width="29" height="18" color="0xffcc00" var="txtId"/>
			  <Label text="名字" x="49" y="4" width="86" height="18" color="0xffcc00" var="txtName"/>
			  <Clip skin="png.guidecomp.clip_格子选中" x="3" y="0" sizeGrid="10,10,10,10,1" name="selectBox" width="138" height="26"/>
			</View>;
		public function ComListItemUI(){}
		override protected function createChildren():void {
			super.createChildren();
			createView(uiXML);
		}
	}
}