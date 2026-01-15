package ddt.command
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.EquipType;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.data.goods.ShopItemInfo;
   import ddt.events.BagEvent;
   import ddt.events.ShortcutBuyEvent;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SharedManager;
   import ddt.manager.ShopManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class QuickBuyFrame extends Frame
   {
      
      public var canDispose:Boolean;
      
      private var _view:QuickBuyFrameView;
      
      private var _shopItemInfo:ShopItemInfo;
      
      private var _submitButton:TextButton;
      
      private var _unitPrice:Number;
      
      private var _buyFrom:int;
      
      private var _recordLastBuyCount:Boolean;
      
      private var _flag:Boolean;
      
      public function QuickBuyFrame()
      {
         super();
         this.canDispose = true;
         this.initView();
         this.initEvents();
      }
      
      private function initView() : void
      {
         this._view = new QuickBuyFrameView();
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
      
      public function set itemID(value:int) : void
      {
         this._view.ItemID = value;
         this._shopItemInfo = ShopManager.Instance.getMoneyShopItemByTemplateID(this._view._itemID,false);
         this.perPrice();
      }
      
      public function setIsStoneExploreView(value:Boolean) : void
      {
         this._flag = value;
      }
      
      public function setItemID(ID:int, type:int, param:int = 1) : void
      {
         this._view.setItemID(ID,type,param);
         this._shopItemInfo = ShopManager.Instance.getShopItemByTemplateID(this._view._itemID,type);
         if(type == 1)
         {
            this._unitPrice = this._shopItemInfo.getItemPrice(1).hardCurrencyValue;
         }
         else if(type == 2)
         {
            this._unitPrice = this._shopItemInfo.getItemPrice(1).gesteValue;
         }
         else if(type == 3)
         {
            this._unitPrice = this._shopItemInfo.getItemPrice(param).moneyValue;
         }
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
         var itemInfo:ShopItemInfo = ShopManager.Instance.getMoneyShopItemByTemplateID(this._view.ItemID);
         this._unitPrice = itemInfo.getItemPrice(1).moneyValue;
      }
      
      public function set recordLastBuyCount(value:Boolean) : void
      {
         this._recordLastBuyCount = value;
         if(this._recordLastBuyCount)
         {
            this._view.stoneNumber = SharedManager.Instance.lastBuyCount;
         }
      }
      
      private function doPay(e:Event) : void
      {
         var items:Array = null;
         var types:Array = null;
         var colors:Array = null;
         var dresses:Array = null;
         var skins:Array = null;
         var places:Array = null;
         var bands:Array = null;
         var i:int = 0;
         SoundManager.instance.play("008");
         if(!this._shopItemInfo.isValid)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.caddy.quickDate"));
         }
         if(this._view.type == 0 || this._view.type == 3)
         {
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
         }
         else if(this._view.type == 1)
         {
            if(!this._view.isBand && PlayerManager.Instance.Self.hardCurrency < this._view.stoneNumber * this._unitPrice)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("shop.view.lackCoin"));
               return;
            }
         }
         else if(this._view.type == 2)
         {
            if(!this._view.isBand && PlayerManager.Instance.Self.Offer < this._view.stoneNumber * this._unitPrice)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ConsortiaShopItem.gongXunbuzu"));
               return;
            }
         }
         if(this._recordLastBuyCount)
         {
            SharedManager.Instance.lastBuyCount = this._view.stoneNumber;
         }
         if(this._view.ItemID == EquipType.GOLD_BOX)
         {
            SocketManager.Instance.out.sendQuickBuyGoldBox(this._view.stoneNumber,this._view.isBand);
         }
         else
         {
            items = [];
            types = [];
            colors = [];
            dresses = [];
            skins = [];
            places = [];
            bands = [];
            for(i = 0; i < this._view.stoneNumber; i++)
            {
               items.push(this._shopItemInfo.GoodsID);
               types.push(this._view.time);
               colors.push("");
               dresses.push(false);
               skins.push("");
               places.push(-1);
               bands.push(this._view.isBand);
            }
            SocketManager.Instance.out.sendBuyGoods(items,types,colors,places,dresses,skins,this._buyFrom,null,bands);
            if(this._shopItemInfo.GoodsID == 1195801)
            {
               SocketManager.Instance.out.requestCakeStatus();
            }
         }
         dispatchEvent(new ShortcutBuyEvent(this._view._itemID,this._view.stoneNumber));
         var itemInfo:ItemTemplateInfo = ItemManager.Instance.getTemplateById(this._view._itemID);
         if(itemInfo.CategoryID == 11 && !this._flag)
         {
            if(itemInfo.TemplateID == 100100)
            {
               PlayerManager.Instance.dispatchEvent(new BagEvent(BagEvent.GEMSTONE_BUG_COUNT,null));
            }
            else if(itemInfo.TemplateID != 112150)
            {
               PlayerManager.Instance.dispatchEvent(new BagEvent(BagEvent.QUICK_BUG_CARDS,null));
            }
         }
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
      
      private function _responseI(e:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         if(e.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            this.doMoney();
         }
         else
         {
            this.cancelMoney();
         }
         ObjectUtils.disposeObject(e.target);
      }
      
      private function doMoney() : void
      {
         LeavePageManager.leaveToFillPath();
         dispatchEvent(new ShortcutBuyEvent(0,0,false,false,ShortcutBuyEvent.SHORTCUT_BUY_MONEY_OK));
      }
      
      private function cancelMoney() : void
      {
         dispatchEvent(new ShortcutBuyEvent(0,0,false,false,ShortcutBuyEvent.SHORTCUT_BUY_MONEY_CANCEL));
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
         this._recordLastBuyCount = false;
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

