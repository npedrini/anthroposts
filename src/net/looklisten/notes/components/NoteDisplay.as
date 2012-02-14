package net.looklisten.notes.components
{
	//import caurina.transitions.Tweener;
	
	import com.greensock.TweenLite;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.geom.Point;
	import flash.net.URLRequest;
	
	import mx.controls.Image;
	import mx.core.UIComponent;
	import mx.effects.Fade;
	import mx.events.TweenEvent;
	
	import net.looklisten.notes.events.NoteEvent;
	import net.looklisten.notes.model.NotesModel;
	import net.looklisten.notes.soap.Location;
	import net.looklisten.notes.soap.Note;
	import net.looklisten.utils.BitmapUtils;
	import net.looklisten.utils.StringUtils;
	
	[Event(name="showNote",type="NoteEvent")]
	
	public class NoteDisplay extends UIComponent
	{
		//	constants
		private const BORDER_COLOR:uint = 0xFFFFFF;
		
		//	model
		private var _model:Note;
		
		//	children
		private var _border:UIComponent;
		private var _bitmap:Image;
		private var _star:FavoriteStar;
		private var _loader:Loader;
		
		//	for persisting "resting" state
		private var _default_x:Number;
		public var default_y:Number;
		public var default_rotation:Number;
		public var default_width:Number;
		public var default_height:Number;
		public var default_depth:Number;
		
		//	misc public properties
		public var maps_url:String;
		public var content_flat:String;
		public var siblings:Array;
		public var parentSibling:NoteDisplay;
		
		//	private properties
		private var _showEffect:Fade;
		private var _hideEffect:Fade;
		private var _imgCache:Array;
		private var _currentKey:String;		
		
		//	state
		[Bindable] 
		public var loading:Boolean;
		public var layedOut:Boolean;
		private var _maximized:Boolean;
		private var _isRolledOver:Boolean;
		private var _colorHasBeenSet:Boolean;
		
		public var tweening:Boolean;
		
		public function NoteDisplay( __model:Note )
		{
			super();
			
			//	store ref to model
			note = __model;
			
			//	init some props
			_imgCache = new Array();
			maximized = false;
			_colorHasBeenSet = false;
			
			//	could this be source of some problems...?
			//_move.addEventListener(TweenEvent.TWEEN_END,onTweenEnd);
			
			//	init loader
			_loader = new Loader();
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, imgLoaded);
			_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, imgIoError);
			
			//	init show effect
			var _showEffect:Fade = new Fade(this);
			_showEffect.alphaFrom=0;
			_showEffect.alphaTo=1;
			_showEffect.duration=1000;
			setStyle('showEffect',_showEffect);
			
			//	init hide effect
			var _hideEffect:Fade = new Fade(this);
			_hideEffect.alphaFrom=1;
			_hideEffect.alphaTo=0;
			_hideEffect.duration=1000;
			setStyle('hideEffect',_hideEffect);
			
			//	add some shadow
			filters = [new DropShadowFilter(2)];
			
			mouseChildren=false;
			
			//	init listeners
			addEventListener(MouseEvent.ROLL_OVER,onRollOver);
			addEventListener(MouseEvent.ROLL_OUT,onRollOut);
			addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
		}
		
		override protected function createChildren():void
		{
			super.createChildren();
			
			if(_border == null)
			{
				_border = new UIComponent();
				_border.visible=false;
				_border.mouseEnabled=false;
				addChild(_border);
			}
			
			if(_bitmap == null) 
			{
		    	_bitmap = new Image();
		    	_bitmap.autoLoad=true;
		    	_bitmap.visible=false;
		    	_bitmap.mouseEnabled=false;
		    	addChild(_bitmap);
			}
			
			if(_star == null && note.is_favorite)
			{
				_star = new FavoriteStar();
				_star.alpha = .6;
				_star.visible = false;
				_star.includeInLayout = false;
				_star.mouseEnabled=false;
				addChild(_star);
				_star.blendMode = BlendMode.ALPHA;
			}
		}
		
		override protected function commitProperties():void
		{
			super.commitProperties();
			
			//var tweens:Array = Tweener.getTweens(this);
			_border.visible = _isRolledOver && !maximized && !tweening; // && tweens.indexOf("x")==-1;
			_bitmap.visible = _bitmap.width && _bitmap.height;
			
			if(_star!=null)
				_star.visible = note.is_favorite && _bitmap.visible && !maximized && !tweening; // && tweens.indexOf("x")==-1;
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			//	position star
			if(_star!=null)
			{
				_star.width = _star.height = Math.min(	unscaledWidth - unscaledWidth/2,
														unscaledHeight - unscaledHeight/2);
				_star.move(-_star.width/2,-_star.height/2);				
			}
			//	center _bitmap
			if(_bitmap.width && _bitmap.height)
				_bitmap.move(-_bitmap.width/2,-_bitmap.height/2);
				
			//	center border
			_border.x = -_border.width/2;
			_border.y = -_border.height/2;
		}
		
		private function onMouseDown(event:MouseEvent):void
		{
			if(!maximized)
				dispatchEvent(new NoteEvent(NoteEvent.SHOW));
			else
				dispatchEvent(new NoteEvent(NoteEvent.HIDE));
		}
		
		private function onRollOver(event:MouseEvent):void
		{
			_isRolledOver=true;
			invalidateProperties();
		}
		
		private function onRollOut(event:MouseEvent):void
		{
			_isRolledOver=false;
			invalidateProperties();
		}
		
		private function updateBorderVisiblity():void
		{
			if(_border==null) return;
			_border.visible = _isRolledOver && !maximized;
		}
		
		/**
		 * Handler for loading an image
		 * Images are re-loaded at different sizes
		*/
		private function imgLoaded(e:Event):void
		{
		    var _loader:Loader = e.target.loader;
		    
		    var w:Number = _loader.contentLoaderInfo.width;
		    var h:Number = _loader.contentLoaderInfo.height;
		    
		    //	Identify unique id for this image...(1) to see if it is still relevant
		    //	and (2), to use as a cache key if it is
		    //
		    //	1.  first, parse `constrain` and `height` query params from loader.url
		    //		...these become the cache key
		    var requestUrl:Array = (e.target as LoaderInfo).url.split("?");
		    var requestUrlParams:Array = String(requestUrl[1]).split("&");
		    var varPair:Array;
		    var requestedConstrain:String;
		    var requestedHeight:String;
		    for each(var param:String in requestUrlParams)
		  	{
		  		varPair = param.split("=");
		  		if(varPair[0]=="constrain")
		  			requestedConstrain = varPair[1];
		  		if(varPair[0]=="h")
		  			requestedHeight = varPair[1];
		  	}
		  	
		  	var cacheKey:String = getKey(Number(requestedHeight),requestedConstrain);
		    //	2. see if image is still current. if not, return
		    if(_currentKey != cacheKey) return;
		  	
		    //	TODO: does this need to be set everytime?
		    if(!maximized){
		    	default_width  = w;
		    	default_height = h;
		    }
		    
		    //	cache the image
		    //	see if it has already been cached, and if so, update it
		    //	(an entry should have been created when the request 
		    //	 was sent, so update should never fail after this loop)
		   	var updated:Boolean = false;
		    for(var i:int=0;i<_imgCache.length;i++){
				if(_imgCache[i].height == requestedHeight && _imgCache[i].constrain==requestedConstrain){
					_imgCache[i] = {height:h,constrain:requestedConstrain,bitmapData:_loader.content};
					updated=true;
				}
			}
			//	as a fallback, add it if it hasn't been updated yet...
			if(!updated)
				_imgCache.push({height:h,constrain:requestedConstrain,bitmapData:_loader.content});
		    
		    //	draw loaded image
		    showImg(_loader.content);
		    
		    loading = false;
		}
		
		private function imgIoError(e:IOErrorEvent):void
		{
			dispatchEvent(new NoteEvent(NoteEvent.LOAD_ERROR));
		}
		
		/**
		 * Draws a DisplayObject (an image) onto the Bitmap surface
		 * @param img DisplayObject to be drawn
		*/
		private function showImg( img:DisplayObject ):void
		{
			var bd:BitmapData = new BitmapData(img.width,img.height);
			bd.draw(img);
			
			if(!_colorHasBeenSet)
			{
				var hex:uint = BitmapUtils.averageColour( bd );
				note.color_hex = hex;
				
				_colorHasBeenSet = true;
			}
			
		    _bitmap.load( new Bitmap(bd) );
		   	_bitmap.width = width = img.width;
		    _bitmap.height = height = img.height;
		    
		    //	update border size
		    if(!maximized)
		    {
			    var borderSize:int = 6;
				var bw:Number = width+borderSize*2;
				var bh:Number = height+borderSize*2;
				
				_border.graphics.clear();
				_border.graphics.beginFill(BORDER_COLOR,1);
				_border.graphics.drawRect(0,0,bw,bh);
				_border.width = bw;
				_border.height = bh;
		    }
		    
		    if(!_bitmap.visible) _bitmap.visible = true;
			
		    //	since sizes may have changed, re-draw/position some stuff
		    invalidateProperties();
		    invalidateDisplayList();
			
			//	dispatch load_complete event for interested parties
		    dispatchEvent(new NoteEvent(NoteEvent.LOAD_COMPLETE));
		}
		
		public function moveTo(	xTo:Number,yTo:Number,target:Object,tweenLengthMs:Number = 500,
								easingFunction:String = "easeInSine", tweenEndCallback:Function=null):void
		{
			TweenLite.to( target, tweenLengthMs*.001, {x:xTo,y:yTo,ease:easingFunction,onComplete:tweenEndCallback,onCompleteParams:[this] } );
			
			_border.visible=false;
		}
		
		public function rotateTo(	rTo:Number,target:Object,tweenLengthMs:Number = 500,
									easingFunction:String = "easeInSine", tweenEndCallback:Function=null, tweenEndCallbackParams:Array = null):void
		{
			TweenLite.to( target, tweenLengthMs*.001, {rotation:rTo,ease:easingFunction,onComplete:tweenEndCallback,onCompleteParams:tweenEndCallbackParams} );
		}
		
		public function resizeTo(	wTo:Number,hTo:Number,target:Object,tweenLengthMs:Number = 500,
									easingFunction:String = "easeInSine", tweenEndCallback:Function=null):void
		{
			TweenLite.to(target, tweenLengthMs*.001, {width:wTo,height:hTo,ease:easingFunction,onComplete:tweenEndCallback});
		}
		
		public function tweenTo(	target:Object,properties:Object,tweenLengthMs:Number = 500,
									easingFunction:String = "easeInSine", tweenEndCallback:Function=null, delay:int = 0 ):void
		{
			var params:Object = {ease:easingFunction,onComplete:tweenEndCallback,onCompleteParams:[this],delay:delay };
			
			for(var p:String in properties) params[p] = properties[p];
			
			TweenLite.to( target, tweenLengthMs*.001, params );
			
			_border.visible=false;
		}
		
		private function onTweenEnd(nd:NoteDisplay=null):void
		{
			this.tweening = false;
			
			dispatchEvent(new NoteEvent(NoteEvent.TWEEN_COMPLETE));
		}
		
		/**
		 * Maximize a note. In context of app this always means
		 * centering and blowing it up, but function allows for flexibility
		 * @param width Desired width
		 * @param height Desired height
		 * @param x Desired x position
		 * @param y Desired y position
		*/
		public function show(w:Number,h:Number,x:Number,y:Number):void
		{
			var time:Number = 750;
			var tween:String = "easeOutExpo";
			var r:int = 0;
			
			if(note.rotation_offset!=0) r+= note.rotation_offset;
			
			this.tweening = true;
			
			tweenTo( this, {x:x, y:y, rotation: r}, time, tween, onTweenEnd);
			tweenTo( _bitmap, {width:w, height:h}, time );
			
			//center(x,y,true,tween);
			//moveTo(x,y,this);
			//rotateTo(r,this,time);
			//resizeTo(w,h,_bitmap,time,null,onTweenEnd);
		}
		
		/**
		 * Minimize a note
		*/
		public function hide():void
		{
			var time:Number = 750;
			var tween:String = "easeOutExpo";
			
			if(_loader!=null) try{_loader.close()}catch(e:Error){};
			
			tweening = true;
			
			tweenTo( this, {x:default_x, y:default_y, rotation: default_rotation}, time, tween, onTweenEnd );
			tweenTo( _bitmap, {x:-default_width/2,y:-default_height/2, width:default_width, height:default_height}, time, tween );
			
			//moveTo(default_x,default_y,this,time,tween);
			//moveTo(-default_width/2,-default_height/2,_bitmap);
			//rotateTo(default_rotation,this,time);
			//resizeTo(default_width,default_height,_bitmap,time,null,onTweenEnd);
		}
		
		/**
		 * Abstracts the centering of a note, to allow
		 * for tweening or not
		 * @param x Desired x position
		 * @param y Desired y position
		 * @param tween Whether to tween or not
		 * @param easingFunction Easing function to apply
		 * @param tweenEndCallback Function to call when tween completes
		*/
		public function center(	x:Number,y:Number,tween:Boolean = true,
								easingFunction:String = "easeInSine", tweenEndCallback:Function=null, speed:int = 500):void
		{
			var coords:Point = new Point(x,y);
			coords = parent.parent.globalToLocal(coords);
			
			if(tween){
				moveTo(coords.x,coords.y,this,speed,easingFunction,tweenEndCallback);
			}else{
				this.x = coords.x;
				this.y = coords.y;
			}
		}
		
		/**
		 * Changes the size of a note's underlying image. This is done by
		 * passing a desired height and a whether or not width should be 
		 * constrained to height value if image is wider than it is tall.
		 * 
		 * If image has already been loaded at requested size, a cached
		 * version is used for optimization instead of re-requesting it
		 * 
		 * @param value Desired height
		 * @param constrain Whether to constrain to height or not
		*/
		public function setHeight(value:Number,constrain:Boolean=false):void
		{
			var perIncrease:Number = value/note.image_height;
			if(note.image_width*perIncrease>systemManager.screen.width)
			{
				value = note.image_height * (note.image_width/systemManager.screen.width);
			}
			
			var cacheDim:Number = default_width>default_height?Math.round(value*(default_height/default_width)):value
			var cached:Object = getCached(cacheDim,constrain?"1":"0");
			
			value = Math.round(value);
			
			if(cached==null)
			{
				//	try cancelling a pending (and now expired) request, if any
				if(_loader!=null) try{_loader.close()}catch(e:Error){};
				
				//	build url
				var url:String = Constants.SITE_ROOT+"/image.php?id="+_model.id;
				url += "&constrain=" + (constrain?"1":"0");
				url += "&h="+value;
				
				//url = Constants.SITE_ROOT+"/images/notes/"+_model.id+"_tiny.jpg";
				trace(url);
				
				//	make request
				var _request:URLRequest = new URLRequest(url);			
				_loader.load(_request);
				
				//	set loading flag
				loading = true;
				trace("loading "+url);
			}
			else{
				showImg(cached.bitmapData);
				trace("using cached image for "+note.id);
			}
			//	record current key, so when image is loaded we can
			//	use it for comparison to see if 
			_currentKey = getKey(value,constrain?"1":"0");
		}
		
		private function getCached(value:Number,constrain:String):Object
		{
			if(_imgCache==null) return null;
			
			for(var i:int=0;i<_imgCache.length;i++){
				if(_imgCache[i].height == value && _imgCache[i].constrain==constrain){
					return _imgCache[i];
				}
			}
			return null;
		}
		
		private function getKey(value:Number,constrain:String):String
		{
			return value+"_"+constrain;
		}
		
		public function getWhereText():String
		{
			var loc_found:Array = new Array();
			var street:String="";
			if(note.found_street!=null && note.found_street!=""){
				if(note.found_street_no!=null && note.found_street_no!="0")
					street += note.found_street_no + " ";
				if(note.found_street_2!=null && note.found_street_2!="")
					street += note.found_street + " " + resourceManager.getString("resources","note.info.and") + " " + note.found_street_2;
				else
					street += note.found_street;
				loc_found.push(street);
			}else if(note.found_street_2!=null && note.found_street_2!=""){
				street += note.found_street_2;
				loc_found.push(street);
			}
			
			if(note.location_id)
			{
				var location:Location = NotesModel.getInstance().locationsIndexed[note.location_id] as Location;
				
				if(location.city!=null) loc_found.push(location.city);
				if(location.state!=null) loc_found.push(location.state);
				if(location.country!=null) loc_found.push(location.country);	
			}
			
			if( (loc_found!=null && loc_found.length) )
			{
				if( (loc_found!=null && loc_found.length) )
					return loc_found.join(", ");
			}
			
			return null;
		}
		
		public function getWhenText():String
		{
			if(	note.found_date!=null && note.found_date!="0000-00-00 00:00:00" && note.found_date!="0-0-0 00:00:00")
			{
				var when_parts:Array = note.found_date.split(" ");
				var date:Array = when_parts[0].split("-");
				var time:Array = when_parts[1].split(":");
				
				/*
				var date_found:Date = new Date(1970, 0, 1, 0, 0, 0);
				date_found.setSeconds(new Date(int(note.found_date)).getTime());
				*/
				var date_found:Date = new Date(date[0], date[1], date[2], time[0], time[1], time[2]);
				
				if(date_found!=null)
				{
					var hour:int = date_found.getHours();
					var meridian:String = "am";
					if(hour>12)
					{
						hour-=12;
						meridian = "pm";
					}
					
					var monthLabels:Array = resourceManager.getStringArray("resources","months");
	               	var ret:String = StringUtils.replace(resourceManager.getString("resources","foundDateTimeFormat"),
	               										date_found.getUTCDate(),
	               										monthLabels[date_found.getUTCMonth()],
	               										date_found.getUTCFullYear(),
	               										hour,date_found.getMinutes(),meridian);
	               	return ret;
				}
			}
			
			return null;
		}
		
		/*	computes a note's complexity	*/
		private function getComplexity():Number
		{
			/*
			var nums:String = "12345678910";
			var c:Number = 0;
			
			for(var i:int=0;i<note.content.length;i++){
				var char:String = note.content.charAt(i);
				if(char==" ") continue;
				if(nums.indexOf(char)) c+=COMPLEXITY_NUMBER_MULTIPLIER;
				else c+=COMPLEXITY_LETTER_MULTIPLIER;
			}
			
			c += note.content.split(" ").length*COMPLEXITY_WORD_MULTIPLIER;
			*/
			
			var str:String = note.content.replace(" ","");
			str = str.replace("\r\n","");
			return str.length;
		}
		
		public function set maximized(value:Boolean):void
		{
			_maximized = value;
			invalidateProperties();
		}
		public function get maximized():Boolean
		{
			return _maximized;
		}
		
		public function addSibling(value:NoteDisplay):void
		{
			if(siblings==null) siblings = new Array();
			siblings.push(value);
		}
		
		public function siblingExists(value:NoteDisplay):Boolean
		{
			if(siblings==null) return false;
			for each(var s:NoteDisplay in siblings)
				if(s.note.id == value.note.id) return true;
			return false;
		}
		
		public function get bitmap():Image{ return _bitmap; }
		
		[Bindable]
		public function set note(__model:Note):void{
			_model = __model;
			//	set url
			maps_url = getMapsURL();
			//	set content flat
			content_flat = note.content!=""?note.content.split("\r\n").join(" / "):"[content not specified]";
			//	set complexity
			if(note.complexity==0) note.complexity = getComplexity();
		}
		public function get note():Note{ return _model; }
		
		/*	used to set `url` internally	*/ 
		private function getMapsURL():String{
			var parts:Array = new Array();
			
			if(note.found_street_no!=null) parts.push(note.found_street_no);
			if(note.found_street!=null) parts.push(note.found_street + ',');
			
			if(note.location_id)
			{
				var location:Location = NotesModel.getInstance().locationsIndexed[note.location_id] as Location;
				if(location.city!=null) parts.push(location.city);
				if(location.state!=null) parts.push(location.state);
			}	
			
			return Constants.MAPS_URL + "?q=" + parts.join(" ");
		}
		
		public function getCenter():Point
		{
			var radVal:Number = Math.PI * default_rotation / 180;
			var originX:Number = width / 2;
			var originY:Number = height / 2;
			
			var x:Number = default_x +
					  		originX * Math.cos(radVal) -
					  		originY * Math.sin(radVal);
			var y:Number = default_y +
					  		originX * Math.sin(radVal) +
					  		originY * Math.cos(radVal);
			
			return new Point(x,y);
		}
		
		public function get default_x():Number
		{
			return _default_x;
		}
		
		public function set default_x(value:Number):void
		{
			_default_x = value;
		}
	}
}