package net.looklisten.components.preload
{
	
	import flash.display.Graphics;
	import mx.skins.Border;
	import mx.styles.StyleManager;
	import mx.utils.ColorUtil;
	
	public class ProgressSkinIndeterminate extends Border
	{
		public function ProgressSkinIndeterminate()
		{
			super();
		}	
		
		override public function get measuredWidth():Number
		{
			return 200;
		}
		      
		override public function get measuredHeight():Number
		{
			return 6;
		}
		  
		override protected function updateDisplayList(w:Number, h:Number):void
		{
			super.updateDisplayList(w, h);
			
			// User-defined styles
			var barColorStyle:* = getStyle("barColor");
			var barColor:uint = styleManager.isValidStyleValue(barColorStyle) ?
				barColorStyle :
				getStyle("themeColor");
			
			var barColor0:Number = ColorUtil.adjustBrightness2(barColor, 60);
			var hatchInterval:Number = getStyle("indeterminateMoveInterval");
			
			// Prevents a crash when hatchInterval == 0. Really the indeterminateMoveInterval style should
			// not be hijacked to control the width of the segments on the bar but I'm not sure this is
			// unavoidable while retaining backwards compatibility (see Bug 12942) 
			if (isNaN(hatchInterval) || hatchInterval == 0)
				hatchInterval = 28;
			
			var g:Graphics = graphics;
			
			g.clear();
			
			// Hatches
			for (var i:int = 0; i < w; i += hatchInterval)
			{
				g.beginFill(0x333333, .8);
				g.moveTo(i, 1);
				g.lineTo(Math.min(i + 14, w), 1);
				g.lineTo(Math.min(i + 10, w), h - 1);
				g.lineTo(Math.max(i - 4, 0), h - 1);
				g.lineTo(i, 1);
				g.endFill();
			}
		}
	}
	
}
