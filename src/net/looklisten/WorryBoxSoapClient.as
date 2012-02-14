
/**
 * WorryBoxSoapClientService.as
 * This file was auto-generated from WSDL by the Apache Axis2 generator modified by Adobe
 * Any change made to this file will be overwritten when the code is re-generated.
 */
 /**
  * Usage example: to use this service from within your Flex application you have two choices:
  * Use it via Actionscript only
  * Use it via MXML tags
  * Actionscript sample code:
  * Step 1: create an instance of the service; pass it the LCDS destination string if any
  * var myService:WorryBoxSoapClient= new WorryBoxSoapClient();
  * Step 2: for the desired operation add a result handler (a function that you have already defined previously)  
  * myService.addgetWorriesEventListener(myResultHandlingFunction);
  * Step 3: Call the operation as a method on the service. Pass the right values as arguments:
  * myService.getWorries(mylimit,mycategory_id);
  *
  * MXML sample code:
  * First you need to map the package where the files were generated to a namespace, usually on the <mx:Application> tag, 
  * like this: xmlns:srv="net.looklisten.*"
  * Define the service and within its tags set the request wrapper for the desired operation
  * <srv:WorryBoxSoapClient id="myService">
  *   <srv:getWorries_request_var>
  *		<srv:GetWorries_request limit=myValue,category_id=myValue/>
  *   </srv:getWorries_request_var>
  * </srv:WorryBoxSoapClient>
  * Then call the operation for which you have set the request wrapper value above, like this:
  * <mx:Button id="myButton" label="Call operation" click="myService.getWorries_send()" />
  */
 package net.looklisten{
	import mx.rpc.AsyncToken;
	import flash.events.EventDispatcher;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.events.FaultEvent;
	import flash.utils.ByteArray;
	import mx.rpc.soap.types.*;

    /**
     * Dispatches when a call to the operation getWorries completes with success
     * and returns some data
     * @eventType GetWorriesResultEvent
     */
    [Event(name="GetWorries_result", type="net.looklisten.GetWorriesResultEvent")]
    
    /**
     * Dispatches when a call to the operation getCategories completes with success
     * and returns some data
     * @eventType GetCategoriesResultEvent
     */
    [Event(name="GetCategories_result", type="net.looklisten.GetCategoriesResultEvent")]
    
	/**
	 * Dispatches when the operation that has been called fails. The fault event is common for all operations
	 * of the WSDL
	 * @eventType mx.rpc.events.FaultEvent
	 */
    [Event(name="fault", type="mx.rpc.events.FaultEvent")]

	public class WorryBoxSoapClient extends EventDispatcher implements IWorryBoxSoapClient
	{
    	private var _baseService:BaseWorryBoxSoapClient;
        
        /**
         * Constructor for the facade; sets the destination and create a baseService instance
         * @param The LCDS destination (if any) associated with the imported WSDL
         */  
        public function WorryBoxSoapClient(destination:String=null,rootURL:String=null)
        {
        	_baseService = new BaseWorryBoxSoapClient(destination,rootURL);
        }
        
		//stub functions for the getWorries operation
          

        /**
         * @see IWorryBoxSoapClient#getWorries()
         */
        public function getWorries(limit:Number,category_id:Number):AsyncToken
        {
         	var _internal_token:AsyncToken = _baseService.getWorries(limit,category_id);
            _internal_token.addEventListener("result",_getWorries_populate_results);
            _internal_token.addEventListener("fault",throwFault); 
            return _internal_token;
		}
        /**
		 * @see IWorryBoxSoapClient#getWorries_send()
		 */    
        public function getWorries_send():AsyncToken
        {
        	return getWorries(_getWorries_request.limit,_getWorries_request.category_id);
        }
              
		/**
		 * Internal representation of the request wrapper for the operation
		 * @private
		 */
		private var _getWorries_request:GetWorries_request;
		/**
		 * @see IWorryBoxSoapClient#getWorries_request_var
		 */
		[Bindable]
		public function get getWorries_request_var():GetWorries_request
		{
			return _getWorries_request;
		}
		
		/**
		 * @private
		 */
		public function set getWorries_request_var(request:GetWorries_request):void
		{
			_getWorries_request = request;
		}
		
	  		/**
		 * Internal variable to store the operation's lastResult
		 * @private
		 */
        private var _getWorries_lastResult:WorryArray;
		[Bindable]
		/**
		 * @see IWorryBoxSoapClient#getWorries_lastResult
		 */	  
		public function get getWorries_lastResult():WorryArray
		{
			return _getWorries_lastResult;
		}
		/**
		 * @private
		 */
		public function set getWorries_lastResult(lastResult:WorryArray):void
		{
			_getWorries_lastResult = lastResult;
		}
		
		/**
		 * @see IWorryBoxSoapClient#addgetWorries()
		 */
		public function addgetWorriesEventListener(listener:Function):void
		{
			addEventListener(GetWorriesResultEvent.GetWorries_RESULT,listener);
		}
			
		/**
		 * @private
		 */
        private function _getWorries_populate_results(event:ResultEvent):void
        {
        var e:GetWorriesResultEvent = new GetWorriesResultEvent();
		            e.result = event.result as WorryArray;
		                       e.headers = event.headers;
		             getWorries_lastResult = e.result;
		             dispatchEvent(e);
	        		
		}
		
		//stub functions for the getCategories operation
          

        /**
         * @see IWorryBoxSoapClient#getCategories()
         */
        public function getCategories():AsyncToken
        {
         	var _internal_token:AsyncToken = _baseService.getCategories();
            _internal_token.addEventListener("result",_getCategories_populate_results);
            _internal_token.addEventListener("fault",throwFault); 
            return _internal_token;
		}
        /**
		 * @see IWorryBoxSoapClient#getCategories_send()
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
		 * @see IWorryBoxSoapClient#getCategories_lastResult
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
		 * @see IWorryBoxSoapClient#addgetCategories()
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
		
		//service-wide functions
		/**
		 * @see IWorryBoxSoapClient#getWebService()
		 */
		public function getWebService():BaseWorryBoxSoapClient
		{
			return _baseService;
		}
		
		/**
		 * Set the event listener for the fault event which can be triggered by each of the operations defined by the facade
		 */
		public function addWorryBoxSoapClientFaultEventListener(listener:Function):void
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
