package ddt.view.caddyII.offerPack
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.SelectedButtonGroup;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.controls.container.HBox;
   import com.pickgliss.ui.image.Image;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.vo.AlertInfo;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.command.NumberSelecter;
   import ddt.data.EquipType;
   import ddt.data.goods.ShopItemInfo;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class OfferQuickBuyFrame extends BaseAlerFrame
   {
      
      private var _list:HBox;
      
      private var _cellItems:Vector.<OfferQuickCell>;
      
      private var _moneyTxt:FilterFrameText;
      
      private var _selectNumber:NumberSelecter;
      
      private var _itemGroup:SelectedButtonGroup;
      
      private var _money:int;
      
      private var _select:int = -1;
      
      private var _selectCell:OfferQuickCell;
      
      private var _shopInfoList:Vector.<ShopItemInfo> = new Vector.<ShopItemInfo>();
      
      private var _itemTempLateID:Array = [EquipType.OFFER_PACK_I,EquipType.OFFER_PACK_II,EquipType.OFFER_PACK_III,EquipType.OFFER_PACK_IV,EquipType.OFFER_PACK_V];
      
      public function OfferQuickBuyFrame()
      {
         super();
         this.initView();
         this.initEvents();
      }
      
      private function initView() : void
      {
         this._list = ComponentFactory.Instance.creatComponentByStylename("offer.quickBox");
         this._selectNumber = ComponentFactory.Instance.creatCustomObject("offer.numberSelecter");
         var _tipsTextBg:Image = ComponentFactory.Instance.creatComponentByStylename("offer.TipsTextBg");
         var _totalTipText:FilterFrameText = ComponentFactory.Instance.creatComponentByStylename("offer.TotalTipsText");
         _totalTipText.text = LanguageMgr.GetTranslation("ddt.QuickFrame.TotalTipText");
         this._moneyTxt = ComponentFactory.Instance.creatComponentByStylename("offer.TotalText");
         this._itemGroup = new SelectedButtonGroup();
         addToContent(this._moneyTxt);
         addToContent(this._selectNumber);
         addToContent(_tipsTextBg);
         addToContent(_totalTipText);
         addToContent(this._moneyTxt);
         this.createCell();
      }
      
      private function initEvents() : void
      {
         addEventListener(FrameEvent.RESPONSE,this._response);
         this._selectNumber.addEventListener(Event.CHANGE,this._numberChange);
         this._selectNumber.addEventListener(NumberSelecter.NUMBER_CLOSE,this._numberClose);
         this._selectNumber.addEventListener(NumberSelecter.NUMBER_ENTER,this._numberEnter);
      }
      
      private function removeEvents() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this._response);
         this._selectNumber.removeEventListener(Event.CHANGE,this._numberChange);
         this._selectNumber.removeEventListener(NumberSelecter.NUMBER_CLOSE,this._numberClose);
         this._selectNumber.removeEventListener(NumberSelecter.NUMBER_ENTER,this._numberEnter);
      }
      
      public function set offShopList(pValue:Vector.<ShopItemInfo>) : void
      {
         this._shopInfoList = pValue;
      }
      
      public function get offShopList() : Vector.<ShopItemInfo>
      {
         return this._shopInfoList;
      }
      
      private function createCell() : void
      {
         var cell:OfferQuickCell = null;
         this._list.beginChanges();
         for(var i:int = 0; i < this._itemTempLateID.length; i++)
         {
            cell = new OfferQuickCell();
            cell.info = ItemManager.Instance.getTemplateById(this._itemTempLateID[i]);
            cell.addEventListener(MouseEvent.CLICK,this._itemClick);
            this._itemGroup.addSelectItem(cell);
            this._list.addChild(cell);
         }
         this._list.commitChanges();
      }
      
      private function removeListChildEvent() : void
      {
         for(var i:int = 0; i < this._list.numChildren; i++)
         {
            this._list.getChildAt(i).removeEventListener(MouseEvent.CLICK,this._itemClick);
         }
      }
      
      private function _numberChange(e:Event) : void
      {
         this.money = this._selectNumber.number * this._shopInfoList[this.select].getItemPrice(1).gesteValue;
      }
      
      private function _numberClose(e:Event) : void
      {
         ObjectUtils.disposeObject(this);
      }
      
      private function _numberEnter(e:Event) : void
      {
         this.buy();
         ObjectUtils.disposeObject(this);
      }
      
      private function _response(e:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         if(e.responseCode == FrameEvent.ENTER_CLICK || e.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            this.buy();
         }
         ObjectUtils.disposeObject(this);
      }
      
      private function _itemClick(e:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._selectCell = e.currentTarget as OfferQuickCell;
         this.select = this._list.getChildIndex(this._selectCell);
         this._selectNumber.number = 1;
      }
      
      private function buy() : void
      {
         if(PlayerManager.Instance.Self.ConsortiaID == 0)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.offer.noConsortia"));
            return;
         }
         if(PlayerManager.Instance.Self.consortiaInfo.ShopLevel < this._shopInfoList[this.select].ShopID - 10)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.consortia.consortiashop.ConsortiaShopItem.checkMoney"));
            return;
         }
         if(PlayerManager.Instance.Self.Offer < this._shopInfoList[this.select].getItemPrice(1).gesteValue)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.offer.noOffer"));
            return;
         }
         var items:Array = [];
         var types:Array = [];
         var colors:Array = [];
         var dresses:Array = [];
         var skins:Array = [];
         var places:Array = [];
         for(var i:int = 0; i < this._selectNumber.number; i++)
         {
            items.push(this._shopInfoList[this.select].GoodsID);
            types.push(1);
            colors.push("");
            dresses.push(false);
            skins.push("");
            places.push(-1);
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
      
      public function set money(value:int) : void
      {
         this._money = value;
         this._moneyTxt.text = String(this._money) + " " + LanguageMgr.GetTranslation("offer");
      }
      
      public function get money() : int
      {
         return this._money;
      }
      
      public function set select(value:int) : void
      {
         if(this._select == value)
         {
            return;
         }
         this._select = value;
         this._itemGroup.selectIndex = this._select;
         this._numberChange(null);
      }
      
      public function get select() : int
      {
         return this._select;
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
         this.select = number;
      }
      
      override public function dispose() : void
      {
         var cell:OfferQuickCell = null;
         this.removeListChildEvent();
         this.removeEvents();
         if(Boolean(this._list))
         {
            ObjectUtils.disposeObject(this._list);
         }
         this._list = null;
         if(Boolean(this._moneyTxt))
         {
            ObjectUtils.disposeObject(this._moneyTxt);
         }
         this._moneyTxt = null;
         if(Boolean(this._selectNumber))
         {
            ObjectUtils.disposeObject(this._selectNumber);
         }
         this._selectNumber = null;
         if(Boolean(this._selectCell))
         {
            ObjectUtils.disposeObject(this._selectCell);
         }
         this._selectCell = null;
         if(Boolean(this._itemGroup))
         {
            ObjectUtils.disposeObject(this._itemGroup);
         }
         this._itemGroup = null;
         for each(cell in this._cellItems)
         {
            ObjectUtils.disposeObject(cell);
         }
         this._cellItems = null;
         this._shopInfoList = null;
         ObjectUtils.disposeAllChildren(this);
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

