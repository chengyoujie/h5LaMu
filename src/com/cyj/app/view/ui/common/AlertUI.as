/**Created by the Morn,do not modify.*/
package com.cyj.app.view.ui.common {
	import morn.core.components.*;
	public class AlertUI extends View {
		public var bg:Image = null;
		public var txtTitle:Label = null;
		public var btnCancle:Button = null;
		public var btnOK:Button = null;
		public var btnClose:Button = null;
		public var txtContent:TextArea = null;
		protected static var uiXML:XML =
			<View width="350" height="200">
			  <Image skin="png.guidecomp.通用面板_2" x="0" y="0" width="349" height="201" sizeGrid="160,40,160,40,1" var="bg"/>
			  <Label text="提示" x="128" y="9" width="97" height="18" align="center" color="0xccff00" stroke="0x0" var="txtTitle"/>
			  <Button label="取消" skin="png.guidecomp.btn_四字常规_1" x="190" y="152" labelColors="0xc79a84,0xe0a98d,0x93827a" labelStroke="0x0" var="btnCancle"/>
			  <Button label="确定" skin="png.guidecomp.btn_四字常规_1" x="78" y="152" labelColors="0xc79a84,0xe0a98d,0x93827a" labelStroke="0x0" var="btnOK"/>
			  <Button skin="png.guidecomp.btn_关闭_1" x="325" y="13" var="btnClose"/>
			  <TextArea text="提示" skin="png.guidecomp.textarea" x="16" y="43" vScrollBarSkin="png.guidecomp.vscroll" width="318" height="112" color="0xff6600" align="center" var="txtContent" isHtml="true" editable="false"/>
			</View>;
		public function AlertUI(){}
		override protected function createChildren():void {
			super.createChildren();
			createView(uiXML);
		}
	}
}