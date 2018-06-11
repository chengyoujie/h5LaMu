/**Created by the Morn,do not modify.*/
package com.cyj.app.view.ui.laMuUI {
	import morn.core.components.*;
	public class LMUnitSetUI extends View {
		public var boxScene:Box = null;
		public var inputResName:TextInput = null;
		public var combResType:ComboBox = null;
		public var inputPstName:TextInput = null;
		public var inputUnitPosY:TextInput = null;
		public var combUnitAction:ComboBox = null;
		public var combUnitDir:ComboBox = null;
		public var checkCenterRole:CheckBox = null;
		public var btnCreateUnit:Button = null;
		public var checkCenterScreen:CheckBox = null;
		public var inputUnitPosX:TextInput = null;
		public var inputUnitToY:TextInput = null;
		public var inputUnitToX:TextInput = null;
		public var inputCameraPosY:TextInput = null;
		public var inputCameraPosX:TextInput = null;
		public var checkCarmeraCur:CheckBox = null;
		public var btnRemoveUnit:Button = null;
		protected static var uiXML:XML =
			<View width="350" height="800">
			  <Image skin="png.guidecomp.内框_圆角2" x="0" y="0" width="350" height="800" sizeGrid="10,10,10,10,1"/>
			  <Box x="10" y="12" var="boxScene">
			    <Label text="资源名字：" y="30" color="0x996600"/>
			    <TextInput skin="png.guidecomp.textinput_文字输入底框_2" x="62" y="29" color="0xff9900" width="160" height="23" sizeGrid="5,5,5,5,1" var="inputResName" multiline="true" wordWrap="true"/>
			    <ComboBox skin="png.guidecomp.combobox" x="62" var="combResType" width="115" height="23" visibleNum="15" scrollBarSkin="png.guidecomp.vscroll" itemColors="0x262626,0xffe0ce,0xff861a,0x885202,0x3d3d3d" labelColors="0xf4a339,0xfedcaf,0xe0e0e0" labels="PAK,ANI" selectedIndex="0"/>
			    <Label text="资源类型：" x="3" y="2" color="0x996600" width="61" height="19"/>
			    <Label text="PST名字：" x="1" y="57" color="0x996600"/>
			    <TextInput skin="png.guidecomp.textinput_文字输入底框_2" x="62" y="56" color="0xff9900" width="160" height="23" sizeGrid="5,5,5,5,1" var="inputPstName" multiline="true" wordWrap="true"/>
			    <Label text="动    作：" x="12" y="88" color="0x996600"/>
			    <Label text="位置：" y="202" color="0x996600"/>
			    <TextInput skin="png.guidecomp.textinput_文字输入底框_2" x="193" y="204" color="0xff9900" width="83" height="23" sizeGrid="5,5,5,5,1" var="inputUnitPosY" multiline="true" wordWrap="true" text="0"/>
			    <ComboBox skin="png.guidecomp.combobox" x="62" y="87" var="combUnitAction" width="115" height="23" visibleNum="15" scrollBarSkin="png.guidecomp.vscroll" itemColors="0x262626,0xffe0ce,0xff861a,0x885202,0x3d3d3d" labelColors="0xf4a339,0xfedcaf,0xe0e0e0" labels="待机,走路,死亡" selectedIndex="0"/>
			    <Label text="方    向：" x="12" y="120" color="0x996600"/>
			    <ComboBox skin="png.guidecomp.combobox" x="62" y="119" var="combUnitDir" width="115" height="23" visibleNum="15" scrollBarSkin="png.guidecomp.vscroll" itemColors="0x262626,0xffe0ce,0xff861a,0x885202,0x3d3d3d" labelColors="0xf4a339,0xfedcaf,0xe0e0e0" labels="上,下,左,右" selectedIndex="0"/>
			    <CheckBox label="人物为中心点" skin="png.guidecomp.checkbox_单选" x="62" y="150" labelColors="0xc79a84,0xe0a98d,0x93827a" labelStroke="0" var="checkCenterRole"/>
			    <Button label="创建" skin="png.guidecomp.btn_四字常规_1" x="66" y="350" var="btnCreateUnit" labelColors="0xc79a84,0xe0a98d,0x93827a" labelStroke="0" sizeGrid="10,10,10,,10,1" width="74" height="39"/>
			    <Label text="中 心 点：" x="6" y="160" color="0x996600"/>
			    <CheckBox label="屏幕左上角为中心点" skin="png.guidecomp.checkbox_单选" x="62" y="176" labelColors="0xc79a84,0xe0a98d,0x93827a" labelStroke="0" var="checkCenterScreen"/>
			    <Label text="Y:" x="176" y="205" color="0x996600"/>
			    <Label text="X:" x="69" y="204" color="0x996600"/>
			    <TextInput skin="png.guidecomp.textinput_文字输入底框_2" x="86" y="204" color="0xff9900" width="81" height="23" sizeGrid="5,5,5,5,1" var="inputUnitPosX" multiline="true" wordWrap="true" text="0"/>
			    <Label text="移动至：" x="1" y="235" color="0x996600"/>
			    <TextInput skin="png.guidecomp.textinput_文字输入底框_2" x="194" y="237" color="0xff9900" width="83" height="23" sizeGrid="5,5,5,5,1" var="inputUnitToY" multiline="true" wordWrap="true" text="0"/>
			    <Label text="Y:" x="177" y="238" color="0x996600"/>
			    <Label text="X:" x="70" y="237" color="0x996600"/>
			    <TextInput skin="png.guidecomp.textinput_文字输入底框_2" x="87" y="237" color="0xff9900" width="81" height="23" sizeGrid="5,5,5,5,1" var="inputUnitToX" multiline="true" wordWrap="true" text="0"/>
			    <Label text="镜头移动至：" y="296" color="0x996600"/>
			    <TextInput skin="png.guidecomp.textinput_文字输入底框_2" x="196" y="296" color="0xff9900" width="83" height="23" sizeGrid="5,5,5,5,1" var="inputCameraPosY" multiline="true" wordWrap="true" text="0"/>
			    <Label text="Y:" x="179" y="297" color="0x996600"/>
			    <Label text="X:" x="72" y="296" color="0x996600"/>
			    <TextInput skin="png.guidecomp.textinput_文字输入底框_2" x="89" y="296" color="0xff9900" width="81" height="23" sizeGrid="5,5,5,5,1" var="inputCameraPosX" multiline="true" wordWrap="true" text="0"/>
			    <CheckBox label="使用当前镜头位置" skin="png.guidecomp.checkbox_单选" x="3" y="270" labelColors="0xc79a84,0xe0a98d,0x93827a" labelStroke="0" var="checkCarmeraCur"/>
			    <Button label="删除" skin="png.guidecomp.btn_四字常规_1" x="150" y="348" var="btnRemoveUnit" labelColors="0xc79a84,0xe0a98d,0x93827a" labelStroke="0" sizeGrid="10,10,10,,10,1" width="74" height="39"/>
			  </Box>
			</View>;
		public function LMUnitSetUI(){}
		override protected function createChildren():void {
			super.createChildren();
			createView(uiXML);
		}
	}
}