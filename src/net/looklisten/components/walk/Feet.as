package net.looklisten.components.walk
{
	import caurina.transitions.Tweener;
	
	import flash.display.Loader;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.media.SoundTransform;
	import flash.utils.Timer;
	
	import mx.core.UIComponent;
	
	/**
	 * Component that executes a "walking" effect.
	 * Once walk has completed, the component removes itself
	 * once fading out.
	*/
	public class Feet extends UIComponent
	{
		
		private var _center:Point;
		//	left(-1) or right(1) foot
		private var _foot:int = 1;
		private var _target:UIComponent;
		
		private var _fromDegrees:Number;
		private var _secs:Number;
		private var _walkTimer:Timer;
		private var _steps:int;
		private var _diameter:Number;
		private var _printTypeIndex:int;
		
		private const SHOE_SIZE:int = 200;
		
		private var _sneaker:Loader;
		
		public function Feet()
		{
			super();
			
			_sneaker = new Loader(  );
      		
		}
		
		public function walk(__fromDegrees:Number = -90,__secs:Number = 1):void
		{
			//	TO MAKE THINGS EASIER, WE WALK FROM ONE SIDE OF AN A CIRCLE
			//	TO THE OTHER, WHERE THE CIRCLE CIRCUMBSCRIBES THE STAGE
			
			//	angle along circle where walk starts
			_fromDegrees = __fromDegrees;
			//	# of seconds walk should take
			_secs = __secs;
			//	set diameter so it circumscribes stage
			_diameter = Math.max(parent.width,parent.height);
			//	determien # of steps
			_steps = Math.ceil((_diameter)/SHOE_SIZE);
			
			//	computer center point of walk
			var maxXOffset:Number = 100;
			var maxYOffset:Number = 100;
			_center = new Point(parent.width/2  - maxXOffset + (Math.random()*maxXOffset*2),
								parent.height/2 - maxYOffset + (Math.random()*maxYOffset*2));
			
			//	select a type of shoe style randomly from those available
			_printTypeIndex = Math.round(Math.random()*SneakerPrint.PRINTS.length);
			
			//	init timer which manages execution of walk
			_walkTimer = new Timer(_secs*1000/_steps,_steps);
			_walkTimer.addEventListener(TimerEvent.TIMER,onWalk);
			_walkTimer.addEventListener(TimerEvent.TIMER_COMPLETE,onWalkComplete);
			_walkTimer.start();
		}
		
		/**
		 * Executes a step
		*/
		private function onWalk(e:TimerEvent):void
		{
			var n:Number = _walkTimer.currentCount;		//  step we're on
			var r:Number = _diameter/2;					//	radius
			r = r - (n*SHOE_SIZE);
			
			var radians:Number = _fromDegrees * (Math.PI/180);	
			var pt:Point = new Point(	_center.x + r * Math.cos(radians),
										_center.y + r * Math.sin(radians));
			step(pt);
			
			//	TODO: undertand, confirm this
			var p:Number = pt.x-parent.width/2;
			p = p/(parent.width/2);
			
			var v:Number = Math.max(Math.sqrt(parent.width/2*pt.x + parent.height/2*pt.y)/400,.2);
			
			/*
			var st:SoundTransform = new SoundTransform(v,p);
			SoundManager.getInstance().play("assets/sounds/footstep2.mp3",st);
			*/
		}
		
		private function onWalkComplete(event:TimerEvent):void
		{
			_walkTimer = new Timer(20*1000,1);
			_walkTimer.addEventListener(TimerEvent.TIMER_COMPLETE,onWalkExpire);
			_walkTimer.start();
		}
		
		private function onWalkExpire(event:TimerEvent):void
		{
			Tweener.addTween(this,{alpha:0,time:10,onComplete:onFadeComplete});
		}
		
		private function onFadeComplete():void{
			parent.removeChild(this);
		}
		
		private function step(__stepCoords:Point):void
		{
			if(parent==null) return;
			
			//	left (-1) or right (1) foot
			_foot = _foot*-1;
			
			var d:Number = _fromDegrees + (_foot*-1)*90;
			var spread:Number = 50;
			
			var radians:Number = d * Math.PI/180;
			var offset:Point = new Point(	__stepCoords.x + spread * Math.cos(radians),
											__stepCoords.y + spread * Math.sin(radians));
			
			
			var _print:SneakerPrint = new SneakerPrint();
			_print.style = SneakerPrint.PRINTS[_printTypeIndex];
			_print.rotation = (_fromDegrees * Math.PI/180)*180/Math.PI + 270;
			_print.x = offset.x;
			_print.y = offset.y;
			_print.scaleX = _foot;
			addChild(_print);
		}
	}
}