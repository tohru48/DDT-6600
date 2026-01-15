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
   import com.pickgliss.ui.image.Image;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.vo.AlertInfo;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.EquipType;
   import ddt.data.goods.ShopItemInfo;
   import ddt.manager.ChatManager;
   import ddt.manager.KeyboardShortcutsManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.ShopManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import ddtBuried.BuriedManager;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.ui.Keyboard;
   
   public class NewShopBugleView extends Sprite implements Disposeable
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
      
      private var _text1:FilterFrameText;
      
      private var _text2:FilterFrameText;
      
      private var _textBg:Image;
      
      private var _isBand:Boolean;
      
      public function NewShopBugleView($type:int)
      {
         super();
         this._type = $type;
         this.init();
         ChatManager.Instance.focusFuncEnabled = false;
         if(Boolean(this._info))
         {
            LayerManager.Instance.addToLayer(this,LayerManager.GAME_TOP_LAYER,true,LayerManager.ALPHA_BLOCKGOUND);
         }
         this._textBg = ComponentFactory.Instance.creat("asset.medicineQuickBugTextBg");
         addChild(this._textBg);
         this._text1 = ComponentFactory.Instance.creat("asset.medicineQuickBugText1");
         addChild(this._text1);
         this._text1.text = LanguageMgr.GetTranslation("ddt.QuickFrame.TotalTipText");
         this._text2 = ComponentFactory.Instance.creat("asset.medicineQuickBugText2");
         addChild(this._text2);
         if(this._isBand)
         {
            this._text2.text = (this._itemContainer.getChildAt(0) as NewShopBugViewItem).money + LanguageMgr.GetTranslation("ddtMoney");
         }
         else
         {
            this._text2.text = (this._itemContainer.getChildAt(0) as NewShopBugViewItem).money + LanguageMgr.GetTranslation("money");
         }
      }
      
      public function dispose() : void
      {
         var item:NewShopBugViewItem = null;
         StageReferance.stage.removeEventListener(KeyboardEvent.KEY_DOWN,this.__onKeyDownd);
         if(this._type == EquipType.TEXP_LV_III)
         {
            KeyboardShortcutsManager.Instance.prohibitNewHandBag(true);
         }
         if(Boolean(this._itemContainer))
         {
            while(this._itemContainer.numChildren > 0)
            {
               item = this._itemContainer.getChildAt(0) as NewShopBugViewItem;
               item.removeEventListener(MouseEvent.CLICK,this.__click);
               item.dispose();
               item = null;
            }
            this._itemContainer.dispose();
            this._itemContainer = null;
         }
         if(Boolean(this._textBg))
         {
            this._textBg.dispose();
         }
         this._textBg = null;
         if(Boolean(this._text1))
         {
            ObjectUtils.disposeObject(this._text1);
         }
         this._text1 = null;
         if(Boolean(this._text2))
         {
            ObjectUtils.disposeObject(this._text2);
         }
         this._text2 = null;
         this._frame.dispose();
         this.clearAllItem();
         this._frame = null;
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
         if(this._isBand)
         {
            this._text2.text = this.info.getItemPrice(number + 1).moneyValue + LanguageMgr.GetTranslation("ddtMoney");
         }
         else
         {
            this._text2.text = this.info.getItemPrice(number + 1).moneyValue + LanguageMgr.GetTranslation("money");
         }
         e.stopImmediatePropagation();
         e.stopPropagation();
      }
      
      private function __frameEventHandler(e:FrameEvent) : void
      {
         var item:NewShopBugViewItem = null;
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
               item = this._itemContainer.getChildAt(this._itemGroup.selectIndex) as NewShopBugViewItem;
               if(BuriedManager.Instance.checkMoney(this._isBand,item.money))
               {
                  return;
               }
               SocketManager.Instance.out.sendBuyGoods([this._info.GoodsID],[item.type],[""],[0],[Boolean(0)],[""],this._buyFrom,null,[this._isBand]);
               break;
            case FrameEvent.CANCEL_CLICK:
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.ESC_CLICK:
               dispatchEvent(new Event("DONT_BUY_ANYTHING"));
         }
         this.dispose();
      }
      
      private function addItem(info:ShopItemInfo, index:int) : void
      {
         var shape:Shape = new Shape();
         shape.graphics.beginFill(16777215,0);
         shape.graphics.drawRect(0,0,70,70);
         shape.graphics.endFill();
         var cell:ShopItemCell = CellFactory.instance.createShopItemCell(shape,info.TemplateInfo) as ShopItemCell;
         PositionUtils.setPos(cell,"ddtshop.BugleViewItemCellPos");
         var item:NewShopBugViewItem = new NewShopBugViewItem(index,info.getTimeToString(index),info.getItemPrice(index).moneyValue,cell);
         item.addEventListener(MouseEvent.CLICK,this.__click);
         this._itemContainer.addChild(item);
         this._itemGroup.addSelectItem(item);
      }
      
      private function __click(e:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._itemGroup.selectIndex = this._itemContainer.getChildIndex(e.currentTarget as NewShopBugViewItem);
         if(this._isBand)
         {
            this._text2.text = (this._itemContainer.getChildAt(this._itemGroup.selectIndex) as NewShopBugViewItem).money + LanguageMgr.GetTranslation("ddtMoney");
         }
         else
         {
            this._text2.text = (this._itemContainer.getChildAt(this._itemGroup.selectIndex) as NewShopBugViewItem).money + LanguageMgr.GetTranslation("money");
         }
      }
      
      private function addItems() : void
      {
         var id:int = 0;
         var price1:Boolean = false;
         var price2:Boolean = false;
         var price3:Boolean = false;
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
         else if(this._type == EquipType.TEXP_LV_III)
         {
            id = EquipType.TEXP_LV_III;
            this._frame.titleText = LanguageMgr.GetTranslation("tank.dialog.showbugleframe.texpQuickBuy");
            this._buyFrom = TEXP;
         }
         this._info = ShopManager.Instance.getMoneyShopItemByTemplateID(id);
         if(Boolean(this._info))
         {
            price1 = this._info.getItemPrice(1).IsValid;
            price2 = this._info.getItemPrice(2).IsValid;
            price3 = this._info.getItemPrice(3).IsValid;
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
         var item:NewShopBugViewItem = null;
         if(!this._itemContainer)
         {
            return;
         }
         while(this._itemContainer.numChildren > 0)
         {
            item = this._itemContainer.getChildAt(0) as NewShopBugViewItem;
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
         this._frame.moveEnable = false;
         this._frame.addToContent(this._itemContainer);
         this._frame.addEventListener(FrameEvent.RESPONSE,this.__frameEventHandler);
         addChild(this._frame);
         this._isBand = false;
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

