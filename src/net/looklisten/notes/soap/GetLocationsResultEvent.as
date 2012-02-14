/**
 * GetLocationsResultEvent.as
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
    
    public class GetLocationsResultEvent extends Event
    {
        /**
         * The event type value
         */
        public static var GetLocations_RESULT:String="GetLocations_result";
        /**
         * Constructor for the new event type
         */
        public function GetLocationsResultEvent()
        {
            super(GetLocations_RESULT,false,false);
        }
        
        private var _headers:Object;
        private var _result:LocationArray;
         public function get result():LocationArray
        {
            return _result;
        }
        
        public function set result(value:LocationArray):void
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