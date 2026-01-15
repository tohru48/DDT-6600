package ddt.manager
{
   import ddt.command.SoundEffect;
   import ddt.events.SoundEffectEvent;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import flash.events.ProgressEvent;
   import flash.net.URLRequest;
   import flash.system.ApplicationDomain;
   import flash.system.LoaderContext;
   import flash.utils.Dictionary;
   import flash.utils.getTimer;
   
   public class SoundEffectManager extends EventDispatcher
   {
      
      private static var _instance:SoundEffectManager;
      
      private var _loader:Loader;
      
      private var _soundDomain:ApplicationDomain;
      
      private var _context:LoaderContext;
      
      private var _lib:Dictionary;
      
      private var _delay:Dictionary;
      
      private var _maxCounts:Dictionary;
      
      private var _progress:Dictionary;
      
      private var _movieClips:Dictionary;
      
      private var _currentLib:String;
      
      public function SoundEffectManager(target:IEventDispatcher = null)
      {
         super(target);
      }
      
      public static function get Instance() : SoundEffectManager
      {
         if(_instance == null)
         {
            _instance = new SoundEffectManager();
         }
         return _instance;
      }
      
      public function setup() : void
      {
         this._loader = new Loader();
         this._soundDomain = new ApplicationDomain();
         this._context = new LoaderContext(false,this._soundDomain);
         this._lib = new Dictionary();
         this._delay = new Dictionary();
         this._maxCounts = new Dictionary();
         this._progress = new Dictionary();
         this._movieClips = new Dictionary(true);
         this._loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,this.__onProgress);
         this._loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.__onLoadComplete);
      }
      
      public function loadSound(lib:String) : void
      {
         this._currentLib = lib;
         if(this._progress[this._currentLib] == 1)
         {
            return;
         }
         this._progress[this._currentLib] = 0;
         this._loader.load(new URLRequest(this._currentLib),this._context);
      }
      
      public function definition(name:String) : *
      {
         return this._soundDomain.getDefinition(name);
      }
      
      public function get progress() : int
      {
         return this._progress[this._currentLib];
      }
      
      public function controlMovie(mc:MovieClip) : void
      {
         mc.addEventListener("play",this.__onPlay);
         this._movieClips[mc] = mc;
      }
      
      public function releaseMovie(mc:MovieClip) : void
      {
         mc.removeEventListener("play",this.__onPlay);
         delete this._movieClips[mc];
         this._movieClips[mc] = null;
      }
      
      private function play(soundId:String) : void
      {
         var time:int = 0;
         var se:SoundEffect = null;
         if(this._lib[this._currentLib] == null)
         {
            this.loadSound(this._currentLib);
         }
         else
         {
            time = getTimer();
            if(this.checkPlay(soundId))
            {
               se = new SoundEffect(soundId);
               se.addEventListener(Event.SOUND_COMPLETE,this.__onSoundComplete);
               se.play();
            }
         }
      }
      
      private function checkPlay(id:String) : Boolean
      {
         var time:int = 0;
         if(Boolean(this._delay[id]))
         {
            if(this._delay[id].length > 0)
            {
               time = getTimer();
               if(time - this._delay[id][0] > 200)
               {
                  if(this._delay[id].length >= this._maxCounts[id])
                  {
                     this._delay[id].shift();
                  }
                  this._delay[id].push(time);
                  return true;
               }
               return false;
            }
            return true;
         }
         this._delay[id] = [getTimer()];
         return true;
      }
      
      private function __onPlay(e:SoundEffectEvent) : void
      {
         this._maxCounts[e.soundInfo.soundId] = e.soundInfo.maxCount;
         this.play(e.soundInfo.soundId);
      }
      
      private function __onProgress(e:ProgressEvent) : void
      {
         this._progress[this._currentLib] = Math.floor(e.bytesLoaded / e.bytesTotal);
      }
      
      private function __onLoadComplete(e:Event) : void
      {
         this._lib[this._currentLib] = true;
         this._progress[this._currentLib] = 1;
      }
      
      private function __onSoundComplete(e:Event) : void
      {
         var se:SoundEffect = e.currentTarget as SoundEffect;
         this._delay[se.id].shift();
         se.dispose();
         se = null;
      }
   }
}

