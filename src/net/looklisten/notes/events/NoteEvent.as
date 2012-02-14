package net.looklisten.notes.events
{
	import flash.events.Event;

	public class NoteEvent extends Event
	{
		public static const SHOW:String = "showNote";
		public static const HIDE:String = "hideNote";
		public static const LOAD_COMPLETE:String = "loadComplete";
		public static const LOAD_ERROR:String = "loadError";
		public static const TWEEN_COMPLETE:String = "tweenComplete";
		
		public function NoteEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		override public function clone():Event{
			return new NoteEvent(type,bubbles,cancelable);
		}
	}
}