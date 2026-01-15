package vip.view
{
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import flash.events.MouseEvent;
   
   public class BuyVipGiftBagButton extends BaseButton
   {
      
      public static const VIPGIFTBAG_PRICE:int = 6680;
      
      private var _buyPackageBtn:BaseButton;
      
      public function BuyVipGiftBagButton()
      {
         super();
         this._init();
         this._addEvent();
      }
      
      private function _init() : void
      {
         this._buyPackageBtn = ComponentFactory.Instance.creatComponentByStylename("vip.buyPackageBtn");
         addChild(this._buyPackageBtn);
      }
      
      public function _addEvent() : void
      {
         this._buyPackageBtn.addEventListener(MouseEvent.CLICK,this.__onbuyMouseCilck);
      }
      
      private function __onbuyMouseCilck(event:MouseEvent) : void
      {
         var alert1:BaseAlerFrame = null;
         if(_enable)
         {
            event.stopImmediatePropagation();
            SoundManager.instance.play("008");
            if(PlayerManager.Instance.Self.bagLocked)
            {
               BaglockedManager.Instance.show();
               return;
            }
            if(PlayerManager.Instance.Self.Money < VIPGIFTBAG_PRICE)
            {
               LeavePageManager.showFillFrame();
               return;
            }
            alert1 = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.vip.view.buyVipGift"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,true,false,LayerManager.ALPHA_BLOCKGOUND);
            alert1.mouseEnabled = false;
            alert1.addEventListener(FrameEvent.RESPONSE,this._responseI);
         }
      }
      
      private function _responseI(event:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         (event.currentTarget as BaseAlerFrame).removeEventListener(FrameEvent.RESPONSE,this._responseI);
         if(event.responseCode == FrameEvent.SUBMIT_CLICK || event.responseCode == FrameEvent.ENTER_CLICK)
         {
            this.dobuy();
         }
         ObjectUtils.disposeObject(event.target);
      }
      
      private function dobuy() : void
      {
      }
   }
}

