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
   
   public class PhoneInputFrame extends Frame
   {
      
      private var _bagLockedController:BagLockedController;
      
      private var _description:FilterFrameText;
      
      private var _numInput:TextInput;
      
      private var _tips:FilterFrameText;
      
      private var _nextBtn:TextButton;
      
      private var type:int;
      
      public function PhoneInputFrame()
      {
         super();
      }
      
      public function init2(value:int) : void
      {
         this.type = value;
         this.titleText = LanguageMgr.GetTranslation("tank.view.bagII.baglocked.changePhoneTxt");
         this._description = ComponentFactory.Instance.creatComponentByStylename("baglocked.whiteTxt");
         PositionUtils.setPos(this._description,"bagLocked.phoneDescPos");
         addToContent(this._description);
         this._numInput = ComponentFactory.Instance.creatComponentByStylename("baglocked.phoneTextInput");
         this._numInput.textField.restrict = "0-9";
         addToContent(this._numInput);
         this._tips = ComponentFactory.Instance.creatComponentByStylename("baglocked.deepRedTxt");
         PositionUtils.setPos(this._tips,"bagLocked.phoneTipPos");
         addToContent(this._tips);
         this._nextBtn = ComponentFactory.Instance.creatComponentByStylename("core.simplebt");
         this._nextBtn.text = LanguageMgr.GetTranslation("tank.view.bagII.baglocked.next");
         PositionUtils.setPos(this._nextBtn,"bagLocked.nextBtnPos2");
         addToContent(this._nextBtn);
         this._description.text = LanguageMgr.GetTranslation("tank.view.bagII.baglocked.inputFormerPhoneNum");
         this._tips.text = LanguageMgr.GetTranslation("tank.view.bagII.baglocked.tip1");
         this.addEvent();
      }
      
      protected function __nextBtnClick(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(this._numInput.text.length != 11)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.bagII.baglocked.phoneLengthWrong"));
            return;
         }
         SocketManager.Instance.out.getBackLockPwdByPhone(1,this._numInput.text);
         BaglockedManager.Instance.phoneNum = this._numInput.text;
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
         if(Boolean(this._description))
         {
            ObjectUtils.disposeObject(this._description);
         }
         this._description = null;
         if(Boolean(this._numInput))
         {
            ObjectUtils.disposeObject(this._numInput);
         }
         this._numInput = null;
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

