package baglocked
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.events.MouseEvent;
   
   public class AppealFrame extends Frame
   {
      
      private var _bagLockedController:BagLockedController;
      
      private var _appealMap:Bitmap;
      
      private var _closeBtn:TextButton;
      
      public function AppealFrame()
      {
         super();
      }
      
      override protected function init() : void
      {
         super.init();
         this.titleText = LanguageMgr.GetTranslation("tank.view.bagII.baglocked.appeal");
         this._appealMap = ComponentFactory.Instance.creat("baglocked.appeal");
         addToContent(this._appealMap);
         this._closeBtn = ComponentFactory.Instance.creatComponentByStylename("core.simplebt");
         PositionUtils.setPos(this._closeBtn,"bagLocked.closeBtnPos");
         this._closeBtn.text = LanguageMgr.GetTranslation("close");
         addToContent(this._closeBtn);
         this.addEvent();
      }
      
      protected function __closeBtnClick(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._bagLockedController.close();
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
      
      public function set bagLockedController(value:BagLockedController) : void
      {
         this._bagLockedController = value;
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      private function addEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__frameEventHandler);
         this._closeBtn.addEventListener(MouseEvent.CLICK,this.__closeBtnClick);
      }
      
      private function remvoeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__frameEventHandler);
         this._closeBtn.removeEventListener(MouseEvent.CLICK,this.__closeBtnClick);
      }
      
      override public function dispose() : void
      {
         if(Boolean(this._appealMap))
         {
            ObjectUtils.disposeObject(this._appealMap);
         }
         this._appealMap = null;
         if(Boolean(this._closeBtn))
         {
            ObjectUtils.disposeObject(this._closeBtn);
         }
         this._closeBtn = null;
         super.dispose();
      }
   }
}

