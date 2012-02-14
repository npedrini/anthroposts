package net.looklisten.sound
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.TimerEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundMixer;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	import flash.utils.Timer;
	
	/**
	 * Singleton sound manager supporting the ability
	 * to play a random sounds, as well as global mute,
	 * volume adjust, etc.
	*/
	public class SoundManager
	{
		//	internal reference to single class instance
		private static var __instance:SoundManager;
		
		private var _muted:Boolean;
		private var _volume:Number;
		private var _volumeAtMute:Number;
		
		private var timer:Timer;
		private var cache:Array;
		
		private var library:Array = new Array();
		
		public function SoundManager()
		{
			if(__instance!=null) {
				throw new Error("Singleton already instantiated");
			}
			
			//	init variables
			muted = false;
			volume = 1;
			cache = new Array();
		}
		
		/**
		 * Plays a sound (mp3) similar to Sound.play()
		 * 
		 * @param url Absolute or relative path to the mp3
		 * @param st SoundTransform object to set volume and pan
		 * @param startTime Delay
		 * @param loops Number of loops (0 is once, 9999 is forever)
		 * @param allowGhosts Whether to allow the same sound to play concurrently
		*/
		public function play(	url:String, st:SoundTransform=null,
								startTime:Number=0, loops:int=0, allowGhosts:Boolean = true):SoundChannel
		{
			//	if ghosts aren't allowed, see if requested sound is 
			//	currently playing and return null if so
			if(!allowGhosts && soundIsPlaying(url)) return null;
			
			//	init sound object and listeners
			var s:Sound = new Sound(new URLRequest(url));
			s.addEventListener(IOErrorEvent.IO_ERROR,onSoundStreamError);
			
			//	massage requested volume based on global volume
			//	i.e. if volume via `st` param is .5 and global 
			//	volume is .5 as well, massage it to .25
			if(st==null) st = new SoundTransform(1);
			var vol:Number = st.volume;
			st.volume*=volume;
			trace("plaing "+url+" at "+st.volume);
			
			//	cache sound in an object containing returned SoundChannel, 
			//	url and volume property (storing volume allows us to 
			//	loop through cache and update volume when altering global
			//	volume, while maintaining sound's local volume
			var channel:SoundChannel = s.play(startTime,loops,st);
			if(loops!=99999) channel.addEventListener(Event.SOUND_COMPLETE,onSoundComplete);
			cache.push( {channel:channel,url:url,volume:vol,pan:st.pan,loops:loops} );
			
			return channel;
		}
		
		/**
		 * Plays a sound randomly
		 * 
		 * @param url Absolute or relative path to the mp3
		 * @param interval Length of the interval in which the sound should be played
		 * @param intervalLikelihood Percentage, from 0 to 1, that the sound will
		 * 								be played at each interval
		 * @param maxPlays TMaximum number of times the sound should be played
		 * @param st SoundTransform object to set volume and pan
		 * @param minVolume Minimum volume
		 * @param maxVolume Maximum volume
		 * @param panRandomly Whether to pan sound randomly
		*/
		public function playRandom(	url:String, interval:Number, intervalLikelihood:Number,
									maxPlays:int=0, st:SoundTransform=null,
									minVolume:Number=0, maxVolume:Number=0, panRandomly:Boolean = true):void
		{
			//	add sound to library from which it will be randomly pulled
			library.push( {	url:url,transform:st,
							interval:interval,intervalLikelihood:intervalLikelihood,
							minVolume:minVolume,maxVolume:maxVolume,panRandomly:panRandomly,
							lastAttempt:flash.utils.getTimer(),lastPlay:flash.utils.getTimer(),
							maxPlays:maxPlays,loops:1,playCount:0,
							isRandom:true} );
			//	start timer
			initTimer();
		}
		
		/**
		 * Plays an array of sounds randomly
		 * 
		 * @param urls Array of absolute or relative paths to the mp3s
		 * @param interval Length of the interval in which one of the sounds should be played
		 * @param intervalLikelihood Percentage, from 0 to 1, that one of the sounds will
		 * 								be played at each interval
		 * @param minVolume The minimum volume at which a sound will be played
		 * @param maxVolume The maximum volume at which a sound will be played
		 * @param panRandomly Whether to pan sounds in the list randomly
		 * @param playThroughBeforeRepeating Whether to avoid repeating sounds before all have been played
		*/
		public function playRandomList( urls:Array, interval:Number, intervalLikelihood:Number, 
										minVolume:Number, maxVolume:Number, panRandomly:Boolean = true,
										playThroughBeforeRepeating:Boolean = false):void
		{
			//	add sound to library from which it will be randomly pulled
			library.push( {	urls:urls,
							interval:interval,intervalLikelihood:intervalLikelihood,
							minVolume:minVolume,maxVolume:maxVolume,panRandomly:panRandomly,
							lastAttempt:flash.utils.getTimer(),lastPlay:flash.utils.getTimer(),
							playCount:0,maxPlays:0,loops:1,isRandom:true} );
			//	start timer
			initTimer();
		}
		
		private function onTimerTick(event:TimerEvent):void
		{
			if(library==null || !library.length) return;
			if(_muted) return;
			
			for(var i:int=0,rs:Object;i<library.length;i++)
			{
				rs = library[i];
				if(rs.isRandom)
				{
					var elapsed:int = flash.utils.getTimer()-rs.lastPlay;
					var timeout:int = rs.interval*60*1000;
					if(elapsed>=timeout && (rs.maxPlays==0 || rs.playCount<rs.maxPlays))
					{
						var lot:int = Math.random()*100;
						if(lot>rs.intervalLikelihood)
						{
							rs.lastPlay = flash.utils.getTimer();
							rs.playCount += 1;
							
							var url:String = rs.urls?getRandomSound(rs):rs.url;
							var st:SoundTransform = rs.minVolume>0 && rs.maxVolume>0?
										new SoundTransform(rs.minVolume+Math.random()*rs.maxVolume):rs.transform;
							if(rs.panRandomly) st.pan = -1+Math.random()*2;
							
							play(url,st,0,1,false);
						}
					}
					rs.lastAttempt = flash.utils.getTimer();
				}
			}
		}
		
		private function getRandomSound(rs:Object):String
		{
			if(!rs.urls) return null;
			if(!rs.history) rs.history = new Array();
			
			//	determine history length
			var historyLength:int = 0;
			for(var i:int=0;i<rs.history.length;i++)
				if(rs.history[i]!=null) historyLength++;
			
			//	if we've played every sound, clear history
			if(historyLength == rs.urls.length) rs.history = new Array();
			//	get random index
			var index:int = Math.round(Math.random()*(rs.urls.length-1));
			
			if(rs.history[index] == null)
			{
				rs.history[index] = rs.urls[index];
				return rs.urls[index];
			}
			else
			{
				return getRandomSound(rs);
			}
		}
		
		private function soundIsPlaying(url:String):Boolean
		{
			var fileName:String = getFilenameFromUrl(url);
			for(var i:int=0;i<cache.length;i++)
				if(getFilenameFromUrl(cache[i].url) == fileName) return true;
			return false;
		}
		
		private function initTimer():void
		{
			if(timer==null)
			{
				timer = new Timer(100);
				timer.addEventListener(TimerEvent.TIMER,onTimerTick);
				timer.start();
			}
		}
		
		private function removeFromCache(url:String):Array
		{
			var fileName:String = getFilenameFromUrl(url);
			for(var i:int=0;i<cache.length;i++)
				if(getFilenameFromUrl(cache[i].url) == fileName)
					return cache.splice(i,1);
			
			return null;
		}
		
		private function onSoundComplete(event:Event):void
		{
			var channel:SoundChannel = event.currentTarget as SoundChannel;
			//	this is a volatile way to remove a completed sound
			//	from the cache, as multiple sounds currently playing
			//	could have the same SoundTransform, but it's all we have
			var url:String = getSoundUrlFromSoundChannel(channel);
			if(url!=null) removeFromCache(url);
		}
		
		private function onSoundStreamError(event:IOErrorEvent):void
		{
			//	TODO: handle error
			trace(event.target);
		}
		
		private function getSoundUrlFromSoundChannel(channel:SoundChannel):String
		{
			for each(var sc:Object in cache)
				if(SoundChannel(sc.channel).position == channel.position)
					return sc.url;
			return null;
		}
		
		private function getFilenameFromUrl(url:String):String
		{
			var urlParts:Array = url.split("/");
			return urlParts[urlParts.length-1];
		}
		
		//	TODO: fix
		[Bindable]
		public function set muted(value:Boolean):void
		{
			var sc:Object;
			volume = value?0:1;
			_muted = value;
		}
		
		private function updateCurrentlyPlayingSounds():void
		{
			for each(var sc:Object in cache)
			{
				var channel:SoundChannel = sc.channel as SoundChannel;					
				if(soundIsPlaying(sc.url))
					channel.soundTransform = new SoundTransform(sc.volume*volume,sc.pan);
			}
		}
		
		public function get muted():Boolean
		{
			return _muted;
		}
		
		[Bindable]
		public function set volume(value:Number):void
		{
			_volume = value;
			updateCurrentlyPlayingSounds();
		}
		public function get volume():Number{
			return _volume;
		}
		
		public function stop(channel:SoundChannel):void
		{
			channel.stop();
		}
		
		public function stopGlobal():void
		{
			SoundMixer.stopAll();
		}
		
		public static function getInstance():SoundManager
		{
			if(__instance==null) __instance = new SoundManager();
			return __instance;
		}
	}
}