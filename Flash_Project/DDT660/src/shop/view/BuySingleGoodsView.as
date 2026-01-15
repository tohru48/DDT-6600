package shop.view
{
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.NumberSelecter;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.Image;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.ShopType;
   import ddt.data.goods.Price;
   import ddt.data.goods.ShopCarItemInfo;
   import ddt.data.goods.ShopItemInfo;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.ShopManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.FilterWordManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import shop.manager.ShopSaleManager;
   
   public class BuySingleGoodsView extends Sprite implements Disposeable
   {
      
      public static const SHOP_CANNOT_FIND:String = "shopCannotfind";
      
      private var _frame:Frame;
      
      private var _shopCartItem:ShopCartItem;
      
      private var _commodityPricesText1:FilterFrameText;
      
      private var _commodityPricesText2:FilterFrameText;
      
      private var _commodityPricesText1Label:FilterFrameText;
      
      private var _commodityPricesText2Label:FilterFrameText;
      
      private var _needToPayTip:FilterFrameText;
      
      private var _purchaseConfirmationBtn:BaseButton;
      
      private var _numberSelecter:NumberSelecter;
      
      private var _goodsID:int;
      
      private var _isDisCount:Boolean = false;
      
      public var isSale:Boolean = false;
      
      private var _isBand:Boolean;
      
      private var _type:int;
      
      protected var _askBtn:SimpleBitmapButton;
      
      private var _shopPresentClearingFrame:ShopPresentClearingFrame;
      
      public function BuySingleGoodsView(type:int = 1)
      {
         super();
         this._type = type;
         this.initView();
         this.addEvent();
      }
      
      private function initView() : void
      {
         this._frame = ComponentFactory.Instance.creatComponentByStylename("core.ddtshop.CheckOutViewFrame");
         this._frame.titleText = LanguageMgr.GetTranslation("store.view.shortcutBuy.buyBtn");
         var bg:ScaleBitmapImage = ComponentFactory.Instance.creatComponentByStylename("core.ddtshop.CheckOutViewBg");
         this._frame.addToContent(bg);
         this._purchaseConfirmationBtn = ComponentFactory.Instance.creatComponentByStylename("core.ddtshop.SingleGoodView.PurchaseBtn");
         this._frame.addToContent(this._purchaseConfirmationBtn);
         var innerBg:Image = ComponentFactory.Instance.creatComponentByStylename("ddtshop.TotalMoneyPanel2");
         PositionUtils.setPos(innerBg,"ddtshop.CheckOutViewBgPos");
         this._frame.addToContent(innerBg);
         var textImg:Bitmap = ComponentFactory.Instance.creatBitmap("asset.ddtshop.PurchaseAmount");
         PositionUtils.setPos(textImg,"ddtshop.PurchaseAmountTextImgPos");
         this._frame.addToContent(textImg);
         this._numberSelecter = ComponentFactory.Instance.creatComponentByStylename("core.ddtshop.NumberSelecter");
         this._frame.addToContent(this._numberSelecter);
         this._needToPayTip = ComponentFactory.Instance.creatComponentByStylename("ddtshop.NeedToPayTip");
         this._needToPayTip.text = LanguageMgr.GetTranslation("shop.CheckOutView.NeedToPayTipText");
         PositionUtils.setPos(this._needToPayTip,"ddtshop.NeedToPayTipTextPos");
         this._frame.addToContent(this._needToPayTip);
         this._commodityPricesText1Label = ComponentFactory.Instance.creatComponentByStylename("ddtshop.CommodityPricesText1Label");
         this._commodityPricesText1Label.text = LanguageMgr.GetTranslation("shop.CheckOutView.CommodityPricesText1Label");
         this._commodityPricesText2Label = ComponentFactory.Instance.creatComponentByStylename("ddtshop.CommodityPricesText2Label");
         this._commodityPricesText2Label.text = LanguageMgr.GetTranslation("shop.CheckOutView.CommodityPricesText2Label");
         if(this._type == 3)
         {
            this._purchaseConfirmationBtn.visible = false;
            this._frame.titleText = LanguageMgr.GetTranslation("shop.ShopIIPresentView.ask");
            this._askBtn = ComponentFactory.Instance.creatComponentByStylename("core.ddtshop.askButton");
            this._askBtn.x = 120;
            this._askBtn.y = 280;
            this._askBtn.addEventListener(MouseEvent.CLICK,this.askBtnHander);
            this._frame.addToContent(this._askBtn);
         }
         else if(this._type != Price.DDT_MONEY)
         {
            this._isBand = false;
         }
         this._commodityPricesText1 = ComponentFactory.Instance.creatComponentByStylename("core.ddtshop.CommodityPricesText");
         this._commodityPricesText1.text = "0";
         PositionUtils.setPos(this._commodityPricesText1,"ddtshop.commodityPricesText1Pos");
         this._frame.addToContent(this._commodityPricesText1);
         this._commodityPricesText2 = ComponentFactory.Instance.creatComponentByStylename("core.ddtshop.CommodityPricesText");
         this._commodityPricesText2.text = "0";
         PositionUtils.setPos(this._commodityPricesText2,"ddtshop.commodityPricesText2Pos");
         this._frame.addToContent(this._commodityPricesText2);
         PositionUtils.setPos(this._commodityPricesText1Label,"ddtshop.commodityPricesText1LabelPos");
         PositionUtils.setPos(this._commodityPricesText2Label,"ddtshop.commodityPricesText2LabelPos");
         this._frame.addToContent(this._commodityPricesText1Label);
         this._frame.addToContent(this._commodityPricesText2Label);
         addChild(this._frame);
      }
      
      private function askBtnHander(e:MouseEvent) : void
      {
         this.payPanl();
      }
      
      private function payPanl() : void
      {
         this._shopPresentClearingFrame = ComponentFactory.Instance.creatComponentByStylename("core.ddtshop.ShopPresentClearingFrame");
         this._shopPresentClearingFrame.show();
         this._shopPresentClearingFrame.setType(ShopPresentClearingFrame.FPAYTYPE_SHOP);
         this._shopPresentClearingFrame.presentBtn.addEventListener(MouseEvent.CLICK,this.presentBtnClick);
         this._shopPresentClearingFrame.addEventListener(FrameEvent.RESPONSE,this.shopPresentClearingFrameResponseHandler);
      }
      
      protected function shopPresentClearingFrameResponseHandler(event:FrameEvent) : void
      {
         this._shopPresentClearingFrame.removeEventListener(FrameEvent.RESPONSE,this.shopPresentClearingFrameResponseHandler);
         if(Boolean(this._shopPresentClearingFrame.presentBtn))
         {
            this._shopPresentClearingFrame.presentBtn.removeEventListener(MouseEvent.CLICK,this.presentBtnClick);
         }
         if(event.responseCode == FrameEvent.CLOSE_CLICK || event.responseCode == FrameEvent.ESC_CLICK || event.responseCode == FrameEvent.CANCEL_CLICK)
         {
            this._shopPresentClearingFrame.dispose();
            this._shopPresentClearingFrame = null;
         }
      }
      
      protected function presentBtnClick(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         var name:String = this._shopPresentClearingFrame.nameInput.text;
         if(name == "")
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("shop.ShopIIPresentView.askPay"));
            return;
         }
         if(FilterWordManager.IsNullorEmpty(name))
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("shop.ShopIIPresentView.askSpace"));
            return;
         }
         this._shopPresentClearingFrame.presentBtn.removeEventListener(MouseEvent.CLICK,this.presentBtnClick);
         this._shopPresentClearingFrame.removeEventListener(FrameEvent.RESPONSE,this.shopPresentClearingFrameResponseHandler);
         this.sendAsk();
         this._shopPresentClearingFrame.dispose();
         this._shopPresentClearingFrame = null;
         this.dispose();
      }
      
      private function sendAsk() : void
      {
         var t:ShopCarItemInfo = null;
         var items:Array = [];
         var types:Array = [];
         var goodsTypes:Array = [];
         var colors:Array = [];
         var skins:Array = [];
         for(var i:int = 0; i < this._numberSelecter.currentValue; i++)
         {
            t = this._shopCartItem.shopItemInfo;
            items.push(t.GoodsID);
            types.push(t.currentBuyType);
            goodsTypes.push(t.isDiscount);
            colors.push(t.Color);
            skins.push(t.skin);
         }
         SocketManager.Instance.out.requestShopPay(items,types,goodsTypes,colors,skins,this._shopPresentClearingFrame.Name,this._shopPresentClearingFrame.textArea.text);
      }
      
      public function set isDisCount(value:Boolean) : void
      {
         this._isDisCount = value;
      }
      
      public function set goodsID(value:int) : void
      {
         var shopItemInfo:ShopItemInfo = null;
         var shopItem:ShopCarItemInfo = null;
         if(Boolean(this._shopCartItem))
         {
            this._shopCartItem.removeEventListener(ShopCartItem.CONDITION_CHANGE,this.__shopCartItemChange);
            this._shopCartItem.dispose();
         }
         this._goodsID = value;
         if(this.isSale)
         {
            shopItemInfo = ShopManager.Instance.getMoneySaleShopItemByTemplateID(this._goodsID);
         }
         else if(this._isDisCount)
         {
            shopItemInfo = ShopManager.Instance.getDisCountShopItemByGoodsID(this._goodsID);
         }
         else
         {
            shopItemInfo = ShopManager.Instance.getShopItemByGoodsID(this._goodsID);
         }
         if(!shopItemInfo)
         {
            shopItemInfo = ShopManager.Instance.getGoodsByTemplateID(this._goodsID);
         }
         if(Boolean(shopItemInfo))
         {
            shopItem = new ShopCarItemInfo(shopItemInfo.GoodsID,shopItemInfo.TemplateID);
            ObjectUtils.copyProperties(shopItem,shopItemInfo);
            this._shopCartItem = new ShopCartItem();
            PositionUtils.setPos(this._shopCartItem,"ddtshop.shopCartItemPos");
            this._shopCartItem.closeBtn.visible = false;
            this._shopCartItem.setShopItemInfo(shopItem);
            this._shopCartItem.setColor(shopItem.Color);
            this._frame.addToContent(this._shopCartItem);
            this._shopCartItem.addEventListener(ShopCartItem.CONDITION_CHANGE,this.__shopCartItemChange);
            this.updateCommodityPrices();
         }
      }
      
      private function addEvent() : void
      {
         this._purchaseConfirmationBtn.addEventListener(MouseEvent.CLICK,this.__purchaseConfirmationBtnClick);
         this._numberSelecter.addEventListener(Event.CHANGE,this.__numberSelecterChange);
         this._frame.addEventListener(FrameEvent.RESPONSE,this.__framePesponse);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.BUY_GOODS,this.onBuyedGoods);
      }
      
      private function removeEvent() : void
      {
         if(Boolean(this._askBtn))
         {
            this._askBtn.removeEventListener(MouseEvent.CLICK,this.askBtnHander);
         }
         if(Boolean(this._purchaseConfirmationBtn))
         {
            this._purchaseConfirmationBtn.removeEventListener(MouseEvent.CLICK,this.__purchaseConfirmationBtnClick);
         }
         if(Boolean(this._numberSelecter))
         {
            this._numberSelecter.removeEventListener(Event.CHANGE,this.__numberSelecterChange);
         }
         if(Boolean(this._shopCartItem))
         {
            this._shopCartItem.removeEventListener(ShopCartItem.CONDITION_CHANGE,this.__shopCartItemChange);
         }
         if(Boolean(this._frame))
         {
            this._frame.removeEventListener(FrameEvent.RESPONSE,this.__framePesponse);
         }
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.BUY_GOODS,this.onBuyedGoods);
      }
      
      private function updateCommodityPrices() : void
      {
         if(this._shopCartItem.shopItemInfo.getCurrentPrice().PriceType == Price.HARD_CURRENCY)
         {
            this._commodityPricesText1.text = (this._shopCartItem.shopItemInfo.getCurrentPrice().moneyValue * this._numberSelecter.currentValue).toString();
            this._commodityPricesText2.text = (this._shopCartItem.shopItemInfo.getCurrentPrice().hardCurrencyValue * this._numberSelecter.currentValue).toString();
            this._commodityPricesText2Label.text = Price.HARD_CURRENCY_TO_STRING;
         }
         else if(this._isBand)
         {
            this._commodityPricesText1.text = (this._shopCartItem.shopItemInfo.getCurrentPrice().bandDdtMoneyValue * this._numberSelecter.currentValue).toString();
            this._commodityPricesText2.text = (this._shopCartItem.shopItemInfo.getCurrentPrice().moneyValue * this._numberSelecter.currentValue).toString();
         }
         else
         {
            this._commodityPricesText1.text = (this._shopCartItem.shopItemInfo.getCurrentPrice().moneyValue * this._numberSelecter.currentValue).toString();
            this._commodityPricesText2.text = (this._shopCartItem.shopItemInfo.getCurrentPrice().bandDdtMoneyValue * this._numberSelecter.currentValue).toString();
         }
      }
      
      protected function __purchaseConfirmationBtnClick(event:MouseEvent) : void
      {
         var t:ShopCarItemInfo = null;
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         var moneyValue:int = this._shopCartItem.shopItemInfo.getCurrentPrice().moneyValue;
         if(this._isBand && PlayerManager.Instance.Self.BandMoney < moneyValue)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.view.transfer.StoreIITransferBG.lijinbuzu"));
            return;
         }
         if(!this._isBand && PlayerManager.Instance.Self.Money < moneyValue)
         {
            LeavePageManager.showFillFrame();
            return;
         }
         if(this._shopCartItem.shopItemInfo.ShopID == ShopType.SALE_SHOP && ShopSaleManager.Instance.goodsBuyMaxNum > 0)
         {
            if(this._numberSelecter.currentValue > ShopSaleManager.Instance.goodsBuyMaxNum)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("asset.ddtshop.notBuyMaxNum",ShopSaleManager.Instance.goodsBuyMaxNum));
               return;
            }
         }
         this._purchaseConfirmationBtn.enable = false;
         var items:Array = new Array();
         var types:Array = new Array();
         var colors:Array = new Array();
         var dresses:Array = new Array();
         var places:Array = new Array();
         var goodsTypes:Array = [];
         var bands:Array = [];
         for(var i:int = 0; i < this._numberSelecter.currentValue; i++)
         {
            t = this._shopCartItem.shopItemInfo;
            items.push(t.GoodsID);
            types.push(t.currentBuyType);
            colors.push("");
            dresses.push("");
            places.push("");
            goodsTypes.push(t.isDiscount);
            bands.push(this._isBand);
         }
         SocketManager.Instance.out.sendBuyGoods(items,types,colors,places,dresses,null,0,goodsTypes,bands);
      }
      
      protected function onBuyedGoods(event:CrazyTankSocketEvent) : void
      {
         this._purchaseConfirmationBtn.enable = true;
         event.pkg.position = SocketManager.PACKAGE_CONTENT_START_INDEX;
         var success:int = event.pkg.readInt();
         if(success != 0)
         {
            this.dispose();
         }
      }
      
      protected function __numberSelecterChange(event:Event) : void
      {
         SoundManager.instance.play("008");
         this.updateCommodityPrices();
      }
      
      protected function __shopCartItemChange(event:Event) : void
      {
         this.updateCommodityPrices();
      }
      
      protected function __framePesponse(event:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         switch(event.responseCode)
         {
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.ESC_CLICK:
               this.dispose();
         }
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         if(Boolean(this._frame))
         {
            ObjectUtils.disposeObject(this._frame);
         }
         this._frame = null;
         ObjectUtils.disposeObject(this._askBtn);
         this._askBtn = null;
         if(Boolean(this._shopCartItem))
         {
            ObjectUtils.disposeObject(this._shopCartItem);
         }
         this._shopCartItem = null;
         if(Boolean(this._needToPayTip))
         {
            ObjectUtils.disposeObject(this._needToPayTip);
         }
         this._needToPayTip = null;
         if(Boolean(this._commodityPricesText1))
         {
            ObjectUtils.disposeObject(this._commodityPricesText1);
         }
         this._commodityPricesText1 = null;
         if(Boolean(this._commodityPricesText2))
         {
            ObjectUtils.disposeObject(this._commodityPricesText2);
         }
         this._commodityPricesText2 = null;
         if(Boolean(this._purchaseConfirmationBtn))
         {
            ObjectUtils.disposeObject(this._purchaseConfirmationBtn);
         }
         this._purchaseConfirmationBtn = null;
         if(Boolean(this._numberSelecter))
         {
            ObjectUtils.disposeObject(this._numberSelecter);
         }
         this._numberSelecter = null;
         if(Boolean(this._commodityPricesText1Label))
         {
            ObjectUtils.disposeObject(this._commodityPricesText1Label);
         }
         this._commodityPricesText1Label = null;
         if(Boolean(this._commodityPricesText2Label))
         {
            ObjectUtils.disposeObject(this._commodityPricesText2Label);
         }
         this._commodityPricesText2Label = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

