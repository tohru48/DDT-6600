package gemstone.items
{
   import bagAndInfo.cell.BagCell;
   import baglocked.BaglockedManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.bagStore.BagStore;
   import ddt.command.QuickBuyFrame;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.data.goods.ShopItemInfo;
   import ddt.events.ShortcutBuyEvent;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.ShopManager;
   import ddt.manager.SoundManager;
   import ddt.view.tips.GoodTipInfo;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class GemstoneBuyItem extends Sprite
   {
      
      private var _itemID:int;
      
      private var _needDispatchEvent:Boolean;
      
      private var _storeTab:int;
      
      private var _itemInfo:ItemTemplateInfo;
      
      private var _shopItemInfo:ShopItemInfo;
      
      private var tipData:GoodTipInfo;
      
      private var _cell:BagCell;
      
      private var _txt:FilterFrameText;
      
      private var _btn:SimpleBitmapButton;
      
      public function GemstoneBuyItem()
      {
         super();
      }
      
      public function setup(itemID:int, storeTab:int, needDispacthEvent:Boolean = false) : void
      {
         this._itemID = itemID;
         this._storeTab = storeTab;
         this._needDispatchEvent = needDispacthEvent;
         this.initliziItemTemplate();
      }
      
      private function initliziItemTemplate() : void
      {
         this._itemInfo = ItemManager.Instance.getTemplateById(this._itemID);
         this._shopItemInfo = ShopManager.Instance.getMoneyShopItemByTemplateID(this._itemID);
         var goodInfo:GoodTipInfo = new GoodTipInfo();
         goodInfo.itemInfo = this._itemInfo;
         goodInfo.isBalanceTip = false;
         goodInfo.typeIsSecond = false;
         this.tipData = goodInfo;
         this._btn = ComponentFactory.Instance.creatComponentByStylename("gemstone.buy.btn");
         addChild(this._btn);
         mouseChildren = false;
         buttonMode = true;
         useHandCursor = true;
         addEventListener(MouseEvent.CLICK,this.clickHander);
      }
      
      protected function clickHander(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         var _quick:QuickBuyFrame = ComponentFactory.Instance.creatComponentByStylename("ddtcore.QuickFrame");
         _quick.setTitleText(LanguageMgr.GetTranslation("tank.view.store.matte.goldQuickBuy"));
         _quick.itemID = this._itemID;
         _quick.buyFrom = this._storeTab;
         _quick.addEventListener(ShortcutBuyEvent.SHORTCUT_BUY,this.__shortCutBuyHandler);
         _quick.addEventListener(Event.REMOVED_FROM_STAGE,this.removeFromStageHandler);
         LayerManager.Instance.addToLayer(_quick,LayerManager.GAME_TOP_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      private function removeFromStageHandler(event:Event) : void
      {
         BagStore.instance.reduceTipPanelNumber();
      }
      
      private function __shortCutBuyHandler(evt:ShortcutBuyEvent) : void
      {
         evt.stopImmediatePropagation();
         if(this._needDispatchEvent)
         {
            dispatchEvent(new ShortcutBuyEvent(evt.ItemID,evt.ItemNum));
         }
      }
      
      public function setText(str:String) : void
      {
         this._txt.text = str;
      }
      
      public function dispose() : void
      {
         while(Boolean(numChildren))
         {
            ObjectUtils.disposeObject(getChildAt(0));
         }
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

