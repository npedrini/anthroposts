package net.looklisten.notes.components
{
	import com.greensock.TweenLite;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.media.SoundTransform;
	
	import mx.binding.utils.BindingUtils;
	import mx.core.Container;
	import mx.core.UIComponent;
	import mx.effects.Fade;
	import mx.events.CollectionEvent;
	
	import net.looklisten.components.TextBox;
	import net.looklisten.notes.components.connection.NoteConnectionDisplay;
	import net.looklisten.notes.events.ApplicationEvent;
	import net.looklisten.notes.events.NoteEvent;
	import net.looklisten.notes.events.NoteLayoutEvent;
	import net.looklisten.notes.layouts.INotesLayout;
	import net.looklisten.notes.layouts.ScatteredLayout;
	import net.looklisten.notes.layouts.SimilarityLayout;
	import net.looklisten.notes.model.NotesModel;
	import net.looklisten.notes.soap.Category;
	import net.looklisten.notes.soap.Note;
	import net.looklisten.notes.soap.NoteArray;
	import net.looklisten.notes.soap.Type;
	import net.looklisten.sound.SoundManager;
	
	[Event(name="navigateToUrl",type="net.looklisten.notes.events.ApplicationEvent")]
	
	public class NotesDisplay extends Container
	{
		public const CURTAIN_ALPHA:Number = .9;
		
		//	constants
		private const TWEEN:String = "easeOutExpo";
		private const TWEEN_LENGTH:Number = 500;
		private const MARGIN_INNER:Number = 5;
		private const MARGIN_OUTER:Number = 60;
		
		private static var _notesModel:NotesModel = NotesModel.getInstance();
		
		// 	CHILDREN
		public var nodes:UIComponent;	//	- child container for NoteDisplays
		public var connectionDisplay:NoteConnectionDisplay;		//	child container for NoteConnectionDisplays
		private var infoBox:TextBox;	//	- header and footer
		private var _footer:TextBox;
		public var curtain:Sprite;
		
		private var lastWidth:Number;
		private var lastHeight:Number;
		
		private var maximizedNoteIsRolledOver:Boolean;
		
		public function NotesDisplay()
		{
			super();
			
			autoLayout=true;
			
			BindingUtils.bindSetter(onSetNotes,_notesModel,"notes");
			BindingUtils.bindSetter(onSetNotesFiltered,_notesModel,"notesFiltered");
			BindingUtils.bindSetter(onSetLayout,_notesModel,"layout");
			
			onSetLayout(_notesModel.layout);
		}
		
		override protected function createChildren():void
		{
			super.createChildren();
			
			//	init note container
			if(nodes==null)
			{
				nodes = new UIComponent();
				addChild(nodes);
				
				curtain = new Sprite();
				curtain.alpha=0;
				curtain.graphics.clear();
				curtain.graphics.beginFill(0x000000,1);
				curtain.graphics.drawRect(0,0,10,10);
				curtain.graphics.endFill();
				curtain.addEventListener(MouseEvent.CLICK,onCurtainClick);
			}
			
			//	init connection display container
			if(connectionDisplay==null)
			{
				connectionDisplay = new NoteConnectionDisplay();
				connectionDisplay.notesDisplay = this;
				connectionDisplay.percentWidth=100;
				connectionDisplay.percentHeight=100;
				addChild(connectionDisplay);
			}
			
			if(infoBox==null)
			{
				infoBox = new TextBox();
				infoBox.styleName="noteHeader";
				infoBox.textStyleName="noteHeaderText";
				infoBox.cornerRadii = {tl:0,tr:15,bl:0,br:0};
				infoBox.visible=false;
				infoBox.padding = 10;
				infoBox.width = 150;
				infoBox.addEventListener(MouseEvent.ROLL_OUT,onInfoRollOut);
				
				//	init show effect
				var _showEffect:Fade = new Fade(infoBox);
				_showEffect.alphaFrom=0;
				_showEffect.alphaTo=1;
				_showEffect.duration=250;
				infoBox.setStyle('showEffect',_showEffect);
			}
		}
		
		override protected function commitProperties():void
		{
			super.commitProperties();
			
			if(_notesModel.notes==null) return;
			if(nodes.numChildren>0) return;
			
			nodes.addChild(curtain);
			nodes.addChild(infoBox);
			
			//	POPULATE NOTES CONTAINER (w/ NoteDisplays)
			var nd:NoteDisplay;
			for(var i:int=0;i<_notesModel.notes.length;i++)
			{	
				if( (nd = nodes.getChildByName("nd"+_notesModel.notes[i].id) as NoteDisplay) == null ){
					nd = new NoteDisplay( _notesModel.notes[i] as Note );
					nd.name = "nd"+_notesModel.notes[i].id;
					//	add listeners
					nd.addEventListener(MouseEvent.ROLL_OVER,onNoteRollOver);
					nd.addEventListener(NoteEvent.SHOW,onNoteShow);
					nd.addEventListener(NoteEvent.HIDE,onNoteHide);
					nd.addEventListener(NoteEvent.TWEEN_COMPLETE,onNoteTweenComplete);
					nd.addEventListener(NoteEvent.LOAD_COMPLETE,onNoteLoadComplete);
					nd.addEventListener(NoteEvent.LOAD_ERROR,onNoteLoadError);
					//	default state
					nd.visible=false;
					
					//	add and set default depth
					nodes.addChild(nd);
					nd.default_depth = nodes.getChildIndex(nd);
				}
			}
		}
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth,unscaledHeight);
			
			if(_notesModel.notes==null) return;
			
			trace('invalidateDisplayList');
			
			curtain.x = -nodes.x;
			curtain.y = -nodes.y;
			curtain.width = Math.max(width,nodes.width);
			curtain.height = Math.max(height,nodes.height);
			
			var screen:Rectangle = systemManager.screen; 
			
			//	center maximized note
			var maximizedNote:NoteDisplay = _notesModel.maximizedNote;
			if(maximizedNote!=null && maximizedNote.maximized) 
			{
				var center:Point = new Point(unscaledWidth/2-nodes.x,unscaledHeight/2-nodes.y);
				//	keep note on screen
				var nw:Number = maximizedNote.note.rotation_offset==-90 || maximizedNote.note.rotation_offset==90 ?
								maximizedNote.height:maximizedNote.width;
				var nh:Number = maximizedNote.note.rotation_offset==-90 || maximizedNote.note.rotation_offset==90 ?
								maximizedNote.width:maximizedNote.height;
				
				center = nodes.globalToLocal(center);
				center.x = Math.max(nw/2,center.x);
				center.y = Math.max(nh/2,center.y);
				
				var showInfo:Boolean = _notesModel.maximizedNote!=null && maximizedNoteIsRolledOver && !maximizedNote.loading;
				showInfo ? center.x-=infoBox.width/2 : null;
				
				//	position maximized note
				maximizedNote.center(center.x,center.y,showInfo,"easeOutCirc",showInfo?onMaximizedNoteReposition:null,150);
				
				//	position header
				infoBox.height = maximizedNote.height-40;
				infoBox.x = showInfo ? center.x+nw/2:maximizedNote.x+nw/2-infoBox.width;
				infoBox.y = center.y - infoBox.height/2;
				return;
			}
			
			var sizeHasChanged:Boolean = unscaledWidth!=lastWidth || unscaledHeight!=lastHeight;
			if(!sizeHasChanged && !(_notesModel.layoutDirty || _notesModel.layoutChanged)) return;
			
			var nd:NoteDisplay;
			//	hide notes based on notesModel.notesFiltered
			for(var i:int=0;i<_notesModel.notes.length;i++)
			{
				nd = nodes.getChildByName("nd"+_notesModel.notes[i].id) as NoteDisplay;
				nd.visible = nd.enabled = _notesModel.notesFiltered.getNoteIndex(nd.note)>-1;
			}
			
			//	ask current layout to update note position
			//	TODO: how can this go in controller?
			_notesModel.layout.doLayout(	_notesModel.notesFiltered,nodes,unscaledWidth,unscaledHeight,
											MARGIN_OUTER,MARGIN_INNER,_notesModel.layoutChanged);
			
			lastWidth = unscaledWidth;
			lastHeight = unscaledHeight;
		}
		
		private function onLayoutComplete(event:NoteLayoutEvent):void
		{
			if(_notesModel.layoutChanged || _notesModel.layoutDirty)
			{
				//	reset load queue
				_notesModel.loadQueue = _notesModel.loadQueueTotal = _notesModel.notesFiltered.length;
			}
			
			var ms:Number = 4;
			var s_inc:Number  = ms/_notesModel.notesFiltered.length;
			var nd:NoteDisplay;
			var w:Number = 0;
			var h:Number = 0;
			var noteSize:Number = Math.min(_notesModel.layout.noteSize,_notesModel.maxNoteSize);
			
			for(var i:int=0;i<_notesModel.notesFiltered.length;i++)
			{
				nd = nodes.getChildByName("nd"+_notesModel.notesFiltered[i].id) as NoteDisplay;
				
				if( _notesModel.layoutChanged || _notesModel.layoutDirty )
				{
					var x:Number = nd.default_x;
					var y:Number = nd.default_y;
					
					if( _notesModel.layoutInitialized )
					{
						nd.tweenTo( nd, { x:x, y:y, rotation:nd.default_rotation }, 500, "easeOutQuint", null, s_inc*i );
					}
					else
					{
						nd.x = nd.default_x;
						nd.y = nd.default_y;
						nd.rotation = nd.default_rotation;
					}
					
					nd.setHeight(noteSize,true);					
				}
				else
				{
					nd.x = nd.default_x;
					nd.y = nd.default_y;
					nd.rotation = nd.default_rotation;
				}
				
				w = Math.max(w,nd.default_x);
				h = Math.max(h,nd.default_y);
			}
			
			var m:Number = 30;
			nodes.x = nodes.y = m;
			nodes.width = w-m*2;
			nodes.height = h + noteSize/2;
			
			if(connectionDisplay!=null && connectionDisplay.visible) connectionDisplay.invalidateDisplayList();
			if(_notesModel.layoutChanged) _notesModel.layoutChanged = false;
			if(_notesModel.layoutDirty) _notesModel.layoutDirty = false;
			if( !_notesModel.layoutInitialized ) _notesModel.layoutInitialized = true;
			
			invalidateDisplayList();
		}
		
		//	binding
		private function onSetNotes(notes:NoteArray):void{	if(notes!=null) invalidateProperties();	}
		private function onSetNotesFiltered(notes:NoteArray):void{	
			if(notes!=null) notes.addEventListener(CollectionEvent.COLLECTION_CHANGE,onNotesChange);
			invalidateDisplayList();
		}
		
		private function onNotesChange(event:CollectionEvent):void
		{
			_notesModel.layoutDirty = true;
			invalidateDisplayList();
		}
		private function onSetLayout(value:INotesLayout):void{
			if(_notesModel.layoutChanged)
			{
				(_notesModel.layout as EventDispatcher).removeEventListener(NoteLayoutEvent.LAYOUT_COMPLETE,onLayoutComplete);
				(_notesModel.layout as EventDispatcher).addEventListener(NoteLayoutEvent.LAYOUT_COMPLETE,onLayoutComplete);
			}
		}
		
		private function onCurtainClick(event:MouseEvent):void
		{
			if(_notesModel.maximizedNote!=null)
				hideNote(_notesModel.maximizedNote);
		}
		
		/**
		 * Handler for ShowNote event (clicking)
		*/
		private function onNoteShow(event:NoteEvent):void
		{
			showNote(event.target as NoteDisplay);
		}
		
		private function onNoteHide(event:NoteEvent):void
		{
			hideNote(event.target as NoteDisplay);
		}
		
		public function showNote(nd:NoteDisplay):void
		{
			//	minimize the currently maximized note, if any
			if(_notesModel.maximizedNote!=null && _notesModel.maximizedNote != nd)
				hideNote(_notesModel.maximizedNote);
			
			if(nd==null) return;
			
			if(!nd.maximized){
				
				var center:Point = new Point(unscaledWidth/2-nodes.x,unscaledHeight/2-nodes.y);
				//	keep note on screen
				var nw:Number = nd.note.rotation_offset==-90 || nd.note.rotation_offset==90 ?
								nd.height:nd.width;
				var nh:Number = nd.note.rotation_offset==-90 || nd.note.rotation_offset==90 ?
								nd.width:nd.height;
				
				center.x = Math.max(nw/2,center.x);
				center.y = Math.max(nh/2,center.y);
				center = nodes.globalToLocal(center);
				
				var screenRect:Rectangle = systemManager.screen; 
				var w:Number = nd.note.image_width;
				var h:Number = nd.note.image_height;
				
				nd.maximized = true;
				nd.show(w,h,center.x,center.y);
			}
			
			//	update "curtain" to be behind maximized note
			nodes.setChildIndex(curtain,nodes.numChildren-1);
			//	update "curtain" to be behind maximized note
			nodes.setChildIndex(infoBox,nodes.numChildren-1);
			//	update maximized note to be topmost layer
			nodes.setChildIndex(nd,nodes.numChildren-1);
			
			//	fade up curtain
			TweenLite.to( curtain, .5, {alpha:CURTAIN_ALPHA} );
		}
		
		public function hideNote(nd:NoteDisplay):void
		{
			if(nd.maximized)
			{
				//	hide header and footer
				infoBox.visible=false;
				//_footer.visible=false;
				//	minimize
				nd.maximized = false;
				nd.hide();
				//	unset `maximizedNote`
				if(_notesModel.maximizedNote!=null && _notesModel.maximizedNote==nd)
				{
					_notesModel.maximizedNote=null;
					maximizedNoteIsRolledOver = false;
				}
				
				//	update "curtain" to be behind maximized note
				nodes.setChildIndex(curtain,1);
				//	update "curtain" to be behind maximized note
				nodes.setChildIndex(infoBox,2);
				//	update maximized note to be topmost layer
				nodes.setChildIndex(nd,nd.default_depth);
				
				//	fade up curtain
				TweenLite.to( curtain, .5, {alpha:0} );
			}
		}
		
		private function onNoteTweenComplete(event:Event):void
		{
			var nd:NoteDisplay = event.target as NoteDisplay;
			nd.setHeight(nd.maximized?nd.note.image_height:nd.default_height);
			
			if(nd.maximized)
			{
				if(nd.note.has_audio)
					SoundManager.getInstance().play(Constants.MP3_ROOT+"/"+nd.note.id+".mp3",new SoundTransform(.75));
				
				_notesModel.maximizedNote = nd;
				showHeader();
				invalidateDisplayList();
			}
		}
		
		private function showHeader():void
		{
			var nd:NoteDisplay = _notesModel.maximizedNote;
			if(nd!=null && nd.maximized)
			{	
				var typeCatTxt:String = "";
				var type:Type = NotesModel.getInstance().typesIndexed[nd.note.type_id] as Type;
				if(type!=null) typeCatTxt += type.width_inches + "\" x " + type.height_inches + "\", ";
				
				var category:Category = NotesModel.getInstance().categoriesIndexed[nd.note.category_id] as Category;
				if(category!=null) typeCatTxt += category.title + ".";
				
				var headerTxt:Array = [];
				var whereTxt:String = nd.getWhereText();
				var whenTxt:String  = nd.getWhenText();
				
				if(whereTxt!=null || whenTxt!=null) headerTxt.push(resourceManager.getString("resources","note.info.found"));
				whereTxt!=null	? headerTxt.push(resourceManager.getString("resources","note.info.at")+" " + whereTxt):null;
				whenTxt!=null	? headerTxt.push(resourceManager.getString("resources","note.info.on")+" " + whenTxt):null;
				
				var content:String = nd.note.content;
				content = content.replace(new RegExp("\n","g"),"");
				
				infoBox.content  = '<font size="16">' + typeCatTxt + '</font>\n\n';
				infoBox.content += headerTxt.join(" ") + '\n\n';
				if(content!=null && content!='')
					infoBox.content += '<font color="#000000" size="12"><u>' + content + '</u></font>\n\n';
				if( !AnthroPosts.simplifyUI )
					infoBox.content += '<a href="event:' + nd.maps_url + '" target="_blank">'+resourceManager.getString("resources","label.map")+'</a>\n\n';
				infoBox.text.addEventListener(TextEvent.LINK,onLinkClick);
			}
		}
		
		private function onLinkClick(event:TextEvent):void 
		{
	    	var e:ApplicationEvent = new ApplicationEvent(ApplicationEvent.NAVIGATE_TO_URL);
	    	e.url = event.text;
	    	dispatchEvent(e);
        }
        
		override protected function resourcesChanged():void
		{
			showHeader();
		}
		
		private function onNoteLoadComplete(event:Event):void
		{
			var nd:NoteDisplay = event.target as NoteDisplay;
			if(nd && !nd.maximized)
			{
				//	TODO: don't decrement when minimizing a note
				if(_notesModel.loadQueueTotal>0)
				{
					_notesModel.loadQueue -= 1;
					//trace(_notesModel.loadQueue);
					if(_notesModel.loadQueue == 0) 
					{
						_notesModel.loadQueueTotal=0;
						//trace('loadComplete');
					}
				}
			}
			
			if(nd.maximized)
				invalidateDisplayList();
		}
		
		private function onNoteLoadError(event:Event):void
		{
			var nd:NoteDisplay = event.target as NoteDisplay;
			if(nd && !nd.maximized)
			{
				if(_notesModel.loadQueueTotal>0)
				{
					_notesModel.loadQueue -= 1;
					//trace(_notesModel.loadQueue);
					if(_notesModel.loadQueue == 0) 
					{
						_notesModel.loadQueueTotal=0;
						//trace('loadComplete');
					}
				}
			}
			if(_notesModel.loadQueue == 0) trace('loadComplete');
		}
		
		private function onNoteRollOver(event:MouseEvent):void
		{
			var nd:NoteDisplay = event.currentTarget as NoteDisplay;
			
			doNoteRollOver( nd );
		}
		
		public function doNoteRollOver( nd:NoteDisplay ):void
		{
			if( nd.tweening ) return;
			
			trace('onNoteRollOver');
			
			//	rotate the note
			if(nd.maximized)
			{
				maximizedNoteIsRolledOver = _notesModel.maximizedNote==nd?true:null;
				invalidateDisplayList();
			}
			else
			{
				if((_notesModel.layout is SimilarityLayout) && nd.siblings!=null && nd.siblings.length)
				{
					nd.addEventListener(MouseEvent.ROLL_OUT,onNoteRollOut);
					connectionDisplay.onNoteRollOver(nd);
				}
				else 
				{
					if((_notesModel.layout is ScatteredLayout) && nd.rotation!=0) nd.rotateTo(0,nd,TWEEN_LENGTH/2,TWEEN,onNoteRotate,[nd]);
					nodes.setChildIndex(nd,_notesModel.notes.length-1);
				}
			}
		}
		
		private function doNoteRollOut(nd:NoteDisplay):void
		{
			trace('doNoteRollOut');
			
			if( nd.tweening ) return;
			
			
			if(nd.maximized)
			{
				if(infoBox.hitTestPoint(mouseX,mouseY)) return;
				maximizedNoteIsRolledOver = _notesModel.maximizedNote==nd?false:null;
				invalidateDisplayList();
			}
			else
			{
				if((_notesModel.layout is SimilarityLayout) && nd.siblings!=null && nd.siblings.length)
				{
					connectionDisplay.onNoteRollOut(nd);
				}
				else
				{
					if(_notesModel.layout is ScatteredLayout) 
					{
						nd.rotateTo(nd.default_rotation,nd,TWEEN_LENGTH-100,TWEEN);
						nd.removeEventListener(MouseEvent.ROLL_OUT,onNoteRollOut);
					}
				}
			}
		}
		
		private function onNoteRotate(nd:NoteDisplay):void
		{
			//var nd:NoteDisplay = NoteDisplay(event.target);
			if(!nd.hitTestPoint(mouseX,mouseY))
				doNoteRollOut(nd);
			else
				nd.addEventListener(MouseEvent.ROLL_OUT,onNoteRollOut);
		}
		
		private function onMaximizedNoteReposition(...args):void
		{
			infoBox.visible = true;
		}
		
		private function onNoteRollOut(event:MouseEvent):void
		{
			var nd:NoteDisplay = event.currentTarget as NoteDisplay;
			doNoteRollOut(nd);
		}
		
		private function onInfoRollOut(event:MouseEvent):void
		{
			if(_notesModel.maximizedNote==null) return;
			doNoteRollOut(_notesModel.maximizedNote);
		}
		
		public function getNext( index:int ):NoteDisplay
		{
			var nd:NoteDisplay;
			
			if(index>=_notesModel.notesFiltered.length) index = 0;
			
			var note:Note = _notesModel.notesFiltered.getItemAt(index) as Note;
			nd = nodes.getChildByName("nd"+note.id) as NoteDisplay;
			
			return nd!=null && nd.enabled ? nd : getNext(index+2);
		}
		
		public function getPrev( index:int ):NoteDisplay
		{
			var nd:NoteDisplay;
			if(index<0) index = _notesModel.notesFiltered.length-1;
			
			var note:Note = _notesModel.notesFiltered.getItemAt(index) as Note;
			nd = nodes.getChildByName("nd"+note.id) as NoteDisplay;
			
			return nd!=null && nd.enabled ? nd : getNext(index-2);
		}
		
		public function getNoteDisplayByNote(note:Note):NoteDisplay
		{
			return nodes.getChildByName("nd"+note.id) as NoteDisplay;
		}
		
		public function getRandomNote( hasSiblings:Boolean = false, i:int = 0 ):NoteDisplay
		{
			if( i == _notesModel.notesFiltered.length - 1 ) return null;
			
			var id:int = Math.round( Math.random() * (_notesModel.notesFiltered.length - 1 ) );
			var note:Note = _notesModel.notesFiltered.getNoteAt( id );
			var nd:NoteDisplay = getNoteDisplayByNote( note );
			
			if( hasSiblings )
			{
				if( nd.siblings && nd.siblings.length )
				{
					return nd;
				}
				else
				{
					return getRandomNote( hasSiblings, i+1 );
				}
			}
			
			return nd;
		}
		
		public function get showingInfo():Boolean
		{
			return infoBox.visible;
		}
	}
}