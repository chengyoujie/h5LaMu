/**Created by the Morn,do not modify.*/
package com.cyj.app.view.ui.laMuUI {
	import morn.core.components.*;
	public class LMContainUI extends View {
		public var boxHeadImageSet:View = null;
		public var imgContentBg:Image = null;
		public var inputStepName:TextInput = null;
		public var inputId:TextInput = null;
		public var combEndType:ComboBox = null;
		public var inputEndCondition:TextInput = null;
		public var inputStepEndEvent:TextInput = null;
		public var combCameraOper:ComboBox = null;
		public var boxCameraOper:Box = null;
		public var inputCameraPosY:TextInput = null;
		public var inputCameraPosX:TextInput = null;
		public var boxCameraMoveTime:Box = null;
		public var inputCameraMoveTime:TextInput = null;
		public var btnCameraCurPos:Button = null;
		public var combCoordinate:ComboBox = null;
		public var checkUnitShowOther:CheckBox = null;
		public var checkUnitShowUI:CheckBox = null;
		public var checkUnitShowBorder:CheckBox = null;
		public var inputUnitId:TextInput = null;
		public var combUnitType:ComboBox = null;
		public var inputUnitPosY:TextInput = null;
		public var inputUnitPosX:TextInput = null;
		public var inputUnitName:TextInput = null;
		public var combUnitOper:ComboBox = null;
		public var boxUnitMove:Box = null;
		public var inputUnitToY:TextInput = null;
		public var inputUnitToX:TextInput = null;
		public var inputUnitMoveTime:TextInput = null;
		public var boxUnitJumpParams:Box = null;
		public var inputUnitJumpHeight:TextInput = null;
		public var btnUnitMoveToCenter:Button = null;
		public var boxUnitPst:Box = null;
		public var inputUnitPst:TextInput = null;
		public var boxUnitRes:Box = null;
		public var inputUnitPak:TextInput = null;
		public var boxUnitNpc:Box = null;
		public var combUnitNPCList:ComboBox = null;
		public var boxUnitMonster:Box = null;
		public var combUnitMonsterList:ComboBox = null;
		public var boxUnitSay:Box = null;
		public var inputUnitSay:TextInput = null;
		public var boxUnitActionDir:Box = null;
		public var combUnitAction:ComboBox = null;
		public var combUnitDir:ComboBox = null;
		public var btnUnitDefPos:Button = null;
		public var boxRotaition:Box = null;
		public var inputUnitRotation:TextInput = null;
		public var btnUnitLastPos:Button = null;
		public var checkUnitShowFace:CheckBox = null;
		public var boxUnitFace:Box = null;
		public var inputUnitFace:TextInput = null;
		public var btnFaceUseMain:Button = null;
		public var checkFaceLeft:CheckBox = null;
		public var boxUnitRole:Box = null;
		public var inputUnitWeapon:TextInput = null;
		public var inputUnitWing:TextInput = null;
		public var inputUnitMount:TextInput = null;
		public var btnStepLastPos:Button = null;
		protected static var uiXML:XML =
			<View width="350" height="800" var="boxHeadImageSet">
			  <Image skin="png.guidecomp.内框_圆角2" x="0" y="0" width="350" height="800" sizeGrid="10,10,10,10,1" var="imgContentBg"/>
			  <TextInput skin="png.guidecomp.textinput_文字输入底框_2" x="74" y="55" color="0xff9900" width="160" height="23" sizeGrid="5,5,5,5,1" multiline="true" wordWrap="true" var="inputStepName"/>
			  <Label text="步骤ID" x="16" y="22" color="0x996600"/>
			  <TextInput skin="png.guidecomp.textinput_文字输入底框_2" x="72" y="22" color="0xff9900" width="160" height="23" sizeGrid="5,5,5,5,1" var="inputId" multiline="true" wordWrap="true"/>
			  <Label text="结束条件" x="16" y="206" color="0x996600"/>
			  <ComboBox skin="png.guidecomp.combobox" x="77" y="206" var="combEndType" width="126" height="23" itemColors="0x262626,0xffe0ce,0xff861a,0x885202,0x3d3d3d" labelColors="0xf4a339,0xfedcaf,0xe0e0e0" scrollBarSkin="png.guidecomp.vscroll" labels="计时或点击,计时,点击,自定义事件"/>
			  <TextInput skin="png.guidecomp.textinput_文字输入底框_2" x="77" y="238" color="0xff9900" width="265" height="49" sizeGrid="5,5,5,5,1" var="inputEndCondition" multiline="true" wordWrap="true"/>
			  <Label text="步骤名字" x="10" y="60" color="0x996600"/>
			  <Label text="步骤相关" x="7" y="1" color="0xccff00" width="336" height="19" align="center"/>
			  <TextInput skin="png.guidecomp.textinput_文字输入底框_2" x="74" y="319" color="0xff9900" width="160" height="23" sizeGrid="5,5,5,5,1" multiline="true" wordWrap="true" var="inputStepEndEvent"/>
			  <Label text="结束派发" x="10" y="322" color="0x996600"/>
			  <Label text="镜头操作：" x="12" y="122" color="0x996600"/>
			  <ComboBox skin="png.guidecomp.combobox" x="73" y="118" var="combCameraOper" width="115" height="23" visibleNum="15" scrollBarSkin="png.guidecomp.vscroll" itemColors="0x262626,0xffe0ce,0xff861a,0x885202,0x3d3d3d" labelColors="0xf4a339,0xfedcaf,0xe0e0e0" labels="玩家,移动,跳转,同上" selectedIndex="0"/>
			  <Box x="3" y="150" var="boxCameraOper">
			    <Label text="镜头移动至：" color="0x996600" y="1" x="11"/>
			    <TextInput skin="png.guidecomp.textinput_文字输入底框_2" x="207" color="0xff9900" width="83" height="23" sizeGrid="5,5,5,5,1" var="inputCameraPosY" multiline="false" wordWrap="false" text="0" y="1"/>
			    <Label text="Y:" x="190" y="2" color="0x996600"/>
			    <Label text="X:" x="83" color="0x996600" y="1"/>
			    <TextInput skin="png.guidecomp.textinput_文字输入底框_2" x="100" color="0xff9900" width="81" height="23" sizeGrid="5,5,5,5,1" var="inputCameraPosX" multiline="false" wordWrap="false" text="0" y="1"/>
			    <Box y="29" var="boxCameraMoveTime">
			      <Label text="移动时间(ms)：" color="0x996600"/>
			      <TextInput skin="png.guidecomp.textinput_文字输入底框_2" x="82" color="0xff9900" width="81" height="23" sizeGrid="5,5,5,5,1" var="inputCameraMoveTime" multiline="false" wordWrap="false" text="0" restrict="-0-9"/>
			    </Box>
			    <Button label="当前" skin="png.guidecomp.btn_小按钮_1" x="298" labelColors="0xc79a84,0xe0a98d,0x93827a" var="btnCameraCurPos" labelStroke="0" width="39" height="22"/>
			  </Box>
			  <Label text="坐标系：" x="14" y="88" color="0x996600"/>
			  <ComboBox skin="png.guidecomp.combobox" x="75" y="84" var="combCoordinate" width="115" height="23" visibleNum="15" scrollBarSkin="png.guidecomp.vscroll" itemColors="0x262626,0xffe0ce,0xff861a,0x885202,0x3d3d3d" labelColors="0xf4a339,0xfedcaf,0xe0e0e0" labels="屏幕坐标,地图" selectedIndex="0"/>
			  <CheckBox label="是否显示其他玩家" skin="png.guidecomp.checkbox_单选" x="209" y="294" labelColors="0xc79a84,0xe0a98d,0x93827a" labelStroke="0" var="checkUnitShowOther"/>
			  <CheckBox label="是否显示UI" skin="png.guidecomp.checkbox_单选" x="117" y="294" labelColors="0xc79a84,0xe0a98d,0x93827a" labelStroke="0" var="checkUnitShowUI"/>
			  <CheckBox label="是否显示边框" skin="png.guidecomp.checkbox_单选" x="10" y="294" labelColors="0xc79a84,0xe0a98d,0x93827a" labelStroke="0" var="checkUnitShowBorder" selected="true"/>
			  <Box x="1" y="345" width="344" height="470">
			    <Image skin="png.guidecomp.购买类控件底_1" width="348" height="453" sizeGrid="10,10,10,10,1" x="0" y="0"/>
			    <Label text="角色ID" x="18" y="26" color="0x996600"/>
			    <TextInput skin="png.guidecomp.textinput_文字输入底框_2" x="74" y="26" color="0xff9900" width="160" height="23" sizeGrid="5,5,5,5,1" var="inputUnitId" multiline="true" wordWrap="true"/>
			    <ComboBox skin="png.guidecomp.combobox" x="69" var="combUnitType" width="115" height="23" visibleNum="15" scrollBarSkin="png.guidecomp.vscroll" itemColors="0x262626,0xffe0ce,0xff861a,0x885202,0x3d3d3d" labelColors="0xf4a339,0xfedcaf,0xe0e0e0" labels="NPC,怪物,主角,PAK,ANI,其他" selectedIndex="0" y="81"/>
			    <Label text="资源类型：" x="11" y="86" color="0x996600" width="61" height="19"/>
			    <Label text="位置：" y="232" color="0x996600" x="30"/>
			    <TextInput skin="png.guidecomp.textinput_文字输入底框_2" x="174" y="233" color="0xff9900" width="66" height="23" sizeGrid="5,5,5,5,1" var="inputUnitPosY" multiline="false" wordWrap="false" text="0" restrict="-0-9"/>
			    <Label text="Y:" x="157" y="234" color="0x996600"/>
			    <Label text="X:" x="67" y="231" color="0x996600"/>
			    <TextInput skin="png.guidecomp.textinput_文字输入底框_2" x="84" y="231" color="0xff9900" width="66" height="23" sizeGrid="5,5,5,5,1" var="inputUnitPosX" multiline="false" wordWrap="false" text="0" restrict="-0-9"/>
			    <Label text="人物名字：" y="57" color="0x996600" x="9"/>
			    <TextInput skin="png.guidecomp.textinput_文字输入底框_2" x="70" y="53" color="0xff9900" width="160" height="23" sizeGrid="5,5,5,5,1" var="inputUnitName" multiline="false" wordWrap="true"/>
			    <Label text="其他操作：" y="261" color="0x996600" x="6"/>
			    <ComboBox skin="png.guidecomp.combobox" x="67" y="257" var="combUnitOper" width="115" height="23" visibleNum="15" scrollBarSkin="png.guidecomp.vscroll" itemColors="0x262626,0xffe0ce,0xff861a,0x885202,0x3d3d3d" labelColors="0xf4a339,0xfedcaf,0xe0e0e0" labels="无,移动,跳跃" selectedIndex="0"/>
			    <Box y="285" var="boxUnitMove" x="1">
			      <Label text="移动至：" x="17" y="2" color="0x996600" width="52" height="19"/>
			      <TextInput skin="png.guidecomp.textinput_文字输入底框_2" x="194" color="0xff9900" width="83" height="23" sizeGrid="5,5,5,5,1" var="inputUnitToY" multiline="false" wordWrap="false" text="0" restrict="-0-9"/>
			      <Label text="Y:" x="177" y="1" color="0x996600"/>
			      <Label text="X:" x="70" color="0x996600"/>
			      <TextInput skin="png.guidecomp.textinput_文字输入底框_2" x="87" color="0xff9900" width="81" height="23" sizeGrid="5,5,5,5,1" var="inputUnitToX" multiline="false" wordWrap="false" text="0" restrict="-0-9"/>
			      <Label text="移动时间(ms)：" y="30" color="0x996600"/>
			      <TextInput skin="png.guidecomp.textinput_文字输入底框_2" x="77" y="29" color="0xff9900" width="81" height="23" sizeGrid="5,5,5,5,1" var="inputUnitMoveTime" multiline="false" wordWrap="false" text="0" restrict="-0-9"/>
			      <Box x="183" y="29" var="boxUnitJumpParams">
			        <Label text="跳跃高度：" color="0x996600" y="2"/>
			        <TextInput skin="png.guidecomp.textinput_文字输入底框_2" x="57" color="0xff9900" width="83" height="23" sizeGrid="5,5,5,5,1" var="inputUnitJumpHeight" multiline="false" wordWrap="false" text="0" restrict="-0-9"/>
			      </Box>
			      <Button label="中心点" skin="png.guidecomp.btn_小按钮_1" x="285" labelColors="0xc79a84,0xe0a98d,0x93827a" var="btnUnitMoveToCenter" labelStroke="0" width="39" height="22" y="0"/>
			    </Box>
			    <Box x="12" y="135" var="boxUnitPst">
			      <Label text="PST名字：" y="4" color="0x996600"/>
			      <TextInput skin="png.guidecomp.textinput_文字输入底框_2" x="60" color="0xff9900" width="160" height="23" sizeGrid="5,5,5,5,1" var="inputUnitPst" multiline="false" wordWrap="false"/>
			    </Box>
			    <Box x="11" y="108" var="boxUnitRes">
			      <Label text="资源名字：" y="4" color="0x996600"/>
			      <TextInput skin="png.guidecomp.textinput_文字输入底框_2" x="61" color="0xff9900" width="160" height="23" sizeGrid="5,5,5,5,1" var="inputUnitPak" multiline="false" wordWrap="true"/>
			    </Box>
			    <Box x="22" y="110" var="boxUnitNpc">
			      <Label text="NPC:" y="2" color="0x996600"/>
			      <ComboBox skin="png.guidecomp.combobox" x="49" var="combUnitNPCList" width="159" height="23" visibleNum="15" scrollBarSkin="png.guidecomp.vscroll" itemColors="0x262626,0xffe0ce,0xff861a,0x885202,0x3d3d3d" labelColors="0xf4a339,0xfedcaf,0xe0e0e0" selectedIndex="0" y="0"/>
			    </Box>
			    <Box x="20" y="109" var="boxUnitMonster">
			      <Label text="怪物：" y="2" color="0x996600"/>
			      <ComboBox skin="png.guidecomp.combobox" x="49" var="combUnitMonsterList" width="158" height="23" visibleNum="15" scrollBarSkin="png.guidecomp.vscroll" itemColors="0x262626,0xffe0ce,0xff861a,0x885202,0x3d3d3d" labelColors="0xf4a339,0xfedcaf,0xe0e0e0" selectedIndex="0" y="0"/>
			    </Box>
			    <Box x="18" y="372" var="boxUnitSay">
			      <Label text="对话内容" y="5" color="0x996600"/>
			      <TextInput skin="png.guidecomp.textinput_文字输入底框_2" x="49" color="0xff9900" width="270" height="74" sizeGrid="5,5,5,5,1" var="inputUnitSay" multiline="true" wordWrap="true"/>
			    </Box>
			    <Box x="24" y="166" var="boxUnitActionDir">
			      <Label text="动    作：" y="4" color="0x996600"/>
			      <ComboBox skin="png.guidecomp.combobox" x="49" var="combUnitAction" width="115" height="23" visibleNum="15" scrollBarSkin="png.guidecomp.vscroll" itemColors="0x262626,0xffe0ce,0xff861a,0x885202,0x3d3d3d" labelColors="0xf4a339,0xfedcaf,0xe0e0e0" selectedIndex="0"/>
			      <Label text="方    向：" y="36" color="0x996600"/>
			      <ComboBox skin="png.guidecomp.combobox" x="49" y="32" var="combUnitDir" width="115" height="23" visibleNum="15" scrollBarSkin="png.guidecomp.vscroll" itemColors="0x262626,0xffe0ce,0xff861a,0x885202,0x3d3d3d" labelColors="0xf4a339,0xfedcaf,0xe0e0e0" labels="下   ↓-0,右下 ↘-1,右   →-2,右上 ↗-3,上   ↑-4,左上 ↖-5,左   ←-6,左下 ↙-7" selectedIndex="0"/>
			    </Box>
			    <Button label="中心点" skin="png.guidecomp.btn_小按钮_1" x="256" labelColors="0xc79a84,0xe0a98d,0x93827a" var="btnUnitDefPos" labelStroke="0" width="39" height="22" y="235"/>
			    <Box x="214" y="164" var="boxRotaition">
			      <Label text="旋转：" color="0x996600" y="1"/>
			      <TextInput skin="png.guidecomp.textinput_文字输入底框_2" x="37" color="0xff9900" width="81" height="23" sizeGrid="5,5,5,5,1" var="inputUnitRotation" multiline="false" wordWrap="false" text="0" restrict="-0-9"/>
			    </Box>
			    <Label text="角色相关" x="1" y="3" color="0xccff00" width="336" height="19" align="center"/>
			    <Button label="上一帧" skin="png.guidecomp.btn_小按钮_1" x="298" labelColors="0xc79a84,0xe0a98d,0x93827a" var="btnUnitLastPos" labelStroke="0" width="39" height="22" y="235"/>
			    <CheckBox label="是否拉幕对话" skin="png.guidecomp.checkbox_单选" x="11" y="341" labelColors="0xc79a84,0xe0a98d,0x93827a" labelStroke="0" var="checkUnitShowFace" selected="true"/>
			    <Box x="114" y="343" var="boxUnitFace">
			      <Label text="头像(cn/face/)" y="2.5" color="0x996600" x="30"/>
			      <TextInput skin="png.guidecomp.textinput_文字输入底框_2" x="111" color="0xff9900" width="82" height="23" sizeGrid="5,5,5,5,1" var="inputUnitFace" multiline="false" wordWrap="false" y="0.5"/>
			      <Button label="主角" skin="png.guidecomp.btn_小按钮_1" x="197" labelColors="0xc79a84,0xe0a98d,0x93827a" var="btnFaceUseMain" labelStroke="0" width="29" height="22" y="1"/>
			      <CheckBox label="左" skin="png.comp.checkbox_2" y="3.75" labelColors="0xc79a84,0xe0a98d,0x93827a" var="checkFaceLeft"/>
			    </Box>
			    <Box x="237" y="74" var="boxUnitRole">
			      <Label text="武器：" color="0x996600" y="1"/>
			      <TextInput skin="png.guidecomp.textinput_文字输入底框_2" x="37" color="0xff9900" width="68" height="23" sizeGrid="5,5,5,5,1" var="inputUnitWeapon" multiline="false" wordWrap="false" text="0" y="0"/>
			      <Label text="翅膀：" color="0x996600" y="32" x="2"/>
			      <TextInput skin="png.guidecomp.textinput_文字输入底框_2" x="37" color="0xff9900" width="69" height="23" sizeGrid="5,5,5,5,1" var="inputUnitWing" multiline="false" wordWrap="false" text="0" y="31"/>
			      <Label text="坐骑：" color="0x996600" y="59" x="1"/>
			      <TextInput skin="png.guidecomp.textinput_文字输入底框_2" x="37" color="0xff9900" width="69" height="23" sizeGrid="5,5,5,5,1" var="inputUnitMount" multiline="false" wordWrap="false" text="0" y="58"/>
			    </Box>
			  </Box>
			  <Image skin="png.guidecomp.line" x="0" y="343" width="350"/>
			  <Button label="上一中心点" skin="png.guidecomp.btn_小按钮_1" x="274" labelColors="0xc79a84,0xe0a98d,0x93827a" var="btnStepLastPos" labelStroke="0" width="64" height="31" y="81"/>
			</View>;
		public function LMContainUI(){}
		override protected function createChildren():void {
			super.createChildren();
			createView(uiXML);
		}
	}
}