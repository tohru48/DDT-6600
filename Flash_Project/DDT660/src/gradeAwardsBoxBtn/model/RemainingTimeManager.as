package gradeAwardsBoxBtn.model
{
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class RemainingTimeManager
   {
      
      private static var instance:RemainingTimeManager;
      
      public var funOnTimer:Function = null;
      
      private var _timer:Timer;
      
      public function RemainingTimeManager(single:inner)
      {
         super();
         this._timer = new Timer(30000);
      }
      
      public static function getInstance() : RemainingTimeManager
      {
         if(instance == null)
         {
            instance = new RemainingTimeManager(new inner());
         }
         return instance;
      }
      
      public function start() : void
      {
         this._timer.addEventListener(TimerEvent.TIMER,this.onTimer);
         this._timer.start();
      }
      
      protected function onTimer(te:TimerEvent) : void
      {
         if(this.funOnTimer != null)
         {
            this.funOnTimer();
         }
      }
      
      public function stop() : void
      {
         this._timer.removeEventListener(TimerEvent.TIMER,this.onTimer);
         this._timer.reset();
      }
      
      public function isRuning() : Boolean
      {
         return Boolean(this._timer) && this._timer.running;
      }
      
      public function dispose() : void
      {
         instance = null;
         this._timer.stop();
         this._timer.removeEventListener(TimerEvent.TIMER,this.onTimer);
         this._timer = null;
         this.funOnTimer = null;
      }
   }
}

class inner
{
   
   public function inner()
   {
      super();
   }
}
