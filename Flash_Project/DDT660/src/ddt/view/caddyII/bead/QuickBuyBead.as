package ddt.view.caddyII.bead
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
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.ShopManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class QuickBuyBead extends BaseAlerFrame
   {
      
      private var _list:HBox;
      
      private var _cellItems:Vector.<QuickBuyItem>;
      
      private var _moneyTxt:FilterFrameText;
      
      private var _money:int;
      
      private var _clickNumber:int;
      
      private var _cellId:Array = [EquipType.BEAD_ATTACK,EquipType.BEAD_DEFENSE,EquipType.BEAD_ATTRIBUTE];
      
      private var _selectedItem:QuickBuyItem;
      
      public function QuickBuyBead()
      {
         super();
         this.initView();
         this.initEvents();
      }
      
      private function initView() : void
      {
         this._list = ComponentFactory.Instance.creatComponentByStylename("bead.quickBox");
         var font1:Image = ComponentFactory.Instance.creatComponentByStylename("bead.quickFont1");
         var font2:Image = ComponentFactory.Instance.creatComponentByStylename("bead.quickFont2");
         var moneyBG:Image = ComponentFactory.Instance.creatComponentByStylename("bead.quickMoneyBG");
         this._moneyTxt = ComponentFactory.Instance.creatComponentByStylename("bead.moneyTxt");
         addToContent(font1);
         addToContent(font2);
         addToContent(moneyBG);
         addToContent(this._moneyTxt);
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
      }
      
      private function __itemClick(evt:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         var item:QuickBuyItem = evt.currentTarget as QuickBuyItem;
         this.selectedItem = item;
      }
      
      private function _response(e:FrameEvent) : void
      {
         var alert:BaseAlerFrame = null;
         SoundManager.instance.play("008");
         if(e.responseCode == FrameEvent.SUBMIT_CLICK || e.responseCode == FrameEvent.ENTER_CLICK)
         {
            if(this.money > 0)
            {
               if(PlayerManager.Instance.Self.Money < this.money)
               {
                  ObjectUtils.disposeObject(this);
                  alert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.view.comon.lack"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,false,LayerManager.ALPHA_BLOCKGOUND);
                  alert.moveEnable = false;
                  alert.addEventListener(FrameEvent.RESPONSE,this._responseI);
                  return;
               }
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
         var item:QuickBuyItem = null;
         var targetItem:QuickBuyItem = null;
         var sum:int = 0;
         for each(item in this._cellItems)
         {
            sum += item.count * ShopManager.Instance.getMoneyShopItemByTemplateID(item.info.TemplateID).getItemPrice(1).moneyValue;
         }
         this.money = sum;
         targetItem = e.currentTarget as QuickBuyItem;
         this.selectedItem = targetItem;
      }
      
      private function _numberClose(e:Event) : void
      {
         ObjectUtils.disposeObject(this);
      }
      
      private function _numberEnter(e:Event) : void
      {
         if(this.money > 0)
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
         var item:QuickBuyItem = null;
         var i:int = 0;
         var items:Array = [];
         var types:Array = [];
         var colors:Array = [];
         var dresses:Array = [];
         var skins:Array = [];
         var places:Array = [];
         for each(item in this._cellItems)
         {
            for(i = 0; i < item.count; i++)
            {
               items.push(ShopManager.Instance.getMoneyShopItemByTemplateID(item.info.TemplateID).GoodsID);
               types.push(1);
               colors.push("");
               dresses.push(false);
               skins.push("");
               places.push(-1);
            }
         }
         SocketManager.Instance.out.sendBuyGoods(items,types,colors,places,dresses,skins,5);
      }
      
      private function _responseI(e:FrameEvent) : void
      {
         (e.currentTarget as BaseAlerFrame).removeEventListener(FrameEvent.RESPONSE,this._responseI);
         if(e.responseCode == FrameEvent.SUBMIT_CLICK || e.responseCode == FrameEvent.ENTER_CLICK)
         {
            LeavePageManager.showFillFrame();
         }
         ObjectUtils.disposeObject(e.target);
      }
      
      private function _showTip() : void
      {
         MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.bead.quickNode"));
      }
      
      public function set money(value:int) : void
      {
         this._money = value;
         this._moneyTxt.text = String(this._money);
      }
      
      public function get money() : int
      {
         return this._money;
      }
      
      public function set clickNumber(value:int) : void
      {
         if(value >= 0)
         {
            this._clickNumber = value;
            this._cellItems[this._clickNumber].count = 1;
            this._cellItems[this._clickNumber].setFocus();
         }
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

