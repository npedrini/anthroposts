package net.looklisten.notes.components.connection
{
	import flash.geom.Point;
	
	import mx.binding.utils.BindingUtils;
	import mx.controls.TextArea;
	import mx.core.UIComponent;
	
	import net.looklisten.notes.components.NoteDisplay;

	public class ConnectionDisplay extends UIComponent
	{
		private const COLOR:uint = 0x000000;
		
		private var _word:String;
		private var _startNote:NoteDisplay;
		private var _endNote:NoteDisplay;
		private var _size:int;
		public var notes:Array;
		
		private var _label:TextArea;
		
		public function ConnectionDisplay()
		{
			super();
		}
		
		override protected function createChildren():void{
			super.createChildren();
			
			_label = new TextArea();
			_label.styleName="connectionLabel";
			_label.setStyle("embedFonts",true);
			_label.selectable=false;
			_label.wordWrap=false;
			_label.visible=false;
			
			addChild(_label);
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			if(!startNote.visible || !endNote.visible)
			{
				visible = false;
				return;
			}
			
			visible = true;
			
			var start:Point = new Point(startNote.x,startNote.y);
			var end:Point = new Point(endNote.x,endNote.y);
			
			graphics.clear();
			graphics.lineStyle(size,COLOR,1);
			graphics.moveTo(start.x,start.y);
			graphics.curveTo(Math.max(start.x,end.x),Math.min(start.y,end.y),end.x,end.y);
			
			graphics.beginFill(COLOR,alpha);
			graphics.drawCircle(start.x,start.y,2);
			graphics.drawCircle(end.x,end.y,2);
			graphics.endFill();
			
			var a:Number = end.x - start.x;
			var b:Number = end.y - start.y;
			var c:Number = Math.sqrt(a*a+b*b);
			
			var radius:Number = c/2;
			var radians:Number = Math.atan2(end.y - start.y,end.x - start.x);
			
			var x:Number = start.x + radius * Math.cos(radians);
			var y:Number = start.y + radius * Math.sin(radians);
			
			_label.width  = _label.textWidth+6;
			_label.height = _label.textHeight+6;
			_label.x = x;
			_label.y = y;
			_label.rotation = radians * 180/Math.PI;
		}
		
		private function redraw(value:Number):void{
			invalidateDisplayList();
		}
		
		public function set word(value:String):void{
			_word = value;
			_label.text = word;
		}
		public function get word():String{
			return _word;
		}
		public function set startNote(value:NoteDisplay):void{
			_startNote = value;
			if(_startNote!=null){
				BindingUtils.bindSetter(redraw,startNote,"x");
				BindingUtils.bindSetter(redraw,startNote,"y");
				BindingUtils.bindSetter(redraw,startNote,"width");
				BindingUtils.bindSetter(redraw,startNote,"height");
				BindingUtils.bindSetter(redraw,startNote,"visible");
			}
		}
		public function get startNote():NoteDisplay{
			return _startNote;
		}
		
		public function set endNote(value:NoteDisplay):void{
			_endNote = value;
			if(_startNote!=null){
				BindingUtils.bindSetter(redraw,endNote,"x");
				BindingUtils.bindSetter(redraw,endNote,"y");
				BindingUtils.bindSetter(redraw,endNote,"width");
				BindingUtils.bindSetter(redraw,endNote,"height");
				BindingUtils.bindSetter(redraw,endNote,"visible");
			}
		}
		public function get endNote():NoteDisplay{
			return _endNote;
		}
		
		public function set size(value:int):void{
			_size = value;
			invalidateDisplayList();
		}
		public function get size():int{
			return _size;
		}
	}
}