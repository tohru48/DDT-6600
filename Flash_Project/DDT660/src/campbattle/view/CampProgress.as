package campbattle.view
{
   import campbattle.CampBattleManager;
   import campbattle.event.MapEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.SocketManager;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class CampProgress extends Sprite implements Disposeable
   {
      
      private var _mc:MovieClip;
      
      private var _timer:Timer;
      
      private var _index:int = 1;
      
      public function CampProgress()
      {
         super();
         this.initView();
      }
      
      private function initView() : void
      {
         this._mc = ComponentFactory.Instance.creat("asset.campbattle.progress.bar");
         this._mc.stop();
         this._mc.visible = false;
         addChild(this._mc);
         this._timer = new Timer(1000,3);
         CampBattleManager.instance.addEventListener(MapEvent.CAPTURE_START,this.captureStartHander);
         CampBattleManager.instance.addEventListener(MapEvent.CAPTURE_OVER,this.captureHander);
      }
      
      protected function captureHander(event:MapEvent) : void
      {
         this._mc.visible = CampBattleManager.instance.model.isCapture;
         if(!CampBattleManager.instance.model.isCapture)
         {
            this._mc.gotoAndStop(1);
         }
         else
         {
            this._mc.gotoAndStop(4);
         }
      }
      
      public function setCapture() : void
      {
         this._mc.visible = true;
         this._mc.gotoAndStop(4);
      }
      
      protected function captureStartHander(event:MapEvent) : void
      {
         this._index = 1;
         this._timer.reset();
         this._mc.visible = true;
         this._timer.addEventListener(TimerEvent.TIMER,this.timerHander);
         this._timer.addEventListener(TimerEvent.TIMER_COMPLETE,this.timerCompeteHander);
         this._timer.start();
         this._mc.gotoAndStop(1);
      }
      
      private function timerCompeteHander(event:TimerEvent) : void
      {
         this._timer.removeEventListener(TimerEvent.TIMER,this.timerHander);
         this._timer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.timerCompeteHander);
         SocketManager.Instance.out.captureMap(true);
         this.setCapture();
      }
      
      private function timerHander(event:TimerEvent) : void
      {
         ++this._index;
         this._mc.gotoAndStop(this._index);
      }
      
      public function dispose() : void
      {
         CampBattleManager.instance.removeEventListener(MapEvent.CAPTURE_OVER,this.captureHander);
         CampBattleManager.instance.removeEventListener(MapEvent.CAPTURE_START,this.captureStartHander);
         if(Boolean(this._timer))
         {
            this._timer.stop();
            this._timer.removeEventListener(TimerEvent.TIMER,this.timerHander);
            this._timer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.timerCompeteHander);
         }
         this._timer = null;
         if(Boolean(this._mc))
         {
            this._mc.stop();
            while(Boolean(this._mc.numChildren))
            {
               ObjectUtils.disposeObject(this._mc.getChildAt(0));
            }
         }
         ObjectUtils.disposeObject(this._mc);
         this._mc = null;
      }
   }
}

