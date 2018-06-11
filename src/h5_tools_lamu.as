package
{
	import com.cyj.app.ToolsApp;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	
	[SWF(width="1540", height="800", backgroundColor="#333333", frameRate="30", test="123")]
	public class h5_tools_lamu extends Sprite
	{
		public function h5_tools_lamu()
		{
			if(stage == null)
			{
				this.addEventListener(Event.ADDED_TO_STAGE, init);
			}else{
				init();
			}
		}
		
		private function init(e:Event=null):void
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			App.stage = stage;
			ToolsApp.start();
		}
	}
}