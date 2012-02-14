package net.looklisten.notes.layouts
{
	import flash.events.EventDispatcher;
	
	import mx.collections.ArrayCollection;
	import mx.core.UIComponent;
	
	import net.looklisten.notes.components.NoteDisplay;
	import net.looklisten.notes.events.NoteLayoutEvent;
	import net.looklisten.notes.model.NotesModel;
	
	public class GridLayout extends EventDispatcher implements INotesLayout
	{
		public static const LAYOUT_NAME:String = "grid";
		private var _notesModel:NotesModel = NotesModel.getInstance();
		
		public function GridLayout()
		{
			super();
		}
		
		public function doLayout(	dataProvider:ArrayCollection,target:UIComponent,
									width:Number,height:Number,
									outerMargin:Number = 0,innerMargin:Number = 0,
									hasChanged:Boolean = true ):void{
			
			if(dataProvider==null) return;
			
			width  = width - outerMargin*2;
			
			var m:Number = innerMargin;
			var cols:int = Math.floor(width/(noteSize+m));
			var rows:int = Math.ceil(dataProvider.length/rows);
			var x:Number = outerMargin;
			var y:Number = outerMargin;
			
			for(var i:int=0,r:int=0,c:int=0,nd:NoteDisplay;i<dataProvider.length;i++)
			{
				nd = target.getChildByName("nd"+dataProvider[i].id) as NoteDisplay;
				
				x = outerMargin + c*(noteSize+m);
				y = outerMargin + r*(noteSize+m);
				
				nd.default_x = x;
				nd.default_y = y;
				nd.default_rotation = 0;
				
				if(c>=cols) {
					c=0;
					r++;
				}else{
					c++;
				}
			}
			
			dispatchEvent(new NoteLayoutEvent(NoteLayoutEvent.LAYOUT_COMPLETE));
		}
		
		public function get name():String{
			return GridLayout.LAYOUT_NAME;
		}
		
		public function get noteSize():Number{
			return 50;
		}
		
		public function get sortable():Boolean{
			return true;
		}
	}
}