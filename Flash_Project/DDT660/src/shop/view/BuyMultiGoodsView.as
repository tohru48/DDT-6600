package shop.view
{
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.Image;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.EquipType;
   import ddt.data.goods.ShopCarItemInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.ShopManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import shop.manager.ShopBuyManager;
   
   public class BuyMultiGoodsView extends Sprite implements Disposeable
   {
      
      private var _bg:Image;
      
      private var _commodityNumberTip:FilterFrameText;
      
      private var _commodityNumberText:FilterFrameText;
      
      private var _commodityPricesText1:FilterFrameText;
      
      private var _commodityPricesText2:FilterFrameText;
      
      private var _commodityPricesText1Label:FilterFrameText;
      
      private var _commodityPricesText2Label:FilterFrameText;
      
      private var _needToPayTip:FilterFrameText;
      
      private var _purchaseConfirmationBtn:BaseButton;
      
      private var _buyArray:Vector.<ShopCarItemInfo>;
      
      private var _cartList:VBox;
      
      private var _cartScroll:ScrollPanel;
      
      private var _frame:Frame;
      
      private var _innerBg1:Image;
      
      private var _innerBg:Bitmap;
      
      private var _extraTextButton:BaseButton;
      
      public var dressing:Boolean = false;
      
      private var _commodityPricesText3Label:FilterFrameText;
      
      private var _commodityPricesText3:FilterFrameText;
      
      public function BuyMultiGoodsView()
      {
         super();
         this.initView();
         this.initEvents();
      }
      
      private function initView() : void
      {
         this._frame = ComponentFactory.Instance.creatComponentByStylename("ddtshop.CheckOutViewFrame");
         this._frame.titleText = LanguageMgr.GetTranslation("shop.Shop.car");
         addChild(this._frame);
         this._cartList = new VBox();
         this._bg = ComponentFactory.Instance.creatComponentByStylename("ddtshop.CheckOutViewBg");
         this._purchaseConfirmationBtn = ComponentFactory.Instance.creatComponentByStylename("ddtshop.PurchaseBtn");
         this._cartScroll = ComponentFactory.Instance.creatComponentByStylename("ddtshop.CheckOutViewItemList");
         this._extraTextButton = ComponentFactory.Instance.creatComponentByStylename("ddtshop.PurchaseBtn");
         this._cartScroll.setView(this._cartList);
         this._cartScroll.vScrollProxy = ScrollPanel.ON;
         this._cartList.spacing = 5;
         this._cartList.strictSize = 80;
         this._cartList.isReverAdd = true;
         this._frame.addToContent(this._bg);
         this._innerBg1 = ComponentFactory.Instance.creatComponentByStylename("ddtshop.TotalMoneyPanel");
         this._frame.addToContent(this._innerBg1);
         this._commodityNumberTip = ComponentFactory.Instance.creatComponentByStylename("ddtshop.CommodityNumberTipText");
         this._commodityNumberTip.text = LanguageMgr.GetTranslation("shop.CheckOutView.CommodityNumberTip");
         this._frame.addToContent(this._commodityNumberTip);
         this._commodityNumberText = ComponentFactory.Instance.creatComponentByStylename("ddtshop.CommodityNumberText");
         this._frame.addToContent(this._commodityNumberText);
         this._needToPayTip = ComponentFactory.Instance.creatComponentByStylename("ddtshop.NeedToPayTip");
         this._needToPayTip.text = LanguageMgr.GetTranslation("shop.CheckOutView.NeedToPayTipText");
         this._frame.addToContent(this._needToPayTip);
         this._commodityPricesText1 = ComponentFactory.Instance.creatComponentByStylename("ddtshop.CommodityPricesText1");
         this._commodityPricesText2 = ComponentFactory.Instance.creatComponentByStylename("ddtshop.CommodityPricesText2");
         this._commodityPricesText3 = ComponentFactory.Instance.creatComponentByStylename("ddtshop.CommodityPricesText3");
         this._commodityPricesText1Label = ComponentFactory.Instance.creatComponentByStylename("ddtshop.CommodityPricesText1Label");
         this._commodityPricesText1Label.text = LanguageMgr.GetTranslation("shop.CheckOutView.CommodityPricesText1Label");
         this._commodityPricesText2Label = ComponentFactory.Instance.creatComponentByStylename("ddtshop.CommodityPricesText2Label");
         this._commodityPricesText2Label.text = LanguageMgr.GetTranslation("shop.CheckOutView.CommodityPricesText2Label");
         this._frame.addToContent(this._commodityPricesText1Label);
         this._frame.addToContent(this._commodityPricesText2Label);
         this._frame.addToContent(this._commodityPricesText1);
         this._frame.addToContent(this._commodityPricesText2);
         this._frame.addToContent(this._commodityPricesText3);
         this._frame.addToContent(this._cartScroll);
         this._frame.addToContent(this._purchaseConfirmationBtn);
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_TOP_LAYER,true,LayerManager.ALPHA_BLOCKGOUND,true);
      }
      
      protected function updateTxt() : void
      {
         var prices:Array = ShopBuyManager.calcPrices(this._buyArray);
         this._commodityNumberText.text = String(this._buyArray.length);
         this._commodityPricesText1.text = String(prices[1]);
         this._commodityPricesText3.text = String(prices[2]);
      }
      
      private function initEvents() : void
      {
         this._purchaseConfirmationBtn.addEventListener(MouseEvent.CLICK,this.__buyAvatar);
         this._frame.addEventListener(FrameEvent.RESPONSE,this.__onResponse);
      }
      
      private function removeEvents() : void
      {
         this._purchaseConfirmationBtn.removeEventListener(MouseEvent.CLICK,this.__buyAvatar);
         this._frame.removeEventListener(FrameEvent.RESPONSE,this.__onResponse);
      }
      
      private function __onResponse(event:FrameEvent) : void
      {
         switch(event.responseCode)
         {
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.ESC_CLICK:
               SoundManager.instance.playButtonSound();
               this.dispose();
         }
      }
      
      private function __buyAvatar(event:MouseEvent) : void
      {
         var item:ShopCarItemInfo = null;
         var canbuy:Array = null;
         var item2:ShopCartItem = null;
         var item1:ShopCarItemInfo = null;
         var t:ShopCarItemInfo = null;
         SoundManager.instance.play("008");
         var money:int = int(this._commodityPricesText1.text);
         var bandMoney:int = int(this._commodityPricesText2.text);
         var orderMoney:int = int(this._commodityPricesText3.text);
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         if(bandMoney > PlayerManager.Instance.Self.BandMoney)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.view.transfer.StoreIITransferBG.lijinbuzu"));
            return;
         }
         if(money > PlayerManager.Instance.Self.Money)
         {
            LeavePageManager.showFillFrame();
            return;
         }
         var buy:Array = [];
         for each(item in this._buyArray)
         {
            buy.push(item);
         }
         canbuy = ShopManager.Instance.buyIt(buy);
         if(canbuy.length == 0)
         {
            for each(item1 in this._buyArray)
            {
               if(item1.getCurrentPrice().moneyValue > 0)
               {
                  LeavePageManager.showFillFrame();
                  return;
               }
            }
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("shop.view.lackCoin"));
            return;
         }
         if(canbuy.length < this._buyArray.length)
         {
         }
         var items:Array = new Array();
         var types:Array = new Array();
         var colors:Array = new Array();
         var dresses:Array = new Array();
         var places:Array = new Array();
         var skins:Array = [];
         for(var i:int = 0; i < canbuy.length; i++)
         {
            t = canbuy[i];
            items.push(t.GoodsID);
            types.push(t.currentBuyType);
            colors.push(t.Color);
            places.push(t.place);
            if(t.CategoryID == EquipType.FACE)
            {
               skins.push(t.skin);
            }
            else
            {
               skins.push("");
            }
            dresses.push(this.dressing);
         }
         SocketManager.Instance.out.sendBuyGoods(items,types,colors,places,dresses,skins);
         var ch:Array = [];
         for(var j:int = this._cartList.numChildren - 1; j >= 0; j--)
         {
            ch.push(this._cartList.getChildAt(j));
         }
         for each(item2 in ch)
         {
            if(canbuy.indexOf(item2.shopItemInfo) > -1)
            {
               item2.removeEventListener(ShopCartItem.DELETE_ITEM,this.__deleteItem);
               item2.removeEventListener(ShopCartItem.CONDITION_CHANGE,this.__conditionChange);
               this._cartList.removeChild(item2);
               this._buyArray.splice(this._buyArray.indexOf(item2.shopItemInfo),1);
               item2.dispose();
            }
         }
         if(this._cartList.numChildren == 0)
         {
            this.dispose();
         }
         else
         {
            this.updateTxt();
         }
      }
      
      public function setGoods(value:Vector.<ShopCarItemInfo>) : void
      {
         var info:ShopCarItemInfo = null;
         var item:ShopCartItem = null;
         var cItem:ShopCartItem = null;
         while(this._cartList.numChildren > 0)
         {
            item = this._cartList.getChildAt(this._cartList.numChildren - 1) as ShopCartItem;
            item.removeEventListener(ShopCartItem.DELETE_ITEM,this.__deleteItem);
            item.removeEventListener(ShopCartItem.CONDITION_CHANGE,this.__conditionChange);
            this._cartList.removeChild(item);
            item.dispose();
         }
         this._buyArray = value;
         for each(info in this._buyArray)
         {
            cItem = new ShopCartItem();
            cItem.setShopItemInfo(info);
            cItem.setColor(info.Color);
            this._cartList.addChild(cItem);
            cItem.addEventListener(ShopCartItem.DELETE_ITEM,this.__deleteItem);
            cItem.addEventListener(ShopCartItem.CONDITION_CHANGE,this.__conditionChange);
         }
         this._cartScroll.invalidateViewport();
         this.updateTxt();
      }
      
      private function __conditionChange(evt:Event) : void
      {
         this.updateTxt();
      }
      
      private function __deleteItem(evt:Event) : void
      {
         var item:ShopCartItem = evt.currentTarget as ShopCartItem;
         var shopItemInfo:ShopCarItemInfo = item.shopItemInfo;
         item.removeEventListener(ShopCartItem.DELETE_ITEM,this.__deleteItem);
         item.removeEventListener(ShopCartItem.CONDITION_CHANGE,this.__conditionChange);
         this._cartList.removeChild(item);
         var index:int = int(this._buyArray.indexOf(shopItemInfo));
         this._buyArray.splice(index,1);
         this.updateTxt();
         this._cartScroll.invalidateViewport();
         if(this._buyArray.length < 1)
         {
            this.dispose();
         }
      }
      
      public function dispose() : void
      {
         var item:ShopCartItem = null;
         this.removeEvents();
         while(this._cartList.numChildren > 0)
         {
            item = this._cartList.getChildAt(this._cartList.numChildren - 1) as ShopCartItem;
            item.removeEventListener(ShopCartItem.DELETE_ITEM,this.__deleteItem);
            item.removeEventListener(ShopCartItem.CONDITION_CHANGE,this.__conditionChange);
            this._cartList.removeChild(item);
            item.dispose();
         }
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         ObjectUtils.disposeObject(this._commodityNumberTip);
         this._commodityNumberTip = null;
         ObjectUtils.disposeObject(this._commodityNumberText);
         this._commodityNumberText = null;
         ObjectUtils.disposeObject(this._commodityPricesText1);
         this._commodityPricesText1 = null;
         ObjectUtils.disposeObject(this._commodityPricesText2);
         this._commodityPricesText2 = null;
         ObjectUtils.disposeObject(this._commodityPricesText3);
         this._commodityPricesText3 = null;
         ObjectUtils.disposeObject(this._commodityPricesText1Label);
         ObjectUtils.disposeObject(this._commodityPricesText2Label);
         this._commodityPricesText1Label = null;
         this._commodityPricesText2Label = null;
         ObjectUtils.disposeObject(this._needToPayTip);
         this._needToPayTip = null;
         ObjectUtils.disposeObject(this._purchaseConfirmationBtn);
         this._purchaseConfirmationBtn = null;
         this._buyArray = null;
         ObjectUtils.disposeObject(this._cartList);
         this._cartList = null;
         ObjectUtils.disposeObject(this._cartScroll);
         this._cartScroll = null;
         ObjectUtils.disposeObject(this._frame);
         this._frame = null;
         ObjectUtils.disposeObject(this._bg);
         this._innerBg1 = null;
         ObjectUtils.disposeObject(this._innerBg1);
         this._innerBg = null;
         ObjectUtils.disposeObject(this._extraTextButton);
         this._extraTextButton = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

