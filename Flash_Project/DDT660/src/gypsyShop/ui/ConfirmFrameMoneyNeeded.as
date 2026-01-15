package gypsyShop.ui
{
   import ddt.manager.LanguageMgr;
   import gypsyShop.ctrl.GypsyShopManager;
   import gypsyShop.model.GypsyPurchaseModel;
   import gypsyShop.ui.confirmAlertFrame.ConfirmFrameWithNotShowCheckManager;
   
   public class ConfirmFrameMoneyNeeded
   {
      
      private var _confirmFrameMngr:ConfirmFrameWithNotShowCheckManager;
      
      private var _id:int;
      
      public function ConfirmFrameMoneyNeeded()
      {
         super();
         this._confirmFrameMngr = new ConfirmFrameWithNotShowCheckManager();
      }
      
      public function setID(id:int) : void
      {
         this._id = id;
      }
      
      public function alert() : void
      {
         var detail:String = LanguageMgr.GetTranslation("tank.game.GameView.gypsyRMBTicketConfirm",this.getPrice());
         var title:String = LanguageMgr.GetTranslation("AlertDialog.Info");
         this._confirmFrameMngr.detail = detail;
         this._confirmFrameMngr.title = title;
         this._confirmFrameMngr.frameType = "gypsy.confirmView";
         this._confirmFrameMngr.needMoney = this.getPrice();
         this._confirmFrameMngr.onNotShowAgain = this.onNotShowAgain;
         this._confirmFrameMngr.onComfirm = this.onConfirm;
         this._confirmFrameMngr.isBind = this.isBind;
         this._confirmFrameMngr.alert();
      }
      
      protected function onNotShowAgain(bool:Boolean) : void
      {
         GypsyPurchaseModel.getInstance().updateShowAlertRmbTicketBuy(!bool);
      }
      
      protected function isBind(isBind:Boolean) : void
      {
         GypsyPurchaseModel.getInstance().updateIsUseBindRmbTicket(isBind);
      }
      
      protected function onConfirm() : void
      {
         GypsyShopManager.getInstance().confirmToBuy(this._id);
      }
      
      protected function getPrice() : int
      {
         return GypsyPurchaseModel.getInstance().getRmbTicketNeeded(this._id);
      }
   }
}

