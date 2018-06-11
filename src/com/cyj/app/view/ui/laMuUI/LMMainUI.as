/**Created by the Morn,do not modify.*/
package com.cyj.app.view.ui.laMuUI {
	import morn.core.components.*;
	import com.cyj.app.view.modules.LMContain;
	import com.cyj.app.view.modules.LMItem;
	import com.cyj.app.view.modules.LMPreView;
	import com.cyj.app.view.modules.LaMuComItem;
	public class LMMainUI extends View {
		public var btnAddItem:Button = null;
		public var btnRemoveItem:Button = null;
		public var listNd:List = null;
		public var ndPreView:LMPreView = null;
		public var txtAuth:Label = null;
		public var txtAppName:Label = null;
		public var boxAppOper:Box = null;
		public var btnOpenGame:Button = null;
		public var btnPulish:Button = null;
		public var combProjectList:ComboBox = null;
		public var btnSave:Button = null;
		public var btnLoadNew:Button = null;
		public var txtLog:Label = null;
		public var btnItemIndexUp:Button = null;
		public var btnItemIndexDown:Button = null;
		public var boxStepList:Box = null;
		public var imgStepListBg:Image = null;
		public var btnAddStep:Button = null;
		public var btnReomveStep:Button = null;
		public var listStep:List = null;
		public var btnStepIndexUp:Button = null;
		public var btnStepIndexDown:Button = null;
		public var ndContian:LMContain = null;
		public var boxUnitList:Box = null;
		public var imgUnitListBg:Image = null;
		public var btnReomveUnit:Button = null;
		public var listUnit:List = null;
		public var btnAddUnit:Button = null;
		public var btnUnitCengUp:Button = null;
		public var btnUnitCengDown:Button = null;
		protected static var uiXML:XML =
			<View width="1540" height="800">
			  <Button label="增加" skin="png.guidecomp.btn_四字常规_1" x="20" y="18" var="btnAddItem" labelColors="0xc79a84,0xe0a98d,0x93827a" labelStroke="0" sizeGrid="10,10,10,,10,1" width="74" height="39"/>
			  <Button label="删除" skin="png.guidecomp.btn_四字常规_1" x="97" y="18" var="btnRemoveItem" labelColors="0xc79a84,0xe0a98d,0x93827a" labelStroke="0" sizeGrid="10,10,10,,10,1" width="74" height="39"/>
			  <List x="2" y="56" vScrollBarSkin="png.guidecomp.vscroll" repeatY="8" width="387" height="445" var="listNd">
			    <LMListItem name="render" runtime="com.cyj.app.view.modules.LMItem"/>
			  </List>
			  <LMPreView x="387" y="55" runtime="com.cyj.app.view.modules.LMPreView" var="ndPreView"/>
			  <Label text="made by cyj 2018.05.10" x="1057" y="781" color="0x666666" var="txtAuth"/>
			  <Label text="NPC对话配置工具" x="244" y="8" color="0xff9900" size="24" stroke="0" width="948" height="43" align="center" var="txtAppName"/>
			  <Box x="829" y="21" var="boxAppOper" height="28" width="360">
			    <Button label="打开游戏q" skin="png.guidecomp.btn_小按钮_1" labelColors="0xc79a84,0xe0a98d,0x93827a" var="btnOpenGame" labelStroke="0" width="63" height="28" x="245" y="-1"/>
			    <Button label="发布w" skin="png.guidecomp.btn_小按钮_1" x="199" labelColors="0xc79a84,0xe0a98d,0x93827a" var="btnPulish" labelStroke="0" width="43" height="28" y="-1"/>
			    <ComboBox skin="png.guidecomp.combobox" width="115" height="23" visibleNum="15" scrollBarSkin="png.guidecomp.vscroll" itemColors="0x262626,0xffe0ce,0xff861a,0x885202,0x3d3d3d" labelColors="0xf4a339,0xfedcaf,0xe0e0e0" selectedIndex="0" y="3" x="33" var="combProjectList"/>
			    <Label text="项目列表" y="5" color="0xffff00" x="-25"/>
			    <Button label="保存s" skin="png.guidecomp.btn_小按钮_1" x="152" labelColors="0xc79a84,0xe0a98d,0x93827a" var="btnSave" labelStroke="0" width="43" height="28" y="-1"/>
			    <Button label="更新" skin="png.guidecomp.btn_小按钮_1" x="311" labelColors="0xc79a84,0xe0a98d,0x93827a" labelStroke="0" width="43" height="28" y="-1" var="btnLoadNew"/>
			  </Box>
			  <Label text="made by cyj 2016.05.10" x="1" y="783" color="0xff3366" var="txtLog" width="1000" height="18"/>
			  <Button skin="png.guidecomp.btn_滚动条_上_1" x="177" y="21" var="btnItemIndexUp" width="32" height="32"/>
			  <Button skin="png.guidecomp.btn_滚动条_下_1" x="211" y="21" var="btnItemIndexDown" width="32" height="32"/>
			  <Box x="7" y="501" var="boxStepList">
			    <Image skin="png.guidecomp.购买类控件底_1" sizeGrid="10,10,10,10,1" width="182" height="279" x="0" y="0" var="imgStepListBg"/>
			    <Button skin="png.guidecomp.btn_加号_1" x="2" y="21" var="btnAddStep"/>
			    <Button skin="png.guidecomp.btn_减号_1" x="27" y="21" var="btnReomveStep"/>
			    <List x="9" y="44" repeatY="9" var="listStep" vScrollBarSkin="png.guidecomp.vscroll" width="164" height="232">
			      <ComListItem x="0" y="0" name="render" runtime="com.cyj.app.view.modules.LaMuComItem"/>
			    </List>
			    <Label text="步骤列表" x="6" y="3" color="0x33ffcc" stroke="0" width="139" height="18" align="center"/>
			    <Button skin="png.guidecomp.btn_滚动条_上_1" x="55" y="23" var="btnStepIndexUp"/>
			    <Button skin="png.guidecomp.btn_滚动条_下_1" x="77" y="23" var="btnStepIndexDown"/>
			  </Box>
			  <LMContain x="1193" y="0" runtime="com.cyj.app.view.modules.LMContain" var="ndContian"/>
			  <Box x="193" y="501" var="boxUnitList" mouseEnabled="false">
			    <Image skin="png.guidecomp.购买类控件底_1" sizeGrid="10,10,10,10,1" width="175" height="279" var="imgUnitListBg" x="0" y="0"/>
			    <Button skin="png.guidecomp.btn_减号_1" x="31" var="btnReomveUnit" y="23"/>
			    <List y="45" repeatY="9" var="listUnit" vScrollBarSkin="png.guidecomp.vscroll" width="166" height="228" x="5" mouseEnabled="false">
			      <ComListItem x="0" y="0" name="render" runtime="com.cyj.app.view.modules.LaMuComItem"/>
			    </List>
			    <Button skin="png.guidecomp.btn_加号_1" x="5" y="23" var="btnAddUnit"/>
			    <Label text="地图单元" x="8" y="3" color="0x33ffcc" stroke="0" width="140" height="18" align="center"/>
			    <Button skin="png.guidecomp.btn_滚动条_上_1" x="65" y="23" var="btnUnitCengUp"/>
			    <Button skin="png.guidecomp.btn_滚动条_下_1" x="90" y="23" var="btnUnitCengDown"/>
			  </Box>
			</View>;
		public function LMMainUI(){}
		override protected function createChildren():void {
			viewClassMap["com.cyj.app.view.modules.LMContain"] = LMContain;
			viewClassMap["com.cyj.app.view.modules.LMItem"] = LMItem;
			viewClassMap["com.cyj.app.view.modules.LMPreView"] = LMPreView;
			viewClassMap["com.cyj.app.view.modules.LaMuComItem"] = LaMuComItem;
			super.createChildren();
			createView(uiXML);
		}
	}
}