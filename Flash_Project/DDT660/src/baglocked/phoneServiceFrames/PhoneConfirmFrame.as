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
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.events.MouseEvent;
   
   public class PhoneConfirmFrame extends Frame
   {
      
      private var _bagLockedController:BagLockedController;
      
      private var _description1:FilterFrameText;
      
      private var _description2:FilterFrameText;
      
      private var _phoneInput:TextInput;
      
      private var _phoneReInput:TextInput;
      
      private var _tips:FilterFrameText;
      
      private var _nextBtn:TextButton;
      
      private var type:int;
      
      public function PhoneConfirmFrame()
      {
         super();
      }
      
      public function init2(value:int) : void
      {
         this.type = value;
         this.titleText = LanguageMgr.GetTranslation("tank.view.bagII.baglocked.changePhoneTxt");
         this._description1 = ComponentFactory.Instance.creatComponentByStylename("baglocked.whiteTxt");
         PositionUtils.setPos(this._description1,"bagLocked.phoneInputTxtPos");
         this._description1.text = LanguageMgr.GetTranslation("tank.view.bagII.baglocked.inputNewPhoneNum");
         addToContent(this._description1);
         this._description2 = ComponentFactory.Instance.creatComponentByStylename("baglocked.whiteTxt");
         PositionUtils.setPos(this._description2,"bagLocked.phoneReInputTxtPos");
         this._description2.text = LanguageMgr.GetTranslation("tank.view.bagII.baglocked.reInputNewPhoneNum");
         addToContent(this._description2);
         this._phoneInput = ComponentFactory.Instance.creatComponentByStylename("baglocked.newPhoneTextInput");
         this._phoneInput.textField.restrict = "0-9";
         addToContent(this._phoneInput);
         this._phoneReInput = ComponentFactory.Instance.creatComponentByStylename("baglocked.newPhoneTextReInput");
         this._phoneReInput.textField.restrict = "0-9";
         addToContent(this._phoneReInput);
         this._tips = ComponentFactory.Instance.creatComponentByStylename("baglocked.deepRedTxt");
         PositionUtils.setPos(this._tips,"bagLocked.phoneTipPos");
         this._tips.text = LanguageMgr.GetTranslation("tank.view.bagII.baglocked.tip3");
         addToContent(this._tips);
         this._nextBtn = ComponentFactory.Instance.creatComponentByStylename("core.simplebt");
         this._nextBtn.text = LanguageMgr.GetTranslation("tank.view.bagII.baglocked.next");
         PositionUtils.setPos(this._nextBtn,"bagLocked.nextBtnPos2");
         addToContent(this._nextBtn);
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
         if(this._phoneInput.text != this._phoneReInput.text)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.bagII.baglocked.phoneReInputWrong"));
            return;
         }
         switch(this.type)
         {
            case 0:
               SocketManager.Instance.out.getBackLockPwdByPhone(4,this._phoneInput.text);
               break;
            case 1:
               SocketManager.Instance.out.getBackLockPwdByQuestion(2,this._phoneInput.text);
         }
         BaglockedManager.Instance.phoneNum = this._phoneInput.text;
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
         if(Boolean(this._description1))
         {
            ObjectUtils.disposeObject(this._description1);
         }
         this._description1 = null;
         if(Boolean(this._description2))
         {
            ObjectUtils.disposeObject(this._description2);
         }
         this._description2 = null;
         if(Boolean(this._phoneInput))
         {
            ObjectUtils.disposeObject(this._phoneInput);
         }
         this._phoneInput = null;
         if(Boolean(this._phoneReInput))
         {
            ObjectUtils.disposeObject(this._phoneReInput);
         }
         this._phoneReInput = null;
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

