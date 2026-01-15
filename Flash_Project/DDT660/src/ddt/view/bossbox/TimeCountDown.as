package ddt.view.bossbox
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class TimeCountDown extends EventDispatcher
   {
      
      public static const COUNTDOWN_COMPLETE:String = "TIME_countdown_complete";
      
      public static const COUNTDOWN_ONE:String = "countdown_one";
      
      private var _time:Timer;
      
      private var _count:int;
      
      private var _stepSecond:int;
      
      public function TimeCountDown(stepSecond:int)
      {
         super();
         this._stepSecond = stepSecond;
         this._time = new Timer(this._stepSecond);
         this._time.stop();
      }
      
      public function setTimeOnMinute(minute:int) : void
      {
         this._count = minute * 60 * 1000 / this._stepSecond;
         this._time.repeatCount = this._count;
         this._time.reset();
         this._time.start();
         this._time.addEventListener(TimerEvent.TIMER,this._timer);
         this._time.addEventListener(TimerEvent.TIMER_COMPLETE,this._timerComplete);
      }
      
      private function _timer(e:TimerEvent) : void
      {
         dispatchEvent(new Event(TimeCountDown.COUNTDOWN_ONE));
      }
      
      private function _timerComplete(e:TimerEvent) : void
      {
         dispatchEvent(new Event(TimeCountDown.COUNTDOWN_COMPLETE));
      }
      
      public function dispose() : void
      {
         if(Boolean(this._time))
         {
            this._time.stop();
            this._time.removeEventListener(TimerEvent.TIMER,this._timer);
            this._time.removeEventListener(TimerEvent.TIMER_COMPLETE,this._timerComplete);
         }
         this._time = null;
      }
   }
}

