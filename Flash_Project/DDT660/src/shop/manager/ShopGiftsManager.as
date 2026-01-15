package shop.manager
{
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.NumberSelecter;
   import com.pickgliss.ui.controls.SelectedCheckButton;
   import com.pickgliss.ui.image.Image;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
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
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import shop.view.ShopCartItem;
   import shop.view.ShopPresentClearingFrame;
   
   public class ShopGiftsManager
   {
      
      private static var _instance:ShopGiftsManager;
      
      private var _frame:Frame;
      
      private var _shopCartItem:ShopCartItem;
      
      private var _titleTxt:FilterFrameText;
      
      private var _commodityPricesText1:FilterFrameText;
      
      private var _commodityPricesText2:FilterFrameText;
      
      private var _commodityPricesText1Label:FilterFrameText;
      
      private var _commodityPricesText2Label:FilterFrameText;
      
      private var _needToPayTip:FilterFrameText;
      
      private var _giftsBtn:BaseButton;
      
      private var _numberSelecter:NumberSelecter;
      
      private var _goodsID:int;
      
      private var _isDiscountType:Boolean = true;
      
      private var _shopPresentClearingFrame:ShopPresentClearingFrame;
      
      private var _isBand:Boolean;
      
      private var _selectedBtn:SelectedCheckButton;
      
      private var _selectedBandBtn:SelectedCheckButton;
      
      private var _moneyTxt:FilterFrameText;
      
      private var _bandMoneyTxt:FilterFrameText;
      
      private var _back:MovieClip;
      
      private var _type:int = 0;
      
      public function ShopGiftsManager()
      {
         super();
      }
      
      public static function get Instance() : ShopGiftsManager
      {
         if(_instance == null)
         {
            _instance = new ShopGiftsManager();
         }
         return _instance;
      }
      
      public function buy($goodsID:int, $isDiscountType:Boolean = false, type:int = 1) : void
      {
         if(Boolean(this._frame))
         {
            return;
         }
         this._goodsID = $goodsID;
         this._isDiscountType = $isDiscountType;
         this._type = type;
         this.initView();
         this.addEvent();
         LayerManager.Instance.addToLayer(this._frame,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      private function initView() : void
      {
         this._frame = ComponentFactory.Instance.creatComponentByStylename("core.ddtshop.CheckOutViewFrame");
         this._frame.titleText = LanguageMgr.GetTranslation("shop.view.present");
         this._titleTxt = ComponentFactory.Instance.creatComponentByStylename("shop.PresentFrame.titleText");
         this._titleTxt.text = LanguageMgr.GetTranslation("shop.PresentFrame.titleText");
         this._frame.addToContent(this._titleTxt);
         var bg:Image = ComponentFactory.Instance.creatComponentByStylename("core.ddtshop.CheckOutViewBg");
         this._frame.addToContent(bg);
         this._giftsBtn = ComponentFactory.Instance.creatComponentByStylename("ddtshop.GiftManager.GiftBtn");
         this._frame.addToContent(this._giftsBtn);
         if(this._type == 1)
         {
            this._back = ComponentFactory.Instance.creat("asset.core.stranDown");
            this._back.x = 208;
            this._back.y = 210;
            this._selectedBtn = ComponentFactory.Instance.creatComponentByStylename("com.quickBuyFrame.selectBtn");
            this._selectedBtn.x = 99;
            this._selectedBtn.y = 193;
            this._selectedBtn.enable = false;
            this._selectedBtn.selected = true;
            this._selectedBtn.addEventListener(MouseEvent.CLICK,this.seletedHander);
            this._isBand = false;
            this._selectedBandBtn = ComponentFactory.Instance.creatComponentByStylename("com.quickBuyFrame.selectbandBtn");
            this._selectedBandBtn.x = 237;
            this._selectedBandBtn.y = 193;
            this._selectedBandBtn.addEventListener(MouseEvent.CLICK,this.selectedBandHander);
            this._moneyTxt = ComponentFactory.Instance.creatComponentByStylename("core.ddtshop.CommodityPricesText");
            this._moneyTxt.text = LanguageMgr.GetTranslation("tank.auctionHouse.view.AuctionBrowseView.stipple");
            this._moneyTxt.x = 100;
            this._moneyTxt.y = 199;
            this._bandMoneyTxt = ComponentFactory.Instance.creatComponentByStylename("core.ddtshop.CommodityPricesText");
            this._bandMoneyTxt.x = 253;
            this._bandMoneyTxt.y = 199;
            this._bandMoneyTxt.text = LanguageMgr.GetTranslation("tank.auctionHouse.view.AuctionBrowseView.bandStipple");
         }
         var innerBg:Image = ComponentFactory.Instance.creatComponentByStylename("ddtshop.TotalMoneyPanel2");
         PositionUtils.setPos(innerBg,"ddtshop.CheckOutViewBgPos");
         this._frame.addToContent(innerBg);
         var shopItemInfo:ShopItemInfo = null;
         if(!this._isDiscountType)
         {
            shopItemInfo = ShopManager.Instance.getShopItemByGoodsID(this._goodsID);
            if(shopItemInfo == null)
            {
               shopItemInfo = ShopManager.Instance.getGoodsByTemplateID(this._goodsID);
            }
         }
         else
         {
            shopItemInfo = ShopManager.Instance.getDisCountShopItemByGoodsID(this._goodsID);
         }
         var shopItem:ShopCarItemInfo = new ShopCarItemInfo(shopItemInfo.GoodsID,shopItemInfo.TemplateID);
         ObjectUtils.copyProperties(shopItem,shopItemInfo);
         this._shopCartItem = new ShopCartItem();
         PositionUtils.setPos(this._shopCartItem,"ddtshop.shopCartItemPos");
         this._shopCartItem.closeBtn.visible = false;
         this._shopCartItem.setShopItemInfo(shopItem);
         this._shopCartItem.setColor(shopItem.Color);
         this._frame.addToContent(this._shopCartItem);
         var textImg:Bitmap = ComponentFactory.Instance.creatBitmap("asset.ddtshop.PurchaseAmount");
         PositionUtils.setPos(textImg,"ddtshop.PurchaseAmountTextImgPos");
         this._frame.addToContent(textImg);
         this._numberSelecter = ComponentFactory.Instance.creatComponentByStylename("core.ddtshop.NumberSelecter");
         this._frame.addToContent(this._numberSelecter);
         this._needToPayTip = ComponentFactory.Instance.creatComponentByStylename("ddtshop.NeedToPayTip");
         this._needToPayTip.text = LanguageMgr.GetTranslation("shop.CheckOutView.NeedToPayTipText");
         PositionUtils.setPos(this._needToPayTip,"ddtshop.NeedToPayTipTextPos");
         this._frame.addToContent(this._needToPayTip);
         this._commodityPricesText1 = ComponentFactory.Instance.creatComponentByStylename("core.ddtshop.CommodityPricesText");
         PositionUtils.setPos(this._commodityPricesText1,"ddtshop.commodityPricesText1Pos");
         this._commodityPricesText1.text = "0";
         this._frame.addToContent(this._commodityPricesText1);
         this._commodityPricesText2 = ComponentFactory.Instance.creatComponentByStylename("core.ddtshop.CommodityPricesText");
         PositionUtils.setPos(this._commodityPricesText2,"ddtshop.commodityPricesText2Pos");
         this._commodityPricesText2.text = "0";
         this._frame.addToContent(this._commodityPricesText2);
         this._commodityPricesText1Label = ComponentFactory.Instance.creatComponentByStylename("ddtshop.CommodityPricesText1Label");
         this._commodityPricesText1Label.text = LanguageMgr.GetTranslation("shop.CheckOutView.CommodityPricesText1Label");
         this._commodityPricesText2Label = ComponentFactory.Instance.creatComponentByStylename("ddtshop.CommodityPricesText2Label");
         this._commodityPricesText2Label.text = LanguageMgr.GetTranslation("shop.CheckOutView.CommodityPricesText2Label");
         PositionUtils.setPos(this._commodityPricesText1Label,"ddtshop.commodityPricesText1LabelPos");
         PositionUtils.setPos(this._commodityPricesText2Label,"ddtshop.commodityPricesText2LabelPos");
         this._frame.addToContent(this._commodityPricesText1Label);
         this._frame.addToContent(this._commodityPricesText2Label);
         this.updateCommodityPrices();
      }
      
      private function addEvent() : void
      {
         this._giftsBtn.addEventListener(MouseEvent.CLICK,this.__giftsBtnClick);
         this._numberSelecter.addEventListener(Event.CHANGE,this.__numberSelecterChange);
         this._shopCartItem.addEventListener(ShopCartItem.CONDITION_CHANGE,this.__shopCartItemChange);
         this._frame.addEventListener(FrameEvent.RESPONSE,this.__framePesponse);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GOODS_PRESENT,this.onPresent);
      }
      
      protected function selectedBandHander(event:MouseEvent) : void
      {
         if(this._selectedBandBtn.selected)
         {
            this._isBand = true;
            this._selectedBandBtn.enable = false;
            this._selectedBtn.selected = false;
            this._selectedBtn.enable = true;
         }
         else
         {
            this._isBand = false;
         }
         this.updateCommodityPrices();
      }
      
      protected function seletedHander(event:MouseEvent) : void
      {
         if(this._selectedBtn.selected)
         {
            this._isBand = false;
            this._selectedBandBtn.selected = false;
            this._selectedBandBtn.enable = true;
            this._selectedBtn.enable = false;
         }
         else
         {
            this._isBand = true;
         }
         this.updateCommodityPrices();
      }
      
      private function removeEvent() : void
      {
         this._giftsBtn.removeEventListener(MouseEvent.CLICK,this.__giftsBtnClick);
         this._numberSelecter.removeEventListener(Event.CHANGE,this.__numberSelecterChange);
         this._shopCartItem.removeEventListener(ShopCartItem.CONDITION_CHANGE,this.__shopCartItemChange);
         this._frame.removeEventListener(FrameEvent.RESPONSE,this.__framePesponse);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.GOODS_PRESENT,this.onPresent);
      }
      
      private function updateCommodityPrices() : void
      {
         if(this._isBand)
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
      
      protected function __giftsBtnClick(event:MouseEvent) : void
      {
         var money:int = this._shopCartItem.shopItemInfo.getCurrentPrice().moneyValue * this._numberSelecter.currentValue;
         if(money > PlayerManager.Instance.Self.Money)
         {
            LeavePageManager.showFillFrame();
            return;
         }
         SoundManager.instance.play("008");
         this._shopPresentClearingFrame = ComponentFactory.Instance.creatComponentByStylename("core.ddtshop.ShopPresentClearingFrame");
         this._shopPresentClearingFrame.show();
         this._shopPresentClearingFrame.presentBtn.addEventListener(MouseEvent.CLICK,this.__presentBtnClick);
         this._shopPresentClearingFrame.addEventListener(FrameEvent.RESPONSE,this.__responseHandler);
      }
      
      private function __responseHandler(event:FrameEvent) : void
      {
         if(event.responseCode == FrameEvent.CLOSE_CLICK || event.responseCode == FrameEvent.ESC_CLICK)
         {
            StageReferance.stage.focus = this._frame;
         }
      }
      
      protected function __presentBtnClick(event:MouseEvent) : void
      {
         var t:ShopCarItemInfo = null;
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         if(this._shopPresentClearingFrame.nameInput.text == "")
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("shop.ShopIIPresentView.give"));
            return;
         }
         if(FilterWordManager.IsNullorEmpty(this._shopPresentClearingFrame.nameInput.text))
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("shop.ShopIIPresentView.space"));
            return;
         }
         var moneyValue:int = this._shopCartItem.shopItemInfo.getCurrentPrice().moneyValue;
         if(PlayerManager.Instance.Self.Money < moneyValue && moneyValue != 0)
         {
            LeavePageManager.showFillFrame();
            return;
         }
         this._shopPresentClearingFrame.presentBtn.enable = false;
         var items:Array = new Array();
         var types:Array = new Array();
         var colors:Array = new Array();
         var dresses:Array = new Array();
         var places:Array = new Array();
         var goodTypes:Array = new Array();
         for(var i:int = 0; i < this._numberSelecter.currentValue; i++)
         {
            t = this._shopCartItem.shopItemInfo;
            items.push(t.GoodsID);
            types.push(t.currentBuyType);
            colors.push(t.Color);
            dresses.push("");
            places.push("");
            goodTypes.push(t.isDiscount);
         }
         var msg:String = FilterWordManager.filterWrod(this._shopPresentClearingFrame.textArea.text);
         SocketManager.Instance.out.sendPresentGoods(items,types,colors,goodTypes,msg,this._shopPresentClearingFrame.nameInput.text,null,[false]);
      }
      
      protected function onPresent(event:CrazyTankSocketEvent) : void
      {
         if(Boolean(this._shopPresentClearingFrame))
         {
            this._shopPresentClearingFrame.presentBtn.enable = true;
            this._shopPresentClearingFrame.presentBtn.removeEventListener(MouseEvent.CLICK,this.__presentBtnClick);
            this._shopPresentClearingFrame.dispose();
            this._shopPresentClearingFrame = null;
         }
         var boo:Boolean = event.pkg.readBoolean();
         this.dispose();
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
      
      private function dispose() : void
      {
         this.removeEvent();
         if(Boolean(this._titleTxt))
         {
            ObjectUtils.disposeObject(this._titleTxt);
         }
         this._titleTxt = null;
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
         if(Boolean(this._giftsBtn))
         {
            ObjectUtils.disposeObject(this._giftsBtn);
         }
         this._giftsBtn = null;
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
         if(Boolean(this._frame))
         {
            ObjectUtils.disposeObject(this._frame);
         }
         this._frame = null;
      }
   }
}

