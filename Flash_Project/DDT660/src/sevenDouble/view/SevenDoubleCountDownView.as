package sevenDouble.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.TimeManager;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class SevenDoubleCountDownView extends Sprite implements Disposeable
   {
      
      private var _bg:Bitmap;
      
      private var _txt:FilterFrameText;
      
      private var _recordTxt:String;
      
      private var _timer:Timer;
      
      private var _endTime:Date;
      
      public function SevenDoubleCountDownView()
      {
         super();
         this.x = 261;
         this.initView();
         this._timer = new Timer(1000);
         this._timer.addEventListener(TimerEvent.TIMER,this.timerHandler,false,0,true);
      }
      
      private function initView() : void
      {
         this._bg = ComponentFactory.Instance.creatBitmap("asset.sevenDouble.countDownBg");
         this._txt = ComponentFactory.Instance.creatComponentByStylename("sevenDouble.countDownView.txt");
         this._recordTxt = LanguageMgr.GetTranslation("sevenDouble.frame.countDownViewTxt");
         this._txt.text = this._recordTxt + "--:--";
         addChild(this._bg);
         addChild(this._txt);
      }
      
      public function setCountDown(endTime:Date) : void
      {
         this._timer.start();
         this._endTime = endTime;
         this.refreshView(this._endTime);
      }
      
      private function refreshView(endTime:Date) : void
      {
         var endTimestamp:Number = Number(endTime.getTime());
         var nowTimestamp:Number = Number(TimeManager.Instance.Now().getTime());
         var differ:Number = endTimestamp - nowTimestamp;
         differ = differ < 0 ? 0 : differ;
         var minute:int = differ / TimeManager.Minute_TICKS;
         var second:int = differ % TimeManager.Minute_TICKS / 1000;
         var minStr:String = minute < 10 ? "0" + minute : minute.toString();
         var secStr:String = second < 10 ? "0" + second : second.toString();
         this._txt.text = this._recordTxt + minStr + ":" + secStr;
      }
      
      private function timerHandler(event:TimerEvent) : void
      {
         this.refreshView(this._endTime);
      }
      
      public function dispose() : void
      {
         if(Boolean(this._timer))
         {
            this._timer.removeEventListener(TimerEvent.TIMER,this.timerHandler);
            this._timer.stop();
         }
         this._timer = null;
         ObjectUtils.disposeAllChildren(this);
         this._bg = null;
         this._txt = null;
         this._recordTxt = null;
         this._endTime = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

