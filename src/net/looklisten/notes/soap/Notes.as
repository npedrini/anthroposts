
/**
 * NotesService.as
 * This file was auto-generated from WSDL by the Apache Axis2 generator modified by Adobe
 * Any change made to this file will be overwritten when the code is re-generated.
 */
 /**
  * Usage example: to use this service from within your Flex application you have two choices:
  * Use it via Actionscript only
  * Use it via MXML tags
  * Actionscript sample code:
  * Step 1: create an instance of the service; pass it the LCDS destination string if any
  * var myService:Notes= new Notes();
  * Step 2: for the desired operation add a result handler (a function that you have already defined previously)  
  * myService.addgetNotesEventListener(myResultHandlingFunction);
  * Step 3: Call the operation as a method on the service. Pass the right values as arguments:
  * myService.getNotes(mylimit,mytype_id,mycategory_id);
  *
  * MXML sample code:
  * First you need to map the package where the files were generated to a namespace, usually on the <mx:Application> tag, 
  * like this: xmlns:srv="net.looklisten.notes.soap.*"
  * Define the service and within its tags set the request wrapper for the desired operation
  * <srv:Notes id="myService">
  *   <srv:getNotes_request_var>
  *		<srv:GetNotes_request limit=myValue,type_id=myValue,category_id=myValue/>
  *   </srv:getNotes_request_var>
  * </srv:Notes>
  * Then call the operation for which you have set the request wrapper value above, like this:
  * <mx:Button id="myButton" label="Call operation" click="myService.getNotes_send()" />
  */
 package net.looklisten.notes.soap{
	import mx.rpc.AsyncToken;
	import flash.events.EventDispatcher;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.events.FaultEvent;
	import flash.utils.ByteArray;
	import mx.rpc.soap.types.*;

    /**
     * Dispatches when a call to the operation getNotes completes with success
     * and returns some data
     * @eventType GetNotesResultEvent
     */
    [Event(name="GetNotes_result", type="net.looklisten.notes.soap.GetNotesResultEvent")]
    
    /**
     * Dispatches when a call to the operation getCategories completes with success
     * and returns some data
     * @eventType GetCategoriesResultEvent
     */
    [Event(name="GetCategories_result", type="net.looklisten.notes.soap.GetCategoriesResultEvent")]
    
    /**
     * Dispatches when a call to the operation getTypes completes with success
     * and returns some data
     * @eventType GetTypesResultEvent
     */
    [Event(name="GetTypes_result", type="net.looklisten.notes.soap.GetTypesResultEvent")]
    
    /**
     * Dispatches when a call to the operation getLocations completes with success
     * and returns some data
     * @eventType GetLocationsResultEvent
     */
    [Event(name="GetLocations_result", type="net.looklisten.notes.soap.GetLocationsResultEvent")]
    
	/**
	 * Dispatches when the operation that has been called fails. The fault event is common for all operations
	 * of the WSDL
	 * @eventType mx.rpc.events.FaultEvent
	 */
    [Event(name="fault", type="mx.rpc.events.FaultEvent")]

	public class Notes extends EventDispatcher implements INotes
	{
    	private var _baseService:BaseNotes;
        
        /**
         * Constructor for the facade; sets the destination and create a baseService instance
         * @param The LCDS destination (if any) associated with the imported WSDL
         */  
        public function Notes(destination:String=null,rootURL:String=null)
        {
        	_baseService = new BaseNotes(destination,rootURL);
        }
        
		//stub functions for the getNotes operation
          

        /**
         * @see INotes#getNotes()
         */
        public function getNotes(limit:Number,type_id:Number,category_id:Number):AsyncToken
        {
         	var _internal_token:AsyncToken = _baseService.getNotes(limit,type_id,category_id);
            _internal_token.addEventListener("result",_getNotes_populate_results);
            _internal_token.addEventListener("fault",throwFault); 
            return _internal_token;
		}
        /**
		 * @see INotes#getNotes_send()
		 */    
        public function getNotes_send():AsyncToken
        {
        	return getNotes(_getNotes_request.limit,_getNotes_request.type_id,_getNotes_request.category_id);
        }
              
		/**
		 * Internal representation of the request wrapper for the operation
		 * @private
		 */
		private var _getNotes_request:GetNotes_request;
		/**
		 * @see INotes#getNotes_request_var
		 */
		[Bindable]
		public function get getNotes_request_var():GetNotes_request
		{
			return _getNotes_request;
		}
		
		/**
		 * @private
		 */
		public function set getNotes_request_var(request:GetNotes_request):void
		{
			_getNotes_request = request;
		}
		
	  		/**
		 * Internal variable to store the operation's lastResult
		 * @private
		 */
        private var _getNotes_lastResult:NoteArray;
		[Bindable]
		/**
		 * @see INotes#getNotes_lastResult
		 */	  
		public function get getNotes_lastResult():NoteArray
		{
			return _getNotes_lastResult;
		}
		/**
		 * @private
		 */
		public function set getNotes_lastResult(lastResult:NoteArray):void
		{
			_getNotes_lastResult = lastResult;
		}
		
		/**
		 * @see INotes#addgetNotes()
		 */
		public function addgetNotesEventListener(listener:Function):void
		{
			addEventListener(GetNotesResultEvent.GetNotes_RESULT,listener);
		}
			
		/**
		 * @private
		 */
        private function _getNotes_populate_results(event:ResultEvent):void
        {
        var e:GetNotesResultEvent = new GetNotesResultEvent();
		            e.result = event.result as NoteArray;
		                       e.headers = event.headers;
		             getNotes_lastResult = e.result;
		             dispatchEvent(e);
	        		
		}
		
		//stub functions for the getCategories operation
          

        /**
         * @see INotes#getCategories()
         */
        public function getCategories():AsyncToken
        {
         	var _internal_token:AsyncToken = _baseService.getCategories();
            _internal_token.addEventListener("result",_getCategories_populate_results);
            _internal_token.addEventListener("fault",throwFault); 
            return _internal_token;
		}
        /**
		 * @see INotes#getCategories_send()
		 */    
        public function getCategories_send():AsyncToken
        {
        	return getCategories();
        }
              
	  		/**
		 * Internal variable to store the operation's lastResult
		 * @private
		 */
        private var _getCategories_lastResult:CategoryArray;
		[Bindable]
		/**
		 * @see INotes#getCategories_lastResult
		 */	  
		public function get getCategories_lastResult():CategoryArray
		{
			return _getCategories_lastResult;
		}
		/**
		 * @private
		 */
		public function set getCategories_lastResult(lastResult:CategoryArray):void
		{
			_getCategories_lastResult = lastResult;
		}
		
		/**
		 * @see INotes#addgetCategories()
		 */
		public function addgetCategoriesEventListener(listener:Function):void
		{
			addEventListener(GetCategoriesResultEvent.GetCategories_RESULT,listener);
		}
			
		/**
		 * @private
		 */
        private function _getCategories_populate_results(event:ResultEvent):void
        {
        var e:GetCategoriesResultEvent = new GetCategoriesResultEvent();
		            e.result = event.result as CategoryArray;
		                       e.headers = event.headers;
		             getCategories_lastResult = e.result;
		             dispatchEvent(e);
	        		
		}
		
		//stub functions for the getTypes operation
          

        /**
         * @see INotes#getTypes()
         */
        public function getTypes():AsyncToken
        {
         	var _internal_token:AsyncToken = _baseService.getTypes();
            _internal_token.addEventListener("result",_getTypes_populate_results);
            _internal_token.addEventListener("fault",throwFault); 
            return _internal_token;
		}
        /**
		 * @see INotes#getTypes_send()
		 */    
        public function getTypes_send():AsyncToken
        {
        	return getTypes();
        }
              
	  		/**
		 * Internal variable to store the operation's lastResult
		 * @private
		 */
        private var _getTypes_lastResult:TypeArray;
		[Bindable]
		/**
		 * @see INotes#getTypes_lastResult
		 */	  
		public function get getTypes_lastResult():TypeArray
		{
			return _getTypes_lastResult;
		}
		/**
		 * @private
		 */
		public function set getTypes_lastResult(lastResult:TypeArray):void
		{
			_getTypes_lastResult = lastResult;
		}
		
		/**
		 * @see INotes#addgetTypes()
		 */
		public function addgetTypesEventListener(listener:Function):void
		{
			addEventListener(GetTypesResultEvent.GetTypes_RESULT,listener);
		}
			
		/**
		 * @private
		 */
        private function _getTypes_populate_results(event:ResultEvent):void
        {
        var e:GetTypesResultEvent = new GetTypesResultEvent();
		            e.result = event.result as TypeArray;
		                       e.headers = event.headers;
		             getTypes_lastResult = e.result;
		             dispatchEvent(e);
	        		
		}
		
		//stub functions for the getLocations operation
          

        /**
         * @see INotes#getLocations()
         */
        public function getLocations():AsyncToken
        {
         	var _internal_token:AsyncToken = _baseService.getLocations();
            _internal_token.addEventListener("result",_getLocations_populate_results);
            _internal_token.addEventListener("fault",throwFault); 
            return _internal_token;
		}
        /**
		 * @see INotes#getLocations_send()
		 */    
        public function getLocations_send():AsyncToken
        {
        	return getLocations();
        }
              
	  		/**
		 * Internal variable to store the operation's lastResult
		 * @private
		 */
        private var _getLocations_lastResult:LocationArray;
		[Bindable]
		/**
		 * @see INotes#getLocations_lastResult
		 */	  
		public function get getLocations_lastResult():LocationArray
		{
			return _getLocations_lastResult;
		}
		/**
		 * @private
		 */
		public function set getLocations_lastResult(lastResult:LocationArray):void
		{
			_getLocations_lastResult = lastResult;
		}
		
		/**
		 * @see INotes#addgetLocations()
		 */
		public function addgetLocationsEventListener(listener:Function):void
		{
			addEventListener(GetLocationsResultEvent.GetLocations_RESULT,listener);
		}
			
		/**
		 * @private
		 */
        private function _getLocations_populate_results(event:ResultEvent):void
        {
        var e:GetLocationsResultEvent = new GetLocationsResultEvent();
		            e.result = event.result as LocationArray;
		                       e.headers = event.headers;
		             getLocations_lastResult = e.result;
		             dispatchEvent(e);
	        		
		}
		
		//service-wide functions
		/**
		 * @see INotes#getWebService()
		 */
		public function getWebService():BaseNotes
		{
			return _baseService;
		}
		
		/**
		 * Set the event listener for the fault event which can be triggered by each of the operations defined by the facade
		 */
		public function addNotesFaultEventListener(listener:Function):void
		{
			addEventListener("fault",listener);
		}
		
		/**
		 * Internal function to re-dispatch the fault event passed on by the base service implementation
		 * @private
		 */
		 
		 private function throwFault(event:FaultEvent):void
		 {
		 	dispatchEvent(event);
		 }
    }
}
