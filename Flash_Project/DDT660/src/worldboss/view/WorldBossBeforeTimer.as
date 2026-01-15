package worldboss.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.TimeManager;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class WorldBossBeforeTimer extends Sprite implements Disposeable
   {
      
      private var _timerMc:MovieClip;
      
      private var _timerMc_1:MovieClip;
      
      private var _timerMc_2:MovieClip;
      
      private var _timerMc_3:MovieClip;
      
      private var _timerMc_4:MovieClip;
      
      private var _total:int;
      
      private var _timer:Timer;
      
      public function WorldBossBeforeTimer(total:int)
      {
         super();
         this._total = total;
         this.initView();
         this.refreshView(this._total);
         this._timer = new Timer(1000);
         this._timer.addEventListener(TimerEvent.TIMER,this.timerHandler,false,0,true);
         this._timer.start();
      }
      
      private function initView() : void
      {
         this._timerMc = ComponentFactory.Instance.creat("asset.worldBoss.beforeTimer");
         this._timerMc_1 = this._timerMc["timer_1"];
         this._timerMc_2 = this._timerMc["timer_2"];
         this._timerMc_3 = this._timerMc["timer_3"];
         this._timerMc_4 = this._timerMc["timer_4"];
         this._timerMc_1.gotoAndStop(10);
         this._timerMc_2.gotoAndStop(10);
         this._timerMc_3.gotoAndStop(10);
         this._timerMc_4.gotoAndStop(10);
         addChild(this._timerMc);
      }
      
      private function timerHandler(event:TimerEvent) : void
      {
         --this._total;
         if(this._total <= 0)
         {
            dispatchEvent(new Event(Event.COMPLETE));
            return;
         }
         this.refreshView(this._total);
      }
      
      private function refreshView(remain:int) : void
      {
         var countMin:int = remain / (TimeManager.Minute_TICKS / 1000);
         var tenthMin:int = countMin / 10;
         this._timerMc_1.gotoAndStop(tenthMin == 0 ? 10 : tenthMin);
         var unitMin:int = countMin % 10;
         this._timerMc_2.gotoAndStop(unitMin == 0 ? 10 : unitMin);
         var countSecond:int = remain % (TimeManager.Minute_TICKS / 1000);
         var tenthSecond:int = countSecond / 10;
         this._timerMc_3.gotoAndStop(tenthSecond == 0 ? 10 : tenthSecond);
         var unitSecond:int = countSecond % 10;
         this._timerMc_4.gotoAndStop(unitSecond == 0 ? 10 : unitSecond);
      }
      
      public function dispose() : void
      {
         if(Boolean(this._timer))
         {
            this._timer.removeEventListener(TimerEvent.TIMER,this.timerHandler);
            this._timer.stop();
         }
         this._timer = null;
         ObjectUtils.disposeObject(this._timerMc);
         this._timerMc = null;
         this._timerMc_1 = null;
         this._timerMc_2 = null;
         this._timerMc_3 = null;
         this._timerMc_4 = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

