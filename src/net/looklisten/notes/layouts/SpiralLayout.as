package net.looklisten.notes.layouts
{
	import flash.events.EventDispatcher;
	import flash.geom.Point;
	
	import mx.collections.ArrayCollection;
	import mx.core.UIComponent;
	
	import net.looklisten.notes.components.NoteDisplay;
	import net.looklisten.notes.events.NoteLayoutEvent;
	import net.looklisten.notes.model.NotesModel;
	
	public class SpiralLayout extends EventDispatcher implements INotesLayout
	{
		public static const LAYOUT_NAME:String = "spiral";
		private var _notesModel:NotesModel = NotesModel.getInstance();
		
		private var lastWidth:Number;
		private var lastHeight:Number;
		
		public function SpiralLayout()
		{
			super();
		}
		
		public function doLayout( 	dataProvider:ArrayCollection,target:UIComponent,
									width:Number,height:Number,
									outerMargin:Number = 0, innerMargin:Number = 0,hasChanged:Boolean = true ):void{
			
			if(dataProvider==null) return;
			
			//	if layout has changed, solve
			if(hasChanged || _notesModel.layoutDirty)
			{
				var center:Point = new Point(width/2-target.x,height/2-target.y);
				center = target.localToGlobal(center);
				center = target.globalToLocal(center);
				
				var nd:NoteDisplay;
				
				for(var i:int=0,a:Number=0,radius:Number=10;i<dataProvider.length;i++)
				{
					nd = target.getChildByName("nd"+dataProvider[i].id) as NoteDisplay;
					
					//	convert 'around' and 'away' to X and Y.
					var x:Number = center.x + Math.cos(a * (Math.PI/180)) * radius;
					var y:Number = center.y + Math.sin(a * (Math.PI/180)) * radius;
					
					nd.default_x = x;
					nd.default_y = y;
					nd.default_rotation = (a%360);
					
					a  += noteSize/(Math.PI*radius*2)*360;
					radius = (noteSize+innerMargin*2)*(a/360);
				}
			}
			else
			{
				if(lastWidth!=width && lastHeight!=height)
				{
					var size:Number = Math.min(width,height);
					for(i=0;i<dataProvider.length;i++)
					{
						nd = target.getChildByName("nd"+dataProvider[i].id) as NoteDisplay;
						//	if layout hasn't changed, nudge notes instead of re-solving
						nd.default_x = lastWidth/nd.default_x*size;
						nd.default_y = lastHeight/nd.default_y*size;
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
			return SpiralLayout.LAYOUT_NAME;
		}
		
		public function get noteSize():Number{
			return 30;
		}
		
		public function get sortable():Boolean{ return true; }
	}
}