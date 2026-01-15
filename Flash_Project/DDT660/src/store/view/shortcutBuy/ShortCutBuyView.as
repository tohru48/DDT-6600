package store.view.shortcutBuy
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.NumberSelecter;
   import com.pickgliss.ui.controls.SelectedButtonGroup;
   import com.pickgliss.ui.controls.SelectedCheckButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.Image;
   import com.pickgliss.ui.image.MutipleImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.ItemPrice;
   import ddt.data.goods.ShopItemInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.SharedManager;
   import ddt.manager.ShopManager;
   import ddt.manager.SoundManager;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class ShortCutBuyView extends Sprite implements Disposeable
   {
      
      public static const ADD_NUMBER_Y:int = 40;
      
      public static const ADD_TOTALTEXT_Y:int = 20;
      
      private var _templateItemIDList:Array;
      
      private var _moneySelectBtn:SelectedCheckButton;
      
      private var _giftSelectBtn:SelectedCheckButton;
      
      private var _btnGroup:SelectedButtonGroup;
      
      private var _list:ShortcutBuyList;
      
      private var _num:NumberSelecter;
      
      private var priceStr:String;
      
      private var totalText:FilterFrameText;
      
      private var totalTextBg:Image;
      
      private var msg:FilterFrameText;
      
      private var bg:MutipleImage;
      
      private var _showRadioBtn:Boolean = true;
      
      private var _memoryItemID:int;
      
      private var _firstShow:Boolean = true;
      
      private var _isBand:Boolean;
      
      public function ShortCutBuyView(templateItemIDList:Array, showRadioBtn:Boolean)
      {
         super();
         this._templateItemIDList = templateItemIDList;
         this._showRadioBtn = showRadioBtn;
         this.init();
         this.initEvents();
      }
      
      private function init() : void
      {
         this.bg = ComponentFactory.Instance.creatComponentByStylename("store.ShortCutViewBG");
         addChild(this.bg);
         this._moneySelectBtn = ComponentFactory.Instance.creatComponentByStylename("store.MoneySelectBtn");
         addChild(this._moneySelectBtn);
         this._giftSelectBtn = ComponentFactory.Instance.creatComponentByStylename("store.GiftSelectBtn");
         addChild(this._giftSelectBtn);
         this._btnGroup = new SelectedButtonGroup();
         this._btnGroup.addSelectItem(this._moneySelectBtn);
         this._btnGroup.addSelectItem(this._giftSelectBtn);
         this._btnGroup.selectIndex = 0;
         this._isBand = false;
         this.bg.visible = this._moneySelectBtn.visible = this._giftSelectBtn.visible = this._showRadioBtn;
         this._list = ComponentFactory.Instance.creatCustomObject("ddtstore.ShortcutBuyList");
         this._list.setup(this._templateItemIDList);
         this._memoryItemID = SharedManager.Instance.StoreBuyInfo[PlayerManager.Instance.Self.ID.toString()];
         var item:ShopItemInfo = ShopManager.Instance.getShopItemByGoodsID(this._memoryItemID);
         if(Boolean(item) && this._templateItemIDList.indexOf(item.TemplateID) > -1)
         {
            this._list.selectedItemID = item.TemplateID;
         }
         else
         {
            this._list.selectedItemID = this._templateItemIDList[0];
         }
         if(item && item.getItemPrice(1).IsBandDDTMoneyType && this._templateItemIDList.indexOf(item.TemplateID) > -1)
         {
            this._btnGroup.selectIndex = 1;
         }
         addChild(this._list);
         this._num = ComponentFactory.Instance.creatComponentByStylename("ddtstore.ShortcutBuyFrame.AmountNumberSelecter");
         this._num.y = this._list.y + this._list.height + ADD_NUMBER_Y;
         addChild(this._num);
         this.totalTextBg = ComponentFactory.Instance.creatComponentByStylename("ddstore.ShortcutBuyFrame.TipsTextBg");
         addChild(this.totalTextBg);
         this.msg = ComponentFactory.Instance.creatComponentByStylename("ddtstore.ShortcutBuyFrame.TipsText");
         this.msg.text = LanguageMgr.GetTranslation("store.ShortcutBuyFrame.TotalCostTipText");
         addChild(this.msg);
         this.totalText = ComponentFactory.Instance.creatComponentByStylename("ddtstore.ShortcutBuyFrame.TotalText");
         this.totalText.y = this._num.y + this._num.height + ADD_TOTALTEXT_Y;
         this.msg.y = this.totalText.y;
         addChild(this.totalText);
         this.updateCost();
      }
      
      protected function selectedBandHander(event:MouseEvent) : void
      {
      }
      
      protected function selecetedHander(event:MouseEvent) : void
      {
      }
      
      private function initEvents() : void
      {
         this._list.addEventListener(Event.SELECT,this.selectHandler);
         this._moneySelectBtn.addEventListener(Event.SELECT,this.selectHandler);
         this._moneySelectBtn.addEventListener(MouseEvent.CLICK,this.clickHandlerDian);
         this._giftSelectBtn.addEventListener(Event.SELECT,this.selectHandler);
         this._giftSelectBtn.addEventListener(MouseEvent.CLICK,this.clickHandlerLi);
         this._num.addEventListener(Event.CHANGE,this.selectHandler);
      }
      
      private function removeEvents() : void
      {
         this._list.removeEventListener(Event.SELECT,this.selectHandler);
         this._moneySelectBtn.removeEventListener(Event.SELECT,this.selectHandler);
         this._moneySelectBtn.removeEventListener(MouseEvent.CLICK,this.clickHandlerDian);
         this._giftSelectBtn.removeEventListener(Event.SELECT,this.selectHandler);
         this._giftSelectBtn.removeEventListener(MouseEvent.CLICK,this.clickHandlerLi);
         this._num.removeEventListener(Event.CHANGE,this.selectHandler);
      }
      
      public function get isBand() : Boolean
      {
         return this._isBand;
      }
      
      private function _numberClose(e:Event) : void
      {
         dispatchEvent(e);
      }
      
      private function clickHandlerDian(e:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(this._isBand)
         {
            this.priceStr = "0" + LanguageMgr.GetTranslation("tank.auctionHouse.view.AuctionBrowseView.bandStipple");
         }
         else
         {
            this.priceStr = "0" + LanguageMgr.GetTranslation("tank.auctionHouse.view.AuctionBrowseView.stipple");
         }
         this._firstShow = false;
         this.updateCost();
      }
      
      private function clickHandlerLi(e:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this.priceStr = "0" + LanguageMgr.GetTranslation("tank.gameover.takecard.gifttoken");
         this._firstShow = false;
         this.updateCost();
      }
      
      private function selectHandler(evt:Event) : void
      {
         evt.stopImmediatePropagation();
         this.updateCost();
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      private function updateCost() : void
      {
         if(this._firstShow)
         {
            this.priceStr = "0" + LanguageMgr.GetTranslation("tank.auctionHouse.view.AuctionBrowseView.stipple");
         }
         if(this.currentShopItem != null)
         {
            this.priceStr = this.totalPrice.toString(this._isBand);
         }
         this.totalText.text = this.priceStr;
      }
      
      public function get List() : ShortcutBuyList
      {
         return this._list;
      }
      
      public function get currentShopItem() : ShopItemInfo
      {
         var resultShopItem:ShopItemInfo = null;
         if(this._moneySelectBtn.selected)
         {
            resultShopItem = ShopManager.Instance.getMoneyShopItemByTemplateID(this._list.selectedItemID);
         }
         else
         {
            resultShopItem = ShopManager.Instance.getGiftShopItemByTemplateID(this._list.selectedItemID);
         }
         return resultShopItem;
      }
      
      public function get currentNum() : int
      {
         return this._num.currentValue;
      }
      
      public function get totalPrice() : ItemPrice
      {
         var price:ItemPrice = new ItemPrice(null,null,null);
         if(Boolean(this.currentShopItem) && this._num.currentValue > 0)
         {
            price = this.currentShopItem.getItemPrice(1).multiply(this._num.currentValue);
         }
         return price;
      }
      
      public function get totalMoney() : int
      {
         return this.totalPrice.moneyValue;
      }
      
      public function get totalDDTMoney() : int
      {
         return this.totalPrice.bandDdtMoneyValue;
      }
      
      public function get totalNum() : int
      {
         return this._num.currentValue;
      }
      
      public function save() : void
      {
         SharedManager.Instance.StoreBuyInfo[PlayerManager.Instance.Self.ID] = this.currentShopItem.GoodsID;
         SharedManager.Instance.save();
      }
      
      public function dispose() : void
      {
         this.removeEvents();
         if(Boolean(this._moneySelectBtn))
         {
            ObjectUtils.disposeObject(this._moneySelectBtn);
         }
         this._moneySelectBtn = null;
         if(Boolean(this._giftSelectBtn))
         {
            ObjectUtils.disposeObject(this._giftSelectBtn);
         }
         this._giftSelectBtn = null;
         if(Boolean(this._btnGroup))
         {
            ObjectUtils.disposeObject(this._btnGroup);
         }
         this._btnGroup = null;
         if(Boolean(this._list))
         {
            ObjectUtils.disposeObject(this._list);
         }
         this._list = null;
         if(Boolean(this._num))
         {
            ObjectUtils.disposeObject(this._num);
         }
         this._num = null;
         if(Boolean(this.totalText))
         {
            ObjectUtils.disposeObject(this.totalText);
         }
         this.totalText = null;
         if(Boolean(this.bg))
         {
            ObjectUtils.disposeObject(this.bg);
         }
         this.bg = null;
         if(Boolean(this.totalTextBg))
         {
            ObjectUtils.disposeObject(this.totalTextBg);
         }
         this.totalTextBg = null;
         if(Boolean(this.msg))
         {
            ObjectUtils.disposeObject(this.msg);
         }
         this.msg = null;
         this._templateItemIDList = null;
         ObjectUtils.disposeAllChildren(this);
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

