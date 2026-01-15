package baglocked
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class ExplainFrame2 extends Frame
   {
      
      private var _bagLockedController:BagLockedController;
      
      private var _explainMap:Bitmap;
      
      private var _btnBG:ScaleBitmapImage;
      
      private var _delPassBtn:TextButton;
      
      private var _setPassBtn:TextButton;
      
      private var _updatePassBtn:TextButton;
      
      private var _phoneServiceBtn:TextButton;
      
      private var _appealBtn:TextButton;
      
      private var _unLockBtn:SimpleBitmapButton;
      
      public function ExplainFrame2()
      {
         super();
      }
      
      public function set bagLockedController(value:BagLockedController) : void
      {
         this._bagLockedController = value;
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_TOP_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      override protected function init() : void
      {
         super.init();
         this.titleText = LanguageMgr.GetTranslation("tank.view.bagII.baglocked.BagLockedHelpFrame.titleText");
         this._explainMap = ComponentFactory.Instance.creat("baglocked.pwdExplanation");
         addToContent(this._explainMap);
         this._btnBG = ComponentFactory.Instance.creatComponentByStylename("baglocked.btnBG");
         addToContent(this._btnBG);
         this._setPassBtn = ComponentFactory.Instance.creatComponentByStylename("baglocked.setPassBtn2");
         this._setPassBtn.text = LanguageMgr.GetTranslation("tank.view.bagII.baglocked.setting");
         addToContent(this._setPassBtn);
         this._delPassBtn = ComponentFactory.Instance.creatComponentByStylename("baglocked.delPassBtn2");
         this._delPassBtn.text = LanguageMgr.GetTranslation("tank.view.bagII.baglocked.delete");
         addToContent(this._delPassBtn);
         this._updatePassBtn = ComponentFactory.Instance.creatComponentByStylename("baglocked.updatePassBtn2");
         this._updatePassBtn.text = LanguageMgr.GetTranslation("tank.view.bagII.baglocked.modify");
         addToContent(this._updatePassBtn);
         this._phoneServiceBtn = ComponentFactory.Instance.creatComponentByStylename("baglocked.phoneServiceBtn");
         this._phoneServiceBtn.text = LanguageMgr.GetTranslation("tank.view.bagII.baglocked.phoneService");
         this._appealBtn = ComponentFactory.Instance.creatComponentByStylename("baglocked.appealBtn");
         this._appealBtn.text = LanguageMgr.GetTranslation("tank.view.bagII.baglocked.appeal");
         this._unLockBtn = ComponentFactory.Instance.creatComponentByStylename("baglocked.unlockedBtn");
         addToContent(this._unLockBtn);
         this._setPassBtn.visible = !PlayerManager.Instance.Self.bagPwdState;
         this._delPassBtn.visible = !this._setPassBtn.visible;
         this._unLockBtn.enable = PlayerManager.Instance.Self.bagLocked;
         this._updatePassBtn.enable = PlayerManager.Instance.Self.bagPwdState;
         this._phoneServiceBtn.enable = false;
         this.addEvent();
      }
      
      private function __frameEventHandler(event:FrameEvent) : void
      {
         switch(event.responseCode)
         {
            case FrameEvent.ESC_CLICK:
            case FrameEvent.CLOSE_CLICK:
               SoundManager.instance.play("008");
               this._bagLockedController.close();
         }
      }
      
      private function __setPassBtnClick(event:Event) : void
      {
         SoundManager.instance.play("008");
         BaglockedManager.Instance.checkBindCase = 1;
         SocketManager.Instance.out.checkPhoneBind();
      }
      
      private function __delPassBtnClick(event:Event) : void
      {
         SoundManager.instance.play("008");
         this._bagLockedController.openDeletePwdFrame();
         this._bagLockedController.closeExplainFrame();
      }
      
      private function __removeLockBtnClick(event:Event) : void
      {
         SoundManager.instance.play("008");
         this._bagLockedController.close();
         BaglockedManager.Instance.show();
      }
      
      private function __updatePassBtnClick(event:Event) : void
      {
         SoundManager.instance.play("008");
         this._bagLockedController.openUpdatePassFrame();
         this._bagLockedController.closeExplainFrame();
      }
      
      protected function __appealBtnClick(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._bagLockedController.openAppealFrame();
         this._bagLockedController.closeExplainFrame();
      }
      
      protected function __phoneServiceBtnClick(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._bagLockedController.openPhoneServiceFrame();
         this._bagLockedController.closeExplainFrame();
      }
      
      private function addEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__frameEventHandler);
         this._setPassBtn.addEventListener(MouseEvent.CLICK,this.__setPassBtnClick);
         this._delPassBtn.addEventListener(MouseEvent.CLICK,this.__delPassBtnClick);
         this._unLockBtn.addEventListener(MouseEvent.CLICK,this.__removeLockBtnClick);
         this._updatePassBtn.addEventListener(MouseEvent.CLICK,this.__updatePassBtnClick);
         this._appealBtn.addEventListener(MouseEvent.CLICK,this.__appealBtnClick);
         this._phoneServiceBtn.addEventListener(MouseEvent.CLICK,this.__phoneServiceBtnClick);
      }
      
      private function remvoeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__frameEventHandler);
         this._setPassBtn.removeEventListener(MouseEvent.CLICK,this.__setPassBtnClick);
         this._delPassBtn.removeEventListener(MouseEvent.CLICK,this.__delPassBtnClick);
         this._unLockBtn.removeEventListener(MouseEvent.CLICK,this.__removeLockBtnClick);
         this._updatePassBtn.removeEventListener(MouseEvent.CLICK,this.__updatePassBtnClick);
         this._appealBtn.removeEventListener(MouseEvent.CLICK,this.__appealBtnClick);
         this._phoneServiceBtn.addEventListener(MouseEvent.CLICK,this.__phoneServiceBtnClick);
      }
      
      override public function dispose() : void
      {
         this.remvoeEvent();
         this._bagLockedController = null;
         if(Boolean(this._explainMap))
         {
            ObjectUtils.disposeObject(this._explainMap);
         }
         this._explainMap = null;
         if(Boolean(this._btnBG))
         {
            ObjectUtils.disposeObject(this._btnBG);
         }
         this._btnBG = null;
         if(Boolean(this._setPassBtn))
         {
            ObjectUtils.disposeObject(this._setPassBtn);
         }
         this._setPassBtn = null;
         if(Boolean(this._delPassBtn))
         {
            ObjectUtils.disposeObject(this._delPassBtn);
         }
         this._delPassBtn = null;
         if(Boolean(this._updatePassBtn))
         {
            ObjectUtils.disposeObject(this._updatePassBtn);
         }
         this._updatePassBtn = null;
         if(Boolean(this._phoneServiceBtn))
         {
            ObjectUtils.disposeObject(this._phoneServiceBtn);
         }
         this._phoneServiceBtn = null;
         if(Boolean(this._appealBtn))
         {
            ObjectUtils.disposeObject(this._appealBtn);
         }
         this._appealBtn = null;
         if(Boolean(this._unLockBtn))
         {
            ObjectUtils.disposeObject(this._unLockBtn);
         }
         this._unLockBtn = null;
         super.dispose();
      }
      
      public function get phoneServiceBtn() : TextButton
      {
         return this._phoneServiceBtn;
      }
   }
}

