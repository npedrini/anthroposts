/**
 * LocationArray.as
 * This file was auto-generated from WSDL by the Apache Axis2 generator modified by Adobe
 * Any change made to this file will be overwritten when the code is re-generated.
 */
package net.looklisten.notes.soap{
    import mx.utils.ObjectProxy;
    import mx.collections.ArrayCollection;
    import mx.collections.IList;
    import mx.collections.ICollectionView;
    import mx.rpc.soap.types.*;
    /**
     * Typed array collection
     */

    public class LocationArray extends ArrayCollection
    {
        /**
         * Constructor - initializes the array collection based on a source array
         */
        
        public function LocationArray(source:Array = null)
        {
            super(source);
        }
        
        
        public function addLocationAt(item:Location,index:int):void {
            addItemAt(item,index);
        }
            
        public function addLocation(item:Location):void {
            addItem(item);
        } 

        public function getLocationAt(index:int):Location {
            return getItemAt(index) as Location;
        }
                
        public function getLocationIndex(item:Location):int {
            return getItemIndex(item);
        }
                            
        public function setLocationAt(item:Location,index:int):void {
            setItemAt(item,index);
        }

        public function asIList():IList {
            return this as IList;
        }
        
        public function asICollectionView():ICollectionView {
            return this as ICollectionView;
        }
    }
}
