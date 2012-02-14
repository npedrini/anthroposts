/**
 * CategoryArray.as
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

    public class CategoryArray extends ArrayCollection
    {
        /**
         * Constructor - initializes the array collection based on a source array
         */
        
        public function CategoryArray(source:Array = null)
        {
            super(source);
        }
        
        
        public function addCategoryAt(item:Category,index:int):void {
            addItemAt(item,index);
        }
            
        public function addCategory(item:Category):void {
            addItem(item);
        } 

        public function getCategoryAt(index:int):Category {
            return getItemAt(index) as Category;
        }
                
        public function getCategoryIndex(item:Category):int {
            return getItemIndex(item);
        }
                            
        public function setCategoryAt(item:Category,index:int):void {
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
