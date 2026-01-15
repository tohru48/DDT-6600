package ddt.view.common
{
   import baglocked.BaglockedManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.ComponentSetting;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.TextButton;
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
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class BuyItemButton extends TextButton
   {
      
      protected var _itemInfo:ItemTemplateInfo;
      
      protected var _shopItemInfo:ShopItemInfo;
      
      private var _needDispatchEvent:Boolean;
      
      private var _storeTab:int;
      
      private var _itemID:int;
      
      public function BuyItemButton()
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
      
      protected function initliziItemTemplate() : void
      {
         this._itemInfo = ItemManager.Instance.getTemplateById(this._itemID);
         this._shopItemInfo = ShopManager.Instance.getMoneyShopItemByTemplateID(this._itemID);
         var goodInfo:GoodTipInfo = new GoodTipInfo();
         goodInfo.itemInfo = this._itemInfo;
         goodInfo.isBalanceTip = false;
         goodInfo.typeIsSecond = false;
         tipData = goodInfo;
      }
      
      override protected function __onMouseClick(event:MouseEvent) : void
      {
         var _quick:QuickBuyFrame = null;
         if(_enable)
         {
            event.stopImmediatePropagation();
            if(useLogID != 0 && ComponentSetting.SEND_USELOG_ID != null)
            {
               ComponentSetting.SEND_USELOG_ID(useLogID);
            }
            SoundManager.instance.play("008");
            if(PlayerManager.Instance.Self.bagLocked)
            {
               BaglockedManager.Instance.show();
               return;
            }
            _quick = ComponentFactory.Instance.creatComponentByStylename("ddtcore.QuickFrame");
            _quick.setTitleText(LanguageMgr.GetTranslation("tank.view.store.matte.goldQuickBuy"));
            _quick.itemID = this._itemID;
            _quick.buyFrom = this._storeTab;
            _quick.addEventListener(ShortcutBuyEvent.SHORTCUT_BUY,this.__shortCutBuyHandler);
            _quick.addEventListener(Event.REMOVED_FROM_STAGE,this.removeFromStageHandler);
            LayerManager.Instance.addToLayer(_quick,LayerManager.GAME_TOP_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
         }
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
      
      override public function dispose() : void
      {
         super.dispose();
         this._itemInfo = null;
         this._shopItemInfo = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

