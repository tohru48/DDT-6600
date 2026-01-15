package DDPlay
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.controls.container.HBox;
   import com.pickgliss.ui.image.Image;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.vo.AlertInfo;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.command.NumberSelecter;
   import ddt.data.EquipType;
   import ddt.data.goods.ShopItemInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.ShopManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import ddt.view.caddyII.bead.QuickBuyItem;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class DDPlayQuickBuy extends BaseAlerFrame
   {
      
      public static const DDPLAY_COIN_NUMBER:int = 0;
      
      public static const CADDY_NUMBER:int = 1;
      
      private var _list:HBox;
      
      private var _cellItems:Vector.<QuickBuyItem>;
      
      private var _shopItemInfoList:Vector.<ShopItemInfo>;
      
      private var _money:int;
      
      private var _gift:int;
      
      private var _clickNumber:int;
      
      private var _cellId:Array = [EquipType.DDPLAY_COIN];
      
      private var _selectedItem:QuickBuyItem;
      
      private var _font2:FilterFrameText;
      
      public function DDPlayQuickBuy()
      {
         super();
         this.initView();
         this.initEvents();
      }
      
      private function initView() : void
      {
         this._list = ComponentFactory.Instance.creatComponentByStylename("DDPlay.quickBox");
         PositionUtils.setPos(this._list,"DDPlay.quickBuy.listPos");
         var font1:FilterFrameText = ComponentFactory.Instance.creatComponentByStylename("asset.medicineQuickBugText1");
         this._font2 = ComponentFactory.Instance.creatComponentByStylename("asset.medicineQuickBugText2");
         var moneyBG:Image = ComponentFactory.Instance.creat("asset.medicineQuickBugTextBg");
         font1.text = LanguageMgr.GetTranslation("tank.ddPlay.quickBuy.totalPay");
         this._font2.text = LanguageMgr.GetTranslation("money");
         PositionUtils.setPos(font1,"DDPlay.quickBuy.font1Pos");
         PositionUtils.setPos(this._font2,"DDPlay.quickBuy.font2Pos");
         PositionUtils.setPos(moneyBG,"DDPlay.quickBuy.moneybgPos");
         addToContent(moneyBG);
         addToContent(font1);
         addToContent(this._font2);
         this.creatCell();
      }
      
      private function initEvents() : void
      {
         addEventListener(FrameEvent.RESPONSE,this._response);
      }
      
      private function removeEvents() : void
      {
         var item:QuickBuyItem = null;
         removeEventListener(FrameEvent.RESPONSE,this._response);
         for each(item in this._cellItems)
         {
            item.removeEventListener(Event.CHANGE,this._numberChange);
            item.removeEventListener(MouseEvent.CLICK,this.__itemClick);
            item.removeEventListener(NumberSelecter.NUMBER_CLOSE,this._numberClose);
            item.removeEventListener(NumberSelecter.NUMBER_ENTER,this._numberEnter);
         }
      }
      
      private function creatCell() : void
      {
         var item:QuickBuyItem = null;
         this._cellItems = new Vector.<QuickBuyItem>();
         this._shopItemInfoList = new Vector.<ShopItemInfo>();
         this._list.beginChanges();
         for(var i:int = 0; i < this._cellId.length; i++)
         {
            item = new QuickBuyItem();
            item.itemID = this._cellId[i];
            item.addEventListener(Event.CHANGE,this._numberChange);
            item.addEventListener(MouseEvent.CLICK,this.__itemClick);
            item.addEventListener(NumberSelecter.NUMBER_CLOSE,this._numberClose);
            item.addEventListener(NumberSelecter.NUMBER_ENTER,this._numberEnter);
            this._list.addChild(item);
            this._cellItems.push(item);
         }
         this._list.commitChanges();
         this._shopItemInfoList.push(ShopManager.Instance.getMoneyShopItemByTemplateID(this._cellId[DDPLAY_COIN_NUMBER]));
         this._shopItemInfoList.push(ShopManager.Instance.getGiftShopItemByTemplateID(this._cellId[CADDY_NUMBER]));
         this._cellItems[0].selectNumber.maximum = 50;
      }
      
      private function __itemClick(evt:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         var item:QuickBuyItem = evt.currentTarget as QuickBuyItem;
         this.selectedItem = item;
      }
      
      private function _response(e:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         if(e.responseCode == FrameEvent.SUBMIT_CLICK || e.responseCode == FrameEvent.ENTER_CLICK)
         {
            if(this.money > 0 || this.gift > 0)
            {
               this.buy();
               ObjectUtils.disposeObject(this);
            }
            else
            {
               this._showTip();
            }
         }
         else
         {
            ObjectUtils.disposeObject(this);
         }
      }
      
      private function _numberChange(e:Event) : void
      {
         this.money = this._cellItems[DDPLAY_COIN_NUMBER].count * this._shopItemInfoList[DDPLAY_COIN_NUMBER].getItemPrice(1).moneyValue;
         var item:QuickBuyItem = e.currentTarget as QuickBuyItem;
         this.selectedItem = item;
      }
      
      private function _numberClose(e:Event) : void
      {
         ObjectUtils.disposeObject(this);
      }
      
      private function _numberEnter(e:Event) : void
      {
         if(this.money > 0 || this.gift > 0)
         {
            this.buy();
            ObjectUtils.disposeObject(this);
         }
         else
         {
            this._showTip();
         }
      }
      
      private function buy() : void
      {
         var alert:BaseAlerFrame = null;
         var j:int = 0;
         if(this.money > 0 && !this._shopItemInfoList[DDPLAY_COIN_NUMBER].isValid || this.gift > 0 && !this._shopItemInfoList[CADDY_NUMBER].isValid)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.caddy.quickDate"));
            return;
         }
         if(PlayerManager.Instance.Self.Money < this.money)
         {
            alert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.view.comon.lack"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,false,LayerManager.ALPHA_BLOCKGOUND);
            alert.moveEnable = false;
            alert.addEventListener(FrameEvent.RESPONSE,this._responseI);
            return;
         }
         var items:Array = [];
         var types:Array = [];
         var colors:Array = [];
         var dresses:Array = [];
         var skins:Array = [];
         var places:Array = [];
         for(var i:int = 0; i < this._cellItems.length; i++)
         {
            for(j = 0; j < this._cellItems[i].count; j++)
            {
               items.push(this._shopItemInfoList[i].GoodsID);
               types.push(1);
               colors.push("");
               dresses.push(false);
               skins.push("");
               places.push(-1);
            }
         }
         SocketManager.Instance.out.sendBuyGoods(items,types,colors,places,dresses,skins,0);
      }
      
      private function _responseI(e:FrameEvent) : void
      {
         (e.currentTarget as BaseAlerFrame).removeEventListener(FrameEvent.RESPONSE,this._responseI);
         if(e.responseCode == FrameEvent.SUBMIT_CLICK || e.responseCode == FrameEvent.ENTER_CLICK)
         {
            LeavePageManager.leaveToFillPath();
         }
         ObjectUtils.disposeObject(e.target);
      }
      
      private function _showTip() : void
      {
         MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.bead.quickNoBuy"));
      }
      
      public function set money(value:int) : void
      {
         this._money = value;
         this._font2.text = value + LanguageMgr.GetTranslation("money");
      }
      
      public function get money() : int
      {
         return this._money;
      }
      
      public function set gift(value:int) : void
      {
         this._gift = value;
      }
      
      public function get gift() : int
      {
         return this._gift;
      }
      
      public function set clickNumber(value:int) : void
      {
         this._clickNumber = value;
         this._cellItems[this._clickNumber].count = 1;
         this._cellItems[this._clickNumber].setFocus();
      }
      
      public function show(number:int) : void
      {
         var alertInfo:AlertInfo = new AlertInfo();
         alertInfo.title = LanguageMgr.GetTranslation("tank.view.store.matte.goldQuickBuy");
         alertInfo.data = this._list;
         alertInfo.submitLabel = LanguageMgr.GetTranslation("store.view.shortcutBuy.buyBtn");
         alertInfo.showCancel = false;
         alertInfo.moveEnable = false;
         info = alertInfo;
         addToContent(this._list);
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_TOP_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
         this.clickNumber = number;
      }
      
      override public function dispose() : void
      {
         var item:QuickBuyItem = null;
         this.removeEvents();
         for each(item in this._cellItems)
         {
            ObjectUtils.disposeObject(item);
         }
         this._cellItems = null;
         this._cellId = null;
         this._shopItemInfoList = null;
         if(Boolean(this._list))
         {
            ObjectUtils.disposeObject(this._list);
         }
         this._list = null;
         super.dispose();
         ObjectUtils.disposeAllChildren(this);
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
      
      public function get selectedItem() : QuickBuyItem
      {
         return this._selectedItem;
      }
      
      public function set selectedItem(val:QuickBuyItem) : void
      {
         var selectedItem:QuickBuyItem = this._selectedItem;
         this._selectedItem = val;
         this._selectedItem.selected = true;
         if(Boolean(selectedItem) && this._selectedItem != selectedItem)
         {
            selectedItem.selected = false;
         }
      }
   }
}

