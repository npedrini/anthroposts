
/**
 * Service.as
 * This file was auto-generated from WSDL by the Apache Axis2 generator modified by Adobe
 * Any change made to this file will be overwritten when the code is re-generated.
 */
package net.looklisten.notes.soap{
	import mx.rpc.AsyncToken;
	import flash.utils.ByteArray;
	import mx.rpc.soap.types.*;
               
    public interface INotes
    {
    	//Stub functions for the getNotes operation
    	/**
    	 * Call the operation on the server passing in the arguments defined in the WSDL file
    	 * @param limit
    	 * @param type_id
    	 * @param category_id
    	 * @return An AsyncToken
    	 */
    	function getNotes(limit:Number,type_id:Number,category_id:Number):AsyncToken;
        /**
         * Method to call the operation on the server without passing the arguments inline.
         * You must however set the _request property for the operation before calling this method
         * Should use it in MXML context mostly
         * @return An AsyncToken
         */
        function getNotes_send():AsyncToken;
        
        /**
         * The getNotes operation lastResult property
         */
        function get getNotes_lastResult():NoteArray;
		/**
		 * @private
		 */
        function set getNotes_lastResult(lastResult:NoteArray):void;
       /**
        * Add a listener for the getNotes operation successful result event
        * @param The listener function
        */
       function addgetNotesEventListener(listener:Function):void;
       
       
        /**
         * The getNotes operation request wrapper
         */
        function get getNotes_request_var():GetNotes_request;
        
        /**
         * @private
         */
        function set getNotes_request_var(request:GetNotes_request):void;
                   
    	//Stub functions for the getCategories operation
    	/**
    	 * Call the operation on the server passing in the arguments defined in the WSDL file
    	 * @return An AsyncToken
    	 */
    	function getCategories():AsyncToken;
        /**
         * Method to call the operation on the server without passing the arguments inline.
         * You must however set the _request property for the operation before calling this method
         * Should use it in MXML context mostly
         * @return An AsyncToken
         */
        function getCategories_send():AsyncToken;
        
        /**
         * The getCategories operation lastResult property
         */
        function get getCategories_lastResult():CategoryArray;
		/**
		 * @private
		 */
        function set getCategories_lastResult(lastResult:CategoryArray):void;
       /**
        * Add a listener for the getCategories operation successful result event
        * @param The listener function
        */
       function addgetCategoriesEventListener(listener:Function):void;
       
       
    	//Stub functions for the getTypes operation
    	/**
    	 * Call the operation on the server passing in the arguments defined in the WSDL file
    	 * @return An AsyncToken
    	 */
    	function getTypes():AsyncToken;
        /**
         * Method to call the operation on the server without passing the arguments inline.
         * You must however set the _request property for the operation before calling this method
         * Should use it in MXML context mostly
         * @return An AsyncToken
         */
        function getTypes_send():AsyncToken;
        
        /**
         * The getTypes operation lastResult property
         */
        function get getTypes_lastResult():TypeArray;
		/**
		 * @private
		 */
        function set getTypes_lastResult(lastResult:TypeArray):void;
       /**
        * Add a listener for the getTypes operation successful result event
        * @param The listener function
        */
       function addgetTypesEventListener(listener:Function):void;
       
       
    	//Stub functions for the getLocations operation
    	/**
    	 * Call the operation on the server passing in the arguments defined in the WSDL file
    	 * @return An AsyncToken
    	 */
    	function getLocations():AsyncToken;
        /**
         * Method to call the operation on the server without passing the arguments inline.
         * You must however set the _request property for the operation before calling this method
         * Should use it in MXML context mostly
         * @return An AsyncToken
         */
        function getLocations_send():AsyncToken;
        
        /**
         * The getLocations operation lastResult property
         */
        function get getLocations_lastResult():LocationArray;
		/**
		 * @private
		 */
        function set getLocations_lastResult(lastResult:LocationArray):void;
       /**
        * Add a listener for the getLocations operation successful result event
        * @param The listener function
        */
       function addgetLocationsEventListener(listener:Function):void;
       
       
        /**
         * Get access to the underlying web service that the stub uses to communicate with the server
         * @return The base service that the facade implements
         */
        function getWebService():BaseNotes;
	}
}