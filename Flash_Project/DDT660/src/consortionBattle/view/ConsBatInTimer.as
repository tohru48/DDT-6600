package consortionBattle.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import consortionBattle.ConsortiaBattleManager;
   import ddt.manager.LanguageMgr;
   import ddt.utils.PositionUtils;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class ConsBatInTimer extends Sprite implements Disposeable
   {
      
      protected var _promptTxt:FilterFrameText;
      
      protected var _timeCD:MovieClip;
      
      protected var _timer:Timer;
      
      protected var _totalCount:int;
      
      public function ConsBatInTimer()
      {
         super();
         this.x = 406;
         this.y = 10;
         this.init();
      }
      
      protected function init() : void
      {
         this._promptTxt = ComponentFactory.Instance.creatComponentByStylename("consortiaBattle.inTimerView.promptTxt");
         this._promptTxt.text = LanguageMgr.GetTranslation("ddt.consortiaBattle.inTimerView.promptTxt");
         addChild(this._promptTxt);
         this._timeCD = ComponentFactory.Instance.creat("asset.consortiaBattle.resurrectTimeCD");
         PositionUtils.setPos(this._timeCD,"consortiaBattle.timeCDPos2");
         addChild(this._timeCD);
         this._totalCount = ConsortiaBattleManager.instance.toEndTime;
         this._totalCount = this._totalCount < 0 ? 0 : this._totalCount;
         this._timer = new Timer(1000);
         this._timer.addEventListener(TimerEvent.TIMER,this.__startCount);
         this._timer.start();
      }
      
      protected function __startCount(e:TimerEvent) : void
      {
         if(this._totalCount < 0)
         {
            this.__timerComplete();
            return;
         }
         var str:String = this.setFormat(int(this._totalCount / 3600)) + ":" + this.setFormat(int(this._totalCount / 60 % 60)) + ":" + this.setFormat(int(this._totalCount % 60));
         (this._timeCD["timeHour2"] as MovieClip).gotoAndStop("num_" + str.charAt(0));
         (this._timeCD["timeHour"] as MovieClip).gotoAndStop("num_" + str.charAt(1));
         (this._timeCD["timeMint2"] as MovieClip).gotoAndStop("num_" + str.charAt(3));
         (this._timeCD["timeMint"] as MovieClip).gotoAndStop("num_" + str.charAt(4));
         (this._timeCD["timeSecond2"] as MovieClip).gotoAndStop("num_" + str.charAt(6));
         (this._timeCD["timeSecond"] as MovieClip).gotoAndStop("num_" + str.charAt(7));
         --this._totalCount;
      }
      
      protected function setFormat(value:int) : String
      {
         var str:String = value.toString();
         if(value < 10)
         {
            str = "0" + str;
         }
         return str;
      }
      
      protected function __timerComplete(e:TimerEvent = null) : void
      {
         dispatchEvent(new Event(Event.COMPLETE));
      }
      
      public function dispose() : void
      {
         if(Boolean(this._timer))
         {
            this._timer.stop();
            this._timer.removeEventListener(TimerEvent.TIMER,this.__startCount);
            this._timer = null;
         }
         ObjectUtils.disposeAllChildren(this);
         if(Boolean(parent))
         {
            this.parent.removeChild(this);
         }
         this._timeCD = null;
         this._promptTxt = null;
      }
   }
}

