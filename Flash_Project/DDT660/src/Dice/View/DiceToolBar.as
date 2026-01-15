package Dice.View
{
   import Dice.Controller.DiceController;
   import Dice.Event.DiceEvent;
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.ShowTipManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.SelectedButton;
   import com.pickgliss.ui.controls.SelectedCheckButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.events.PlayerPropertyEvent;
   import ddt.manager.GameInSocketOut;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class DiceToolBar extends Sprite implements Disposeable
   {
      
      private var _bg:Bitmap;
      
      private var _currentCouponsCaption:Bitmap;
      
      private var _currentCoupons:FilterFrameText;
      
      private var _currentCouponsBG:Scale9CornerImage;
      
      private var _refreshBtn:BaseButton;
      
      private var _doubleRadio:SelectedButton;
      
      private var _smallRadio:SelectedButton;
      
      private var _bigRadio:SelectedButton;
      
      private var _doubleText:Bitmap;
      
      private var _bigText:Bitmap;
      
      private var _smallText:Bitmap;
      
      private var _baseAlert:BaseAlerFrame;
      
      private var _selectCheckBtn:SelectedCheckButton;
      
      private var _poorManAlert:BaseAlerFrame;
      
      public function DiceToolBar()
      {
         super();
         this.preInitialize();
         this.Initialize();
         this.addEvent();
      }
      
      private function preInitialize() : void
      {
         this._bg = ComponentFactory.Instance.creatBitmap("asset.dice.toolBar.BG");
         this._currentCouponsCaption = ComponentFactory.Instance.creatBitmap("asset.dice.toolBar.currentCouponsCaption");
         this._currentCoupons = ComponentFactory.Instance.creatComponentByStylename("asset.dice.toolBar.currentCoupons");
         this._currentCouponsBG = ComponentFactory.Instance.creatComponentByStylename("asset.dice.toolBar.currentCoupons.BG");
         this._refreshBtn = ComponentFactory.Instance.creatComponentByStylename("asset.dice.toolBar.refreshBtn");
         this._refreshBtn.tipData = LanguageMgr.GetTranslation("dice.refresh.tip",DiceController.Instance.refreshPrice);
         ShowTipManager.Instance.addTip(this._refreshBtn);
         this._doubleRadio = ComponentFactory.Instance.creatComponentByStylename("asset.dice.toolBar.double");
         this._doubleRadio.tipData = LanguageMgr.GetTranslation("dice.double.tip",DiceController.Instance.doubleDicePrice);
         ShowTipManager.Instance.addTip(this._doubleRadio);
         this._smallRadio = ComponentFactory.Instance.creatComponentByStylename("asset.dice.toolBar.small");
         this._smallRadio.tipData = LanguageMgr.GetTranslation("dice.small.tip",DiceController.Instance.smallDicePrice);
         ShowTipManager.Instance.addTip(this._smallRadio);
         this._bigRadio = ComponentFactory.Instance.creatComponentByStylename("asset.dice.toolBar.big");
         this._bigRadio.tipData = LanguageMgr.GetTranslation("dice.big.tip",DiceController.Instance.bigDicePrice);
         ShowTipManager.Instance.addTip(this._bigRadio);
         this._doubleText = ComponentFactory.Instance.creatBitmap("asset.dice.double.text");
         this._bigText = ComponentFactory.Instance.creatBitmap("asset.dice.big.text");
         this._smallText = ComponentFactory.Instance.creatBitmap("asset.dice.small.text");
      }
      
      private function Initialize() : void
      {
         this._currentCoupons.text = String(PlayerManager.Instance.Self.Money);
         addChild(this._bg);
         addChild(this._currentCouponsBG);
         addChild(this._currentCouponsCaption);
         addChild(this._currentCoupons);
         addChild(this._refreshBtn);
         this._doubleRadio.selected = false;
         addChild(this._doubleRadio);
         this._smallRadio.selected = false;
         addChild(this._smallRadio);
         this._bigRadio.selected = false;
         addChild(this._bigRadio);
         addChild(this._doubleText);
         addChild(this._bigText);
         addChild(this._smallText);
         switch(DiceController.Instance.diceType)
         {
            case 1:
               this._doubleRadio.selected = true;
               break;
            case 2:
               this._bigRadio.selected = true;
               break;
            case 3:
               this._smallRadio.selected = true;
         }
      }
      
      private function addEvent() : void
      {
         this._doubleRadio.addEventListener(MouseEvent.CLICK,this.__onSelectBtnClick);
         this._smallRadio.addEventListener(MouseEvent.CLICK,this.__onSelectBtnClick);
         this._bigRadio.addEventListener(MouseEvent.CLICK,this.__onSelectBtnClick);
         this._refreshBtn.addEventListener(MouseEvent.CLICK,this.__onRefreshBtnClick);
         DiceController.Instance.addEventListener(DiceEvent.PLAYER_ISWALKING,this.__onPlayerState);
         DiceController.Instance.addEventListener(DiceEvent.GET_DICE_RESULT_DATA,this.__getDiceResultData);
         PlayerManager.Instance.Self.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__changeMoney);
      }
      
      private function removeEvent() : void
      {
         this._doubleRadio.removeEventListener(MouseEvent.CLICK,this.__onSelectBtnClick);
         this._smallRadio.removeEventListener(MouseEvent.CLICK,this.__onSelectBtnClick);
         this._bigRadio.removeEventListener(MouseEvent.CLICK,this.__onSelectBtnClick);
         this._refreshBtn.removeEventListener(MouseEvent.CLICK,this.__onRefreshBtnClick);
         DiceController.Instance.removeEventListener(DiceEvent.PLAYER_ISWALKING,this.__onPlayerState);
         DiceController.Instance.removeEventListener(DiceEvent.GET_DICE_RESULT_DATA,this.__getDiceResultData);
         PlayerManager.Instance.Self.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__changeMoney);
      }
      
      private function __getDiceResultData(event:DiceEvent) : void
      {
         this._refreshBtn.enable = false;
         this._doubleRadio.enable = false;
         this._smallRadio.enable = false;
         this._bigRadio.enable = false;
      }
      
      private function __onPlayerState(event:DiceEvent) : void
      {
         if(Boolean(event.resultData.isWalking))
         {
            this._refreshBtn.enable = false;
            this._doubleRadio.enable = false;
            this._smallRadio.enable = false;
            this._bigRadio.enable = false;
         }
         else
         {
            this._refreshBtn.enable = true;
            this._doubleRadio.enable = true;
            this._smallRadio.enable = true;
            this._bigRadio.enable = true;
         }
      }
      
      private function __onRefreshBtnClick(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         if(PlayerManager.Instance.Self.Money < Number(DiceController.Instance.refreshPrice))
         {
            if(Boolean(this._poorManAlert))
            {
               ObjectUtils.disposeObject(this._poorManAlert);
            }
            this._poorManAlert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("poorNote"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,false,LayerManager.BLCAK_BLOCKGOUND);
            this._poorManAlert.moveEnable = false;
            this._poorManAlert.addEventListener(FrameEvent.RESPONSE,this.__poorManResponse);
            return;
         }
         this.AlertFeedeductionWindow();
      }
      
      private function __poorManResponse(event:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         this._poorManAlert.removeEventListener(FrameEvent.RESPONSE,this.__poorManResponse);
         if(event.responseCode == FrameEvent.SUBMIT_CLICK || event.responseCode == FrameEvent.ENTER_CLICK)
         {
            LeavePageManager.leaveToFillPath();
         }
         ObjectUtils.disposeObject(this._poorManAlert);
         this._poorManAlert = null;
      }
      
      private function AlertFeedeductionWindow() : void
      {
         if(!DiceController.Instance.canPopupNextRefreshWindow)
         {
            this.openAlertFrame();
         }
         else
         {
            this.sendRefreshDataToServer();
         }
      }
      
      private function sendRefreshDataToServer() : void
      {
         GameInSocketOut.sendDiceRefreshData();
      }
      
      private function openAlertFrame() : void
      {
         var msg:String = LanguageMgr.GetTranslation("dice.refreshPrompt",DiceController.Instance.refreshPrice) + "\n\n";
         if(this._selectCheckBtn == null)
         {
            this._selectCheckBtn = ComponentFactory.Instance.creatComponentByStylename("asset.dice.refreshAlert.selectedCheck");
            this._selectCheckBtn.text = LanguageMgr.GetTranslation("dice.alert.nextPrompt");
            this._selectCheckBtn.selected = DiceController.Instance.canPopupNextRefreshWindow;
            this._selectCheckBtn.addEventListener(MouseEvent.CLICK,this.__onCheckBtnClick);
         }
         if(Boolean(this._baseAlert))
         {
            ObjectUtils.disposeObject(this._baseAlert);
         }
         this._baseAlert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),msg,LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),true,false,false,LayerManager.GAME_TOP_LAYER);
         this._baseAlert.addChild(this._selectCheckBtn);
         this._baseAlert.addEventListener(FrameEvent.RESPONSE,this.__onResponse);
      }
      
      private function __onResponse(evt:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         var alert:BaseAlerFrame = evt.target as BaseAlerFrame;
         alert.removeEventListener(FrameEvent.RESPONSE,this.__onResponse);
         this._selectCheckBtn.removeEventListener(MouseEvent.CLICK,this.__onCheckBtnClick);
         ObjectUtils.disposeObject(this._selectCheckBtn);
         this._selectCheckBtn = null;
         alert.dispose();
         alert = null;
         if(evt.responseCode == FrameEvent.ENTER_CLICK || evt.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            this.sendRefreshDataToServer();
         }
      }
      
      private function __onCheckBtnClick(event:MouseEvent) : void
      {
         DiceController.Instance.setPopupNextRefreshWindow(this._selectCheckBtn.selected);
      }
      
      private function __changeMoney(event:PlayerPropertyEvent) : void
      {
         if(Boolean(this._currentCoupons))
         {
            this._currentCoupons.text = String(PlayerManager.Instance.Self.Money);
         }
      }
      
      private function __onSelectBtnClick(event:MouseEvent) : void
      {
         SoundManager.instance.playMusic("062");
         switch(event.currentTarget)
         {
            case this._doubleRadio:
               this._smallRadio.selected = false;
               this._bigRadio.selected = false;
               break;
            case this._smallRadio:
               this._doubleRadio.selected = false;
               this._bigRadio.selected = false;
               break;
            case this._bigRadio:
               this._doubleRadio.selected = false;
               this._smallRadio.selected = false;
         }
         var selectedIndex:int = 0;
         if(this._doubleRadio.selected)
         {
            selectedIndex = 1;
         }
         else if(this._bigRadio.selected)
         {
            selectedIndex = 2;
         }
         else if(this._smallRadio.selected)
         {
            selectedIndex = 3;
         }
         DiceController.Instance.diceType = selectedIndex;
         DiceController.Instance.dispatchEvent(new DiceEvent(DiceEvent.CHANGED_DICETYPE));
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeObject(this._baseAlert);
         this._baseAlert = null;
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         ObjectUtils.disposeObject(this._currentCouponsCaption);
         this._currentCouponsCaption = null;
         ObjectUtils.disposeObject(this._currentCouponsBG);
         this._currentCouponsBG = null;
         ObjectUtils.disposeObject(this._currentCoupons);
         this._currentCoupons = null;
         ObjectUtils.disposeObject(this._refreshBtn);
         this._refreshBtn = null;
         ObjectUtils.disposeObject(this._doubleRadio);
         this._doubleRadio = null;
         ObjectUtils.disposeObject(this._bigRadio);
         this._bigRadio = null;
         ObjectUtils.disposeObject(this._smallRadio);
         this._smallRadio = null;
         ObjectUtils.disposeObject(this._doubleText);
         this._doubleText = null;
         ObjectUtils.disposeObject(this._bigText);
         this._bigText = null;
         ObjectUtils.disposeObject(this._smallText);
         this._smallText = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

