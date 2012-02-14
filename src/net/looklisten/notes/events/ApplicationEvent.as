package net.looklisten.notes.events
{
	import flash.events.Event;

	public class ApplicationEvent extends Event
	{
		public static const SET_LOCALE:String = "setLanguage";
		public static const SHOW_HELP:String = "showHelp";
		public static const SHOW_SEARCH:String = "showSearch";
		public static const NAVIGATE_TO_URL:String = "navigateToUrl";
		
		//	en_US, es_SP, etc.
		public var locale:String;
		public var url:String;
		
		public function ApplicationEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		override public function clone():Event{
			return new ApplicationEvent(type,bubbles,cancelable);
		}
	}
}