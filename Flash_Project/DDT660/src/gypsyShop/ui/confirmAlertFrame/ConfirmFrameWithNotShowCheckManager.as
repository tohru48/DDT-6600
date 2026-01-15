package gypsyShop.ui.confirmAlertFrame
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import gypsyShop.model.GypsyPurchaseModel;
   
   public class ConfirmFrameWithNotShowCheckManager
   {
      
      private var _confirmFrame:ConfirmWithNotShowCheckAlert;
      
      private var _frameType:String;
      
      private var _needMoney:int;
      
      private var _title:String = "";
      
      private var _detail:String = "";
      
      private var _onNotShowAgain:Function;
      
      private var _isBind:Function;
      
      private var _onComfirm:Function;
      
      public function ConfirmFrameWithNotShowCheckManager()
      {
         super();
      }
      
      public function set detail(value:String) : void
      {
         this._detail = value;
      }
      
      public function set title(value:String) : void
      {
         this._title = value;
      }
      
      public function set frameType(value:String) : void
      {
         this._frameType = value;
      }
      
      public function set needMoney(value:int) : void
      {
         this._needMoney = value;
      }
      
      public function set onNotShowAgain(value:Function) : void
      {
         this._onNotShowAgain = value;
      }
      
      public function set isBind(value:Function) : void
      {
         this._isBind = value;
      }
      
      public function set onComfirm(value:Function) : void
      {
         this._onComfirm = value;
      }
      
      public function alert() : ConfirmWithNotShowCheckAlert
      {
         var confirmFrame:ConfirmWithNotShowCheckAlert = AlertManager.Instance.simpleAlert(this._title,this._detail,LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),true,true,true,LayerManager.BLCAK_BLOCKGOUND,null,this._frameType,30,true,AlertManager.SELECTBTN) as ConfirmWithNotShowCheckAlert;
         confirmFrame.moveEnable = false;
         confirmFrame.addEventListener(FrameEvent.RESPONSE,this.comfirmHandler,false,0,true);
         return confirmFrame;
      }
      
      private function comfirmHandler(event:FrameEvent) : void
      {
         var confirmFrame2:BaseAlerFrame = null;
         SoundManager.instance.play("008");
         var confirmFrame:ConfirmWithNotShowCheckAlert = event.currentTarget as ConfirmWithNotShowCheckAlert;
         confirmFrame.removeEventListener(FrameEvent.RESPONSE,this.comfirmHandler);
         if(event.responseCode == FrameEvent.SUBMIT_CLICK || event.responseCode == FrameEvent.ENTER_CLICK)
         {
            if(confirmFrame.isBand && PlayerManager.Instance.Self.BandMoney < this._needMoney)
            {
               confirmFrame2 = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("sevenDouble.game.useSkillNoEnoughReConfirm"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),true,true,true,LayerManager.BLCAK_BLOCKGOUND);
               confirmFrame2.moveEnable = false;
               confirmFrame2.addEventListener(FrameEvent.RESPONSE,this.reConfirmHandler,false,0,true);
               return;
            }
            if(!confirmFrame.isBand && PlayerManager.Instance.Self.Money < this._needMoney)
            {
               this._onNotShowAgain != null && this._onNotShowAgain(false);
               LeavePageManager.showFillFrame();
               return;
            }
            if(confirmFrame.isNoPrompt)
            {
               this._onNotShowAgain != null && this._onNotShowAgain(true);
            }
            this._isBind != null && this._isBind(confirmFrame.isBand);
            this._onComfirm != null && this._onComfirm();
         }
      }
      
      private function reConfirmHandler(evt:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         this._onNotShowAgain != null && this._onNotShowAgain(false);
         var confirmFrame:BaseAlerFrame = evt.currentTarget as BaseAlerFrame;
         confirmFrame.removeEventListener(FrameEvent.RESPONSE,this.reConfirmHandler);
         if(evt.responseCode == FrameEvent.SUBMIT_CLICK || evt.responseCode == FrameEvent.ENTER_CLICK)
         {
            if(PlayerManager.Instance.Self.Money < this._needMoney)
            {
               LeavePageManager.showFillFrame();
               return;
            }
            GypsyPurchaseModel.getInstance().updateIsUseBindRmbTicket(false);
            this._onComfirm != null && this._onComfirm();
         }
      }
   }
}

