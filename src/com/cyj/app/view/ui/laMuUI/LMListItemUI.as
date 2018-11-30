/**Created by the Morn,do not modify.*/
package com.cyj.app.view.ui.laMuUI {
	import morn.core.components.*;
	public class LMListItemUI extends View {
		public var inputID:TextInput = null;
		public var combType:ComboBox = null;
		public var boxLevel:Box = null;
		public var inputLevel:TextInput = null;
		public var boxTask:Box = null;
		public var combTask:ComboBox = null;
		public var combState:ComboBox = null;
		public var boxEvent:Box = null;
		public var inputEvent:TextInput = null;
		public var inputEndSendEvent:TextInput = null;
		public var inputName:TextInput = null;
		public var boxGuanKa:Box = null;
		public var combGuanKa:ComboBox = null;
		public var combGuanKaState:ComboBox = null;
		protected static var uiXML:XML =
			<View width="365" height="110">
			  <Image skin="png.guidecomp.内框_圆角2" width="365" height="110" sizeGrid="10,10,10,10,1" x="0" y="0"/>
			  <TextInput skin="png.guidecomp.textinput_3" x="40" y="12" width="86" height="30" var="inputID" restrict="0-9" margin="8,5,2,2" color="0xff9900"/>
			  <ComboBox skin="png.guidecomp.combobox" x="43" y="50" width="79" height="23" var="combType" itemColors="0x262626,0xffe0ce,0xff861a,0x885202,0x3d3d3d" labelColors="0xf4a339,0xfedcaf,0xe0e0e0" scrollBarSkin="png.guidecomp.vscroll" labels="任务,等级,事件,关卡,其他,无用"/>
			  <Label text="类型" x="10" y="52" color="0xff9900"/>
			  <Label text="ID" x="10" y="18" color="0xff9900"/>
			  <Box x="144" y="50" var="boxLevel" mouseEnabled="false">
			    <TextInput skin="png.guidecomp.textinput_文字输入底框_2" width="112" height="25" var="inputLevel" centerX="inputLevel" restrict="0-9" color="0xff9900" text="11" margin="3,2,2,2"/>
			  </Box>
			  <Box x="129" y="51" var="boxTask">
			    <ComboBox skin="png.guidecomp.combobox" var="combTask" width="161" height="23" scrollBarSkin="png.guidecomp.vscroll" visibleNum="15" itemColors="0x262626,0xffe0ce,0xff861a,0x885202,0x3d3d3d" labelColors="0xf4a339,0xfedcaf,0xe0e0e0" x="0" y="0"/>
			    <ComboBox skin="png.guidecomp.combobox" x="166" y="1" var="combState" width="65" height="23" itemColors="0x262626,0xffe0ce,0xff861a,0x885202,0x3d3d3d" labelColors="0xf4a339,0xfedcaf,0xe0e0e0" scrollBarSkin="png.guidecomp.vscroll" labels="接收,进行中,完成"/>
			  </Box>
			  <Box x="144" y="50" var="boxEvent" mouseEnabled="false">
			    <TextInput skin="png.guidecomp.textinput_文字输入底框_2" width="112" height="25" var="inputEvent" color="0xff9900" margin="3,2,2,2"/>
			  </Box>
			  <Label text="结束后派发事件" x="7" y="81" color="0x996600"/>
			  <TextInput skin="png.guidecomp.textinput_文字输入底框_2" x="98" y="79" color="0xff9900" width="137" height="23" sizeGrid="5,5,5,5,1" var="inputEndSendEvent" multiline="false" wordWrap="false"/>
			  <TextInput skin="png.guidecomp.textinput_文字输入底框_2" x="148" y="17" color="0xff9900" width="137" height="23" sizeGrid="5,5,5,5,1" var="inputName" multiline="false" wordWrap="false"/>
			  <Clip skin="png.guidecomp.clip_格子选中" x="0" y="0" width="366" height="109" sizeGrid="10,10,10,10,1" name="selectBox" mouseEnabled="false"/>
			  <Box x="143" y="51" var="boxGuanKa">
			    <ComboBox skin="png.guidecomp.combobox" var="combGuanKa" width="161" height="23" scrollBarSkin="png.guidecomp.vscroll" visibleNum="15" itemColors="0x262626,0xffe0ce,0xff861a,0x885202,0x3d3d3d" labelColors="0xf4a339,0xfedcaf,0xe0e0e0" x="-15" y="2"/>
			    <ComboBox skin="png.guidecomp.combobox" var="combGuanKaState" width="61" height="23" scrollBarSkin="png.guidecomp.vscroll" visibleNum="15" itemColors="0x262626,0xffe0ce,0xff861a,0x885202,0x3d3d3d" labelColors="0xf4a339,0xfedcaf,0xe0e0e0" x="153" y="1" labels="退出,进入"/>
			  </Box>
			</View>;
		public function LMListItemUI(){}
		override protected function createChildren():void {
			super.createChildren();
			createView(uiXML);
		}
	}
}