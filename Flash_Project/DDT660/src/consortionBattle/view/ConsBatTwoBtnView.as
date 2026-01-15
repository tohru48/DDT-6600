package consortionBattle.view
{
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.SelectedCheckButton;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import consortionBattle.ConsortiaBattleManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.utils.getTimer;
   
   public class ConsBatTwoBtnView extends Sprite implements Disposeable
   {
      
      private var _bg:Bitmap;
      
      private var _powerFullBtn:SimpleBitmapButton;
      
      private var _doubleScoreBtn:SimpleBitmapButton;
      
      private var _powerFullSprite:SimpleBitmapButton;
      
      private var _doubleScoreSprite:SimpleBitmapButton;
      
      private var _autoBuyBtn:SelectedCheckButton;
      
      private var _lastPowerFullClickTime:int = 0;
      
      public function ConsBatTwoBtnView()
      {
         super();
         this.x = 380;
         this.y = 35;
         this.initView();
         this.initEvent();
         this.refreshView();
         if(ConsortiaBattleManager.instance.isAutoPowerFull)
         {
            this._autoBuyBtn.selected = true;
            this.autoBuyPowerFull();
         }
      }
      
      private function initView() : void
      {
         this._bg = ComponentFactory.Instance.creatBitmap("asset.consortiaBattle.twoBtnBg");
         this._powerFullBtn = ComponentFactory.Instance.creatComponentByStylename("consortiaBattle.powerFull");
         this._powerFullBtn.tipData = LanguageMgr.GetTranslation("ddt.consortiaBattle.powerFullBtn.tipTxt");
         this._doubleScoreBtn = ComponentFactory.Instance.creatComponentByStylename("consortiaBattle.doubleScoreBtn");
         this._doubleScoreBtn.tipData = LanguageMgr.GetTranslation("ddt.consortiaBattle.doubleScoreBtn.tipTxt");
         this._powerFullSprite = ComponentFactory.Instance.creatComponentByStylename("consortiaBattle.powerFull");
         this._powerFullSprite.tipData = LanguageMgr.GetTranslation("ddt.consortiaBattle.powerFullBtn.tipTxt");
         this._powerFullSprite.alpha = 0;
         this._powerFullSprite.buttonMode = false;
         this._doubleScoreSprite = ComponentFactory.Instance.creatComponentByStylename("consortiaBattle.doubleScoreBtn");
         this._doubleScoreSprite.tipData = LanguageMgr.GetTranslation("ddt.consortiaBattle.doubleScoreBtn.tipTxt");
         this._doubleScoreSprite.alpha = 0;
         this._doubleScoreSprite.buttonMode = false;
         this._autoBuyBtn = ComponentFactory.Instance.creatComponentByStylename("consortiaBattle.autoBuyPowerFull");
         this._autoBuyBtn.tipData = LanguageMgr.GetTranslation("ddt.consortiaBattle.autoBuyPowerFullBtnTipTxt");
         addChild(this._bg);
         addChild(this._powerFullBtn);
         addChild(this._doubleScoreBtn);
         addChild(this._powerFullSprite);
         addChild(this._doubleScoreSprite);
         addChild(this._autoBuyBtn);
      }
      
      private function refreshView(event:Event = null) : void
      {
         if(ConsortiaBattleManager.instance.isPowerFullUsed)
         {
            this._powerFullBtn.enable = false;
            this._powerFullSprite.visible = true;
         }
         else
         {
            this._powerFullBtn.enable = true;
            this._powerFullSprite.visible = false;
         }
         if(ConsortiaBattleManager.instance.isDoubleScoreUsed)
         {
            this._doubleScoreBtn.enable = false;
            this._doubleScoreSprite.visible = true;
         }
         else
         {
            this._doubleScoreBtn.enable = true;
            this._doubleScoreSprite.visible = false;
         }
      }
      
      private function initEvent() : void
      {
         this._powerFullBtn.addEventListener(MouseEvent.CLICK,this.powerFullHandler,false,0,true);
         this._doubleScoreBtn.addEventListener(MouseEvent.CLICK,this.doubleScoreHandler,false,0,true);
         this._autoBuyBtn.addEventListener(MouseEvent.CLICK,this.autoClickHandler,false,0,true);
         ConsortiaBattleManager.instance.addEventListener(ConsortiaBattleManager.UPDATE_SCENE_INFO,this.refreshView);
      }
      
      private function autoClickHandler(event:MouseEvent) : void
      {
         var confirmFrame:BaseAlerFrame = null;
         if(!this._autoBuyBtn.selected)
         {
            confirmFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("ddt.consortiaBattle.autoBuyPowerFullTipTxt"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),true,true,true,LayerManager.BLCAK_BLOCKGOUND);
            confirmFrame.moveEnable = false;
            confirmFrame.addEventListener(FrameEvent.RESPONSE,this.__autoBuyConfirm,false,0,true);
         }
         else
         {
            this._autoBuyBtn.selected = false;
            ConsortiaBattleManager.instance.isAutoPowerFull = false;
         }
      }
      
      private function __autoBuyConfirm(evt:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         var confirmFrame:BaseAlerFrame = evt.currentTarget as BaseAlerFrame;
         confirmFrame.removeEventListener(FrameEvent.RESPONSE,this.__autoBuyConfirm);
         if(evt.responseCode == FrameEvent.SUBMIT_CLICK || evt.responseCode == FrameEvent.ENTER_CLICK)
         {
            this._autoBuyBtn.selected = true;
            ConsortiaBattleManager.instance.isAutoPowerFull = true;
            this.autoBuyPowerFull();
         }
      }
      
      private function autoBuyPowerFull() : void
      {
         if(!ConsortiaBattleManager.instance.isPowerFullUsed)
         {
            if(PlayerManager.Instance.Self.BandMoney >= 100)
            {
               SocketManager.Instance.out.sendConsBatConsume(1,true);
            }
            else if(PlayerManager.Instance.Self.Money >= 100)
            {
               SocketManager.Instance.out.sendConsBatConsume(1,false);
            }
            else
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.consortiaBattle.autoBuyPowerFullNoEnoughMoney"),0,true);
               this._autoBuyBtn.selected = false;
               ConsortiaBattleManager.instance.isAutoPowerFull = false;
            }
         }
      }
      
      private function powerFullHandler(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(getTimer() - this._lastPowerFullClickTime <= 1000)
         {
            return;
         }
         this._lastPowerFullClickTime = getTimer();
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         var tmpObj:Object = ConsortiaBattleManager.instance.getBuyRecordStatus(0);
         if(Boolean(tmpObj.isNoPrompt))
         {
            if(Boolean(tmpObj.isBand) && PlayerManager.Instance.Self.BandMoney <= 15)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.consortiaBattle.buy.noEnoughBindMoneyTxt"));
               tmpObj.isNoPrompt = false;
            }
            else
            {
               if(!(!tmpObj.isBand && PlayerManager.Instance.Self.Money <= 15))
               {
                  SocketManager.Instance.out.sendConsBatConsume(1,tmpObj.isBand);
                  return;
               }
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.consortiaBattle.buy.noEnoughMoneyTxt"));
               tmpObj.isNoPrompt = false;
            }
         }
         var confirmFrame:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("ddt.consortiaBattle.buyPowerFull.promptTxt"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),true,true,true,LayerManager.BLCAK_BLOCKGOUND,null,"ConsBatBuyConfirmView",30,true);
         confirmFrame.moveEnable = false;
         confirmFrame.addEventListener(FrameEvent.RESPONSE,this.__powerFullConfirm,false,0,true);
      }
      
      private function __powerFullConfirm(evt:FrameEvent) : void
      {
         var tmpObj:Object = null;
         SoundManager.instance.play("008");
         var confirmFrame:BaseAlerFrame = evt.currentTarget as BaseAlerFrame;
         confirmFrame.removeEventListener(FrameEvent.RESPONSE,this.__powerFullConfirm);
         if(evt.responseCode == FrameEvent.SUBMIT_CLICK || evt.responseCode == FrameEvent.ENTER_CLICK)
         {
            if(confirmFrame.isBand && PlayerManager.Instance.Self.BandMoney < 15)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.consortiaBattle.buy.noEnoughBindMoneyTxt"));
               return;
            }
            if(!confirmFrame.isBand && PlayerManager.Instance.Self.Money < 15)
            {
               LeavePageManager.showFillFrame();
               return;
            }
            if((confirmFrame as ConsBatBuyConfirmView).isNoPrompt)
            {
               tmpObj = ConsortiaBattleManager.instance.getBuyRecordStatus(0);
               tmpObj.isNoPrompt = true;
               tmpObj.isBand = confirmFrame.isBand;
            }
            SocketManager.Instance.out.sendConsBatConsume(1,confirmFrame.isBand);
         }
      }
      
      private function doubleScoreHandler(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         var confirmFrame:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("ddt.consortiaBattle.buyDoubleScore.promptTxt"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),true,true,true,LayerManager.BLCAK_BLOCKGOUND,null,"SimpleAlert",30,true);
         confirmFrame.moveEnable = false;
         confirmFrame.addEventListener(FrameEvent.RESPONSE,this.__doubleScoreConfirm,false,0,true);
      }
      
      private function __doubleScoreConfirm(evt:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         var confirmFrame:BaseAlerFrame = evt.currentTarget as BaseAlerFrame;
         confirmFrame.removeEventListener(FrameEvent.RESPONSE,this.__doubleScoreConfirm);
         if(evt.responseCode == FrameEvent.SUBMIT_CLICK || evt.responseCode == FrameEvent.ENTER_CLICK)
         {
            if(confirmFrame.isBand && PlayerManager.Instance.Self.BandMoney < 150)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.consortiaBattle.buy.noEnoughBindMoneyTxt"));
               return;
            }
            if(!confirmFrame.isBand && PlayerManager.Instance.Self.Money < 150)
            {
               LeavePageManager.showFillFrame();
               return;
            }
            SocketManager.Instance.out.sendConsBatConsume(2,confirmFrame.isBand);
         }
      }
      
      private function removeEvent() : void
      {
         if(Boolean(this._powerFullBtn))
         {
            this._powerFullBtn.removeEventListener(MouseEvent.CLICK,this.powerFullHandler);
         }
         if(Boolean(this._doubleScoreBtn))
         {
            this._doubleScoreBtn.removeEventListener(MouseEvent.CLICK,this.doubleScoreHandler);
         }
         if(Boolean(this._autoBuyBtn))
         {
            this._autoBuyBtn.removeEventListener(MouseEvent.CLICK,this.autoClickHandler);
         }
         ConsortiaBattleManager.instance.removeEventListener(ConsortiaBattleManager.UPDATE_SCENE_INFO,this.refreshView);
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeAllChildren(this);
         this._bg = null;
         this._powerFullBtn = null;
         this._doubleScoreBtn = null;
         this._autoBuyBtn = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

