package baglocked
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class ExplainFrame extends Frame
   {
      
      private var _bagLockedController:BagLockedController;
      
      private var _delPassBtn:TextButton;
      
      private var _explainMap:Sprite;
      
      private var _removeLockBtn:TextButton;
      
      private var _setPassBtn:TextButton;
      
      private var _updatePassBtn:TextButton;
      
      private var _ddtbagLocked:Scale9CornerImage;
      
      public function ExplainFrame()
      {
         super();
      }
      
      public function set bagLockedController(value:BagLockedController) : void
      {
         this._bagLockedController = value;
      }
      
      override public function dispose() : void
      {
         this.remvoeEvent();
         this._bagLockedController = null;
         ObjectUtils.disposeObject(this._explainMap);
         this._explainMap = null;
         ObjectUtils.disposeObject(this._setPassBtn);
         this._setPassBtn = null;
         ObjectUtils.disposeObject(this._delPassBtn);
         this._delPassBtn = null;
         ObjectUtils.disposeObject(this._removeLockBtn);
         this._removeLockBtn = null;
         ObjectUtils.disposeObject(this._updatePassBtn);
         this._updatePassBtn = null;
         ObjectUtils.disposeObject(this._ddtbagLocked);
         this._ddtbagLocked = null;
         super.dispose();
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_TOP_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      override protected function init() : void
      {
         super.init();
         this.titleText = LanguageMgr.GetTranslation("tank.view.bagII.baglocked.BagLockedHelpFrame.titleText");
         this._ddtbagLocked = ComponentFactory.Instance.creatComponentByStylename("ddtbaglocked.BG1");
         addToContent(this._ddtbagLocked);
         this._explainMap = ComponentFactory.Instance.creatCustomObject("baglocked.explainText");
         addToContent(this._explainMap);
         this._setPassBtn = ComponentFactory.Instance.creat("baglocked.setPassBtn");
         this._setPassBtn.text = LanguageMgr.GetTranslation("tank.view.bagII.baglocked.setting");
         addToContent(this._setPassBtn);
         this._delPassBtn = ComponentFactory.Instance.creat("baglocked.delPassBtn");
         this._delPassBtn.text = LanguageMgr.GetTranslation("tank.view.bagII.baglocked.delete");
         addToContent(this._delPassBtn);
         this._removeLockBtn = ComponentFactory.Instance.creat("baglocked.removeLockBtn");
         this._removeLockBtn.text = LanguageMgr.GetTranslation("tank.view.bagII.baglocked.unlock");
         addToContent(this._removeLockBtn);
         this._updatePassBtn = ComponentFactory.Instance.creat("baglocked.updatePassBtn");
         this._updatePassBtn.text = LanguageMgr.GetTranslation("tank.view.bagII.baglocked.modify");
         addToContent(this._updatePassBtn);
         this._setPassBtn.visible = !PlayerManager.Instance.Self.bagPwdState;
         this._delPassBtn.visible = !this._setPassBtn.visible;
         this._removeLockBtn.enable = PlayerManager.Instance.Self.bagLocked;
         this._updatePassBtn.enable = PlayerManager.Instance.Self.bagPwdState;
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
      
      private function addEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__frameEventHandler);
         this._setPassBtn.addEventListener(MouseEvent.CLICK,this.__setPassBtnClick);
         this._delPassBtn.addEventListener(MouseEvent.CLICK,this.__delPassBtnClick);
         this._removeLockBtn.addEventListener(MouseEvent.CLICK,this.__removeLockBtnClick);
         this._updatePassBtn.addEventListener(MouseEvent.CLICK,this.__updatePassBtnClick);
      }
      
      private function remvoeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__frameEventHandler);
         this._setPassBtn.removeEventListener(MouseEvent.CLICK,this.__setPassBtnClick);
         this._delPassBtn.removeEventListener(MouseEvent.CLICK,this.__delPassBtnClick);
         this._removeLockBtn.removeEventListener(MouseEvent.CLICK,this.__removeLockBtnClick);
         this._updatePassBtn.removeEventListener(MouseEvent.CLICK,this.__updatePassBtnClick);
      }
   }
}

