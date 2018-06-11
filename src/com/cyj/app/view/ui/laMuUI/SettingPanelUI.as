/**Created by the Morn,do not modify.*/
package com.cyj.app.view.ui.laMuUI {
	import morn.core.components.*;
	public class SettingPanelUI extends View {
		public var bg:Image = null;
		public var txtTitle:Label = null;
		public var btnTaskPath:Button = null;
		public var btnXmlPath:Button = null;
		public var btnClose:Button = null;
		public var inputXmlPath:TextInput = null;
		public var inputTaskPath:TextInput = null;
		public var inputNpcName:TextInput = null;
		public var inputNpcID:TextInput = null;
		public var btnSave:Button = null;
		public var btnCancle:Button = null;
		public var btnNpcPath:Button = null;
		public var inputNpcPath:TextInput = null;
		public var inputTaskName:TextInput = null;
		public var inputTaskID:TextInput = null;
		public var inputNpcHalfBody:TextInput = null;
		protected static var uiXML:XML =
			<View width="420" height="350">
			  <Image skin="png.guidecomp.通用面板_2" x="0" y="0" width="419" height="346" sizeGrid="160,40,160,40,1" var="bg"/>
			  <Label text="设置" x="127" y="10" width="168" height="18" align="center" color="0xccff00" stroke="0x0" var="txtTitle"/>
			  <Button label="浏览" skin="png.guidecomp.btn_四字常规_1" x="321" y="78" labelColors="0xc79a84,0xe0a98d,0x93827a" labelStroke="0x0" var="btnTaskPath"/>
			  <Button label="浏览" skin="png.guidecomp.btn_四字常规_1" x="323" y="41" labelColors="0xc79a84,0xe0a98d,0x93827a" labelStroke="0x0" var="btnXmlPath"/>
			  <Button skin="png.guidecomp.btn_关闭_1" x="392" y="15" var="btnClose"/>
			  <TextInput skin="png.guidecomp.textinput_文字输入底框_2" x="101" y="52" width="216" height="22" color="0xff6600" var="inputXmlPath" margin="3,2,2,2"/>
			  <TextInput skin="png.guidecomp.textinput_文字输入底框_2" x="101" y="82" width="218" height="22" color="0xff6600" var="inputTaskPath" margin="3,2,2,2"/>
			  <Label text="导出配置路径" x="16" y="53" color="0xff9900" stroke="0"/>
			  <Label text="读取任务路径" x="16" y="83" color="0xff9900" stroke="0"/>
			  <TextInput skin="png.guidecomp.textinput_文字输入底框_2" x="99" y="210" width="218" height="22" color="0xff6600" var="inputNpcName" margin="3,2,2,2"/>
			  <Label text="NPC表中名字" x="16" y="211" color="0xff9900" stroke="0"/>
			  <TextInput skin="png.guidecomp.textinput_文字输入底框_2" x="99" y="240" width="219" height="22" color="0xff6600" var="inputNpcID" margin="3,2,2,2"/>
			  <Label text="NPC表中ID" x="28" y="241" color="0xff9900" stroke="0"/>
			  <Button label="保存" skin="png.guidecomp.btn_四字常规_1" x="95" y="292" labelColors="0xc79a84,0xe0a98d,0x93827a" labelStroke="0x0" var="btnSave"/>
			  <Button label="取消" skin="png.guidecomp.btn_四字常规_1" x="219" y="292" labelColors="0xc79a84,0xe0a98d,0x93827a" labelStroke="0x0" var="btnCancle"/>
			  <Label text="保存后重启生效" x="11" y="321" color="0xff0000" stroke="0" width="210" height="19"/>
			  <Button label="浏览" skin="png.guidecomp.btn_四字常规_1" x="321" y="172" labelColors="0xc79a84,0xe0a98d,0x93827a" labelStroke="0x0" var="btnNpcPath"/>
			  <TextInput skin="png.guidecomp.textinput_文字输入底框_2" x="99" y="180" width="218" height="22" color="0xff6600" var="inputNpcPath" margin="3,2,2,2"/>
			  <Label text="读取NPC路径" x="16" y="181" color="0xff9900" stroke="0"/>
			  <TextInput skin="png.guidecomp.textinput_文字输入底框_2" x="101" y="112" width="218" height="22" color="0xff6600" var="inputTaskName" margin="3,2,2,2"/>
			  <Label text="任务表中名字" x="16" y="113" color="0xff9900" stroke="0"/>
			  <TextInput skin="png.guidecomp.textinput_文字输入底框_2" x="101" y="142" width="219" height="22" color="0xff6600" var="inputTaskID" margin="3,2,2,2"/>
			  <Label text="任务表中ID" x="28" y="143" color="0xff9900" stroke="0"/>
			  <TextInput skin="png.guidecomp.textinput_文字输入底框_2" x="99" y="270" width="219" height="22" color="0xff6600" var="inputNpcHalfBody" margin="3,2,2,2"/>
			  <Label text="NPC半身像" x="28" y="271" color="0xff9900" stroke="0"/>
			  <Image skin="png.guidecomp.line" x="11" y="168" width="404" height="5"/>
			</View>;
		public function SettingPanelUI(){}
		override protected function createChildren():void {
			super.createChildren();
			createView(uiXML);
		}
	}
}