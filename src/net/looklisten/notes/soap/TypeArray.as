/**
 * TypeArray.as
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

    public class TypeArray extends ArrayCollection
    {
        /**
         * Constructor - initializes the array collection based on a source array
         */
        
        public function TypeArray(source:Array = null)
        {
            super(source);
        }
        
        
        public function addTypeAt(item:Type,index:int):void {
            addItemAt(item,index);
        }
            
        public function addType(item:Type):void {
            addItem(item);
        } 

        public function getTypeAt(index:int):Type {
            return getItemAt(index) as Type;
        }
                
        public function getTypeIndex(item:Type):int {
            return getItemIndex(item);
        }
                            
        public function setTypeAt(item:Type,index:int):void {
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
