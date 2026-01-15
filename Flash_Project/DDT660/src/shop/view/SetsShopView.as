package shop.view
{
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.SelectedCheckButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class SetsShopView extends ShopCheckOutView
   {
      
      private var _allCheckBox:SelectedCheckButton;
      
      private var _setsPrice:int = 99;
      
      private var _selectedAll:Boolean = true;
      
      private var _totalPrice:int;
      
      public function SetsShopView()
      {
         super();
      }
      
      public function initialize(list:Array) : void
      {
         this.init();
         this.initEvent();
         setList(list);
         _commodityPricesText2.text = "0";
         _purchaseConfirmationBtn.visible = true;
         _commodityNumberTip.htmlText = LanguageMgr.GetTranslation("shop.setsshopview.commodity");
         PositionUtils.setPos(_commodityNumberTip,"ddt.setsShopView.pos");
         _commodityNumberText.visible = false;
         this._allCheckBox.selected = true;
         this._allCheckBox.dispatchEvent(new Event(Event.SELECT));
      }
      
      override protected function drawFrame() : void
      {
         _frame = ComponentFactory.Instance.creatComponentByStylename("core.ddtshop.setsShopView");
         _frame.titleText = LanguageMgr.GetTranslation("shop.SetsTitle");
         addChild(_frame);
      }
      
      override protected function init() : void
      {
         super.init();
         this._allCheckBox = ComponentFactory.Instance.creatComponentByStylename("ddtshop.SetsShopView.SetsShopALLCheckBox");
         this._allCheckBox.text = LanguageMgr.GetTranslation("tank.view.emailII.readView.textBtnFont1");
         _frame.addToContent(this._allCheckBox);
         this.fixPos();
      }
      
      private function fixPos() : void
      {
         _commodityNumberTip.y += 8;
         _commodityNumberText.y += 8;
         _innerBg1.y += 18;
         _needToPayTip.y += 18;
         _commodityPricesText1.y += 18;
         _commodityPricesText2.y += 18;
         _commodityPricesText1Label.y += 18;
         _commodityPricesText2Label.y += 18;
         _purchaseConfirmationBtn.y += 18;
         _giftsBtn.y += 18;
         _saveImageBtn.y += 18;
      }
      
      override protected function initEvent() : void
      {
         super.initEvent();
         this._allCheckBox.addEventListener(MouseEvent.CLICK,this.__soundPlay);
         this._allCheckBox.addEventListener(Event.SELECT,this.__allSelected);
      }
      
      protected function __soundPlay(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
      }
      
      override protected function removeEvent() : void
      {
         super.removeEvent();
         this._allCheckBox.removeEventListener(MouseEvent.CLICK,this.__soundPlay);
         this._allCheckBox.removeEventListener(Event.SELECT,this.__allSelected);
      }
      
      private function __allSelected(event:Event) : void
      {
         var item:SetsShopItem = null;
         var i:int = 0;
         var j:int = 0;
         if(this._allCheckBox.selected)
         {
            for(i = 0; i < _cartList.numChildren; i++)
            {
               item = _cartList.getChildAt(i) as SetsShopItem;
               if(Boolean(item))
               {
                  item.selected = true;
               }
            }
         }
         else
         {
            for(j = 0; j < _cartList.numChildren; j++)
            {
               item = _cartList.getChildAt(j) as SetsShopItem;
               if(Boolean(item))
               {
                  item.selected = false;
               }
            }
         }
         this.updateTxt();
      }
      
      override protected function addItemEvent(item:ShopCartItem) : void
      {
         super.addItemEvent(item);
         item.addEventListener(Event.SELECT,this.__itemSelectedChanged);
      }
      
      private function __itemSelectedChanged(event:Event) : void
      {
         this.updateTxt();
      }
      
      override protected function removeItemEvent(item:ShopCartItem) : void
      {
         super.removeItemEvent(item);
         item.removeEventListener(Event.SELECT,this.__itemSelectedChanged);
      }
      
      override protected function createShopItem() : ShopCartItem
      {
         return new SetsShopItem();
      }
      
      override protected function updateTxt() : void
      {
         var selectedCount:int = 0;
         var itemCount:int = 0;
         var item:SetsShopItem = null;
         this._totalPrice = 0;
         for(var i:int = 0; i < _cartList.numChildren; i++)
         {
            item = _cartList.getChildAt(i) as SetsShopItem;
            if(Boolean(item))
            {
               itemCount++;
               if(item.selected)
               {
                  this._totalPrice += item.shopItemInfo.AValue1;
                  selectedCount++;
               }
            }
         }
         _commodityNumberText.text = selectedCount.toString();
         if(itemCount > 0 && selectedCount >= itemCount)
         {
            _commodityPricesText1.text = this._setsPrice.toString();
            this._totalPrice = this._setsPrice;
         }
         else if(itemCount > 0)
         {
            _commodityPricesText1.text = this._totalPrice.toString();
         }
         _commodityNumberText.text = String(selectedCount);
         if(selectedCount > 0)
         {
            _purchaseConfirmationBtn.enable = true;
         }
         else
         {
            _purchaseConfirmationBtn.enable = false;
         }
      }
      
      override protected function __purchaseConfirmationBtnClick(event:MouseEvent = null) : void
      {
         var item:SetsShopItem = null;
         var alert:BaseAlerFrame = null;
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         if(PlayerManager.Instance.Self.Money < this._totalPrice)
         {
            alert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("poorNote"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,false,LayerManager.BLCAK_BLOCKGOUND);
            alert.moveEnable = false;
            alert.addEventListener(FrameEvent.RESPONSE,this.__poorManResponse);
            return;
         }
         var items:Array = [];
         for(var j:int = 0; j < _cartList.numChildren; j++)
         {
            item = _cartList.getChildAt(j) as SetsShopItem;
            if(Boolean(item) && item.selected)
            {
               items.push(item.shopItemInfo.GoodsID);
            }
         }
         SocketManager.Instance.out.sendUseCard(-1,-1,items,1);
         ObjectUtils.disposeObject(this);
      }
      
      private function __poorManResponse(event:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         event.currentTarget.removeEventListener(FrameEvent.RESPONSE,this.__poorManResponse);
         ObjectUtils.disposeObject(event.currentTarget);
         if(event.responseCode == FrameEvent.SUBMIT_CLICK || event.responseCode == FrameEvent.ENTER_CLICK)
         {
            LeavePageManager.leaveToFillPath();
         }
      }
   }
}

