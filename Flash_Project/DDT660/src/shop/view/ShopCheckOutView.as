package shop.view
{
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.Image;
   import com.pickgliss.ui.image.Scale9CornerImage;
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
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import shop.ShopController;
   import shop.ShopEvent;
   import shop.ShopModel;
   import shop.manager.ShopBuyManager;
   
   public class ShopCheckOutView extends Sprite implements Disposeable
   {
      
      public static const COUNT:uint = 3;
      
      public static const DDT_MONEY:uint = 1;
      
      public static const BAND_MONEY:uint = 2;
      
      public static const LACK:uint = 1;
      
      public static const MONEY:uint = 0;
      
      public static const PLAYER:uint = 0;
      
      public static const PRESENT:int = 2;
      
      public static const PURCHASE:int = 1;
      
      public static const SAVE:int = 3;
      
      public static const ASKTYPE:int = 4;
      
      protected var _commodityNumberText:FilterFrameText;
      
      protected var _commodityNumberTip:FilterFrameText;
      
      protected var _commodityPricesText1:FilterFrameText;
      
      protected var _commodityPricesText2:FilterFrameText;
      
      private var _commodityPricesText1Bg:Scale9CornerImage;
      
      private var _commodityPricesText2Bg:Scale9CornerImage;
      
      private var _commodityPricesText3Bg:Scale9CornerImage;
      
      protected var _commodityPricesText1Label:FilterFrameText;
      
      protected var _commodityPricesText2Label:FilterFrameText;
      
      protected var _needToPayTip:FilterFrameText;
      
      protected var _purchaseConfirmationBtn:BaseButton;
      
      protected var _giftsBtn:BaseButton;
      
      protected var _askBtn:SimpleBitmapButton;
      
      protected var _saveImageBtn:BaseButton;
      
      private var _buyArray:Array = new Array();
      
      protected var _cartList:VBox;
      
      private var _castList2:Sprite;
      
      private var _cartItemList:Vector.<ShopCartItem>;
      
      private var _cartScroll:ScrollPanel;
      
      private var _controller:ShopController;
      
      protected var _frame:Frame;
      
      private var _giveArray:Array = new Array();
      
      protected var _innerBg1:Image;
      
      private var _innerBg:Image;
      
      protected var _model:ShopModel;
      
      protected var _tempList:Array;
      
      protected var _type:int;
      
      private var _isDisposed:Boolean;
      
      private var shopPresent:ShopPresentView;
      
      protected var _list:Array;
      
      private var _bandMoneyTotal:int;
      
      private var _MoneyTotal:int;
      
      private var _shopPresentClearingFrame:ShopPresentClearingFrame;
      
      private var _isAsk:Boolean;
      
      public function ShopCheckOutView()
      {
         super();
      }
      
      protected function drawFrame() : void
      {
         this._frame = ComponentFactory.Instance.creatComponentByStylename("ddtshop.CheckOutViewFrame");
         this._frame.titleText = LanguageMgr.GetTranslation("shop.Shop.car");
         addChild(this._frame);
      }
      
      protected function drawItemCountField() : void
      {
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
         this._commodityPricesText1Label = ComponentFactory.Instance.creatComponentByStylename("ddtshop.CommodityPricesText1Label");
         this._commodityPricesText1Label.text = LanguageMgr.GetTranslation("shop.CheckOutView.CommodityPricesText1Label");
         this._commodityPricesText2Label = ComponentFactory.Instance.creatComponentByStylename("ddtshop.CommodityPricesText2Label");
         this._commodityPricesText2Label.text = LanguageMgr.GetTranslation("shop.CheckOutView.CommodityPricesText2Label");
         this._frame.addToContent(this._commodityPricesText1Label);
         this._frame.addToContent(this._commodityPricesText2Label);
         this._frame.addToContent(this._commodityPricesText1);
         this._frame.addToContent(this._commodityPricesText2);
      }
      
      protected function drawPayListField() : void
      {
         this._innerBg = ComponentFactory.Instance.creatComponentByStylename("ddtshop.CheckOutViewBg");
         this._frame.addToContent(this._innerBg);
      }
      
      protected function init() : void
      {
         this._cartList = new VBox();
         this._castList2 = new Sprite();
         this.drawFrame();
         this._purchaseConfirmationBtn = ComponentFactory.Instance.creatComponentByStylename("ddtshop.PurchaseBtn");
         this._purchaseConfirmationBtn.visible = false;
         this._askBtn = ComponentFactory.Instance.creatComponentByStylename("core.ddtshop.askButton");
         this._askBtn.visible = false;
         this._giftsBtn = ComponentFactory.Instance.creatComponentByStylename("ddtshop.GiftsBtn");
         this._giftsBtn.visible = false;
         this._saveImageBtn = ComponentFactory.Instance.creatComponentByStylename("ddtshop.SaveImageBtn");
         this._saveImageBtn.visible = false;
         this._cartScroll = ComponentFactory.Instance.creatComponentByStylename("ddtshop.CheckOutViewItemList");
         this._cartScroll.setView(this._castList2);
         this._cartScroll.vScrollProxy = ScrollPanel.ON;
         this._cartList.spacing = 5;
         this._cartList.strictSize = 80;
         this._cartList.isReverAdd = true;
         this.drawItemCountField();
         this.drawPayListField();
         this._frame.addToContent(this._cartScroll);
         this._frame.addToContent(this._askBtn);
         this._frame.addToContent(this._purchaseConfirmationBtn);
         this._frame.addToContent(this._giftsBtn);
         this._frame.addToContent(this._saveImageBtn);
         this.setList(this._tempList,0,true);
         this.updateTxt();
         if(this._type == SAVE)
         {
            this._saveImageBtn.visible = true;
         }
         else if(this._type == PURCHASE)
         {
            this._purchaseConfirmationBtn.visible = true;
         }
         else if(this._type == PRESENT)
         {
            this._giftsBtn.visible = true;
         }
         else if(this._type == ASKTYPE)
         {
            this._askBtn.visible = true;
         }
      }
      
      private function clearList() : void
      {
         var item:ShopCartItem = null;
         while(this._castList2.numChildren > 0)
         {
            item = this._castList2.getChildAt(this._castList2.numChildren - 1) as ShopCartItem;
            this.removeItemEvent(item);
            this._castList2.removeChild(item);
            item.dispose();
            item = null;
         }
      }
      
      protected function initEvent() : void
      {
         this._frame.addEventListener(FrameEvent.RESPONSE,this.__frameEventHandler);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.BUY_GOODS,this.onBuyedGoods);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GOODS_PRESENT,this.onPresent);
         this._purchaseConfirmationBtn.addEventListener(MouseEvent.CLICK,this.__purchaseConfirmationBtnClick);
         this._saveImageBtn.addEventListener(MouseEvent.CLICK,this.__purchaseConfirmationBtnClick);
         this._giftsBtn.addEventListener(MouseEvent.CLICK,this.__purchaseConfirmationBtnClick);
         this._askBtn.addEventListener(MouseEvent.CLICK,this.__purchaseConfirmationBtnClick);
      }
      
      protected function __purchaseConfirmationBtnClick(event:MouseEvent = null) : void
      {
         SoundManager.instance.play("008");
         var money:int = int(this._commodityPricesText1.text);
         var bandMoney:int = int(this._commodityPricesText2.text);
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         if(this._type == ASKTYPE)
         {
            this.sendAsk();
         }
         else if(this._type == SAVE)
         {
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
            this.saveFigureCheckOut();
         }
         else if(this._type == PURCHASE)
         {
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
            this.shopCarCheckOut();
         }
         else if(this._type == PRESENT)
         {
            if(money > PlayerManager.Instance.Self.Money)
            {
               LeavePageManager.showFillFrame();
               this.dispose();
               return;
            }
            this.presentCheckOut();
         }
      }
      
      private function sendAsk() : void
      {
         this._isAsk = true;
         if(Boolean(this._shopPresentClearingFrame))
         {
            this._shopPresentClearingFrame.dispose();
            this._shopPresentClearingFrame = null;
         }
         var askArray:Array = this._model.allItems;
         if(askArray.length > 0)
         {
            this._shopPresentClearingFrame = ComponentFactory.Instance.creatComponentByStylename("core.ddtshop.ShopPresentClearingFrame");
            this._shopPresentClearingFrame.show();
            this._shopPresentClearingFrame.setType(ShopPresentClearingFrame.FPAYTYPE_SHOP);
            this._shopPresentClearingFrame.presentBtn.addEventListener(MouseEvent.CLICK,this.__presentBtnClick);
            this._shopPresentClearingFrame.addEventListener(FrameEvent.RESPONSE,this.__shopPresentClearingFrameResponseHandler);
            this.visible = false;
         }
         else
         {
            LeavePageManager.showFillFrame();
         }
      }
      
      private function seleBand(id:int, num:int, bool:Boolean) : void
      {
         this._model.isBandList[id] = bool;
         this.updateTxt();
      }
      
      protected function addItemEvent(item:ShopCartItem) : void
      {
         item.addEventListener(ShopCartItem.DELETE_ITEM,this.__deleteItem);
         item.addEventListener(ShopCartItem.ADD_LENGTH,this.addLength);
         item.addEventListener(ShopCartItem.CONDITION_CHANGE,this.__conditionChange);
      }
      
      protected function addLength(event:Event) : void
      {
         var items:ShopCartItem = event.currentTarget as ShopCartItem;
         ShopBuyManager.crrItemId = items.id;
         this.setList(this._tempList,items.id);
      }
      
      protected function removeItemEvent(item:ShopCartItem) : void
      {
         item.removeEventListener(ShopCartItem.DELETE_ITEM,this.__deleteItem);
         item.removeEventListener(ShopCartItem.CONDITION_CHANGE,this.__conditionChange);
      }
      
      public function setList(arr:Array, id:int = 0, isfst:Boolean = false) : void
      {
         var cItem:ShopCartItem = null;
         this.clearList();
         this._cartItemList = new Vector.<ShopCartItem>();
         this._list = arr;
         if(isfst)
         {
            this._model.isBandList = [];
         }
         var len:int = int(arr.length);
         for(var i:int = 0; i < len; i++)
         {
            cItem = this.createShopItem();
            cItem.id = i;
            if(this._type == PRESENT || this._type == ASKTYPE)
            {
               cItem.setShopItemInfo(arr[i]);
               cItem.type = PRESENT;
            }
            else if(ShopBuyManager.crrItemId != 0)
            {
               cItem.setShopItemInfo(arr[i],ShopBuyManager.crrItemId,this._model.isBandList[i]);
            }
            else
            {
               cItem.setShopItemInfo(arr[i],id,this._model.isBandList[i]);
            }
            cItem.seleBand = this.seleBand;
            cItem.upDataBtnState = this.upDataBtnState;
            cItem.setColor(arr[i].Color);
            this._castList2.addChild(cItem);
            if(isfst)
            {
               this._model.isBandList.push(cItem.isBand);
            }
            else
            {
               cItem.setDianquanType(this._model.isBandList[i]);
            }
            this._cartItemList.push(cItem);
            this.addItemEvent(cItem);
         }
         this.updateList();
         this._cartScroll.invalidateViewport();
         this.updateTxt();
      }
      
      private function upDataBtnState() : void
      {
         this._model.dispatchEvent(new ShopEvent(ShopEvent.COST_UPDATE));
      }
      
      private function updateList() : void
      {
         var len:int = int(this._cartItemList.length);
         for(var i:int = 0; i < len; i++)
         {
            this._cartItemList[i].id = i;
            if(i > 0)
            {
               this._cartItemList[i].y = this._cartItemList[i - 1].y + this._cartItemList[i - 1].height;
            }
            else
            {
               this._cartItemList[i].y = 0;
            }
         }
      }
      
      protected function createShopItem() : ShopCartItem
      {
         return new ShopCartItem();
      }
      
      public function setup(controller:ShopController, model:ShopModel, list:Array, type:int) : void
      {
         this._controller = controller;
         this._model = model;
         this._tempList = list;
         this._type = type;
         this._isDisposed = false;
         this.visible = true;
         this.init();
         this.initEvent();
      }
      
      private function __conditionChange(evt:Event) : void
      {
         this.updateTxt();
      }
      
      private function upDataListInfo(id:int) : void
      {
         var len:int = int(this._cartItemList.length);
         for(var i:int = 0; i < len; i++)
         {
            if(id == this._cartItemList[i].id)
            {
               this._cartItemList.splice(i,1);
               this._tempList.splice(i,1);
               if(id == ShopBuyManager.crrItemId)
               {
                  ShopBuyManager.crrItemId = 0;
                  if(this._cartItemList.length > 0 && this._type != PRESENT)
                  {
                     this._cartItemList[0].addItem(this._model.isBandList[0]);
                  }
               }
               break;
            }
         }
      }
      
      private function __deleteItem(evt:Event) : void
      {
         var item:ShopCartItem = evt.currentTarget as ShopCartItem;
         var shopItemInfo:ShopCarItemInfo = item.shopItemInfo;
         item.removeEventListener(ShopCartItem.DELETE_ITEM,this.__deleteItem);
         item.removeEventListener(ShopCartItem.CONDITION_CHANGE,this.__conditionChange);
         this._model.isBandList.splice(item.id,1);
         this._castList2.removeChild(item);
         if(ShopBuyManager.crrItemId > item.id)
         {
            --ShopBuyManager.crrItemId;
         }
         item.dispose();
         if(this._type == SAVE)
         {
            this._controller.removeTempEquip(shopItemInfo);
            this.updateTxt();
            this.updateList();
            this._cartScroll.invalidateViewport();
            if(this._model.currentTempList.length == 0)
            {
               this.dispose();
            }
         }
         if(this._type == PURCHASE || this._type == ASKTYPE)
         {
            this._controller.removeFromCar(shopItemInfo);
            this.upDataListInfo(item.id);
            this.updateTxt();
            this.updateList();
            this._cartScroll.invalidateViewport();
            if(this._model.allItems.length == 0)
            {
               this.dispose();
            }
         }
         if(this._type == PRESENT)
         {
            this._controller.removeFromCar(shopItemInfo);
            this.upDataListInfo(item.id);
            this.updateTxt();
            this.updateList();
            this._cartScroll.invalidateViewport();
            if(this._tempList.length == 0)
            {
               this.dispose();
            }
         }
      }
      
      private function __frameEventHandler(evt:FrameEvent) : void
      {
         switch(evt.responseCode)
         {
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.ESC_CLICK:
               SoundManager.instance.play("008");
               this.dispose();
         }
      }
      
      public function get extraButton() : BaseButton
      {
         return null;
      }
      
      protected function removeEvent() : void
      {
         this._frame.removeEventListener(FrameEvent.RESPONSE,this.__frameEventHandler);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.BUY_GOODS,this.onBuyedGoods);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.GOODS_PRESENT,this.onPresent);
         this._purchaseConfirmationBtn.removeEventListener(MouseEvent.CLICK,this.__purchaseConfirmationBtnClick);
         this._saveImageBtn.removeEventListener(MouseEvent.CLICK,this.__purchaseConfirmationBtnClick);
         this._giftsBtn.removeEventListener(MouseEvent.CLICK,this.__purchaseConfirmationBtnClick);
      }
      
      private function __dispatchFrameEvent(e:MouseEvent) : void
      {
         this._frame.dispatchEvent(new FrameEvent(FrameEvent.SUBMIT_CLICK));
      }
      
      private function isMoneyGoods(item:*, index:int, array:Array) : Boolean
      {
         if(item is ShopItemInfo)
         {
            return ShopItemInfo(item).getItemPrice(1).IsMoneyType;
         }
         return false;
      }
      
      private function notPresentGoods() : Array
      {
         var item:ShopCarItemInfo = null;
         var notPresent:Array = [];
         for each(item in this._tempList)
         {
            if(this._giveArray.indexOf(item) == -1)
            {
               notPresent.push(item);
            }
         }
         return notPresent;
      }
      
      private function onBuyedGoods(event:CrazyTankSocketEvent) : void
      {
         var item:ShopCarItemInfo = null;
         var j:int = 0;
         event.pkg.position = SocketManager.PACKAGE_CONTENT_START_INDEX;
         var success:int = event.pkg.readInt();
         var isDispose:Boolean = false;
         if(success != 0)
         {
            if(this._type == SAVE)
            {
               this._model.clearCurrentTempList(this._model.fittingSex ? 1 : 2);
            }
            else if(this._type == PURCHASE)
            {
               this._model.clearAllitems();
            }
         }
         else if(this._type == SAVE)
         {
            this._model.clearCurrentTempList(this._model.fittingSex ? 1 : 2);
            for each(item in this._model.currentLeftList)
            {
               this._model.addTempEquip(item);
            }
            this.setList(this._model.currentTempList);
            if(this._model.currentTempList.length < 1)
            {
               isDispose = true;
            }
         }
         else if(this._type == PURCHASE)
         {
            for(j = 0; j < this._buyArray.length; j++)
            {
               this._model.removeFromShoppingCar(this._buyArray[j] as ShopCarItemInfo);
            }
            this.setList(this._model.allItems);
            if(this._model.allItems.length < 1)
            {
               isDispose = true;
            }
         }
         if(success != 0)
         {
            this.dispose();
         }
         else if(isDispose)
         {
            this.dispose();
         }
      }
      
      private function onPresent(event:CrazyTankSocketEvent) : void
      {
         this._shopPresentClearingFrame.presentBtn.enable = true;
         this._shopPresentClearingFrame.dispose();
         this._shopPresentClearingFrame = null;
         this.visible = true;
         var boo:Boolean = event.pkg.readBoolean();
         for(var k:int = 0; k < this._giveArray.length; k++)
         {
            this._model.removeFromShoppingCar(this._giveArray[k] as ShopCarItemInfo);
            this._tempList.splice(this._tempList.indexOf(this._giveArray[k] as ShopCarItemInfo),1);
         }
         if(this._tempList.length == 0)
         {
            this.dispose();
            return;
         }
         if(this._tempList.length > 0)
         {
            this.setList(this.notPresentGoods());
            return;
         }
      }
      
      private function presentCheckOut() : void
      {
         this._isAsk = false;
         if(Boolean(this._shopPresentClearingFrame))
         {
            this._shopPresentClearingFrame.dispose();
            this._shopPresentClearingFrame = null;
         }
         this._giveArray = ShopManager.Instance.giveGift(this._model.allItems,this._model.Self);
         if(this._giveArray.length > 0)
         {
            this._shopPresentClearingFrame = ComponentFactory.Instance.creatComponentByStylename("core.ddtshop.ShopPresentClearingFrame");
            this._shopPresentClearingFrame.show();
            this._shopPresentClearingFrame.presentBtn.addEventListener(MouseEvent.CLICK,this.__presentBtnClick);
            this._shopPresentClearingFrame.addEventListener(FrameEvent.RESPONSE,this.__shopPresentClearingFrameResponseHandler);
            this.visible = false;
         }
         else
         {
            LeavePageManager.showFillFrame();
         }
      }
      
      private function __shopPresentClearingFrameResponseHandler(event:FrameEvent) : void
      {
         this._shopPresentClearingFrame.removeEventListener(FrameEvent.RESPONSE,this.__shopPresentClearingFrameResponseHandler);
         if(event.responseCode == FrameEvent.CLOSE_CLICK || event.responseCode == FrameEvent.ESC_CLICK || event.responseCode == FrameEvent.CANCEL_CLICK)
         {
            StageReferance.stage.focus = this._frame;
            this.visible = true;
         }
      }
      
      protected function __presentBtnClick(event:MouseEvent) : void
      {
         var len:int = 0;
         var goodsIDs:Array = null;
         var types:Array = null;
         var goodsTypes:Array = null;
         var colors:Array = null;
         var skins:Array = null;
         var i:int = 0;
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
         if(this._isAsk)
         {
            this._shopPresentClearingFrame.presentBtn.removeEventListener(MouseEvent.CLICK,this.__presentBtnClick);
            this._shopPresentClearingFrame.removeEventListener(FrameEvent.RESPONSE,this.__shopPresentClearingFrameResponseHandler);
            len = int(this._cartItemList.length);
            goodsIDs = [];
            types = [];
            goodsTypes = [];
            colors = [];
            skins = [];
            for(i = 0; i < len; i++)
            {
               goodsIDs.push(this._cartItemList[i].shopItemInfo.GoodsID);
               types.push(this._cartItemList[i].shopItemInfo.currentBuyType);
               goodsTypes.push(this._cartItemList[i].shopItemInfo.isDiscount);
               colors.push(this._cartItemList[i].shopItemInfo.Color);
               skins.push(this._cartItemList[i].shopItemInfo.skin);
            }
            SocketManager.Instance.out.requestShopPay(goodsIDs,types,goodsTypes,colors,skins,this._shopPresentClearingFrame.Name);
         }
         else
         {
            this._shopPresentClearingFrame.presentBtn.enable = false;
            this._controller.presentItems(this._tempList,this._shopPresentClearingFrame.textArea.text,this._shopPresentClearingFrame.nameInput.text);
         }
         this._shopPresentClearingFrame.dispose();
         this._shopPresentClearingFrame = null;
         this.dispose();
      }
      
      private function saveFigureCheckOut() : void
      {
         this._buyArray = ShopManager.Instance.buyIt(this._model.currentTempList);
         this._controller.buyItems(this._model.currentTempList,true,this._model.currentModel.Skin,this._model.isBandList);
      }
      
      private function shopCarCheckOut() : void
      {
         this._buyArray = ShopManager.Instance.buyIt(this._model.allItems);
         this._controller.buyItems(this._model.allItems,false,"",this._model.isBandList);
      }
      
      protected function updateTxt() : void
      {
         var tempArray:Array = this._type == SAVE ? this._model.currentTempList : this._model.allItems;
         if(this._type == PRESENT)
         {
            tempArray = this._tempList;
         }
         var prices:Array = this._model.calcPrices(tempArray,this._model.isBandList);
         this._commodityNumberText.text = String(tempArray.length);
         this._commodityPricesText1.text = String(prices[MONEY + 1]);
         this._commodityPricesText2.text = String(prices[BAND_MONEY + 1]);
      }
      
      public function dispose() : void
      {
         var item:ShopCartItem = null;
         if(Boolean(this._shopPresentClearingFrame))
         {
            if(Boolean(this._shopPresentClearingFrame.presentBtn))
            {
               this._shopPresentClearingFrame.presentBtn.removeEventListener(MouseEvent.CLICK,this.__presentBtnClick);
            }
            this._shopPresentClearingFrame.removeEventListener(FrameEvent.RESPONSE,this.__shopPresentClearingFrameResponseHandler);
            this._shopPresentClearingFrame.dispose();
            this._shopPresentClearingFrame = null;
         }
         this._model.isBandList = [];
         if(!this._isDisposed)
         {
            this.removeEvent();
            ObjectUtils.disposeAllChildren(this);
            while(this._cartList.numChildren > 0)
            {
               item = this._cartList.getChildAt(this._cartList.numChildren - 1) as ShopCartItem;
               this.removeItemEvent(item);
               this._cartList.removeChild(item);
               item.dispose();
               item = null;
            }
            ObjectUtils.disposeObject(this._needToPayTip);
            this._needToPayTip = null;
            this._buyArray = null;
            this._cartList = null;
            this._cartScroll = null;
            this._controller = null;
            this._giveArray = null;
            this._innerBg = null;
            this._frame = null;
            this.shopPresent = null;
            this._commodityNumberText = null;
            this._commodityPricesText1 = null;
            this._commodityNumberTip = null;
            this._commodityPricesText2 = null;
            this._commodityPricesText1Bg = null;
            this._commodityPricesText2Bg = null;
            this._commodityPricesText3Bg = null;
            this._commodityPricesText1Label = null;
            this._commodityPricesText2Label = null;
            this._purchaseConfirmationBtn = null;
            this._giftsBtn = null;
            this._saveImageBtn = null;
            this._innerBg1 = null;
            this._innerBg = null;
            this._model = null;
            if(Boolean(parent))
            {
               parent.removeChild(this);
            }
            this._isDisposed = true;
         }
      }
   }
}

