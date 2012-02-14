package net.looklisten.skins
{
	import mx.controls.LinkBar;
	import mx.skins.halo.LinkSeparator;

	public class CustomLinkSeparator extends LinkSeparator
	{
		public function CustomLinkSeparator()
		{
			super();
		}
		
		override protected function updateDisplayList(unscaledWidth:Number,
                                                       unscaledHeight:Number):void
     	{
			var parentLinkBar:LinkBar;
			var myColor:uint;
		     
			if( parent is LinkBar)
			{
				// Use the separatorColor if the parent is a LinkBar
		       	parentLinkBar= parent as LinkBar;
		       	myColor=parentLinkBar.getStyle("separatorColor");
			}
			else
		   	{
			    myColor=0xC4CCCC; // The default separatorColor in a LinkBar
		    }
		    
		   	graphics.lineStyle(2,myColor, 1);
		   	graphics.moveTo(0, unscaledHeight);
		   	graphics.lineTo(unscaledWidth, 0);
		  	graphics.endFill();
     	}
	}
}