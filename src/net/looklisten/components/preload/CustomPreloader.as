package net.looklisten.components.preload
{
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.ProgressEvent;
    import flash.events.TimerEvent;
    import flash.filters.GlowFilter;
    import flash.utils.Timer;
    
    import mx.events.FlexEvent;
    import mx.preloaders.DownloadProgressBar;
    
    public class CustomPreloader extends DownloadProgressBar {
    	
    	private var loader:CustomPreloaderLoader;
    	private var timer:Timer;
    	
        public function CustomPreloader() {
            super();
        }
        
        override public function initialize() : void
	    {
	        super.initialize();
	        
	        loader = new CustomPreloaderLoader();
	        loader.filters = [new GlowFilter(0xFFFFFF,1,3,3)];
	        addChild(loader);
	    }
	    
        override public function set preloader(preloader:Sprite):void 
        {
            preloader.addEventListener(ProgressEvent.PROGRESS, onLoadProgress);
            preloader.addEventListener(FlexEvent.INIT_COMPLETE, onLoadEnd);
        }
        
        private function onLoadProgress(event:ProgressEvent):void 
        {
            var per:int=(Math.round(event.bytesLoaded/event.bytesTotal)*100);
        }
        
        private function onLoadEnd(event:Event):void 
        {
            timer = new Timer(1);
            timer.addEventListener(TimerEvent.TIMER,onTimer);
            timer.start();
        }
        
        private function onTimer(event:TimerEvent):void
        {
        	if(loader.alpha>0)
			{
				loader.alpha-=.01;
			}
			else
			{
				timer.stop();
				loader.remove();
				dispatchEvent(new Event(Event.COMPLETE));
			}
        }
    }
}