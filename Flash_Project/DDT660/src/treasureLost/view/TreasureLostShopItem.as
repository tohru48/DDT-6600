package treasureLost.view
{
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.bagStore.BagStore;
   import ddt.command.QuickBuyFrame;
   import ddt.data.goods.ShopItemInfo;
   import ddt.events.ShortcutBuyEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import labyrinth.view.BuyFrame;
   import shop.view.ShopGoodItem;
   import treasureLost.controller.TreasureLostManager;
   
   public class TreasureLostShopItem extends ShopGoodItem
   {
      
      public static const TREASURELOST_STONE:uint = 5;
      
      protected var _explanation:FilterFrameText;
      
      private var _frame:BuyFrame;
      
      private var _quickFrame:QuickBuyFrame;
      
      public function TreasureLostShopItem()
      {
         super();
      }
      
      override protected function initContent() : void
      {
         super.initContent();
         _shopItemCellTypeBg.parent.removeChild(_shopItemCellTypeBg);
      }
      
      override protected function initPrice() : void
      {
         _itemPriceTxt.text = String(_shopItemInfo.AValue1);
         _payType.setFrame(TREASURELOST_STONE);
         _payPaneGivingBtn.visible = false;
      }
      
      override public function set shopItemInfo(value:ShopItemInfo) : void
      {
         super.shopItemInfo = value;
         this.updateCircumscribe();
      }
      
      protected function updateCircumscribe() : void
      {
         _payPaneaskBtn.visible = false;
         if(Boolean(_shopItemInfo))
         {
            _payPaneBuyBtn.visible = true;
            _itemCellBtn.filters = null;
         }
         else
         {
            _payPaneBuyBtn.visible = false;
         }
      }
      
      override protected function __payPanelClick(event:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         if(TreasureLostManager.Instance.buyFrameEnable)
         {
            this._quickFrame = ComponentFactory.Instance.creatComponentByStylename("ddtcore.QuickFrame");
            this._quickFrame.setTitleText(LanguageMgr.GetTranslation("tank.view.store.matte.goldQuickBuy"));
            this._quickFrame.setItemID(shopItemInfo.TemplateID,-1700);
            this._quickFrame.buyFrom = 0;
            this._quickFrame.addEventListener(ShortcutBuyEvent.SHORTCUT_BUY,this.__shortCutBuyHandler);
            this._quickFrame.addEventListener(Event.REMOVED_FROM_STAGE,this.removeFromStageHandler);
            LayerManager.Instance.addToLayer(this._quickFrame,LayerManager.GAME_TOP_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
         }
         else
         {
            this.buy();
         }
      }
      
      private function removeFromStageHandler(event:Event) : void
      {
         BagStore.instance.reduceTipPanelNumber();
      }
      
      private function __shortCutBuyHandler(evt:ShortcutBuyEvent) : void
      {
         evt.stopImmediatePropagation();
         dispatchEvent(new ShortcutBuyEvent(evt.ItemID,evt.ItemNum));
      }
      
      protected function __onframeEvent(event:FrameEvent) : void
      {
         SoundManager.instance.playButtonSound();
         switch(event.responseCode)
         {
            case FrameEvent.SUBMIT_CLICK:
            case FrameEvent.ENTER_CLICK:
               this.buy();
         }
         this._frame.removeEventListener(FrameEvent.RESPONSE,this.__onframeEvent);
         ObjectUtils.disposeObject(this._frame);
         this._frame = null;
      }
      
      override public function dispose() : void
      {
         if(Boolean(this._quickFrame))
         {
            this._quickFrame.removeEventListener(ShortcutBuyEvent.SHORTCUT_BUY,this.__shortCutBuyHandler);
            this._quickFrame.removeEventListener(Event.REMOVED_FROM_STAGE,this.removeFromStageHandler);
            ObjectUtils.disposeObject(this._quickFrame);
            this._quickFrame = null;
         }
         super.dispose();
      }
      
      private function buy() : void
      {
         var items:Array = new Array();
         var types:Array = new Array();
         var colors:Array = new Array();
         var dresses:Array = new Array();
         var places:Array = new Array();
         var goodsTypes:Array = [];
         var bands:Array = [];
         items.push(shopItemInfo.GoodsID);
         types.push(1);
         colors.push("");
         dresses.push("");
         places.push("");
         goodsTypes.push(1);
         bands.push("");
         SocketManager.Instance.out.sendBuyGoods(items,types,colors,places,dresses,null,0,goodsTypes,bands);
      }
   }
}

