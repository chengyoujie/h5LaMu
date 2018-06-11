/**Created by the Morn,do not modify.*/
package com.cyj.app.view.ui.laMuUI {
	import morn.core.components.*;
	public class LMMapViewUI extends View {
		public var boxMapContain:Box = null;
		public var panelUnitScene:Panel = null;
		public var boxUnitBg:Box = null;
		public var boxMapInfo:Box = null;
		public var imgMapInfoBg:Image = null;
		public var combMapList:ComboBox = null;
		public var boxMapPosInfo:Box = null;
		public var txtPosCenter:Label = null;
		public var txtPosCellMouse:Label = null;
		public var txtPosCenterGap:Label = null;
		public var txtMapInfo:Label = null;
		public var txtPosMapMouse:Label = null;
		public var btnMapInfoShow:Button = null;
		public var btnMapInfoHide:Button = null;
		protected static var uiXML:XML =
			<View width="805" height="727">
			  <Box var="boxMapContain" name="boxMapContain" x="0" y="0">
			    <Image skin="png.comp.blank" width="805" height="727" sizeGrid="1,1,1,1,1" alpha="1"/>
			  </Box>
			  <Panel x="0" y="0" width="805" height="727" var="panelUnitScene" vScrollBarSkin="png.guidecomp.vscroll" hScrollBarSkin="png.guidecomp.hscroll" name="panelUnitScene">
			    <Box var="boxUnitBg" name="boxUnitBg" x="0" y="0">
			      <Image skin="png.comp.blank" width="805" height="727" sizeGrid="1,1,1,1,1" alpha="1"/>
			    </Box>
			  </Panel>
			  <Box x="1" y="0" var="boxMapInfo">
			    <Image skin="png.guidecomp.内框_圆角2" sizeGrid="10,10,10,10,1" width="191" height="134" x="0" y="0" var="imgMapInfoBg"/>
			    <Label text="地图列表" y="8" color="0xffff00" x="1"/>
			    <ComboBox skin="png.guidecomp.combobox" x="51" var="combMapList" width="115" height="23" visibleNum="15" scrollBarSkin="png.guidecomp.vscroll" itemColors="0x262626,0xffe0ce,0xff861a,0x885202,0x3d3d3d" labelColors="0xf4a339,0xfedcaf,0xe0e0e0" selectedIndex="0" y="7"/>
			    <Box x="4" y="31" var="boxMapPosInfo" width="182" height="98">
			      <Label text="中 心 点：" color="0xffcc00" x="4" width="53" height="18"/>
			      <Label text="0" y="2" color="0x33cc00" x="62" width="113" height="18" var="txtPosCenter"/>
			      <Label text="格子位置：" y="20" color="0xffcc00" x="4" width="53" height="18"/>
			      <Label text="0" y="22" color="0x33cc00" x="62" width="116" height="18" var="txtPosCellMouse"/>
			      <Label text="距中心点：" y="41" color="0xffcc00" x="4" width="53" height="18"/>
			      <Label text="0" y="43" color="0x33cc00" x="62" width="114" height="18" var="txtPosCenterGap"/>
			      <Label text="地图" y="79" color="0xffcc00" width="32" height="18"/>
			      <Label text="0" y="80" color="0xff6600" x="33" width="149" height="18" var="txtMapInfo"/>
			      <Label text="屏幕地图：" y="60" color="0xffcc00" x="4" width="53" height="18"/>
			      <Label text="0" y="62" color="0x33cc00" x="62" width="114" height="18" var="txtPosMapMouse"/>
			    </Box>
			    <Button label="label" skin="png.guidecomp.button_down" x="168" y="10" var="btnMapInfoShow"/>
			    <Button label="label" skin="png.guidecomp.button_up" x="168" y="10" var="btnMapInfoHide"/>
			  </Box>
			</View>;
		public function LMMapViewUI(){}
		override protected function createChildren():void {
			super.createChildren();
			createView(uiXML);
		}
	}
}