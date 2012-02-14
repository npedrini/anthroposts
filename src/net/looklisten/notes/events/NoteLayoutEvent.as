package net.looklisten.notes.events
{
	import flash.events.Event;

	public class NoteLayoutEvent extends Event
	{
		public static const LAYOUT_COMPLETE:String = "layout_complete";
		
		public function NoteLayoutEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		override public function clone():Event{
			return new NoteLayoutEvent(type,bubbles,cancelable);
		}
	}
}