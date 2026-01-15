package shop.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.SelectedButtonGroup;
   import com.pickgliss.ui.controls.SelectedCheckButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.Price;
   import ddt.data.goods.ShopCarItemInfo;
   import ddt.data.goods.ShopItemInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.ShopManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.filters.ColorMatrixFilter;
   
   public class ShopRechargeEquipViewItem extends ShopCartItem implements Disposeable
   {
      
      public static const DELETE_ITEM:String = "deleteitem";
      
      public static const CONDITION_CHANGE:String = "conditionchange";
      
      private var _moneyRadioBtn:SelectedCheckButton;
      
      private var _giftRadioBtn:SelectedCheckButton;
      
      private var _orderRadioBtn:SelectedCheckButton;
      
      private var _isDelete:Boolean = false;
      
      private var _radioGroup:SelectedButtonGroup;
      
      private var _shopItems:Array;
      
      private var fileterArr:Array = [new ColorMatrixFilter([0.3086,0.6094,0.082,0,0,0.3086,0.6094,0.082,0,0,0.3086,0.6094,0.082,0,0,0,0,0,1,0])];
      
      public var clieckHander:Function;
      
      public var moneType:int = 1;
      
      public function ShopRechargeEquipViewItem()
      {
         super();
         this.init();
         this.initEventListener();
      }
      
      private function init() : void
      {
         this._radioGroup = new SelectedButtonGroup();
         this._moneyRadioBtn = ComponentFactory.Instance.creatComponentByStylename("ddtshop.RechargeView.TicketSelectedCheckBtn");
         this._moneyRadioBtn.text = LanguageMgr.GetTranslation("shop.RechargeView.TicketText");
         this._giftRadioBtn = ComponentFactory.Instance.creatComponentByStylename("ddtshop.RechargeView.GiftSelectedCheckBtn");
         this._giftRadioBtn.text = LanguageMgr.GetTranslation("shop.RechargeView.GiftText");
         this._orderRadioBtn = ComponentFactory.Instance.creatComponentByStylename("ddtshop.RechargeView.OrderSelectedCheckBtn");
         this._orderRadioBtn.text = LanguageMgr.GetTranslation("shop.RechargeView.GiftText");
         PositionUtils.setPos(_itemName,"ddtshop.RechargeViewItemNamePos");
         PositionUtils.setPos(_closeBtn,"ddtshop.RechargeViewCloseBtnPos");
         PositionUtils.setPos(_cartItemSelectVBox,"ddtshop.RechargeViewSelectVBoxPos");
         this._radioGroup.addSelectItem(this._moneyRadioBtn);
         this._radioGroup.addSelectItem(this._giftRadioBtn);
         this._radioGroup.addSelectItem(this._orderRadioBtn);
         this._radioGroup.selectIndex = 0;
         addChild(this._moneyRadioBtn);
         addChild(this._giftRadioBtn);
         addChild(this._orderRadioBtn);
         this._giftRadioBtn.visible = false;
      }
      
      override protected function drawBackground(bool:Boolean = false) : void
      {
         _bg = ComponentFactory.Instance.creatComponentByStylename("ddtshop.RechargeView.CartItemBg");
         _itemCellBg = ComponentFactory.Instance.creat("ddtshop.CartItemCellBg");
         _verticalLine = ComponentFactory.Instance.creatComponentByStylename("ddtshop.RechargeView.VerticalLine");
         addChild(_bg);
         addChild(_verticalLine);
         addChild(_itemCellBg);
      }
      
      private function initEventListener() : void
      {
         this._moneyRadioBtn.addEventListener(MouseEvent.CLICK,this.__selectRadioBtn);
         this._giftRadioBtn.addEventListener(MouseEvent.CLICK,this.__selectRadioBtn);
         this._orderRadioBtn.addEventListener(MouseEvent.CLICK,this.__selectRadioBtn);
      }
      
      public function set itemInfo(value:InventoryItemInfo) : void
      {
         _cell.info = value;
         this._shopItems = ShopManager.Instance.getShopRechargeItemByTemplateId(value.TemplateID);
         _shopItemInfo = null;
         for(var i:int = 0; i < this._shopItems.length; i++)
         {
            if(Boolean(this._shopItems[i].getItemPrice(1).IsMoneyType))
            {
               _shopItemInfo = this.fillToShopCarInfo(this._shopItems[i]);
               break;
            }
         }
         if(_shopItemInfo == null)
         {
            _shopItemInfo = this.fillToShopCarInfo(this._shopItems[0]);
         }
         this.resetRadioBtn(value.IsBinds);
         this.cartItemSelectVBoxInit();
         _cartItemGroup.selectIndex = _cartItemSelectVBox.numChildren - 1;
         _itemName.text = value.Name;
      }
      
      override protected function cartItemSelectVBoxInit() : void
      {
         super.cartItemSelectVBoxInit();
         if(_cartItemSelectVBox.numChildren == 2)
         {
            _cartItemSelectVBox.y = 15;
         }
         else if(_cartItemSelectVBox.numChildren == 1)
         {
            _cartItemSelectVBox.y = 21;
         }
         else if(_cartItemSelectVBox.numChildren == 3)
         {
            _cartItemSelectVBox.y = 9;
         }
      }
      
      private function __selectRadioBtn(evt:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(evt.currentTarget == this._moneyRadioBtn)
         {
            this.updateCurrentShopItem(Price.MONEY);
            this.moneType = 1;
         }
         else if(evt.currentTarget == this._giftRadioBtn)
         {
            this.updateCurrentShopItem(Price.MONEY);
            this.moneType = 2;
         }
         else if(evt.currentTarget == this._orderRadioBtn)
         {
            this.updateCurrentShopItem(Price.DDT_MONEY);
            this.moneType = 3;
         }
         this.clieckHander(id,this.moneType);
         this.cartItemSelectVBoxInit();
         _cartItemGroup.selectIndex = _cartItemSelectVBox.numChildren - 1;
         dispatchEvent(new Event(CONDITION_CHANGE));
      }
      
      public function get currentShopItem() : ShopCarItemInfo
      {
         return _shopItemInfo;
      }
      
      public function get isDelete() : Boolean
      {
         return this._isDelete;
      }
      
      private function updateCurrentShopItem(type:int) : void
      {
         for(var i:int = 0; i < this._shopItems.length; i++)
         {
            if(this._shopItems[i].getItemPrice(1).PriceType == type)
            {
               _shopItemInfo = this.fillToShopCarInfo(this._shopItems[i]);
               break;
            }
         }
      }
      
      private function resetRadioBtn(bind:Boolean) : void
      {
         this._moneyRadioBtn.enable = this._moneyRadioBtn.selected = false;
         this._giftRadioBtn.enable = this._giftRadioBtn.selected = false;
         this._orderRadioBtn.enable = this._orderRadioBtn.selected = false;
         this._moneyRadioBtn.filters = this.fileterArr;
         this._giftRadioBtn.filters = this.fileterArr;
         this._orderRadioBtn.filters = this.fileterArr;
         for(var i:int = 0; i < this._shopItems.length; i++)
         {
            if(Boolean(this._shopItems[i].getItemPrice(1).IsMixed) || Boolean(this._shopItems[i].getItemPrice(2).IsMixed))
            {
               throw new Error("续费价格填错了！！！");
            }
            if(Boolean(this._shopItems[i].getItemPrice(1).IsMoneyType))
            {
               this._moneyRadioBtn.enable = true;
               this._moneyRadioBtn.filters = null;
            }
            else if(Boolean(this._shopItems[i].getItemPrice(1).IsBandDDTMoneyType) && (_cell.info as InventoryItemInfo).IsBinds)
            {
               this._orderRadioBtn.enable = true;
               this._orderRadioBtn.filters = null;
            }
         }
         if(_shopItemInfo.getItemPrice(1).IsMoneyType)
         {
            this._moneyRadioBtn.selected = true;
            this._giftRadioBtn.selected = false;
            this._orderRadioBtn.selected = false;
         }
      }
      
      override protected function __closeClick(evt:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         filters = this.fileterArr;
         this._isDelete = true;
         mouseChildren = false;
         evt.stopPropagation();
         addEventListener(MouseEvent.CLICK,function(e:Event):void
         {
            SoundManager.instance.play("008");
            mouseChildren = true;
            _isDelete = false;
            filters = null;
            dispatchEvent(new Event(CONDITION_CHANGE));
            removeEventListener(MouseEvent.CLICK,arguments.callee);
         });
         dispatchEvent(new Event(CONDITION_CHANGE));
      }
      
      private function fillToShopCarInfo(item:ShopItemInfo) : ShopCarItemInfo
      {
         if(!item)
         {
            return null;
         }
         var t:ShopCarItemInfo = new ShopCarItemInfo(item.GoodsID,item.TemplateID,_cell.info.CategoryID);
         ObjectUtils.copyProperties(t,item);
         return t;
      }
      
      override public function dispose() : void
      {
         super.dispose();
         this._moneyRadioBtn.removeEventListener(MouseEvent.CLICK,this.__selectRadioBtn);
         this._giftRadioBtn.removeEventListener(MouseEvent.CLICK,this.__selectRadioBtn);
         this._orderRadioBtn.removeEventListener(MouseEvent.CLICK,this.__selectRadioBtn);
         ObjectUtils.disposeAllChildren(this);
         this._moneyRadioBtn = null;
         this._giftRadioBtn = null;
         this._orderRadioBtn = null;
         this._shopItems = null;
      }
   }
}

