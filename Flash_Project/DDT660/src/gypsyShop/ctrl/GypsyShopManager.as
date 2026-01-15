package gypsyShop.ctrl
{
   import baglocked.BaglockedManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.UIModuleTypes;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import gypsyShop.model.GypsyNPCModel;
   import gypsyShop.model.GypsyPurchaseModel;
   import gypsyShop.model.GypsyShopModel;
   import gypsyShop.npcBehavior.GypsyNPCAdapter;
   import gypsyShop.npcBehavior.IGypsyNPCBehavior;
   import gypsyShop.ui.ConfirmFrameHonourNeeded;
   import gypsyShop.ui.ConfirmFrameMoneyNeeded;
   import gypsyShop.view.GypsyShopMainFrame;
   import gypsyShop.view.GypsyUILoader;
   
   public class GypsyShopManager
   {
      
      private static var instance:GypsyShopManager;
      
      private var _mainFrameGypsy:GypsyShopMainFrame;
      
      private var _npcBehavior:IGypsyNPCBehavior;
      
      private var _modelShop:GypsyShopModel;
      
      private var _gypsyShopFrameIsShowing:Boolean;
      
      public function GypsyShopManager(single:inner)
      {
         super();
         this._npcBehavior = new GypsyNPCAdapter(null);
      }
      
      public static function getInstance() : GypsyShopManager
      {
         if(!instance)
         {
            instance = new GypsyShopManager(new inner());
         }
         return instance;
      }
      
      public function init() : void
      {
         GypsyNPCModel.getInstance().init();
         this._modelShop = GypsyShopModel.getInstance();
      }
      
      public function showMainFrame() : void
      {
         new GypsyUILoader().loadUIModule("gypsy",[UIModuleTypes.GYPSYSHOP],this.onLoaded);
      }
      
      private function onLoaded() : void
      {
         this._mainFrameGypsy = ComponentFactory.Instance.creatComponentByStylename("gypsy.mainframe");
         this._mainFrameGypsy.setModel(this._modelShop);
         this._gypsyShopFrameIsShowing = true;
         LayerManager.Instance.addToLayer(this._mainFrameGypsy,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
         this._modelShop.init();
         this._modelShop.requestRareList();
         this._modelShop.requestRefreshList();
      }
      
      public function hideMainFrame() : void
      {
         this._gypsyShopFrameIsShowing = false;
         if(this._mainFrameGypsy != null)
         {
            ObjectUtils.disposeObject(this._mainFrameGypsy);
            this._mainFrameGypsy = null;
            this._modelShop.dispose();
         }
      }
      
      public function refreshNPC() : void
      {
         GypsyNPCModel.getInstance().refreshNPCState();
      }
      
      public function showNPC() : void
      {
         this._npcBehavior.show();
      }
      
      public function hideNPC() : void
      {
         this._npcBehavior.hide();
      }
      
      public function disposeNPC() : void
      {
         GypsyNPCModel.getInstance().dispose();
         this._npcBehavior.dispose();
      }
      
      public function newRareItemsUpdate() : void
      {
         this._mainFrameGypsy.updateRareItemsList();
      }
      
      public function newItemListUpdate() : void
      {
         this._mainFrameGypsy.updateNewItemList();
      }
      
      public function updateBuyResult() : void
      {
         this._mainFrameGypsy.updateBuyResult();
      }
      
      public function itemBuyBtnClicked(id:int) : void
      {
         var confirmFrame:ConfirmFrameMoneyNeeded = null;
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         if(GypsyPurchaseModel.getInstance().getUseBind() && !GypsyPurchaseModel.getInstance().isBindMoneyEnough(id))
         {
            GypsyPurchaseModel.getInstance().updateShowAlertRmbTicketBuy(true);
         }
         else if(!GypsyPurchaseModel.getInstance().getUseBind() && !GypsyPurchaseModel.getInstance().isMoneyEnough(id))
         {
            GypsyPurchaseModel.getInstance().updateShowAlertRmbTicketBuy(true);
         }
         if(GypsyPurchaseModel.getInstance().isShowRmbTicketBuyAgain())
         {
            confirmFrame = new ConfirmFrameMoneyNeeded();
            confirmFrame.setID(id);
            confirmFrame.alert();
         }
         else
         {
            this.confirmToBuy(id);
         }
      }
      
      public function confirmToBuy(id:int) : void
      {
         this._modelShop.requestBuyItem(id);
      }
      
      public function refreshBtnClicked() : void
      {
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         if(!GypsyPurchaseModel.getInstance().isHonourEnough())
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("gypsy.honourNotEnough"),0,true,3);
         }
         else if(GypsyPurchaseModel.getInstance().isShowHonourRefreshAgain())
         {
            new ConfirmFrameHonourNeeded().alert();
         }
         else
         {
            this.confirmToRefresh();
         }
      }
      
      public function confirmToRefresh() : void
      {
         this._modelShop.requestManualRefreshList();
      }
      
      public function dispose() : void
      {
         this._modelShop && this._modelShop.dispose();
         GypsyNPCModel.getInstance().dispose();
         this._npcBehavior.dispose();
      }
      
      public function set npcBehavior(value:IGypsyNPCBehavior) : void
      {
         this._npcBehavior = value;
      }
      
      public function get npcBehavior() : IGypsyNPCBehavior
      {
         return this._npcBehavior;
      }
      
      public function get gypsyShopFrameIsShowing() : Boolean
      {
         return this._gypsyShopFrameIsShowing;
      }
   }
}

class inner
{
   
   public function inner()
   {
      super();
   }
}
