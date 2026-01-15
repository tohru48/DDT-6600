package escort.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import ddt.utils.PositionUtils;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class EscortStartCountDownView extends Sprite implements Disposeable
   {
      
      private var _mc:MovieClip;
      
      private var _timer:Timer;
      
      private var _count:int;
      
      private var _func:Function;
      
      private var _funcParams:Array;
      
      public function EscortStartCountDownView(callFunction:Function, callParams:Array)
      {
         super();
         PositionUtils.setPos(this,"escort.gameStart.countDownViewPos");
         this._func = callFunction;
         this._funcParams = callParams;
         this._mc = ComponentFactory.Instance.creat("asset.escort.gameStartCountDown");
         addChild(this._mc);
         this._timer = new Timer(1000);
         this._timer.addEventListener(TimerEvent.TIMER,this.timerHandler,false,0,true);
         this._timer.start();
         this._count = 1;
         this.refreshMc();
      }
      
      private function timerHandler(event:TimerEvent) : void
      {
         ++this._count;
         if(this._count > 10)
         {
            if(null != this._func)
            {
               this._func.apply(null,this._funcParams);
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
         this._funcParams = null;
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

