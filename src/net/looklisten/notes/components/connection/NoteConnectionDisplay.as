package net.looklisten.notes.components.connection
{
	import mx.binding.utils.BindingUtils;
	import mx.collections.ArrayCollection;
	import mx.controls.TextArea;
	import mx.core.UIComponent;
	
	import net.looklisten.notes.components.NoteDisplay;
	import net.looklisten.notes.components.NotesDisplay;
	import net.looklisten.notes.layouts.INotesLayout;
	import net.looklisten.notes.layouts.SimilarityLayout;
	import net.looklisten.notes.model.NotesModel;
	
	public class NoteConnectionDisplay extends UIComponent
	{
		private var _notesModel:NotesModel=NotesModel.getInstance();
		
		//	CHILDREN
		private var _linkContainer:UIComponent;
		private var _label:TextArea;
		
		private var _notesDisplay:NotesDisplay;
		private var _connections:Array;
		private var _links:Array;
		private var _connectionsDirty:Boolean;
		private var _noteWords:Array;
		
		[Bindable]
		public var word:String;
		
		public function NoteConnectionDisplay()
		{
			_noteWords = new Array();
			
			BindingUtils.bindSetter(onSetConnections,_notesModel,"connections");
			BindingUtils.bindSetter(onSetLayout,_notesModel,"layout");
			BindingUtils.bindSetter(onSetMaximizedNote,_notesModel,"maximizedNote");
			BindingUtils.bindSetter(onSetWord,this,"word");
		}
		
		override protected function createChildren():void
		{	
			//	init the holder if it doesn't exist
			if(_linkContainer==null)
			{
				_linkContainer = new UIComponent();
				_linkContainer.percentWidth=100;
				_linkContainer.percentHeight=100;
				addChild(_linkContainer);
			}
			
			if(_label==null)
			{
				_label = new TextArea();
				_label.styleName="connectionLabel";
				_label.setStyle("embedFonts",true);
				_label.selectable=false;
				_label.wordWrap=false;
				_label.visible=false;
				_label.horizontalScrollPolicy="off";
				_label.verticalScrollPolicy="off";
				addChild(_label);
			}
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			if(notesDisplay==null) return;
			//if(!_notesCreated) createNotes();
			if(_links == null || !_links.length) return;
			
			_label.width  = _label.textWidth+6;
			_label.height = _label.textHeight+6;
			_label.x = _notesDisplay.width/2-_label.width/2;
			_label.y = _notesDisplay.height/2-_label.height/2-100;
			
			for(var i:int=0;i<_links.length;i++)
				(_links[i] as ConnectionDisplay).invalidateDisplayList();
				
			x = _notesDisplay.nodes.x;
			y = _notesDisplay.nodes.y;
		}
		
		override protected function  commitProperties():void
		{
			if(notesDisplay==null || notesDisplay.nodes==null) return;
			if(_notesModel.connections==null) return;
			
			if(_connectionsDirty)
			{
				while(_linkContainer.numChildren>0) _linkContainer.removeChildAt(0);
				
				//	create the link objects
				var link:ConnectionDisplay;
				var linkName:String;
				var note1id:int;
				var note2id:int;
				var startNote:NoteDisplay;
				var endNote:NoteDisplay;
				_links = new Array();
				
				//	iterate over each word (that appears in 1 or more notes)
				for(var i:int=0;i<_notesModel.connections.length;i++)
				{
					var commonWord:Object = _notesModel.connections.getItemAt(i);
					var word:String = commonWord.word;
					//	iterate over each note that contains the word
					var notes:Array = commonWord.notes;
					for(var j:int=0;j<notes.length;j++)
					{
						note1id = notes[j];
						//	iterate over each note again (that contains the word)
						for(var k:int=0;k<notes.length;k++)
						{
							note2id = notes[k];
							//	if is not the note in the parent iteration (note1), draw a link
							//	between the two
							if(note1id!=note2id)
							{	
								linkName = note1id<note2id ? note1id + "_" + note2id : note2id + "_" + note1id;
								
								startNote = notesDisplay.nodes.getChildByName("nd"+String(note1id<note2id?note1id:note2id)) as NoteDisplay;
								endNote	= notesDisplay.nodes.getChildByName("nd"+String(note1id<note2id?note2id:note1id)) as NoteDisplay;
								
								if(startNote!=null && endNote != null)
								{
									if((link = _linkContainer.getChildByName(linkName) as ConnectionDisplay)==null){
										link = new ConnectionDisplay();
										_linkContainer.addChild(link);
									}
									link.startNote = startNote;
									link.endNote = endNote;
									link.word = word;
									link.size = 1;
									link.notes = notes;
									
									_links.push(link);
									
									if(startNote.siblings==null || !startNote.siblingExists(endNote))
										startNote.addSibling(endNote);
									if(endNote.siblings==null || !endNote.siblingExists(startNote))
										endNote.addSibling(startNote);
									
									if( _noteWords[startNote.note.id]==null ||
										(_noteWords[startNote.note.id] as Array).indexOf(word)==-1)
										if(_noteWords[startNote.note.id]==null)
											_noteWords[startNote.note.id]=[word];
										else
											_noteWords[startNote.note.id].push(word);
									
									if( _noteWords[endNote.note.id]==null ||
										(_noteWords[endNote.note.id] as Array).indexOf(word)==-1)
										if(_noteWords[endNote.note.id]==null)
											_noteWords[endNote.note.id]=[word];
										else
											_noteWords[endNote.note.id].push(word);
								}
							}
						}
					}
				}
				_connectionsDirty = false;
			}
		}
		
		public function focusNotes(notes:Array):void
		{
			//	if a note is maximized, don't do anything
			if(_notesModel.maximizedNote!=null) return;
			//	set "focused" notes on top
			for(var i:int=0;i<notes.length;i++)
			{
				var nd:NoteDisplay = _notesDisplay.nodes.getChildByName("nd"+notes[i]) as NoteDisplay;
				_notesDisplay.nodes.setChildIndex(nd,_notesDisplay.nodes.numChildren-(i+1));
			}
			//	update "curtain" to be behind maximized note
			_notesDisplay.nodes.setChildIndex(_notesDisplay.curtain,_notesDisplay.nodes.numChildren-notes.length-1);
			//	show "curtains"
			_notesDisplay.curtain.alpha=.9;
		}
		
		public function unfocusNotes(notes:Array):void
		{
			//	if a note is maximized, don't do anything
			if(_notesModel.maximizedNote!=null) return;
			//	set "curtain" back at bottom
			_notesDisplay.nodes.setChildIndex(_notesDisplay.curtain,1);
			//	set "focused" notes to default depth
			for(var i:int=0;i<notes.length;i++)
			{
				var nd:NoteDisplay = _notesDisplay.nodes.getChildByName("nd"+notes[i]) as NoteDisplay;
				_notesDisplay.nodes.setChildIndex(nd,nd.default_depth);
			}
			//	hide "curtains"
			_notesDisplay.curtain.alpha=0;
		}
		
		public function onNoteRollOver(nd:NoteDisplay):void
		{
			var notes:Array = getRelated(nd);
			focusNotes(notes);
			
			var words:Array = new Array();
			word = (_noteWords[nd.note.id] as Array).join(", ").toUpperCase();
		}
		
		public function onNoteRollOut(nd:NoteDisplay):void
		{
			var notes:Array = getRelated(nd);
			//for each(var sib:NoteDisplay in nd.siblings) notes.push(sib.note);
			unfocusNotes(notes);
			word = null;
		}
		
		private function getRelated(note:NoteDisplay):Array
		{
			var notes:Array = new Array();
			for each(var word:String in _noteWords[note.note.id]) 
			{
				notes = notes.concat(getNotesForWord(word));
			}
			return notes;
		}
		
		private function getNotesForWord(word:String):Array
		{
			var notes:Array = new Array();
			for(var i:int=0;i<_notesDisplay.nodes.numChildren;i++)
			{
				if(_notesDisplay.nodes.getChildAt(i) is NoteDisplay)
				{
					var nd:NoteDisplay = _notesDisplay.nodes.getChildAt(i) as NoteDisplay;
					var noteWords:Array = _noteWords[nd.note.id];
					if(noteWords!=null && noteWords.indexOf(word)>-1)
						notes.push(nd.note.id);
				}
			}
			return notes;
		}
		
		private function updateVisibility():void
		{
			visible = (_notesModel.layout is SimilarityLayout) && _notesModel.maximizedNote==null;
		}
		
		private function onSetWord(value:String):void
		{
			if(_label!=null)
			{
				_label.visible = value!=null;
				_label.text = value!=null?value:'';
				invalidateDisplayList();
			}
		}
		
		public function onSetConnections(value:ArrayCollection):void
		{
			_connectionsDirty = true;
			invalidateProperties();
		}
		
		public function onSetLayout(value:INotesLayout):void
		{
			updateVisibility();
		}
		
		public function onSetMaximizedNote(value:NoteDisplay):void
		{
			updateVisibility();
		}
		
		public function set notesDisplay(value:NotesDisplay):void
		{
			_notesDisplay = value;
			invalidateDisplayList();
		}
		
		public function get notesDisplay():NotesDisplay
		{
			return _notesDisplay;
		}
	}
}