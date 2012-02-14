
/**
 * Service.as
 * This file was auto-generated from WSDL by the Apache Axis2 generator modified by Adobe
 * Any change made to this file will be overwritten when the code is re-generated.
 */
package net.looklisten{
	import mx.rpc.AsyncToken;
	import flash.utils.ByteArray;
	import mx.rpc.soap.types.*;
               
    public interface IWorryBoxSoapClient
    {
    	//Stub functions for the getWorries operation
    	/**
    	 * Call the operation on the server passing in the arguments defined in the WSDL file
    	 * @param limit
    	 * @param category_id
    	 * @return An AsyncToken
    	 */
    	function getWorries(limit:Number,category_id:Number):AsyncToken;
        /**
         * Method to call the operation on the server without passing the arguments inline.
         * You must however set the _request property for the operation before calling this method
         * Should use it in MXML context mostly
         * @return An AsyncToken
         */
        function getWorries_send():AsyncToken;
        
        /**
         * The getWorries operation lastResult property
         */
        function get getWorries_lastResult():WorryArray;
		/**
		 * @private
		 */
        function set getWorries_lastResult(lastResult:WorryArray):void;
       /**
        * Add a listener for the getWorries operation successful result event
        * @param The listener function
        */
       function addgetWorriesEventListener(listener:Function):void;
       
       
        /**
         * The getWorries operation request wrapper
         */
        function get getWorries_request_var():GetWorries_request;
        
        /**
         * @private
         */
        function set getWorries_request_var(request:GetWorries_request):void;
                   
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
       
       
        /**
         * Get access to the underlying web service that the stub uses to communicate with the server
         * @return The base service that the facade implements
         */
        function getWebService():BaseWorryBoxSoapClient;
	}
}