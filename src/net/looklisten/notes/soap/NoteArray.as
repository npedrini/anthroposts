/**
 * NoteArray.as
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

    public class NoteArray extends ArrayCollection
    {
        /**
         * Constructor - initializes the array collection based on a source array
         */
        
        public function NoteArray(source:Array = null)
        {
            super(source);
        }
        
        
        public function addNoteAt(item:Note,index:int):void {
            addItemAt(item,index);
        }
            
        public function addNote(item:Note):void {
            addItem(item);
        } 

        public function getNoteAt(index:int):Note {
            return getItemAt(index) as Note;
        }
                
        public function getNoteIndex(item:Note):int {
            return getItemIndex(item);
        }
                            
        public function setNoteAt(item:Note,index:int):void {
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
