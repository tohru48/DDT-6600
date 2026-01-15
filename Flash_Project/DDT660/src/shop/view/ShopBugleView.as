package shop.view
{
   import bagAndInfo.cell.CellFactory;
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.SelectedButtonGroup;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.controls.container.HBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.vo.AlertInfo;
   import ddt.data.EquipType;
   import ddt.data.goods.ShopItemInfo;
   import ddt.manager.ChatManager;
   import ddt.manager.KeyboardShortcutsManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.ShopManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.ui.Keyboard;
   
   public class ShopBugleView extends Sprite implements Disposeable
   {
      
      private static const BUGLE:uint = 3;
      
      private static const GOLD:uint = 0;
      
      private static const TEXP:uint = 6;
      
      public static const DONT_BUY_ANYTHING:String = "dontBuyAnything";
      
      private var _frame:BaseAlerFrame;
      
      private var _info:ShopItemInfo;
      
      private var _itemContainer:HBox;
      
      private var _itemGroup:SelectedButtonGroup;
      
      private var _type:int;
      
      private var _buyFrom:int;
      
      public function ShopBugleView($type:int)
      {
         super();
         this._type = $type;
         this.init();
         ChatManager.Instance.focusFuncEnabled = false;
         if(Boolean(this._info))
         {
            LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.ALPHA_BLOCKGOUND);
         }
      }
      
      public function dispose() : void
      {
         var item:ShopBugleViewItem = null;
         StageReferance.stage.removeEventListener(KeyboardEvent.KEY_DOWN,this.__onKeyDownd);
         if(this._type == EquipType.TEXP_LV_II)
         {
            KeyboardShortcutsManager.Instance.prohibitNewHandBag(true);
         }
         while(this._itemContainer.numChildren > 0)
         {
            item = this._itemContainer.getChildAt(0) as ShopBugleViewItem;
            item.removeEventListener(MouseEvent.CLICK,this.__click);
            item.dispose();
            item = null;
         }
         this._frame.dispose();
         this.clearAllItem();
         this._frame = null;
         this._itemContainer.dispose();
         this._itemContainer = null;
         this._info = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
         ChatManager.Instance.focusFuncEnabled = true;
      }
      
      public function get type() : int
      {
         return this._type;
      }
      
      public function get info() : ShopItemInfo
      {
         return this._info;
      }
      
      protected function __onKeyDownd(e:KeyboardEvent) : void
      {
         var number:int = this._itemGroup.selectIndex;
         var max:int = this._itemContainer.numChildren;
         if(e.keyCode == Keyboard.LEFT)
         {
            number = number == 0 ? 0 : --number;
         }
         else if(e.keyCode == Keyboard.RIGHT)
         {
            number = number == max - 1 ? max - 1 : ++number;
         }
         if(this._itemGroup.selectIndex != number)
         {
            SoundManager.instance.play("008");
            this._itemGroup.selectIndex = number;
         }
         e.stopImmediatePropagation();
         e.stopPropagation();
      }
      
      private function __frameEventHandler(e:FrameEvent) : void
      {
         var item:ShopBugleViewItem = null;
         SoundManager.instance.play("008");
         switch(e.responseCode)
         {
            case FrameEvent.SUBMIT_CLICK:
            case FrameEvent.ENTER_CLICK:
               if(PlayerManager.Instance.Self.bagLocked)
               {
                  BaglockedManager.Instance.show();
                  return;
               }
               item = this._itemContainer.getChildAt(this._itemGroup.selectIndex) as ShopBugleViewItem;
               if(PlayerManager.Instance.Self.Money < item.money)
               {
                  LeavePageManager.showFillFrame();
                  return;
               }
               SocketManager.Instance.out.sendBuyGoods([this._info.GoodsID],[item.type],[""],[0],[Boolean(0)],[""],this._buyFrom);
               this.dispose();
               break;
            case FrameEvent.CANCEL_CLICK:
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.ESC_CLICK:
               dispatchEvent(new Event("DONT_BUY_ANYTHING"));
               this.dispose();
         }
      }
      
      private function addItem(info:ShopItemInfo, index:int) : void
      {
         var shape:Shape = new Shape();
         shape.graphics.beginFill(16777215,0);
         shape.graphics.drawRect(0,0,70,70);
         shape.graphics.endFill();
         var cell:ShopItemCell = CellFactory.instance.createShopItemCell(shape,info.TemplateInfo) as ShopItemCell;
         PositionUtils.setPos(cell,"ddtshop.BugleViewItemCellPos");
         var item:ShopBugleViewItem = new ShopBugleViewItem(index,info.getTimeToString(index),info.getItemPrice(index).moneyValue,cell);
         item.addEventListener(MouseEvent.CLICK,this.__click);
         this._itemContainer.addChild(item);
         this._itemGroup.addSelectItem(item);
      }
      
      private function __click(e:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._itemGroup.selectIndex = this._itemContainer.getChildIndex(e.currentTarget as ShopBugleViewItem);
      }
      
      private function addItems() : void
      {
         var id:int = 0;
         if(this._type == EquipType.T_BBUGLE)
         {
            id = EquipType.T_BBUGLE;
            this._frame.titleText = LanguageMgr.GetTranslation("tank.dialog.showbugleframe.bigbugletitle");
            this._buyFrom = BUGLE;
         }
         else if(this._type == EquipType.T_SBUGLE)
         {
            id = EquipType.T_SBUGLE;
            this._frame.titleText = LanguageMgr.GetTranslation("tank.dialog.showbugleframe.smallbugletitle");
            this._buyFrom = BUGLE;
         }
         else if(this._type == EquipType.T_CBUGLE)
         {
            id = EquipType.T_CBUGLE;
            this._frame.titleText = LanguageMgr.GetTranslation("tank.dialog.showbugleframe.crossbugletitle");
            this._buyFrom = BUGLE;
         }
         else if(this._type == EquipType.CADDY_KEY)
         {
            id = EquipType.CADDY_KEY;
            this._frame.titleText = LanguageMgr.GetTranslation("tank.view.store.matte.goldQuickBuy");
            this._buyFrom = GOLD;
         }
         else if(this._type == EquipType.TEXP_LV_II)
         {
            id = EquipType.TEXP_LV_II;
            this._frame.titleText = LanguageMgr.GetTranslation("tank.dialog.showbugleframe.texpQuickBuy");
            this._buyFrom = TEXP;
         }
         this._info = ShopManager.Instance.getMoneyShopItemByTemplateID(id,true);
         if(Boolean(this._info))
         {
            if(this._info.getItemPrice(1).IsValid)
            {
               this.addItem(this._info,1);
            }
            if(this._info.getItemPrice(2).IsValid)
            {
               this.addItem(this._info,2);
            }
            if(this._info.getItemPrice(3).IsValid)
            {
               this.addItem(this._info,3);
            }
         }
      }
      
      private function clearAllItem() : void
      {
         var item:ShopBugleViewItem = null;
         while(this._itemContainer.numChildren > 0)
         {
            item = this._itemContainer.getChildAt(0) as ShopBugleViewItem;
            item.removeEventListener(MouseEvent.CLICK,this.__click);
            item.dispose();
            item = null;
         }
      }
      
      private function init() : void
      {
         this._itemGroup = new SelectedButtonGroup();
         this._frame = ComponentFactory.Instance.creatComponentByStylename("ddtshop.newBugleFrame");
         this._itemContainer = ComponentFactory.Instance.creatComponentByStylename("ddtshop.newBugleViewItemContainer");
         var ai:AlertInfo = new AlertInfo("",LanguageMgr.GetTranslation("tank.dialog.showbugleframe.ok"));
         this._frame.info = ai;
         this._frame.addToContent(this._itemContainer);
         this._frame.addEventListener(FrameEvent.RESPONSE,this.__frameEventHandler);
         addChild(this._frame);
         this.updateView();
         this._itemGroup.selectIndex = 0;
         StageReferance.stage.addEventListener(KeyboardEvent.KEY_DOWN,this.__onKeyDownd);
      }
      
      private function updateView() : void
      {
         this.clearAllItem();
         this.addItems();
      }
   }
}

