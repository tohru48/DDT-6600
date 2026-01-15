package ddt.view.roulette
{
   import ddt.manager.SoundManager;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class TurnSoundControl extends EventDispatcher
   {
      
      private var _timer:Timer;
      
      private var _isPlaySound:Boolean = false;
      
      private var _oneArray:Array = ["127","128","129","130","131"];
      
      private var _threeArray:Array = ["130","131","133","132","135","134","129","128","127","132","135","134","129","128","127"];
      
      private var _number:int = 0;
      
      public function TurnSoundControl(target:IEventDispatcher = null)
      {
         super(target);
         this.init();
         this.initEvent();
      }
      
      private function init() : void
      {
         this._timer = new Timer(6000);
         this._timer.stop();
      }
      
      private function initEvent() : void
      {
         this._timer.addEventListener(TimerEvent.TIMER,this._timerOne);
         this._timer.addEventListener(TimerEvent.TIMER_COMPLETE,this._timerComplete);
      }
      
      private function _timerOne(evt:TimerEvent) : void
      {
         SoundManager.instance.stop("124");
         SoundManager.instance.play("124");
      }
      
      private function _timerComplete(evt:TimerEvent) : void
      {
      }
      
      public function playSound() : void
      {
         if(!this._isPlaySound)
         {
            this._isPlaySound = true;
            this._timer.delay = 6000;
            this._timer.reset();
            this._timer.start();
            SoundManager.instance.play("124");
         }
      }
      
      public function playOneStep() : void
      {
         var id:String = this._oneArray[this._number];
         SoundManager.instance.play(id);
         this._number = this._number >= 4 ? 0 : this._number + 1;
      }
      
      public function playThreeStep(value:int) : void
      {
         var id:String = this._threeArray[value];
         SoundManager.instance.play(id);
      }
      
      public function stop() : void
      {
         this._isPlaySound = false;
         this._timer.stop();
         SoundManager.instance.stop("124");
      }
      
      public function dispose() : void
      {
         if(Boolean(this._timer))
         {
            this._timer.stop();
            this._timer.removeEventListener(TimerEvent.TIMER,this._timerOne);
            this._timer.removeEventListener(TimerEvent.TIMER_COMPLETE,this._timerComplete);
            this._timer = null;
         }
         this._oneArray = null;
         this._threeArray = null;
      }
   }
}

