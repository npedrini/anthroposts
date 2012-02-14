/**
 * WorryArray.as
 * This file was auto-generated from WSDL by the Apache Axis2 generator modified by Adobe
 * Any change made to this file will be overwritten when the code is re-generated.
 */
package net.looklisten{
    import mx.utils.ObjectProxy;
    import mx.collections.ArrayCollection;
    import mx.collections.IList;
    import mx.collections.ICollectionView;
    import mx.rpc.soap.types.*;
    /**
     * Typed array collection
     */

    public class WorryArray extends ArrayCollection
    {
        /**
         * Constructor - initializes the array collection based on a source array
         */
        
        public function WorryArray(source:Array = null)
        {
            super(source);
        }
        
        
        public function addWorryAt(item:Worry,index:int):void {
            addItemAt(item,index);
        }
            
        public function addWorry(item:Worry):void {
            addItem(item);
        } 

        public function getWorryAt(index:int):Worry {
            return getItemAt(index) as Worry;
        }
                
        public function getWorryIndex(item:Worry):int {
            return getItemIndex(item);
        }
                            
        public function setWorryAt(item:Worry,index:int):void {
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
