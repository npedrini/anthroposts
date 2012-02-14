package net.looklisten.notes.layouts
{
	import flash.events.EventDispatcher;
	
	import mx.collections.ArrayCollection;
	import mx.core.UIComponent;
	
	import net.looklisten.notes.components.NoteDisplay;
	import net.looklisten.notes.events.NoteLayoutEvent;
	import net.looklisten.notes.model.NotesModel;
	
	public class ScatteredLayout extends EventDispatcher implements INotesLayout
	{
		public static const LAYOUT_NAME:String = "scattered";
		private var _notesModel:NotesModel = NotesModel.getInstance();
		
		private var lastWidth:Number;
		private var lastHeight:Number;
		
		public function ScatteredLayout()
		{
			super();
		}
		
		public function doLayout( 	dataProvider:ArrayCollection,target:UIComponent,width:Number,height:Number,
									outerMargin:Number = 0, innerMargin:Number = 0, hasChanged:Boolean = true ):void{
			
			if(dataProvider==null) return;
			
			var i:int=0;
			var nd:NoteDisplay;
			
			//	if layout has changed, solve
			if(hasChanged || _notesModel.layoutDirty)
			{
				for(i=0;i<dataProvider.length;i++)
				{
					nd = target.getChildByName("nd"+dataProvider[i].id) as NoteDisplay;
					//	position and rotate note randomly
					var x:Number = outerMargin + Math.random()*(width-outerMargin*2);
					var y:Number = outerMargin + Math.random()*(height-outerMargin*2);
					nd.default_x = x;
					nd.default_y = y;
					nd.default_rotation = Math.random()*360;
					//nd.toolTip = nd.note.content;
				}
			}
			else
			{
				if(lastWidth != width && lastHeight!=height)
				{
					for(i=0;i<dataProvider.length;i++)
					{	
						nd = target.getChildByName("nd"+dataProvider[i].id) as NoteDisplay;
						//	if layout hasn't changed, nudge notes instead of re-solving
						nd.default_x = nd.default_x/lastWidth*width;
						nd.default_y = nd.default_y/lastHeight*height;
					}
				}
			}
			
			//	store width/height, in case browser is resized later and 
			//	layout hasn't changed, in which case we opt to nudge nodes 
			lastWidth = width;
			lastHeight = height;
				
			dispatchEvent(new NoteLayoutEvent(NoteLayoutEvent.LAYOUT_COMPLETE));
		}
		
		public function get name():String{
			return ScatteredLayout.LAYOUT_NAME;
		}
		
		public function get noteSize():Number{
			return 50;
		}
		
		public function get sortable():Boolean{ return false; }
	}
}