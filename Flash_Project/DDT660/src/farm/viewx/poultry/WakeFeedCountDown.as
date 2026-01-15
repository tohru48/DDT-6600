package farm.viewx.poultry
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.TimeManager;
   import farm.FarmModelController;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class WakeFeedCountDown extends Sprite implements Disposeable
   {
      
      private var _bg:ScaleBitmapImage;
      
      private var _wakeFeed:ScaleFrameImage;
      
      private var _timeText:FilterFrameText;
      
      private var _cdTime:Number;
      
      private var _feedTimer:Timer;
      
      public function WakeFeedCountDown()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         this._bg = ComponentFactory.Instance.creatComponentByStylename("farm.poultry.countdown.bg");
         addChild(this._bg);
         this._timeText = ComponentFactory.Instance.creatComponentByStylename("farm.poultry.countdownTime");
         addChild(this._timeText);
         this._wakeFeed = ComponentFactory.Instance.creatComponentByStylename("farm.poultry.wakefeedBtn");
         addChild(this._wakeFeed);
         this.creatTimer();
      }
      
      private function creatTimer() : void
      {
         this._feedTimer = new Timer(1000);
         this._feedTimer.addEventListener(TimerEvent.TIMER,this.__onTimer);
      }
      
      protected function __onTimer(event:TimerEvent) : void
      {
         --this._cdTime;
         if(this._cdTime > 0)
         {
            this._timeText.text = this.transSecond(this._cdTime);
         }
         else
         {
            this._bg.visible = this._timeText.visible = false;
            this._feedTimer.stop();
         }
      }
      
      public function setCountDownTime(countDownTime:Date) : void
      {
         var millisecond:Number = countDownTime.time - TimeManager.Instance.Now().time;
         if(millisecond <= 0)
         {
            this._bg.visible = this._timeText.visible = false;
            this._feedTimer.stop();
         }
         else
         {
            this._bg.visible = this._timeText.visible = true;
            this._cdTime = millisecond / 1000;
            if(!this._feedTimer.running)
            {
               this._timeText.text = this.transSecond(this._cdTime);
               this._feedTimer.start();
            }
         }
      }
      
      private function transSecond(num:Number) : String
      {
         var hour:int = Math.floor(num / 3600);
         var minite:int = Math.floor((num - hour * 3600) / 60);
         var second:int = num - hour * 3600 - minite * 60;
         return String("0" + hour).substr(-2) + ":" + String("0" + minite).substr(-2) + ":" + String("0" + second).substr(-2);
      }
      
      protected function __onWakeFeedClick(event:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         if(this._wakeFeed.getFrame == 1)
         {
            if(PlayerManager.Instance.Self.ID == FarmModelController.instance.model.currentFarmerId)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("farm.poultry.wakeInfoTiptxt"));
            }
            else
            {
               SocketManager.Instance.out.wakeFarmPoultry(FarmModelController.instance.model.currentFarmerId);
            }
         }
         else
         {
            SocketManager.Instance.out.feedFarmPoultry(FarmModelController.instance.model.currentFarmerId);
         }
      }
      
      protected function __onFeedOver(event:CrazyTankSocketEvent) : void
      {
         FarmModelController.instance.updateFriendListStolen();
      }
      
      public function setFrame(frameIndex:int) : void
      {
         this._wakeFeed.setFrame(frameIndex);
         this._bg.visible = this._timeText.visible = Boolean(frameIndex != 1);
      }
      
      public function set tipData(value:*) : void
      {
         this._wakeFeed.tipData = value;
      }
      
      private function initEvent() : void
      {
         this._wakeFeed.addEventListener(MouseEvent.CLICK,this.__onWakeFeedClick);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.FARM_POULTYRFEED,this.__onFeedOver);
      }
      
      private function removeEvent() : void
      {
         if(Boolean(this._wakeFeed))
         {
            this._wakeFeed.removeEventListener(MouseEvent.CLICK,this.__onWakeFeedClick);
         }
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.FARM_POULTYRFEED,this.__onFeedOver);
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         if(Boolean(this._bg))
         {
            this._bg.dispose();
            this._bg = null;
         }
         if(Boolean(this._wakeFeed))
         {
            this._wakeFeed.dispose();
            this._wakeFeed = null;
         }
         if(Boolean(this._timeText))
         {
            this._timeText.dispose();
            this._timeText = null;
         }
         if(Boolean(this._feedTimer))
         {
            this._feedTimer.removeEventListener(TimerEvent.TIMER,this.__onTimer);
            this._feedTimer.stop();
            this._feedTimer = null;
         }
      }
   }
}

