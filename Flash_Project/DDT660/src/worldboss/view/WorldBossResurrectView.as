package worldboss.view
{
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.socket.ePackageType;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SharedManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddtBuried.BuriedManager;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import flash.utils.getTimer;
   import road7th.comm.PackageOut;
   import worldboss.WorldBossManager;
   import worldboss.event.WorldBossRoomEvent;
   import worldboss.model.WorldBossGamePackageType;
   
   public class WorldBossResurrectView extends Sprite implements Disposeable
   {
      
      public static const FIGHT:int = 2;
      
      private var _bg:ScaleBitmapImage;
      
      private var _resurrectBtn:BaseButton;
      
      private var _reFightBtn:BaseButton;
      
      private var _timeCD:MovieClip;
      
      private var _txtProp:FilterFrameText;
      
      private var _totalCount:int;
      
      private var timer:Timer;
      
      private var alert:WorldBossConfirmFrame;
      
      private var _lastCreatTime:int = 0;
      
      public function WorldBossResurrectView(totalCount:int)
      {
         super();
         this._totalCount = totalCount;
         this.init();
         this.addEvent();
      }
      
      private function init() : void
      {
         this._bg = ComponentFactory.Instance.creat("worldBossRoom.resurrectBg");
         addChild(this._bg);
         this._txtProp = ComponentFactory.Instance.creat("worldBossRoom.resurrect.txtProp");
         addChild(this._txtProp);
         this._txtProp.text = LanguageMgr.GetTranslation("worldboss.resurrectView.prop");
         this._resurrectBtn = ComponentFactory.Instance.creat("worldbossRoom.resurrect.btn");
         addChild(this._resurrectBtn);
         this._reFightBtn = ComponentFactory.Instance.creat("worldbossRoom.reFight.btn");
         addChild(this._reFightBtn);
         this._timeCD = ComponentFactory.Instance.creat("asset.worldboosRoom.timeCD");
         addChild(this._timeCD);
         this.timer = new Timer(1000,this._totalCount + 1);
         this.timer.addEventListener(TimerEvent.TIMER,this.__startCount);
         this.timer.addEventListener(TimerEvent.TIMER_COMPLETE,this.__timerComplete);
         this.timer.start();
      }
      
      private function addEvent() : void
      {
         this._resurrectBtn.addEventListener(MouseEvent.CLICK,this.__resurrect);
         this._reFightBtn.addEventListener(MouseEvent.CLICK,this.__reFight);
      }
      
      private function __resurrect(e:MouseEvent) : void
      {
         if(getTimer() - this._lastCreatTime > 1000)
         {
            this._lastCreatTime = getTimer();
            SoundManager.instance.play("008");
            if(SharedManager.Instance.isResurrect)
            {
               this.promptlyRevive();
            }
            else
            {
               this.alert = ComponentFactory.Instance.creatComponentByStylename("worldboss.buyBuff.WorldBossConfirmFrame");
               this.alert.showFrame(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("worldboss.revive.propMoney",WorldBossManager.Instance.bossInfo.reviveMoney),null,this.seveIsResurrect);
               this.alert.addEventListener(FrameEvent.RESPONSE,this.__onAlertResponse);
            }
         }
      }
      
      private function __reFight(e:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(getTimer() - this._lastCreatTime > 1000)
         {
            this._lastCreatTime = getTimer();
            if(SharedManager.Instance.isReFight)
            {
               this.promptlyFight();
            }
            else
            {
               this.alert = ComponentFactory.Instance.creatComponentByStylename("worldboss.buyBuff.WorldBossConfirmFrame");
               this.alert.showFrame(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("worldboss.reFight.propMoney",WorldBossManager.Instance.bossInfo.reFightMoney),null,this.seveIsReFight);
               this.alert.addEventListener(FrameEvent.RESPONSE,this.__onAlertResponse2);
            }
         }
      }
      
      public function __startCount(e:TimerEvent) : void
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
      
      private function removeEvent() : void
      {
         this._resurrectBtn.removeEventListener(MouseEvent.CLICK,this.__resurrect);
         this._reFightBtn.removeEventListener(MouseEvent.CLICK,this.__reFight);
      }
      
      private function __onAlertResponse(evt:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         switch(evt.responseCode)
         {
            case FrameEvent.ENTER_CLICK:
            case FrameEvent.SUBMIT_CLICK:
               SharedManager.Instance.isResurrectBind = false;
               this.promptlyRevive();
               return;
            case FrameEvent.CANCEL_CLICK:
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.ESC_CLICK:
         }
         this.alert.dispose();
         this.alert.removeEventListener(FrameEvent.RESPONSE,this.__onAlertResponse);
      }
      
      private function __onAlertResponse2(evt:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         switch(evt.responseCode)
         {
            case FrameEvent.ENTER_CLICK:
            case FrameEvent.SUBMIT_CLICK:
               SharedManager.Instance.isReFightBind = false;
               this.promptlyFight();
               return;
            case FrameEvent.CANCEL_CLICK:
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.ESC_CLICK:
         }
         this.alert.dispose();
         this.alert.removeEventListener(FrameEvent.RESPONSE,this.__onAlertResponse2);
      }
      
      private function seveIsResurrect(bool:Boolean) : void
      {
         SharedManager.Instance.isResurrect = bool;
         SharedManager.Instance.save();
      }
      
      private function seveIsReFight(bool:Boolean) : void
      {
         SharedManager.Instance.isReFight = bool;
         SharedManager.Instance.save();
      }
      
      private function promptlyRevive() : void
      {
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         if(BuriedManager.Instance.checkMoney(SharedManager.Instance.isResurrectBind,WorldBossManager.Instance.bossInfo.reviveMoney))
         {
            SharedManager.Instance.isResurrectBind = false;
            SharedManager.Instance.isResurrect = false;
            if(Boolean(this.alert))
            {
               this.alert.dispose();
            }
            this.alert = ComponentFactory.Instance.creatComponentByStylename("worldboss.buyBuff.WorldBossConfirmFrame");
            this.alert.showFrame(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("worldboss.revive.propMoney",WorldBossManager.Instance.bossInfo.reviveMoney),null,this.seveIsResurrect);
            this.alert.addEventListener(FrameEvent.RESPONSE,this.__onAlertResponse);
            return;
         }
         this.requestRevive(1,SharedManager.Instance.isResurrectBind);
         if(Boolean(this.alert))
         {
            this.alert.dispose();
            this.alert.removeEventListener(FrameEvent.RESPONSE,this.__onAlertResponse);
         }
      }
      
      private function promptlyFight() : void
      {
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         if(BuriedManager.Instance.checkMoney(SharedManager.Instance.isReFightBind,WorldBossManager.Instance.bossInfo.reFightMoney))
         {
            SharedManager.Instance.isReFightBind = false;
            SharedManager.Instance.isReFight = false;
            if(Boolean(this.alert))
            {
               this.alert.dispose();
            }
            this.alert = ComponentFactory.Instance.creatComponentByStylename("worldboss.buyBuff.WorldBossConfirmFrame");
            this.alert.showFrame(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("worldboss.reFight.propMoney",WorldBossManager.Instance.bossInfo.reFightMoney),null,this.seveIsReFight);
            this.alert.addEventListener(FrameEvent.RESPONSE,this.__onAlertResponse2);
            return;
         }
         var flag:Boolean = SharedManager.Instance.isReFightBind;
         if(PlayerManager.Instance.Self.Money < WorldBossManager.Instance.bossInfo.reFightMoney)
         {
            LeavePageManager.showFillFrame();
            return;
         }
         this.requestRevive(FIGHT,SharedManager.Instance.isReFightBind);
         WorldBossManager.Instance.dispatchEvent(new WorldBossRoomEvent(WorldBossRoomEvent.STARTFIGHT));
         if(Boolean(this.alert))
         {
            this.alert.dispose();
            this.alert.removeEventListener(FrameEvent.RESPONSE,this.__onAlertResponse2);
         }
      }
      
      private function requestRevive(type:int, bool:Boolean) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.WORLDBOSS_CMD);
         pkg.writeByte(WorldBossGamePackageType.REQUEST_REVIVE);
         pkg.writeInt(type);
         pkg.writeBoolean(bool);
         SocketManager.Instance.socket.send(pkg);
      }
      
      private function setFormat(value:int) : String
      {
         var str:String = value.toString();
         if(value < 10)
         {
            str = "0" + str;
         }
         return str;
      }
      
      private function __timerComplete(e:TimerEvent = null) : void
      {
         dispatchEvent(new Event(Event.COMPLETE));
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         this.timer.stop();
         this.timer.removeEventListener(TimerEvent.TIMER,this.__startCount);
         this.timer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.__timerComplete);
         if(Boolean(this.alert))
         {
            this.alert.dispose();
         }
         ObjectUtils.disposeAllChildren(this);
         if(Boolean(parent))
         {
            this.parent.removeChild(this);
         }
         this._bg = null;
         this._txtProp = null;
         this._resurrectBtn = null;
         this._reFightBtn = null;
         this._timeCD = null;
      }
   }
}

