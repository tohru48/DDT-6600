package baglocked.phoneServiceFrames
{
   import baglocked.BagLockedController;
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import ddt.manager.TaskManager;
   import flash.display.Bitmap;
   import flash.events.MouseEvent;
   
   public class BenefitOfBindingFrame extends Frame
   {
      
      private var _bagLockedController:BagLockedController;
      
      private var _BG:Bitmap;
      
      private var _startBtn:TextButton;
      
      private var _nextTimeBtn:TextButton;
      
      public function BenefitOfBindingFrame()
      {
         super();
      }
      
      override protected function init() : void
      {
         super.init();
         this.titleText = LanguageMgr.GetTranslation("tank.view.bagII.baglocked.benefitOfBinding");
         this._BG = ComponentFactory.Instance.creat("baglock.bindPhoneNum");
         addToContent(this._BG);
         this._startBtn = ComponentFactory.Instance.creatComponentByStylename("baglocked.startBtn");
         this._startBtn.text = LanguageMgr.GetTranslation("tank.view.bagII.baglocked.startToBind");
         addToContent(this._startBtn);
         this._nextTimeBtn = ComponentFactory.Instance.creatComponentByStylename("baglocked.nextTimeBtn");
         this._nextTimeBtn.text = LanguageMgr.GetTranslation("tank.view.bagII.baglocked.nextTime");
         addToContent(this._nextTimeBtn);
         this.addEvent();
      }
      
      protected function __startBtnClick(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._bagLockedController.close();
         TaskManager.instance.jumpToQuestByID(545);
      }
      
      protected function __nextTimeBtnClick(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._bagLockedController.close();
         if(PlayerManager.Instance.Self.questionOne == "")
         {
            this._bagLockedController.openSetPassFrame1();
         }
         else
         {
            this._bagLockedController.openSetPassFrameNew();
         }
         BaglockedManager.Instance.removeLockPwdEvent();
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
         this._startBtn.addEventListener(MouseEvent.CLICK,this.__startBtnClick);
         this._nextTimeBtn.addEventListener(MouseEvent.CLICK,this.__nextTimeBtnClick);
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__frameEventHandler);
         this._startBtn.removeEventListener(MouseEvent.CLICK,this.__startBtnClick);
         this._nextTimeBtn.removeEventListener(MouseEvent.CLICK,this.__nextTimeBtnClick);
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         if(Boolean(this._BG))
         {
            ObjectUtils.disposeObject(this._BG);
         }
         this._BG = null;
         if(Boolean(this._startBtn))
         {
            ObjectUtils.disposeObject(this._startBtn);
         }
         this._startBtn = null;
         if(Boolean(this._nextTimeBtn))
         {
            ObjectUtils.disposeObject(this._nextTimeBtn);
         }
         this._nextTimeBtn = null;
         super.dispose();
      }
   }
}

