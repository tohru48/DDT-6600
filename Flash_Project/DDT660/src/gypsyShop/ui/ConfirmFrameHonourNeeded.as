package gypsyShop.ui
{
   import ddt.manager.LanguageMgr;
   import gypsyShop.ctrl.GypsyShopManager;
   import gypsyShop.model.GypsyPurchaseModel;
   import gypsyShop.ui.confirmAlertFrame.ConfirmFrameHonourWithNotShowCheckManager;
   
   public class ConfirmFrameHonourNeeded
   {
      
      private var _confirmFrameMngr:ConfirmFrameHonourWithNotShowCheckManager;
      
      public function ConfirmFrameHonourNeeded()
      {
         super();
         this._confirmFrameMngr = new ConfirmFrameHonourWithNotShowCheckManager();
      }
      
      public function alert() : void
      {
         var detail:String = LanguageMgr.GetTranslation("tank.game.GameView.gypsyHonourConfirm",this.getPrice());
         var title:String = LanguageMgr.GetTranslation("AlertDialog.Info");
         this._confirmFrameMngr.detail = detail;
         this._confirmFrameMngr.title = title;
         this._confirmFrameMngr.frameType = "SimpleAlert";
         this._confirmFrameMngr.needMoney = this.getPrice();
         this._confirmFrameMngr.onComfirm = this.onConfirm;
         this._confirmFrameMngr.onNotShowAgain = this.onNotShowAgain;
         this._confirmFrameMngr.onComfirm = GypsyShopManager.getInstance().confirmToRefresh;
         this._confirmFrameMngr.isBind = this.isBind;
         this._confirmFrameMngr.alert();
      }
      
      protected function onNotShowAgain(bool:Boolean) : void
      {
         GypsyPurchaseModel.getInstance().updateShowAlertHonourRefresh(!bool);
      }
      
      protected function isBind(isBind:Boolean) : void
      {
      }
      
      protected function onConfirm() : void
      {
         GypsyShopManager.getInstance().confirmToRefresh();
      }
      
      protected function getPrice() : int
      {
         return GypsyPurchaseModel.getInstance().getHonourNeeded();
      }
   }
}

