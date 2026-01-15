package groupPurchase.view
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.command.NumberSelecter;
   import ddt.data.goods.ShopItemInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.ShopManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import groupPurchase.GroupPurchaseManager;
   
   public class GroupPurchaseQuickBuyFrame extends Frame
   {
      
      public var canDispose:Boolean;
      
      private var _view:GroupPurchaseQuickBuyFrameView;
      
      private var _shopItemInfo:ShopItemInfo;
      
      private var _submitButton:TextButton;
      
      private var _unitPrice:Number;
      
      private var _buyFrom:int;
      
      public function GroupPurchaseQuickBuyFrame()
      {
         super();
         this.canDispose = true;
         this.initView();
         this.initEvents();
      }
      
      private function initView() : void
      {
         this._view = new GroupPurchaseQuickBuyFrameView();
         addToContent(this._view);
         this._submitButton = ComponentFactory.Instance.creatComponentByStylename("ddtcore.quickEnter");
         this._submitButton.text = LanguageMgr.GetTranslation("store.view.shortcutBuy.buyBtn");
         this._view.addChild(this._submitButton);
         escEnable = true;
         enterEnable = true;
      }
      
      private function initEvents() : void
      {
         addEventListener(FrameEvent.RESPONSE,this._response);
         this._submitButton.addEventListener(MouseEvent.CLICK,this.doPay);
         this._view.addEventListener(NumberSelecter.NUMBER_CLOSE,this._numberClose);
         addEventListener(NumberSelecter.NUMBER_ENTER,this._numberEnter);
      }
      
      private function removeEvnets() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this._response);
         if(Boolean(this._submitButton))
         {
            this._submitButton.removeEventListener(MouseEvent.CLICK,this.doPay);
         }
         if(Boolean(this._view))
         {
            this._view.removeEventListener(NumberSelecter.NUMBER_CLOSE,this._numberClose);
         }
         removeEventListener(NumberSelecter.NUMBER_ENTER,this._numberEnter);
      }
      
      private function _numberClose(e:Event) : void
      {
         this.cancelMoney();
         ObjectUtils.disposeObject(this);
      }
      
      private function _numberEnter(e:Event) : void
      {
         e.stopImmediatePropagation();
         this.doPay(null);
      }
      
      public function setTitleText(value:String) : void
      {
         titleText = value;
      }
      
      public function hideSelectedBand() : void
      {
      }
      
      public function hideSelected() : void
      {
      }
      
      public function set itemID(value:int) : void
      {
         this._view.ItemID = value;
         this._shopItemInfo = ShopManager.Instance.getMoneyShopItemByTemplateID(this._view._itemID);
         this.perPrice();
      }
      
      public function set stoneNumber(value:int) : void
      {
         this._view.stoneNumber = value;
      }
      
      public function set maxLimit(value:int) : void
      {
         this._view.maxLimit = value;
      }
      
      private function perPrice() : void
      {
         this._unitPrice = GroupPurchaseManager.instance.price;
      }
      
      private function doPay(e:Event) : void
      {
         SoundManager.instance.play("008");
         if(this._view.isBand && PlayerManager.Instance.Self.BandMoney < this._view.stoneNumber * this._unitPrice)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.view.transfer.StoreIITransferBG.lijinbuzu"));
            return;
         }
         if(!this._view.isBand && PlayerManager.Instance.Self.Money < this._view.stoneNumber * this._unitPrice)
         {
            LeavePageManager.showFillFrame();
            return;
         }
         SocketManager.Instance.out.sendGroupPurchaseBuy(this._view.stoneNumber,this._view.isBand);
         this.dispose();
      }
      
      private function _response(e:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         if(e.responseCode == FrameEvent.CLOSE_CLICK || e.responseCode == FrameEvent.ESC_CLICK)
         {
            this.cancelMoney();
            ObjectUtils.disposeObject(this);
         }
         else if(e.responseCode == FrameEvent.ENTER_CLICK)
         {
            this.doPay(null);
         }
      }
      
      private function cancelMoney() : void
      {
      }
      
      public function set buyFrom(value:int) : void
      {
         this._buyFrom = value;
      }
      
      public function get buyFrom() : int
      {
         return this._buyFrom;
      }
      
      override public function dispose() : void
      {
         this.canDispose = false;
         super.dispose();
         this.removeEvnets();
         this._view = null;
         this._shopItemInfo = null;
         if(Boolean(this._submitButton))
         {
            ObjectUtils.disposeObject(this._submitButton);
         }
         this._submitButton = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

