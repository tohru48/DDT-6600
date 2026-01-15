package baglocked.phoneServiceFrames
{
   import baglocked.BagLockedController;
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
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.events.MouseEvent;
   
   public class QuestionConfirmFrame extends Frame
   {
      
      private var _bagLockedController:BagLockedController;
      
      private var _bg:ScaleBitmapImage;
      
      private var _question1:FilterFrameText;
      
      private var _answer1:FilterFrameText;
      
      private var _questionTxt1:FilterFrameText;
      
      private var _answerInput1:TextInput;
      
      private var _question2:FilterFrameText;
      
      private var _answer2:FilterFrameText;
      
      private var _questionTxt2:FilterFrameText;
      
      private var _answerInput2:TextInput;
      
      private var _tips:FilterFrameText;
      
      private var _nextBtn:TextButton;
      
      private var _cancelBtn:TextButton;
      
      public function QuestionConfirmFrame()
      {
         super();
      }
      
      override protected function init() : void
      {
         super.init();
         this.titleText = LanguageMgr.GetTranslation("tank.view.bagII.baglocked.questionConfirm");
         this._bg = ComponentFactory.Instance.creatComponentByStylename("baglocked.questionConfirmBG");
         addToContent(this._bg);
         this._question1 = ComponentFactory.Instance.creatComponentByStylename("baglocked.question1");
         this._question1.text = LanguageMgr.GetTranslation("baglocked.SetPassFrame2.question1");
         addToContent(this._question1);
         this._answer1 = ComponentFactory.Instance.creatComponentByStylename("baglocked.answer1");
         this._answer1.text = LanguageMgr.GetTranslation("baglocked.SetPassFrame2.answer1");
         addToContent(this._answer1);
         this._questionTxt1 = ComponentFactory.Instance.creatComponentByStylename("baglocked.questionTxt1");
         this._questionTxt1.text = PlayerManager.Instance.Self.questionOne;
         addToContent(this._questionTxt1);
         this._answerInput1 = ComponentFactory.Instance.creatComponentByStylename("baglocked.answerTextInput1");
         addToContent(this._answerInput1);
         this._question2 = ComponentFactory.Instance.creatComponentByStylename("baglocked.question2");
         this._question2.text = LanguageMgr.GetTranslation("baglocked.SetPassFrame2.question2");
         addToContent(this._question2);
         this._answer2 = ComponentFactory.Instance.creatComponentByStylename("baglocked.answer2");
         this._answer2.text = LanguageMgr.GetTranslation("baglocked.SetPassFrame2.answer2");
         addToContent(this._answer2);
         this._questionTxt2 = ComponentFactory.Instance.creatComponentByStylename("baglocked.questionTxt2");
         this._questionTxt2.text = PlayerManager.Instance.Self.questionTwo;
         addToContent(this._questionTxt2);
         this._answerInput2 = ComponentFactory.Instance.creatComponentByStylename("baglocked.answerTextInput2");
         addToContent(this._answerInput2);
         this._tips = ComponentFactory.Instance.creatComponentByStylename("baglocked.deepRedTxt");
         PositionUtils.setPos(this._tips,"bagLocked.phoneTipPos2");
         this._tips.text = LanguageMgr.GetTranslation("tank.view.bagII.baglocked.tip21",-1);
         addToContent(this._tips);
         this._nextBtn = ComponentFactory.Instance.creatComponentByStylename("core.simplebt");
         this._nextBtn.text = LanguageMgr.GetTranslation("tank.view.bagII.baglocked.next");
         PositionUtils.setPos(this._nextBtn,"bagLocked.nextBtnPos3");
         addToContent(this._nextBtn);
         this._cancelBtn = ComponentFactory.Instance.creatComponentByStylename("core.simplebt");
         this._cancelBtn.text = LanguageMgr.GetTranslation("cancel");
         PositionUtils.setPos(this._cancelBtn,"bagLocked.cancelBtnPos2");
         addToContent(this._cancelBtn);
         this.addEvent();
      }
      
      public function setRestTimes(value:int) : void
      {
         this._tips.text = LanguageMgr.GetTranslation("tank.view.bagII.baglocked.tip21",value);
      }
      
      protected function __nextBtnClick(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         SocketManager.Instance.out.getBackLockPwdByQuestion(1,this._answerInput1.text,this._answerInput2.text);
      }
      
      protected function __cancelBtnClick(event:MouseEvent) : void
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
         this._nextBtn.addEventListener(MouseEvent.CLICK,this.__nextBtnClick);
         this._cancelBtn.addEventListener(MouseEvent.CLICK,this.__cancelBtnClick);
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__frameEventHandler);
         this._nextBtn.removeEventListener(MouseEvent.CLICK,this.__nextBtnClick);
         this._cancelBtn.removeEventListener(MouseEvent.CLICK,this.__cancelBtnClick);
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         if(Boolean(this._bg))
         {
            ObjectUtils.disposeObject(this._bg);
         }
         this._bg = null;
         if(Boolean(this._question1))
         {
            ObjectUtils.disposeObject(this._question1);
         }
         this._question1 = null;
         if(Boolean(this._answer1))
         {
            ObjectUtils.disposeObject(this._answer1);
         }
         this._answer1 = null;
         if(Boolean(this._questionTxt1))
         {
            ObjectUtils.disposeObject(this._questionTxt1);
         }
         this._questionTxt1 = null;
         if(Boolean(this._answerInput1))
         {
            ObjectUtils.disposeObject(this._answerInput1);
         }
         this._answerInput1 = null;
         if(Boolean(this._question2))
         {
            ObjectUtils.disposeObject(this._question2);
         }
         this._question2 = null;
         if(Boolean(this._answer2))
         {
            ObjectUtils.disposeObject(this._answer2);
         }
         this._answer2 = null;
         if(Boolean(this._questionTxt2))
         {
            ObjectUtils.disposeObject(this._questionTxt2);
         }
         this._questionTxt2 = null;
         if(Boolean(this._answerInput2))
         {
            ObjectUtils.disposeObject(this._answerInput2);
         }
         this._answerInput2 = null;
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
         if(Boolean(this._cancelBtn))
         {
            ObjectUtils.disposeObject(this._cancelBtn);
         }
         this._cancelBtn = null;
         super.dispose();
      }
   }
}

