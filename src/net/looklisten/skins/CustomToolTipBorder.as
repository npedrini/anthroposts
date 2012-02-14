package net.looklisten.skins
{
	import flash.display.Graphics;
	
	import mx.graphics.RectangularDropShadow;
	import mx.skins.halo.ToolTipBorder;

	public class CustomToolTipBorder extends ToolTipBorder
	{
		/**
	 *  @private
	 */
		private var dropShadow:RectangularDropShadow;
	
		public function CustomToolTipBorder()
		{
			super();
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			var borderStyle:String = getStyle("borderStyle");
			var backgroundColor:uint = getStyle("backgroundColor");
			var backgroundAlpha:Number= getStyle("backgroundAlpha");
			var borderColor:uint = getStyle("borderColor");
			var cornerRadius:Number = getStyle("cornerRadius");
			var shadowColor:uint = getStyle("shadowColor");
			var shadowAlpha:Number = 0.1;
	
			var g:Graphics = graphics;
			g.clear();
			
			var w:Number = unscaledWidth;
			var h:Number = unscaledHeight;
			
			filters = [];
	
			switch (borderStyle)
			{
				case "toolTip":
				{
					// face
					
					drawRoundRect(
						0, 0, w, h, cornerRadius,
						backgroundColor, backgroundAlpha) 
					
					var x:int = 3;
					var y:int = 1;
					
					g.beginFill(backgroundColor,backgroundAlpha);
					g.moveTo(x,y+h);
					g.lineTo(parent.x+w,parent.y);
					g.lineTo(x+10,y+h);	//br
					g.lineTo(x,y+h);
					g.endFill();
					
					if (!dropShadow)
						dropShadow = new RectangularDropShadow();
					
					dropShadow.distance = 3;
					dropShadow.angle = 90;
					dropShadow.color = 0;
					dropShadow.alpha = 0.4;
					
					dropShadow.tlRadius = cornerRadius + 2;
					dropShadow.trRadius = cornerRadius + 2;
					dropShadow.blRadius = cornerRadius + 2;
					dropShadow.brRadius = cornerRadius + 2;
					
					dropShadow.drawShadow(graphics, 3, 0, w - 6, h - 4);
					
					break;
				}
			}			
		}
	}
}