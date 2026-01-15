package gypsyShop.ui.confirmAlertFrame
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   
   public class ConfirmFrameHonourWithNotShowCheckManager
   {
      
      private var _confirmFrame:ConfirmWithNotShowCheckAlert;
      
      private var _frameType:String;
      
      private var _needMoney:int;
      
      private var _title:String = "";
      
      private var _detail:String = "";
      
      private var _onNotShowAgain:Function;
      
      private var _isBind:Function;
      
      private var _onComfirm:Function;
      
      public function ConfirmFrameHonourWithNotShowCheckManager()
      {
         super();
      }
      
      protected static function showFillFrame() : BaseAlerFrame
      {
         var frame:BaseAlerFrame = null;
         frame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("gypsy.honourNotEnough"),LanguageMgr.GetTranslation("ok"),"",true,false,false,2);
         frame.addEventListener(FrameEvent.RESPONSE,__onResponse);
         return frame;
      }
      
      private static function __onResponse(evt:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         var alert:BaseAlerFrame = evt.target as BaseAlerFrame;
         alert.removeEventListener(FrameEvent.RESPONSE,__onResponse);
         alert.dispose();
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
      
      public function alert() : ConfirmFrameHonourWithNotShowCheckAlert
      {
         if(PlayerManager.Instance.Self.myHonor < this._needMoney)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("gypsy.honourNotEnough"),0,true,3);
            return null;
         }
         var confirmFrame:ConfirmFrameHonourWithNotShowCheckAlert = ComponentFactory.Instance.creat("gypsy.confirmViewHonour");
         confirmFrame.titleTxt = LanguageMgr.GetTranslation("AlertDialog.Info");
         confirmFrame.detail = LanguageMgr.GetTranslation("tank.game.GameView.gypsyHonourConfirm",this._needMoney);
         confirmFrame.onNotShowAgain = this._onNotShowAgain;
         confirmFrame.onComfirm = this._onComfirm;
         confirmFrame.initView();
         confirmFrame.moveEnable = false;
         confirmFrame.addEventListener(FrameEvent.RESPONSE,this.comfirmHandler,false,0,true);
         LayerManager.Instance.addToLayer(confirmFrame,LayerManager.STAGE_DYANMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
         return confirmFrame;
      }
      
      private function comfirmHandler(event:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         var confirmFrame:ConfirmFrameHonourWithNotShowCheckAlert = event.currentTarget as ConfirmFrameHonourWithNotShowCheckAlert;
         confirmFrame.removeEventListener(FrameEvent.RESPONSE,this.comfirmHandler);
         if(event.responseCode == FrameEvent.SUBMIT_CLICK || event.responseCode == FrameEvent.ENTER_CLICK)
         {
            if(PlayerManager.Instance.Self.myHonor < this._needMoney)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("gypsy.honourNotEnough"),0,true,3);
            }
            else
            {
               this._onComfirm != null && this._onComfirm();
            }
            if(confirmFrame.isNoPrompt)
            {
               this._onNotShowAgain != null && this._onNotShowAgain(true);
            }
         }
      }
   }
}

