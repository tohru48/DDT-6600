package horseRace.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import ddt.utils.PositionUtils;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class HorseRaceStartCountDown extends Sprite implements Disposeable
   {
      
      private var _mc:MovieClip;
      
      private var _timer:Timer;
      
      private var _count:int;
      
      private var _func:Function;
      
      public function HorseRaceStartCountDown($count:int, type:String = "begin", callFunction:Function = null)
      {
         super();
         PositionUtils.setPos(this,"horseRace.raceView.countDownViewPos");
         this._count = $count;
         this._func = callFunction;
         if(type == "begin")
         {
            this._mc = ComponentFactory.Instance.creat("horseRace.raceView.gameStartCountDown");
         }
         else if(type == "end")
         {
            this._mc = ComponentFactory.Instance.creat("horseRace.raceView.gameEndCountDown");
         }
         addChild(this._mc);
         this._timer = new Timer(1000);
         this._timer.addEventListener(TimerEvent.TIMER,this.timerHandler);
         this._timer.start();
         this.refreshMc();
      }
      
      private function timerHandler(event:TimerEvent) : void
      {
         ++this._count;
         if(this._count > 10)
         {
            if(this._func != null)
            {
               this._func();
            }
            this.dispose();
            return;
         }
         this.refreshMc();
      }
      
      private function refreshMc() : void
      {
         this._mc.gotoAndStop(this._count);
      }
      
      public function dispose() : void
      {
         this._func = null;
         if(Boolean(this._timer))
         {
            this._timer.removeEventListener(TimerEvent.TIMER,this.timerHandler);
            this._timer.stop();
         }
         this._timer = null;
         if(Boolean(this._mc) && this.contains(this._mc))
         {
            this.removeChild(this._mc);
         }
         this._mc = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

