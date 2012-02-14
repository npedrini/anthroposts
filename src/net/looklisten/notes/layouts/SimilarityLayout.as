package net.looklisten.notes.layouts
{
	import flash.events.EventDispatcher;
	import flash.geom.Point;
	
	import mx.collections.ArrayCollection;
	import mx.collections.Sort;
	import mx.collections.SortField;
	import mx.core.UIComponent;
	
	import net.looklisten.notes.components.NoteDisplay;
	import net.looklisten.notes.components.connection.NoteConnectionDisplay;
	import net.looklisten.notes.events.NoteLayoutEvent;
	import net.looklisten.notes.model.NotesModel;
	import net.looklisten.notes.soap.Note;
	
	public class SimilarityLayout extends EventDispatcher implements INotesLayout
	{
		public static const LAYOUT_NAME:String = "common words";
		
		private var _notesModel:NotesModel = NotesModel.getInstance();
		
		private var lastWidth:Number;
		private var lastHeight:Number;
		
		private var connectionDisplay:NoteConnectionDisplay;
		
		private var dispersions:Array;
		private var center:Point;
		private var ringSpacing:Number;
		
		public function SimilarityLayout(_connectionDisplay:NoteConnectionDisplay)
		{
			connectionDisplay = _connectionDisplay;
			super();
		}
		
		public function doLayout( 	dataProvider:ArrayCollection,target:UIComponent,
									width:Number,height:Number,
									outerMargin:Number = 0,innerMargin:Number = 0,hasChanged:Boolean = true ):void
		{
			if(dataProvider==null) return;
			
			ringSpacing = innerMargin;
			
			//	if layout has changed, solve
 			if(hasChanged || _notesModel.layoutDirty)
			{
				dispersions = new Array();
				
				//	build collection of NoteDisplays, so we can sort by # siblings
				var nds:ArrayCollection = new ArrayCollection();
				for(var i:int=0,radius:int=0,nd:NoteDisplay;i<dataProvider.length;i++)
				{
					nd = target.getChildByName("nd"+(dataProvider[i] as Note).id) as NoteDisplay;
					nd.layedOut=false;
					nds.addItem(nd);
				}
				
				//	apply sort by siblings
				var sort:Sort = new Sort();
				sort.fields = [new SortField("siblings")];
				sort.compareFunction = sortBySiblings;
				nds.sort = sort;
				nds.refresh();
				
				center = new Point(width/2-target.x,height/2-target.y);
				center = target.localToGlobal(center);
				center = target.globalToLocal(center);
				
				//	begin dispersing notes, laying out those w/ siblings first
				//	(thus, one w/ most siblings will appear as center)
				var level:int;
				for(i=0;i<nds.length;i++)
				{
					nd = nds.getItemAt(i) as NoteDisplay;
					
					//	if note has siblings...
					if(nd.siblings!=null && nd.siblings.length)
					{
						//	lay it out and get "level" (ring from center) in 
						//	which it was placed
						if(!nd.layedOut) level = disperseNode(nd);
						//	place each sibling one level up
						for(var j:int=0;j<nd.siblings.length;j++)
						{
							if(!nd.siblings[j].layedOut)
							{
								nd.siblings[j].parentSibling = nd;
								disperseNode(nd.siblings[j] as NoteDisplay,level+1,j);
							}
						}
					}
				}
				
				//	continue dispersing notes, moving on to those without siblings
				for(i=0;i<nds.length;i++)
				{
					nd = nds.getItemAt(i) as NoteDisplay;
					//	if note has no siblings and has not been layed out, lay it out
					if(!nd.layedOut && (nd.siblings==null || !nd.siblings.length))
						level = disperseNode(nd);
				}
			}
			else
			{
				if(lastWidth != width && lastHeight!=height)
				{
					var size:Number = Math.min(width,height);
					for(i=0;i<dataProvider.length;i++)
					{	
						nd = target.getChildByName("nd"+dataProvider[i].id) as NoteDisplay;
						if(!nd.enabled) continue;
						//	if layout hasn't changed, nudge notes instead of re-solving
						nd.default_x = lastWidth/nd.default_x * size;
						nd.default_y = lastHeight/nd.default_y * size;
					}
				}
			}
			
			//	store width/height, in case browser is resized later and 
			//	layout hasn't changed, in which case we opt to nudge nodes 
			lastWidth = width;
			lastHeight = height;
			
			dispatchEvent(new NoteLayoutEvent(NoteLayoutEvent.LAYOUT_COMPLETE));
		}
		
		private function disperseNode(nd:NoteDisplay,desiredLevel:int = 0,sibId:int = -1):int
		{
			var i:int = desiredLevel;
			var level:int = -1;
			
			while(level==-1)
			{
				var maxAllowedAtLevel:int = getMaxAllowedAtLevel(i);
				var degreeInc:int = 360/maxAllowedAtLevel;
				
				if(dispersions[i]==null || !levelIsFull(i))
				{
					if(dispersions[i]==null) dispersions[i] = new Array();
					
					if(nd.parentSibling)
					{
						var parentAngle:Number;
						
						/*
						var pl:Object = getNodeLocation(nd.parentSibling)
						if( pl!=null ) 
						{
							var max:int = pl.level==0 ? 1 : pl.level*10+pl.level;
							parentAngle = pl.index * (360/max);
						}
						else
						{
							parentAngle = Math.atan2(	nd.parentSibling.default_y-center.y, 
														nd.parentSibling.default_x-center.x) * 180/Math.PI;
						}
						*/
						
						parentAngle = Math.atan2(	nd.parentSibling.default_y-center.y, 
													nd.parentSibling.default_x-center.x) * 180/Math.PI;
						
						//	fix degrees to be between 0 and 360, vs -180 and 180
						var index:int = Math.round( (parentAngle-(Math.ceil(nd.parentSibling.siblings.length/2)*degreeInc)+(sibId*degreeInc))/360*maxAllowedAtLevel );
						
						if(index<0)
							index = maxAllowedAtLevel+index;
						
						if(dispersions[i][index]!=null)
							repositionNode(i,index,maxAllowedAtLevel,nd);
						else
							dispersions[i][index] = nd;
						
					}else{
						
						var inserted:Boolean = false;
						var startLevel:int = 0;
						
						while(!inserted)
						{
							if(!levelIsFull(startLevel))
							{
								if(dispersions[startLevel])
								{
									for(var j:int=0;j<dispersions[startLevel].length;j++)
									{
										if(dispersions[startLevel][j]==null && !inserted)
										{
											dispersions[startLevel][j]=nd;
											inserted=true;
										}
									}
									if(!inserted) {
										dispersions[startLevel].push(nd);
										inserted=true;
									}
								}else{
									dispersions[startLevel]=[nd];
									inserted=true;
								}
							}
							
							startLevel++;
						}
						
					}
					nd.layedOut = true;
					level = i;
				}
				i++;
			}
			
			var a:int = 0;
			var radius:int = Math.round(noteSize+ringSpacing) * level;
			var n:int = getNumInLevel(level);
			
			for(i=0;i<dispersions[level].length;i++)
			{
				var sibling:NoteDisplay = dispersions[level][i] as NoteDisplay;
				
				if(sibling!=null)
				{
					sibling.default_x = center.x + Math.cos(a* (Math.PI/180)) * radius;
					sibling.default_y = center.y + Math.sin(a* (Math.PI/180)) * radius;
					sibling.default_rotation = (a%360)-90;
					
					a += 360/n;
				}
			}
			
			return level;
		}
		
		private function getNodeLocation(nd:NoteDisplay):Object
		{
			if(dispersions==null || !dispersions.length) return null;
			
			for(var i:int=0;i<dispersions.length;i++)
				for(var j:int=0;j<dispersions[i].length;j++)
					if(dispersions[i][j]!=null && (dispersions[i][j] as NoteDisplay).note.id == nd.note.id)
						return {level:i,index:j};
			return null;
		}
		
		private function repositionNode(level:int,index:int,max:int,node:NoteDisplay):void
		{
			var i:int;
			
			for(i = index+1;i<max;i++)
			{
				if(dispersions[level][i]==null) 
				{	
					dispersions[level][i] = node;
					return;
				}
			}
			
			for(i = 0;i<index;i++)
			{
				if(dispersions[level][i]==null) {
					dispersions[level][i] = node;
					return;
				}
			}
		}
		
		private function levelIsFull(level:int):Boolean
		{
			if(!dispersions[level]) return false;
			
			var n:int=getNumInLevel(level);
			return n>=getMaxAllowedAtLevel(level);
		}
		
		private function getMaxAllowedAtLevel(level:int):int{
			if(level==0) return 1;
			
			var radius:Number = Math.round((noteSize+ringSpacing)*level);
			var diameter:Number = radius * 2 * Math.PI;
			
			return Math.round(diameter/(noteSize));
		}
		
		private function getNumInLevel(level:int):int{
			var n:int = 0;
			for(var i:int=0;i<dispersions[level].length;i++)
				if(dispersions[level][i]!=null) n+=1;
			return n;
		}
		
		private function sortBySiblings(a:Object, b:Object, fields:Array = null):int
		{
			//	null cases
			if(a.siblings==null && b.siblings==null) return 0;
			if(a.siblings==null && b.siblings!=null && b.siblings.length) return 1;
			if(a.siblings!=null && a.siblings.length && b.siblings==null) return -1;
			//	non null cases
			if(a.siblings.length == b.siblings.length) return 0;
			if(a.siblings.length>b.siblings.length) return -1;
			if(a.siblings.length<b.siblings.length) return 1;
			return 0;
		}
		
		public function get name():String{
			return GridLayout.LAYOUT_NAME;
		}

		public function get noteSize():Number{
			return 30;
		}
		
		public function get helpMessage():String{
			return "This is the similarity layout";
		}
		
		public function get sortable():Boolean{
			return false;
		}
	}
}