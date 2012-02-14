package net.looklisten.components.preload
{
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	
	public class CustomPreloaderLoader extends Loader
	{
		[Embed(source="../../../../assets/images/anthroposts.png", mimeType="application/octet-stream") ]
        public var Logo:Class;
        private var timer:Timer;
        
		public function CustomPreloaderLoader()
		{
			super();
	        
	       	contentLoaderInfo.addEventListener(Event.COMPLETE,onLogoLoadComplete);
	        loadBytes( new Logo() as ByteArray );
		}
		
		private function onLogoLoadComplete(event:Event):void
		{
			if(!stage.getChildByName(this.name))
			{
				stage.addChild(this);
				visible = true;
			}
            x = stage.stageWidth/2 - width/2
            y = stage.stageHeight/2 - height/2
		}
		
		public function remove():void{
			stage.removeChild(this);
		}
	}
}