package consortion.view.selfConsortia
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.image.MutipleImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import consortion.ConsortionModelControl;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import flash.events.MouseEvent;
   
   public class ConsortionBankFrame extends Frame
   {
      
      private var _bg:MutipleImage;
      
      private var _titleTxt:FilterFrameText;
      
      private var _bankbagView:ConsortionBankBagView;
      
      public function ConsortionBankFrame()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         escEnable = true;
         disposeChildren = true;
         titleText = LanguageMgr.GetTranslation("tank.consortia.consortiabank.ConsortiaBankView.titleText");
         this._bg = ComponentFactory.Instance.creatComponentByStylename("consortion.bank.bg");
         this._titleTxt = ComponentFactory.Instance.creatComponentByStylename("consortion.consortionBankFrame.titleText");
         this._titleTxt.text = LanguageMgr.GetTranslation("consortion.consortionBankFrame.titleText");
         this._bankbagView = ComponentFactory.Instance.creatCustomObject("consortionBankBagView");
         addToContent(this._bg);
         addToContent(this._titleTxt);
         addToContent(this._bankbagView);
         this._bankbagView.isNeedCard(false);
         this._bankbagView.info = PlayerManager.Instance.Self;
      }
      
      private function initEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__responseHandler);
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__responseHandler);
      }
      
      private function __responseHandler(event:FrameEvent) : void
      {
         if(event.responseCode == FrameEvent.CLOSE_CLICK || event.responseCode == FrameEvent.ESC_CLICK)
         {
            SoundManager.instance.play("008");
            this.dispose();
         }
      }
      
      private function __clickHandler(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this.dispose();
      }
      
      override public function dispose() : void
      {
         ConsortionModelControl.Instance.clearReference();
         this.removeEvent();
         if(Boolean(this._bankbagView))
         {
            this._bankbagView.dispose();
         }
         this._bankbagView = null;
         super.dispose();
         this._bg = null;
         this._titleTxt = null;
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}

