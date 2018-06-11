package com.cyj.app.view.modules.unit
{
	import flash.display.Sprite;

	public class CenterCoordinate extends Sprite
	{
		public function CenterCoordinate()
		{
			drawCirle(0xd6a6ff, 0.2);
			this.mouseChildren = this.mouseEnabled = false;
		}
		
		
		public function drawCirle(color:int, alpha:Number):void
		{
			this.graphics.clear();
			this.graphics.beginFill(color, alpha);
			this.graphics.drawCircle(0, 0, 50);
			this.graphics.lineStyle(1, 0x22f7ff, 0.8);
			this.graphics.moveTo(0, -50);
			this.graphics.lineTo(0, 50);
			this.graphics.moveTo(-50, 0);
			this.graphics.lineTo(50, 0);
			this.graphics.endFill();
		}
	}
}