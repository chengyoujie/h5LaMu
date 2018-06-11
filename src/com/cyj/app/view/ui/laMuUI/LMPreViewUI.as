/**Created by the Morn,do not modify.*/
package com.cyj.app.view.ui.laMuUI {
	import morn.core.components.*;
	import com.cyj.app.view.modules.LMLaMuView;
	import com.cyj.app.view.modules.LMMapView;
	public class LMPreViewUI extends View {
		public var imgPreViewBg:Image = null;
		public var uiMapView:LMMapView = null;
		public var uiLaMuView:LMLaMuView = null;
		protected static var uiXML:XML =
			<View width="805" height="727">
			  <Image skin="png.guidecomp.内框_圆角2" x="0" y="0" width="805" height="727" sizeGrid="10,10,10,10,1" var="imgPreViewBg"/>
			  <LMMapView x="0" y="0" var="uiMapView" runtime="com.cyj.app.view.modules.LMMapView"/>
			  <LMLaMuView x="0" y="471" var="uiLaMuView" runtime="com.cyj.app.view.modules.LMLaMuView" mouseChildren="false" mouseEnabled="false"/>
			</View>;
		public function LMPreViewUI(){}
		override protected function createChildren():void {
			viewClassMap["com.cyj.app.view.modules.LMLaMuView"] = LMLaMuView;
			viewClassMap["com.cyj.app.view.modules.LMMapView"] = LMMapView;
			super.createChildren();
			createView(uiXML);
		}
	}
}