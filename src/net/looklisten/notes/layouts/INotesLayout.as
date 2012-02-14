package net.looklisten.notes.layouts
{
	import mx.collections.ArrayCollection;
	import mx.core.UIComponent;
	
	public interface INotesLayout
	{
		function get sortable():Boolean;
		function get name():String;
		function get noteSize():Number;
		function doLayout(	dataProvider:ArrayCollection,
									target:UIComponent,
									width:Number,height:Number,
									outerMargin:Number = 0, 
									innerMargin:Number = 0, 
									hasChanged:Boolean = true ):void;
	}
}