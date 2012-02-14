package net.looklisten.components.preload
{
	import mx.skins.Border;
	import mx.styles.StyleManager;
	import mx.utils.ColorUtil;
	
	public class ProgressSkin extends Border
	{		
		public function ProgressSkin()
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
			
			var barColor0:Number = ColorUtil.adjustBrightness2(barColor, 40);
			
			// default fill color for halo uses theme color
			var fillColors:Array = [ barColor, barColor ]; 
			
			graphics.clear();
			
			var padding:int = 2;
			
			// fill
			drawRoundRect(
				padding, padding, w - padding*2, h - padding*2, 0,
				fillColors, 1);
		}
	}
	
}
