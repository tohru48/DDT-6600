package consortionBattle.view
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
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import flash.utils.getTimer;
   
   public class ConsBatResurrectView extends Sprite implements Disposeable
   {
      
      public static const FIGHT:int = 2;
      
      private var _bg:ScaleBitmapImage;
      
      private var _resurrectBtn:SimpleBitmapButton;
      
      private var _stayResBtn:SimpleBitmapButton;
      
      private var _timeCD:MovieClip;
      
      private var _txtProp:FilterFrameText;
      
      private var _totalCount:int;
      
      private var _timer:Timer;
      
      private var _consumeCount:int = 5;
      
      private var _lastCreatTime2:int = 0;
      
      private var _lastCreatTime:int = 0;
      
      public function ConsBatResurrectView(totalCount:int)
      {
         super();
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
         addChild(this._resurrectBtn);
         this._stayResBtn = ComponentFactory.Instance.creatComponentByStylename("consortiaBattle.stayRes.btn");
         addChild(this._stayResBtn);
         this._timer = new Timer(1000);
         this._timer.addEventListener(TimerEvent.TIMER,this.__startCount);
         this._timer.start();
      }
      
      private function __startCount(e:TimerEvent) : void
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
      
      private function setFormat(value:int) : String
      {
         var str:String = value.toString();
         if(value < 10)
         {
            str = "0" + str;
         }
         return str;
      }
      
      protected function __timerComplete() : void
      {
         if(this._consumeCount >= 5)
         {
            SocketManager.Instance.out.sendConsBatConsume(5,true);
            this._consumeCount = 0;
         }
         else
         {
            ++this._consumeCount;
         }
      }
      
      private function addEvent() : void
      {
         this._resurrectBtn.addEventListener(MouseEvent.CLICK,this.__resurrect,false,0,true);
         this._stayResBtn.addEventListener(MouseEvent.CLICK,this.__stayRes,false,0,true);
      }
      
      private function __stayRes(e:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(getTimer() - this._lastCreatTime2 > 1000)
         {
            this._lastCreatTime2 = getTimer();
            this.promptlyStayRevive();
         }
      }
      
      protected function promptlyStayRevive() : void
      {
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         var tmpObj:Object = ConsortiaBattleManager.instance.getBuyRecordStatus(3);
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
                  SocketManager.Instance.out.sendConsBatConsume(4,tmpObj.isBand);
                  return;
               }
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.consortiaBattle.buy.noEnoughMoneyTxt"));
               tmpObj.isNoPrompt = false;
            }
         }
         var confirmFrame:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("ddt.consortiaBattle.buyStayResurrect.promptTxt"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),true,true,true,LayerManager.BLCAK_BLOCKGOUND,null,"ConsBatBuyConfirmView",30,true);
         confirmFrame.moveEnable = false;
         confirmFrame.addEventListener(FrameEvent.RESPONSE,this.__StayResurrectConfirm,false,0,true);
      }
      
      protected function __StayResurrectConfirm(evt:FrameEvent) : void
      {
         var confirmFrame2:BaseAlerFrame = null;
         var tmpObj:Object = null;
         SoundManager.instance.play("008");
         var confirmFrame:BaseAlerFrame = evt.currentTarget as BaseAlerFrame;
         confirmFrame.removeEventListener(FrameEvent.RESPONSE,this.__StayResurrectConfirm);
         if(evt.responseCode == FrameEvent.SUBMIT_CLICK || evt.responseCode == FrameEvent.ENTER_CLICK)
         {
            if(confirmFrame.isBand && PlayerManager.Instance.Self.BandMoney < 50)
            {
               confirmFrame2 = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("ddt.consortiaBattle.changeMoneyCostTxt"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),true,true,true,LayerManager.BLCAK_BLOCKGOUND);
               confirmFrame2.moveEnable = false;
               confirmFrame2.addEventListener(FrameEvent.RESPONSE,this.__StayResurrectTwoConfirm,false,0,true);
               return;
            }
            if(!confirmFrame.isBand && PlayerManager.Instance.Self.Money < 50)
            {
               LeavePageManager.showFillFrame();
               return;
            }
            if((confirmFrame as ConsBatBuyConfirmView).isNoPrompt)
            {
               tmpObj = ConsortiaBattleManager.instance.getBuyRecordStatus(3);
               tmpObj.isNoPrompt = true;
               tmpObj.isBand = confirmFrame.isBand;
            }
            SocketManager.Instance.out.sendConsBatConsume(4,confirmFrame.isBand);
         }
      }
      
      protected function __StayResurrectTwoConfirm(evt:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         var confirmFrame:BaseAlerFrame = evt.currentTarget as BaseAlerFrame;
         confirmFrame.removeEventListener(FrameEvent.RESPONSE,this.__StayResurrectTwoConfirm);
         if(evt.responseCode == FrameEvent.SUBMIT_CLICK || evt.responseCode == FrameEvent.ENTER_CLICK)
         {
            if(PlayerManager.Instance.Self.Money < 50)
            {
               LeavePageManager.showFillFrame();
               return;
            }
            SocketManager.Instance.out.sendConsBatConsume(4,false);
         }
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
            if(Boolean(tmpObj.isBand) && PlayerManager.Instance.Self.BandMoney < 10)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.consortiaBattle.buy.noEnoughBindMoneyTxt"));
               tmpObj.isNoPrompt = false;
            }
            else
            {
               if(!(!tmpObj.isBand && PlayerManager.Instance.Self.Money < 10))
               {
                  SocketManager.Instance.out.sendConsBatConsume(3,tmpObj.isBand);
                  return;
               }
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.consortiaBattle.buy.noEnoughMoneyTxt"));
               tmpObj.isNoPrompt = false;
            }
         }
         var confirmFrame:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("ddt.consortiaBattle.buyResurrect.promptTxt"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),true,true,true,LayerManager.BLCAK_BLOCKGOUND,null,"ConsBatBuyConfirmView",30,true);
         confirmFrame.moveEnable = false;
         confirmFrame.addEventListener(FrameEvent.RESPONSE,this.__resurrectConfirm,false,0,true);
      }
      
      protected function __resurrectConfirm(evt:FrameEvent) : void
      {
         var confirmFrame2:BaseAlerFrame = null;
         var tmpObj:Object = null;
         SoundManager.instance.play("008");
         var confirmFrame:BaseAlerFrame = evt.currentTarget as BaseAlerFrame;
         confirmFrame.removeEventListener(FrameEvent.RESPONSE,this.__resurrectConfirm);
         if(evt.responseCode == FrameEvent.SUBMIT_CLICK || evt.responseCode == FrameEvent.ENTER_CLICK)
         {
            if(confirmFrame.isBand && PlayerManager.Instance.Self.BandMoney < 10)
            {
               confirmFrame2 = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("ddt.consortiaBattle.changeMoneyCostTxt"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),true,true,true,LayerManager.BLCAK_BLOCKGOUND);
               confirmFrame2.moveEnable = false;
               confirmFrame2.addEventListener(FrameEvent.RESPONSE,this.__resurrectTwoConfirm,false,0,true);
               return;
            }
            if(!confirmFrame.isBand && PlayerManager.Instance.Self.Money < 10)
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
            SocketManager.Instance.out.sendConsBatConsume(3,confirmFrame.isBand);
         }
      }
      
      protected function __resurrectTwoConfirm(evt:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         var confirmFrame:BaseAlerFrame = evt.currentTarget as BaseAlerFrame;
         confirmFrame.removeEventListener(FrameEvent.RESPONSE,this.__resurrectTwoConfirm);
         if(evt.responseCode == FrameEvent.SUBMIT_CLICK || evt.responseCode == FrameEvent.ENTER_CLICK)
         {
            if(PlayerManager.Instance.Self.Money < 50)
            {
               LeavePageManager.showFillFrame();
               return;
            }
            SocketManager.Instance.out.sendConsBatConsume(3,false);
         }
      }
      
      private function removeEvent() : void
      {
         if(Boolean(this._resurrectBtn))
         {
            this._resurrectBtn.removeEventListener(MouseEvent.CLICK,this.__resurrect);
         }
         if(Boolean(this._stayResBtn))
         {
            this._stayResBtn.removeEventListener(MouseEvent.CLICK,this.__stayRes);
         }
      }
      
      public function dispose() : void
      {
         this.removeEvent();
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
         this._bg = null;
         this._txtProp = null;
         this._resurrectBtn = null;
         this._stayResBtn = null;
         this._timeCD = null;
      }
   }
}

