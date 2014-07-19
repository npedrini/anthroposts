package net.looklisten.notes.model
{
	import mx.collections.ArrayCollection;
	import mx.collections.SortField;
	
	import net.looklisten.notes.components.NoteDisplay;
	import net.looklisten.notes.layouts.INotesLayout;
	import net.looklisten.notes.soap.CategoryArray;
	import net.looklisten.notes.soap.LocationArray;
	import net.looklisten.notes.soap.NoteArray;
	import net.looklisten.notes.soap.TypeArray;
	
	[Bindable]
	public class NotesModel
	{
		public static const LOAD_TYPES:String = "getTypes";
		public static const LOAD_CATEGORIES:String = "getCategories";
		public static const LOAD_LOCATIONS:String = "getLocations";
		public static const LOAD_NOTES:String = "getNotes";
		
		//	processes
		public var loadOperations:Array = [	NotesModel.LOAD_TYPES,
											NotesModel.LOAD_CATEGORIES,
											NotesModel.LOAD_LOCATIONS,
											NotesModel.LOAD_NOTES];
		
		public var loading:Boolean;
		public var loadOperationName:String;
		public var loadOperationId:int;
		
		public var loadQueueTotal:int;
		private var _loadQueue:int;
		
		public var dataLoaded:Boolean;
		
		//	data provider, array of Note objects
		public var notes:NoteArray;
		private var _notesFiltered:NoteArray;
		
		public var types:TypeArray;
		public var typesIndexed:Array;
		public var categories:CategoryArray;
		public var categoriesIndexed:Array;
		public var locations:LocationArray;
		public var locationsIndexed:Array;
		
		//	controls layout of notes
		private var _layout:INotesLayout;
		
		//	filters notes by Note[SortField.field]
		public var sortField:SortField;
		
		//	currently-maximized note
		public var maximizedNote:NoteDisplay;
		
		//	whether layout has been changed
		public var layoutChanged:Boolean;
		public var layoutDirty:Boolean;
		public var layoutInitialized:Boolean;
		
		public var connections:ArrayCollection;
		
		public var filterCategoryId:int;
		public var filterTypeId:int;
		public var filterLocationId:int;
		
		public var maxNoteSize:Number;
		
		private static var __instance:NotesModel;
		
		private static var singletonEnforcer:Boolean = true;
		
		public function NotesModel()
		{
			if(__instance!=null) {
				throw new Error("Singleton already instantiated");
			}
			
			dataLoaded = false;
			loadOperationId = 0;
			
			filterCategoryId = -1;
			filterTypeId = -1;
			filterLocationId = -1;
		}
		
		public static function getInstance():NotesModel{
			if(__instance==null)
				__instance = new NotesModel();
			return __instance;
		}
		
		public function set layout(__layout:INotesLayout):void{
			if(_layout!=__layout) layoutChanged = true;
			_layout = __layout;
		}
		public function get layout():INotesLayout{
			return _layout;
		}
		
		public function set loadQueue(value:int):void{
			_loadQueue = value;
			loading = loadQueue>0;
		}
		public function get loadQueue():int{
			return _loadQueue;
		}
		
		public function set notesFiltered(value:NoteArray):void{
			if(notesFiltered!=value) layoutDirty = true;
			_notesFiltered = value;
		}
		public function get notesFiltered():NoteArray{
			return _notesFiltered;
		}
	}
}