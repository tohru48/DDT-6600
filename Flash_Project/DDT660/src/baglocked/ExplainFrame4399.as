package baglocked
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class ExplainFrame4399 extends Frame
   {
      
      private var _bagLockedController:BagLockedController;
      
      private var _explainMap:Bitmap;
      
      private var _btnBG:ScaleBitmapImage;
      
      private var _removeLockBtn:TextButton;
      
      private var _setPassBtn:TextButton;
      
      private var _updatePassBtn:TextButton;
      
      private var _delPassBtn:TextButton;
      
      private var _resetQustionBtn:TextButton;
      
      public function ExplainFrame4399()
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
         this._explainMap = ComponentFactory.Instance.creat("baglocked.pwdExplanation_4399");
         addToContent(this._explainMap);
         this._btnBG = ComponentFactory.Instance.creatComponentByStylename("baglocked.btnBG");
         addToContent(this._btnBG);
         this._setPassBtn = ComponentFactory.Instance.creat("baglocked.setPassBtn3");
         this._setPassBtn.text = LanguageMgr.GetTranslation("tank.view.bagII.baglocked.setting");
         addToContent(this._setPassBtn);
         this._delPassBtn = ComponentFactory.Instance.creat("baglocked.delPassBtn3");
         this._delPassBtn.text = LanguageMgr.GetTranslation("tank.view.bagII.baglocked.delete");
         addToContent(this._delPassBtn);
         this._removeLockBtn = ComponentFactory.Instance.creat("baglocked.removeLockBtn3");
         this._removeLockBtn.text = LanguageMgr.GetTranslation("tank.view.bagII.baglocked.unlock");
         addToContent(this._removeLockBtn);
         this._updatePassBtn = ComponentFactory.Instance.creat("baglocked.updatePassBtn3");
         this._updatePassBtn.text = LanguageMgr.GetTranslation("tank.view.bagII.baglocked.modify");
         addToContent(this._updatePassBtn);
         this._resetQustionBtn = ComponentFactory.Instance.creat("baglocked.resetQuestionBtn");
         this._resetQustionBtn.text = LanguageMgr.GetTranslation("tank.view.bagII.baglocked.resetQuestion");
         addToContent(this._resetQustionBtn);
         this._setPassBtn.visible = !PlayerManager.Instance.Self.bagPwdState;
         this._delPassBtn.visible = !this._setPassBtn.visible;
         this._removeLockBtn.enable = PlayerManager.Instance.Self.bagLocked;
         this._updatePassBtn.enable = PlayerManager.Instance.Self.bagPwdState;
         if(PlayerManager.Instance.Self.questionOne == "")
         {
            this._resetQustionBtn.enable = false;
         }
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
         if(PlayerManager.Instance.Self.questionOne == "")
         {
            this._bagLockedController.openSetPassFrame1();
         }
         else
         {
            this._bagLockedController.openSetPassFrameNew();
         }
         this._bagLockedController.closeExplainFrame();
      }
      
      private function __delPassBtnClick(event:Event) : void
      {
         SoundManager.instance.play("008");
         this._bagLockedController.openDelPassFrame();
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
      
      protected function __resetQustionBtnClick(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         BagLockedController.Instance.openGetConfirmFrame();
         BagLockedController.Instance.closeExplainFrame();
      }
      
      private function addEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__frameEventHandler);
         this._setPassBtn.addEventListener(MouseEvent.CLICK,this.__setPassBtnClick);
         this._delPassBtn.addEventListener(MouseEvent.CLICK,this.__delPassBtnClick);
         this._removeLockBtn.addEventListener(MouseEvent.CLICK,this.__removeLockBtnClick);
         this._updatePassBtn.addEventListener(MouseEvent.CLICK,this.__updatePassBtnClick);
         this._resetQustionBtn.addEventListener(MouseEvent.CLICK,this.__resetQustionBtnClick);
      }
      
      private function remvoeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__frameEventHandler);
         this._setPassBtn.removeEventListener(MouseEvent.CLICK,this.__setPassBtnClick);
         this._delPassBtn.removeEventListener(MouseEvent.CLICK,this.__delPassBtnClick);
         this._removeLockBtn.removeEventListener(MouseEvent.CLICK,this.__removeLockBtnClick);
         this._updatePassBtn.removeEventListener(MouseEvent.CLICK,this.__updatePassBtnClick);
         this._resetQustionBtn.removeEventListener(MouseEvent.CLICK,this.__resetQustionBtnClick);
      }
      
      override public function dispose() : void
      {
         this.remvoeEvent();
         this._bagLockedController = null;
         ObjectUtils.disposeObject(this._explainMap);
         this._explainMap = null;
         ObjectUtils.disposeObject(this._btnBG);
         this._btnBG = null;
         ObjectUtils.disposeObject(this._setPassBtn);
         this._setPassBtn = null;
         ObjectUtils.disposeObject(this._delPassBtn);
         this._delPassBtn = null;
         ObjectUtils.disposeObject(this._removeLockBtn);
         this._removeLockBtn = null;
         ObjectUtils.disposeObject(this._updatePassBtn);
         this._updatePassBtn = null;
         ObjectUtils.disposeObject(this._resetQustionBtn);
         this._resetQustionBtn = null;
         super.dispose();
      }
   }
}

