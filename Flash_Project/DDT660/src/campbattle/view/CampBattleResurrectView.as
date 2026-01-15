package campbattle.view
{
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import consortionBattle.ConsortiaBattleManager;
   import consortionBattle.view.ConsBatBuyConfirmView;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import flash.utils.getTimer;
   
   public class CampBattleResurrectView extends Sprite implements Disposeable
   {
      
      public static const FIGHT:int = 2;
      
      private var _bg:ScaleBitmapImage;
      
      private var _resurrectBtn:SimpleBitmapButton;
      
      private var _timeCD:MovieClip;
      
      private var _txtProp:FilterFrameText;
      
      private var _totalCount:int;
      
      private var timer:Timer;
      
      private var _lastCreatTime:int = 0;
      
      public function CampBattleResurrectView(totalCount:int)
      {
         super();
         this.x = -113;
         this.y = -121;
         this._totalCount = totalCount;
         this.init();
         this.addEvent();
      }
      
      private function init() : void
      {
         this._bg = ComponentFactory.Instance.creatComponentByStylename("consortiaBattle.resurrectBg");
         addChild(this._bg);
         this._txtProp = ComponentFactory.Instance.creatComponentByStylename("consortiaBattle.resurrect.txtProp");
         addChild(this._txtProp);
         this._txtProp.text = LanguageMgr.GetTranslation("worldboss.resurrectView.prop");
         this._timeCD = ComponentFactory.Instance.creat("asset.consortiaBattle.resurrectTimeCD");
         PositionUtils.setPos(this._timeCD,"consortiaBattle.timeCDPos");
         addChild(this._timeCD);
         this._resurrectBtn = ComponentFactory.Instance.creatComponentByStylename("consortiaBattle.resurrect.btn");
         PositionUtils.setPos(this._resurrectBtn,"campBattle.resurrect.Pos");
         addChild(this._resurrectBtn);
         this.timer = new Timer(1000,this._totalCount + 1);
         this.timer.addEventListener(TimerEvent.TIMER,this.__startCount);
         this.timer.addEventListener(TimerEvent.TIMER_COMPLETE,this.__timerComplete);
         this.timer.start();
      }
      
      private function addEvent() : void
      {
         this._resurrectBtn.addEventListener(MouseEvent.CLICK,this.__resurrect);
      }
      
      private function __resurrect(e:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(getTimer() - this._lastCreatTime > 1000)
         {
            this._lastCreatTime = getTimer();
            this.promptlyRevive();
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
         if(Boolean(this._resurrectBtn))
         {
            this._resurrectBtn.removeEventListener(MouseEvent.CLICK,this.__resurrect);
         }
      }
      
      protected function promptlyRevive() : void
      {
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         var tmpObj:Object = ConsortiaBattleManager.instance.getBuyRecordStatus(2);
         if(Boolean(tmpObj.isNoPrompt))
         {
            if(Boolean(tmpObj.isBand) && PlayerManager.Instance.Self.BandMoney < 50)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.consortiaBattle.buy.noEnoughBindMoneyTxt"));
               tmpObj.isNoPrompt = false;
            }
            else
            {
               if(!(!tmpObj.isBand && PlayerManager.Instance.Self.Money < 50))
               {
                  SocketManager.Instance.out.resurrect(tmpObj.isBand);
                  this.dispose();
                  return;
               }
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.consortiaBattle.buy.noEnoughMoneyTxt"));
               tmpObj.isNoPrompt = false;
            }
         }
         var confirmFrame:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("ddt.consortiaBattle.buyResurrect.promptTxt1"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),true,true,true,LayerManager.BLCAK_BLOCKGOUND,null,"ConsBatBuyConfirmView",30,true,AlertManager.SELECTBTN);
         confirmFrame.moveEnable = false;
         confirmFrame.addEventListener(FrameEvent.RESPONSE,this.__resurrectConfirm,false,0,true);
      }
      
      protected function __resurrectConfirm(evt:FrameEvent) : void
      {
         var tmpObj:Object = null;
         SoundManager.instance.play("008");
         var confirmFrame:BaseAlerFrame = evt.currentTarget as BaseAlerFrame;
         confirmFrame.removeEventListener(FrameEvent.RESPONSE,this.__resurrectConfirm);
         if(evt.responseCode == FrameEvent.SUBMIT_CLICK || evt.responseCode == FrameEvent.ENTER_CLICK)
         {
            if(confirmFrame.isBand && PlayerManager.Instance.Self.BandMoney < 50)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.consortiaBattle.buy.noEnoughBindMoneyTxt"));
               return;
            }
            if(!confirmFrame.isBand && PlayerManager.Instance.Self.Money < 50)
            {
               LeavePageManager.showFillFrame();
               return;
            }
            if((confirmFrame as ConsBatBuyConfirmView).isNoPrompt)
            {
               tmpObj = ConsortiaBattleManager.instance.getBuyRecordStatus(2);
               tmpObj.isNoPrompt = true;
               tmpObj.isBand = confirmFrame.isBand;
            }
            this.dispose();
            SocketManager.Instance.out.resurrect(confirmFrame.isBand);
         }
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
      
      protected function __timerComplete(e:TimerEvent = null) : void
      {
         dispatchEvent(new Event(Event.COMPLETE));
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         this.timer.stop();
         this.timer.removeEventListener(TimerEvent.TIMER,this.__startCount);
         this.timer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.__timerComplete);
         ObjectUtils.disposeAllChildren(this);
         if(Boolean(parent))
         {
            this.parent.removeChild(this);
         }
         this._bg = null;
         this._txtProp = null;
         this._resurrectBtn = null;
         this._timeCD = null;
      }
   }
}

