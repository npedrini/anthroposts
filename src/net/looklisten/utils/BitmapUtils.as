package net.looklisten.utils
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	
	public class BitmapUtils
	{
		public function BitmapUtils()
		{
		}
		
		public static function averageColour( source:BitmapData ):uint
		{
			var red:Number = 0;
			var green:Number = 0;
			var blue:Number = 0;
			
			var count:Number = 0;
			var pixel:Number;
			
			for (var x:int = 0; x < source.width; x++)
			{
				for (var y:int = 0; y < source.height; y++)
				{
					pixel = source.getPixel(x, y);
					
					red += pixel >> 16 & 0xFF;
					green += pixel >> 8 & 0xFF;
					blue += pixel & 0xFF;
					
					count++
				}
			}
			
			red /= count;
			green /= count;
			blue /= count;
			
			return red << 16 | green << 8 | blue;
		}
		
		public static function sampleRect(target:BitmapData,start:Point,width:int,height:int):int
		{
			if(start.x+width>target.width) start.x = target.width-width;
			if(start.y+height>target.height) start.y = target.height-height;
			
			var s:int = target.getPixel(start.x,start.y);
			for(var i:int=0,x:int=start.x,y:int=start.y;i<width*height;i++)
			{
				s = (s + target.getPixel(x,y))/2;
				
				if(x<width)
				{
					x++
				}
				else
				{
					x=0;
					y++;
				}
			}
			return s;
		}
	}
}