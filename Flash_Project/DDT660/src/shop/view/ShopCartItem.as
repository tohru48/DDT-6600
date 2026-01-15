package shop.view
{
   import bagAndInfo.cell.CellFactory;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.SelectedButtonGroup;
   import com.pickgliss.ui.controls.SelectedCheckButton;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.Image;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.data.goods.Price;
   import ddt.data.goods.ShopCarItemInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextFormat;
   import shop.manager.ShopBuyManager;
   
   public class ShopCartItem extends Sprite implements Disposeable
   {
      
      public static const DELETE_ITEM:String = "deleteitem";
      
      public static const CONDITION_CHANGE:String = "conditionchange";
      
      public static const ADD_LENGTH:String = "add_length";
      
      protected var _bg:DisplayObject;
      
      protected var _itemCellBg:DisplayObject;
      
      protected var _verticalLine:Image;
      
      protected var _cartItemGroup:SelectedButtonGroup;
      
      protected var _cartItemSelectVBox:VBox;
      
      protected var _closeBtn:BaseButton;
      
      public var id:int;
      
      public var type:int;
      
      public var upDataBtnState:Function;
      
      protected var _itemName:FilterFrameText;
      
      protected var _cell:ShopPlayerCell;
      
      protected var _shopItemInfo:ShopCarItemInfo;
      
      protected var _blueTF:TextFormat;
      
      protected var _yellowTF:TextFormat;
      
      public var seleBand:Function;
      
      private var _items:Vector.<SelectedCheckButton>;
      
      protected var _isBand:Boolean;
      
      public function ShopCartItem()
      {
         super();
         this.drawBackground();
         this.drawNameField();
         this.drawCellField();
         this._closeBtn = ComponentFactory.Instance.creatComponentByStylename("ddtshop.CartItemCloseBtn");
         this._cartItemSelectVBox = ComponentFactory.Instance.creatComponentByStylename("ddtshop.CartItemSelectVBox");
         this._cartItemGroup = new SelectedButtonGroup();
         addChild(this._closeBtn);
         addChild(this._cartItemSelectVBox);
         this.initListener();
      }
      
      public function get closeBtn() : BaseButton
      {
         return this._closeBtn;
      }
      
      protected function drawBackground(bool:Boolean = false) : void
      {
         this._bg = ComponentFactory.Instance.creatComponentByStylename("ddtshop.CartItemBg");
         this._itemCellBg = ComponentFactory.Instance.creat("ddtshop.CartItemCellBg");
         this._verticalLine = ComponentFactory.Instance.creatComponentByStylename("ddtshop.VerticalLine");
         addChild(this._bg);
         addChild(this._verticalLine);
         addChild(this._itemCellBg);
      }
      
      protected function drawNameField() : void
      {
         this._itemName = ComponentFactory.Instance.creatComponentByStylename("ddtshop.CartItemName");
         addChild(this._itemName);
      }
      
      protected function drawCellField() : void
      {
         this._cell = CellFactory.instance.createShopCartItemCell() as ShopPlayerCell;
         PositionUtils.setPos(this._cell,"ddtshop.CartItemCellPoint");
         addChild(this._cell);
      }
      
      public function get isBand() : Boolean
      {
         return this._isBand;
      }
      
      public function set isBand(bool:Boolean) : void
      {
         this._isBand = bool;
      }
      
      protected function initListener() : void
      {
         this._closeBtn.addEventListener(MouseEvent.CLICK,this.__closeClick);
         addEventListener(MouseEvent.CLICK,this.clickHander);
      }
      
      public function addItem(bool:Boolean = false) : void
      {
         if(this._shopItemInfo.getCurrentPrice().PriceType == Price.DDT_MONEY)
         {
            return;
         }
         if(this.type == ShopCheckOutView.PRESENT)
         {
            return;
         }
         this._isBand = bool;
         if(Price.ONLYDDT_MONEY)
         {
            this.addSelectedBandBtn();
         }
         else if(Price.ONLYMONEY)
         {
            this.addSelectedBtn();
         }
         else
         {
            this.addSelectedBtn();
            this.addSelectedBandBtn();
         }
      }
      
      private function addSelectedBtn() : void
      {
      }
      
      private function addSelectedBandBtn() : void
      {
      }
      
      public function setDianquanType(bool:Boolean = false) : void
      {
         var vTimeString:String = null;
         var num:int = 0;
         var index:int = 0;
         var len:int = int(this._items.length);
         for(var i:int = 0; i < len; i++)
         {
            index = i + 1;
            if(bool)
            {
               vTimeString = this._shopItemInfo.getTimeToString(index) != LanguageMgr.GetTranslation("ddt.shop.buyTime1") ? this._shopItemInfo.getTimeToString(index) : LanguageMgr.GetTranslation("ddt.shop.buyTime2");
               this._items[i].text = this._shopItemInfo.getItemPrice(index).toString(true) + "/" + vTimeString;
               num = this.rigthValue(index);
            }
            else
            {
               vTimeString = this._shopItemInfo.getTimeToString(index) != LanguageMgr.GetTranslation("ddt.shop.buyTime1") ? this._shopItemInfo.getTimeToString(index) : LanguageMgr.GetTranslation("ddt.shop.buyTime2");
               this._items[i].text = this._shopItemInfo.getItemPrice(index).toString() + "/" + vTimeString;
               num = this.rigthValue(index);
            }
         }
         if(Boolean(parent) && this.seleBand != null)
         {
            this.seleBand(this.id,num,bool);
         }
      }
      
      private function rigthValue(index:int) : int
      {
         if(index == this._shopItemInfo.currentBuyType)
         {
            return this._shopItemInfo.getItemPrice(index).moneyValue;
         }
         return 0;
      }
      
      protected function clickHander(event:Event) : void
      {
         if(this.type == ShopCheckOutView.PRESENT || this.type == ShopCheckOutView.ASKTYPE)
         {
            return;
         }
         if(this._shopItemInfo.getCurrentPrice().PriceType == Price.DDT_MONEY)
         {
            return;
         }
         if(event.currentTarget.id == ShopBuyManager.crrItemId)
         {
            return;
         }
         if(event.target is SelectedCheckButton)
         {
            return;
         }
         if(event.target is FilterFrameText)
         {
            return;
         }
         dispatchEvent(new Event(ADD_LENGTH));
      }
      
      protected function removeEvent() : void
      {
         if(Boolean(this._cartItemGroup))
         {
            this._cartItemGroup.removeEventListener(Event.CHANGE,this.__cartItemGroupChange);
            this._cartItemGroup = null;
         }
         if(Boolean(this._closeBtn))
         {
            this._closeBtn.removeEventListener(MouseEvent.CLICK,this.__closeClick);
         }
         removeEventListener(MouseEvent.CLICK,this.clickHander);
      }
      
      protected function __closeClick(evt:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         dispatchEvent(new Event(DELETE_ITEM));
      }
      
      protected function __cartItemGroupChange(event:Event) : void
      {
         this._shopItemInfo.currentBuyType = this._cartItemGroup.selectIndex + 1;
         dispatchEvent(new Event(CONDITION_CHANGE));
      }
      
      public function setShopItemInfo(value:ShopCarItemInfo, $id:int = -10, bool:Boolean = false) : void
      {
         if(this._shopItemInfo != value)
         {
            this._cell.info = value.TemplateInfo;
            this._shopItemInfo = value;
            if(this.id == $id)
            {
               this.addItem(bool);
            }
            if(value == null)
            {
               this._itemName.text = "";
            }
            else
            {
               this._itemName.text = String(value.TemplateInfo.Name);
               this.cartItemSelectVBoxInit();
               this.setDianquanType(bool);
            }
         }
      }
      
      protected function cartItemSelectVBoxInit() : void
      {
         var cartItemSelectBtn:SelectedCheckButton = null;
         var vTimeString:String = null;
         var str:String = null;
         this.clearitem();
         this._cartItemGroup = new SelectedButtonGroup();
         this._cartItemGroup.addEventListener(Event.CHANGE,this.__cartItemGroupChange);
         this._items = new Vector.<SelectedCheckButton>();
         for(var i:int = 1; i < 4; i++)
         {
            if(this._shopItemInfo.getItemPrice(i).IsValid)
            {
               cartItemSelectBtn = ComponentFactory.Instance.creatComponentByStylename("ddtshop.CartItemSelectBtn");
               vTimeString = this._shopItemInfo.getTimeToString(i) != LanguageMgr.GetTranslation("ddt.shop.buyTime1") ? this._shopItemInfo.getTimeToString(i) : LanguageMgr.GetTranslation("ddt.shop.buyTime2");
               str = this._shopItemInfo.getItemPrice(i).toString();
               cartItemSelectBtn.text = this._shopItemInfo.getItemPrice(i).toString() + "/" + vTimeString;
               this._cartItemSelectVBox.addChild(cartItemSelectBtn);
               cartItemSelectBtn.addEventListener(MouseEvent.CLICK,this.__soundPlay);
               this._items.push(cartItemSelectBtn);
               this._cartItemGroup.addSelectItem(cartItemSelectBtn);
            }
         }
         this._cartItemGroup.selectIndex = this._shopItemInfo.currentBuyType - 1 < 1 ? 0 : this._shopItemInfo.currentBuyType - 1;
         if(this._cartItemSelectVBox.numChildren == 2)
         {
            this._cartItemSelectVBox.y = 15;
         }
         else if(this._cartItemSelectVBox.numChildren == 1)
         {
            this._cartItemSelectVBox.y = 33;
         }
         else if(this._cartItemSelectVBox.numChildren == 3)
         {
            this._cartItemSelectVBox.y = 9;
         }
      }
      
      private function clearitem() : void
      {
         var i:int = 0;
         if(Boolean(this._cartItemGroup))
         {
            this._cartItemGroup.removeEventListener(Event.CHANGE,this.__cartItemGroupChange);
            this._cartItemGroup = null;
         }
         if(Boolean(this._items))
         {
            for(i = 0; i < this._items.length; i++)
            {
               if(Boolean(this._items[i]))
               {
                  ObjectUtils.disposeObject(this._items[i]);
                  this._items[i].removeEventListener(MouseEvent.CLICK,this.__soundPlay);
               }
               this._items[i] = null;
            }
         }
         if(Boolean(this._cartItemSelectVBox))
         {
            this._cartItemSelectVBox.disposeAllChildren();
         }
      }
      
      protected function __soundPlay(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
      }
      
      public function get shopItemInfo() : ShopCarItemInfo
      {
         return this._shopItemInfo;
      }
      
      public function get info() : ItemTemplateInfo
      {
         return this._cell.info;
      }
      
      public function get TemplateID() : int
      {
         if(this._cell.info == null)
         {
            return -1;
         }
         return this._cell.info.TemplateID;
      }
      
      public function setColor(color:*) : void
      {
         this._cell.setColor(color);
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         this.clearitem();
         ObjectUtils.disposeAllChildren(this);
         this._cartItemSelectVBox = null;
         this._cartItemGroup = null;
         this._bg = null;
         this._itemCellBg = null;
         this._verticalLine = null;
         this._closeBtn = null;
         this._itemName = null;
         this._cell = null;
         this._shopItemInfo = null;
         this._blueTF = null;
         this._yellowTF = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

