package baglocked.phoneServiceFrames
{
   import baglocked.BagLockedController;
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.controls.TextInput;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.events.MouseEvent;
   
   public class DeleteInputFrame extends Frame
   {
      
      private var _bagLockedController:BagLockedController;
      
      private var _BG:ScaleBitmapImage;
      
      private var _description:FilterFrameText;
      
      private var _inputTxt:FilterFrameText;
      
      private var _phoneInput:TextInput;
      
      private var _tips:FilterFrameText;
      
      private var _nextBtn:TextButton;
      
      private var type:int;
      
      public function DeleteInputFrame()
      {
         super();
      }
      
      public function init2(value:int) : void
      {
         this.type = value;
         this.titleText = LanguageMgr.GetTranslation("tank.view.bagII.baglocked.phoneConfirm");
         this._BG = ComponentFactory.Instance.creatComponentByStylename("baglocked.deleteQuestionBG");
         addToContent(this._BG);
         this._description = ComponentFactory.Instance.creatComponentByStylename("baglocked.lightRedTxt");
         PositionUtils.setPos(this._description,"bagLocked.deleteDescPos");
         addToContent(this._description);
         this._inputTxt = ComponentFactory.Instance.creatComponentByStylename("baglocked.whiteTxt");
         PositionUtils.setPos(this._inputTxt,"bagLocked.phoneDescPos2");
         this._inputTxt.text = LanguageMgr.GetTranslation("tank.view.bagII.baglocked.inputBindPhone");
         addToContent(this._inputTxt);
         this._phoneInput = ComponentFactory.Instance.creatComponentByStylename("baglocked.phoneTextInput");
         PositionUtils.setPos(this._phoneInput,"bagLocked.deleteInputPos");
         this._phoneInput.textField.restrict = "0-9";
         addToContent(this._phoneInput);
         this._tips = ComponentFactory.Instance.creatComponentByStylename("baglocked.deepRedTxt");
         this._tips.text = LanguageMgr.GetTranslation("tank.view.bagII.baglocked.tip31");
         PositionUtils.setPos(this._tips,"bagLocked.phoneTipPos3");
         addToContent(this._tips);
         this._nextBtn = ComponentFactory.Instance.creatComponentByStylename("core.simplebt");
         PositionUtils.setPos(this._nextBtn,"bagLocked.nextBtnPos4");
         this._nextBtn.text = LanguageMgr.GetTranslation("tank.view.bagII.baglocked.next");
         addToContent(this._nextBtn);
         switch(this.type)
         {
            case 0:
               this._description.text = LanguageMgr.GetTranslation("tank.view.bagII.baglocked.deleteDesc1");
               break;
            case 1:
               this._description.text = LanguageMgr.GetTranslation("tank.view.bagII.baglocked.deleteDesc2");
         }
         this.addEvent();
      }
      
      protected function __nextBtnClick(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(this._phoneInput.text.length != 11)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.bagII.baglocked.phoneLengthWrong"));
            return;
         }
         BaglockedManager.Instance.phoneNum = this._phoneInput.text;
         switch(this.type)
         {
            case 0:
               SocketManager.Instance.out.deletePwdQuestion(1,this._phoneInput.text);
               break;
            case 1:
               SocketManager.Instance.out.deletePwdByPhone(1,this._phoneInput.text);
         }
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
         this._nextBtn.addEventListener(MouseEvent.CLICK,this.__nextBtnClick);
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__frameEventHandler);
         this._nextBtn.removeEventListener(MouseEvent.CLICK,this.__nextBtnClick);
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         if(Boolean(this._BG))
         {
            ObjectUtils.disposeObject(this._BG);
         }
         this._BG = null;
         if(Boolean(this._description))
         {
            ObjectUtils.disposeObject(this._description);
         }
         this._description = null;
         if(Boolean(this._inputTxt))
         {
            ObjectUtils.disposeObject(this._inputTxt);
         }
         this._inputTxt = null;
         if(Boolean(this._phoneInput))
         {
            ObjectUtils.disposeObject(this._phoneInput);
         }
         this._phoneInput = null;
         if(Boolean(this._tips))
         {
            ObjectUtils.disposeObject(this._tips);
         }
         this._tips = null;
         if(Boolean(this._nextBtn))
         {
            ObjectUtils.disposeObject(this._nextBtn);
         }
         this._nextBtn = null;
         super.dispose();
      }
   }
}

