/**
 * GetTypesResultEvent.as
 * This file was auto-generated from WSDL
 * Any change made to this file will be overwritten when the code is re-generated.
*/
package net.looklisten.notes.soap
{
    import mx.utils.ObjectProxy;
    import flash.events.Event;
    import flash.utils.ByteArray;
    import mx.rpc.soap.types.*;
    /**
     * Typed event handler for the result of the operation
     */
    
    public class GetTypesResultEvent extends Event
    {
        /**
         * The event type value
         */
        public static var GetTypes_RESULT:String="GetTypes_result";
        /**
         * Constructor for the new event type
         */
        public function GetTypesResultEvent()
        {
            super(GetTypes_RESULT,false,false);
        }
        
        private var _headers:Object;
        private var _result:TypeArray;
         public function get result():TypeArray
        {
            return _result;
        }
        
        public function set result(value:TypeArray):void
        {
            _result = value;
        }

        public function get headers():Object
	    {
            return _headers;
	    }
			
	    public function set headers(value:Object):void
	    {
            _headers = value;
	    }
    }
}