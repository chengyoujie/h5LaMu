/**Created by the Morn,do not modify.*/
package com.cyj.app.view.ui.test {
	import morn.core.components.*;
	public class TestPageUI extends Dialog {
		protected static var uiXML:XML =
			<Dialog width="600" height="400">
			  <Image skin="png.comp.bg" x="0" y="0" sizeGrid="4,30,4,4" width="600" height="400"/>
			  <Button skin="png.comp.btn_close" x="563" y="3" name="close"/>
			  <CheckBox label="label" skin="png.comp.checkbox" x="169" y="224"/>
			  <Clip skin="png.comp.clip_num" x="305" y="335" clipX="10" index="8"/>
			  <HSlider skin="png.comp.hslider" x="45" y="97" width="120"/>
			  <RadioGroup labels="label1,label2" skin="png.comp.radiogroup" x="45" y="224"/>
			  <TextInput text="TextInput" skin="png.comp.textinput" x="45" y="258" margin="1,1,1,1" sizeGrid="2,2,2,2" width="150"/>
			  <Button label="label" skin="png.comp.button" x="45" y="178"/>
			  <LinkButton label="linkButton" x="146" y="179"/>
			  <ProgressBar skin="png.comp.progress" x="45" y="135" width="114" height="14" sizeGrid="4,4,4,4"/>
			  <Tab labels="Tab1,Tab2" skin="png.comp.tab" x="251" y="280" selectedIndex="0"/>
			  <TextArea text="TextArea\nTextArea\nTextArea\nTextArea\nTextArea\nTextArea\nTextArea" skin="png.comp.textarea" x="45" y="297" width="150" height="83" vScrollBarSkin="png.comp.vscroll" hScrollBarSkin="png.comp.hscroll" sizeGrid="2,2,2,2" margin="1,1,1,1"/>
			  <VSlider skin="png.comp.vslider" x="195" y="45"/>
			  <Panel x="250" y="45" vScrollBarSkin="png.comp.vscroll" hScrollBarSkin="png.comp.hscroll" width="129" height="200">
			    <Image skin="png.comp.image"/>
			  </Panel>
			  <List x="428" y="46" spaceX="0" spaceY="0" width="130" height="160" vScrollBarSkin="png.comp.vscroll">
			    <Box name="render">
			      <Clip skin="png.comp.clip_selectBox" x="26" y="3" clipY="2" width="87" name="selectBox"/>
			      <Clip skin="png.comp.clip_num" clipX="10" name="icon"/>
			      <Label text="listItem" x="27" y="3" width="80" name="label"/>
			    </Box>
			  </List>
			  <Tree x="428" y="220" width="130" height="160" scrollBarSkin="png.comp.vscroll" spaceBottom="3">
			    <Box name="render" left="0" right="0">
			      <Clip skin="png.comp.clip_selectBox" x="13" y="0" clipY="2" name="selectBox" left="12" right="0" height="24"/>
			      <Clip skin="png.comp.clip_tree_folder" x="14" y="4" clipY="3" name="folder" clipX="1"/>
			      <Label text="treeItem" x="33" color="0x0" name="label" y="1" width="150" height="22" left="33" right="0"/>
			      <Clip y="5" clipY="2" name="arrow" x="0" skin="png.comp.clip_tree_arrow"/>
			    </Box>
			  </Tree>
			  <ComboBox labels="label1,label2" skin="png.comp.combobox" x="45" y="45" width="120" height="23" sizeGrid="2,2,25,2"/>
			  <Clip skin="png.comp.clip_num" x="253" y="335" clipX="10" autoPlay="true"/>
			  <Image skin="png.guidecomp.roleblock" x="200" y="267"/>
			</Dialog>;
		public function TestPageUI(){}
		override protected function createChildren():void {
			super.createChildren();
			createView(uiXML);
		}
	}
}