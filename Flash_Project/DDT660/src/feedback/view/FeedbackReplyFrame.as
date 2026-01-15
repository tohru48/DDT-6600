package feedback.view
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.SelectedButtonGroup;
   import com.pickgliss.ui.controls.SelectedCheckButton;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.controls.TextInput;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.text.TextArea;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.SoundManager;
   import feedback.FeedbackEvent;
   import feedback.FeedbackManager;
   import feedback.data.FeedbackReplyInfo;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   import flash.text.TextFieldType;
   import road7th.utils.StringHelper;
   
   public class FeedbackReplyFrame extends Frame
   {
      
      private var _box:Sprite;
      
      private var _continueSubmitBox:Sprite;
      
      private var _delPostsBox:Sprite;
      
      private var _customerTextImg:FilterFrameText;
      
      private var _dateInput:TextInput;
      
      private var _continueSubmitBtn:TextButton;
      
      private var _backBtn:TextButton;
      
      private var _delPostsBtn:TextButton;
      
      private var _detailTextArea:TextArea;
      
      private var _detailTextArea2:TextArea;
      
      private var _detailTextArea3:TextArea;
      
      private var _detailTextArea4:TextArea;
      
      private var _detailTextImg:FilterFrameText;
      
      private var _detailTextImg3:FilterFrameText;
      
      private var _detailTextImg4:FilterFrameText;
      
      private var _infoText:FilterFrameText;
      
      private var _feedbackReplyInfo:FeedbackReplyInfo;
      
      private var _generalCheckButton:SelectedCheckButton;
      
      private var _occurrenceTimeTextImg:FilterFrameText;
      
      private var _playerEvaluationTextImg:Bitmap;
      
      private var _poorCheckButton:SelectedCheckButton;
      
      private var _problemTitleInput:TextInput;
      
      private var _problemTitleInput4:TextInput;
      
      private var _problemTitleTextImg:FilterFrameText;
      
      private var _problemTitleTextImg4:FilterFrameText;
      
      private var _replyEvaluationTextImg:Bitmap;
      
      private var _satisfactoryCheckButton:SelectedCheckButton;
      
      private var _selectedButtonGroup:SelectedButtonGroup;
      
      private var _submitAssessmentBtn:TextButton;
      
      private var _submitBtn:TextButton;
      
      private var _titleTextBgImg:Bitmap;
      
      private var _verySatisfiedCheckButton:SelectedCheckButton;
      
      public function FeedbackReplyFrame()
      {
         super();
         this._init();
      }
      
      override public function dispose() : void
      {
         this.remvoeEvent();
         ObjectUtils.disposeAllChildren(this._box);
         this._box = null;
         ObjectUtils.disposeAllChildren(this._delPostsBox);
         this._delPostsBox = null;
         ObjectUtils.disposeAllChildren(this._continueSubmitBox);
         this._continueSubmitBox = null;
         ObjectUtils.disposeAllChildren(this);
         this._customerTextImg = null;
         this._dateInput = null;
         this._continueSubmitBtn = null;
         this._backBtn = null;
         this._delPostsBtn = null;
         this._detailTextArea = null;
         this._detailTextArea2 = null;
         this._detailTextArea3 = null;
         this._detailTextArea4 = null;
         this._detailTextImg = null;
         this._detailTextImg3 = null;
         this._detailTextImg4 = null;
         this._infoText = null;
         this._feedbackReplyInfo = null;
         this._generalCheckButton = null;
         this._occurrenceTimeTextImg = null;
         this._playerEvaluationTextImg = null;
         this._poorCheckButton = null;
         this._problemTitleInput = null;
         this._problemTitleInput4 = null;
         this._problemTitleTextImg = null;
         this._problemTitleTextImg4 = null;
         this._replyEvaluationTextImg = null;
         this._satisfactoryCheckButton = null;
         this._selectedButtonGroup = null;
         this._submitAssessmentBtn = null;
         this._submitBtn = null;
         this._titleTextBgImg = null;
         this._verySatisfiedCheckButton = null;
         super.dispose();
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
      
      public function setup(feedbackReplyInfo:FeedbackReplyInfo) : void
      {
         this._feedbackReplyInfo = feedbackReplyInfo;
         this._problemTitleInput.text = feedbackReplyInfo.questionTitle;
         var dateArr:Array = feedbackReplyInfo.occurrenceDate.split("-");
         this._dateInput.text = LanguageMgr.GetTranslation("tank.data.MovementInfo.date",dateArr[0],dateArr[1],dateArr[2]);
         this._detailTextArea.text = feedbackReplyInfo.questionContent;
         this._detailTextArea2.text = feedbackReplyInfo.replyContent;
         this._problemTitleInput4.text = feedbackReplyInfo.questionTitle;
         this.changereplyEvaluationTex(feedbackReplyInfo.stopReply);
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      private function ___submitAssessmentBtnClick(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         FeedbackManager.instance.delPosts(this._feedbackReplyInfo.questionId,this._feedbackReplyInfo.replyId,this._selectedButtonGroup.selectIndex + 1,this._detailTextArea3.text);
      }
      
      private function __backBtnClick(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._continueSubmitBox.visible = false;
         this._box.visible = true;
      }
      
      private function __continueSubmitBtnClick(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._box.visible = false;
         this._continueSubmitBox.visible = true;
      }
      
      private function __delPostsBtnClick(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._box.visible = false;
         this._delPostsBox.visible = true;
      }
      
      private function __frameEventHandler(event:FrameEvent) : void
      {
         switch(event.responseCode)
         {
            case FrameEvent.ESC_CLICK:
            case FrameEvent.CLOSE_CLICK:
               FeedbackManager.instance.closeFrame();
         }
      }
      
      private function __submitBtnClick(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(StringHelper.isNullOrEmpty(this._detailTextArea4.text))
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("feedback.view.question_content"));
            return;
         }
         if(this._detailTextArea4.text.length < 8)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("feedback.view.question_LessThanEight"));
            return;
         }
         FeedbackManager.instance.continueSubmit(this._feedbackReplyInfo.questionId,this._feedbackReplyInfo.replyId,this._detailTextArea4.text);
      }
      
      private function __textInput(event:Event) : void
      {
         this._infoText.text = LanguageMgr.GetTranslation("feedback.view.infoText",this._detailTextArea4.maxChars - this._detailTextArea4.textField.length);
      }
      
      private function _init() : void
      {
         var rec:Rectangle = null;
         titleText = LanguageMgr.GetTranslation("feedback.view.FeedbackSubmitFrame.title");
         this._box = new Sprite();
         addToContent(this._box);
         this._problemTitleTextImg = ComponentFactory.Instance.creatComponentByStylename("ddtfeedback.titleText");
         this._problemTitleTextImg.text = LanguageMgr.GetTranslation("feedback.view.Feedback.text1");
         rec = ComponentFactory.Instance.creatCustomObject("feedback.problemTitleTextImg1Rec");
         ObjectUtils.copyPropertyByRectangle(this._problemTitleTextImg,rec);
         this._box.addChildAt(this._problemTitleTextImg,0);
         this._problemTitleInput = ComponentFactory.Instance.creatComponentByStylename("feedback.textInput");
         rec = ComponentFactory.Instance.creatCustomObject("feedback.problemTitleInput1Rec");
         ObjectUtils.copyPropertyByRectangle(this._problemTitleInput,rec);
         this._problemTitleInput.enable = false;
         this._box.addChildAt(this._problemTitleInput,0);
         this._occurrenceTimeTextImg = ComponentFactory.Instance.creatComponentByStylename("ddtfeedback.timerText");
         this._occurrenceTimeTextImg.text = LanguageMgr.GetTranslation("feedback.view.Feedback.text2");
         rec = ComponentFactory.Instance.creatCustomObject("feedback.occurrenceTimeTextImgRec2");
         ObjectUtils.copyPropertyByRectangle(this._occurrenceTimeTextImg,rec);
         this._box.addChildAt(this._occurrenceTimeTextImg,0);
         this._dateInput = ComponentFactory.Instance.creatComponentByStylename("feedback.textInput");
         rec = ComponentFactory.Instance.creatCustomObject("feedback.dateInputRec");
         ObjectUtils.copyPropertyByRectangle(this._dateInput,rec);
         this._dateInput.enable = false;
         this._box.addChildAt(this._dateInput,0);
         this._detailTextImg = ComponentFactory.Instance.creatComponentByStylename("ddtfeedback.descriptionText");
         this._detailTextImg.text = LanguageMgr.GetTranslation("feedback.view.Feedback.text6");
         rec = ComponentFactory.Instance.creatCustomObject("feedback.detailTextImg1Rec");
         ObjectUtils.copyPropertyByRectangle(this._detailTextImg,rec);
         this._box.addChildAt(this._detailTextImg,0);
         this._detailTextArea = ComponentFactory.Instance.creatComponentByStylename("feedback.simpleTextArea");
         rec = ComponentFactory.Instance.creatCustomObject("feedback.detailSimpleTextArea1Rec");
         ObjectUtils.copyPropertyByRectangle(this._detailTextArea,rec);
         this._detailTextArea.textField.type = TextFieldType.DYNAMIC;
         this._box.addChildAt(this._detailTextArea,0);
         this._customerTextImg = ComponentFactory.Instance.creatComponentByStylename("ddtfeedback.descriptionText");
         this._customerTextImg.text = LanguageMgr.GetTranslation("feedback.view.problemCombox_text10");
         rec = ComponentFactory.Instance.creatCustomObject("feedback.customerTextImgRec");
         ObjectUtils.copyPropertyByRectangle(this._customerTextImg,rec);
         this._box.addChildAt(this._customerTextImg,0);
         this._detailTextArea2 = ComponentFactory.Instance.creatComponentByStylename("feedback.simpleTextArea");
         rec = ComponentFactory.Instance.creatCustomObject("feedback.detailSimpleTextArea2Rec");
         ObjectUtils.copyPropertyByRectangle(this._detailTextArea2,rec);
         this._detailTextArea2.textField.type = TextFieldType.DYNAMIC;
         this._box.addChildAt(this._detailTextArea2,0);
         this._delPostsBtn = ComponentFactory.Instance.creatComponentByStylename("feedback.btn");
         rec = ComponentFactory.Instance.creatCustomObject("feedback.submitBtnRec");
         ObjectUtils.copyPropertyByRectangle(this._delPostsBtn,rec);
         this._delPostsBtn.text = LanguageMgr.GetTranslation("feedback.view.delPostsBtnText");
         this._box.addChildAt(this._delPostsBtn,0);
         this._continueSubmitBtn = ComponentFactory.Instance.creatComponentByStylename("feedback.btn");
         rec = ComponentFactory.Instance.creatCustomObject("feedback.continueSubmitBtnRec");
         ObjectUtils.copyPropertyByRectangle(this._continueSubmitBtn,rec);
         this._continueSubmitBtn.text = LanguageMgr.GetTranslation("feedback.view.continueSubmitBtnText");
         this._box.addChildAt(this._continueSubmitBtn,0);
         this._delPostsBox = new Sprite();
         addToContent(this._delPostsBox);
         this._delPostsBox.visible = false;
         this._titleTextBgImg = ComponentFactory.Instance.creatBitmap("asset.feedback.titleTextBgImg");
         rec = ComponentFactory.Instance.creatCustomObject("feedback.titleTextBgImgRec");
         ObjectUtils.copyPropertyByRectangle(this._titleTextBgImg,rec);
         this._delPostsBox.addChildAt(this._titleTextBgImg,0);
         this._playerEvaluationTextImg = ComponentFactory.Instance.creatBitmap("asset.feedback.playerEvaluationTextImg");
         rec = ComponentFactory.Instance.creatCustomObject("feedback.playerEvaluationTextImgRec");
         ObjectUtils.copyPropertyByRectangle(this._playerEvaluationTextImg,rec);
         this._delPostsBox.addChildAt(this._playerEvaluationTextImg,0);
         this._replyEvaluationTextImg = ComponentFactory.Instance.creatBitmap("asset.feedback.replyEvaluationTextImg");
         rec = ComponentFactory.Instance.creatCustomObject("feedback.replyEvaluationTextImgRec");
         ObjectUtils.copyPropertyByRectangle(this._replyEvaluationTextImg,rec);
         this._delPostsBox.addChildAt(this._replyEvaluationTextImg,0);
         this._poorCheckButton = ComponentFactory.Instance.creatComponentByStylename("feedback.poorCheckButton");
         rec = ComponentFactory.Instance.creatCustomObject("feedback.poorCheckButtonRec");
         ObjectUtils.copyPropertyByRectangle(this._poorCheckButton,rec);
         this._delPostsBox.addChildAt(this._poorCheckButton,0);
         this._generalCheckButton = ComponentFactory.Instance.creatComponentByStylename("feedback.generalCheckButton");
         rec = ComponentFactory.Instance.creatCustomObject("feedback.generalCheckButtonRec");
         ObjectUtils.copyPropertyByRectangle(this._generalCheckButton,rec);
         this._delPostsBox.addChildAt(this._generalCheckButton,0);
         this._satisfactoryCheckButton = ComponentFactory.Instance.creatComponentByStylename("feedback.satisfactoryCheckButton");
         rec = ComponentFactory.Instance.creatCustomObject("feedback.satisfactoryCheckButtonRec");
         ObjectUtils.copyPropertyByRectangle(this._satisfactoryCheckButton,rec);
         this._delPostsBox.addChildAt(this._satisfactoryCheckButton,0);
         this._verySatisfiedCheckButton = ComponentFactory.Instance.creatComponentByStylename("feedback.verySatisfiedCheckButton");
         rec = ComponentFactory.Instance.creatCustomObject("feedback.verySatisfiedCheckButtonRec");
         ObjectUtils.copyPropertyByRectangle(this._verySatisfiedCheckButton,rec);
         this._delPostsBox.addChildAt(this._verySatisfiedCheckButton,0);
         this._selectedButtonGroup = new SelectedButtonGroup(false,1);
         this._selectedButtonGroup.addSelectItem(this._poorCheckButton);
         this._selectedButtonGroup.addSelectItem(this._generalCheckButton);
         this._selectedButtonGroup.addSelectItem(this._satisfactoryCheckButton);
         this._selectedButtonGroup.addSelectItem(this._verySatisfiedCheckButton);
         this._selectedButtonGroup.selectIndex = 3;
         this._detailTextImg3 = ComponentFactory.Instance.creatComponentByStylename("ddtfeedback.descriptionText");
         this._detailTextImg3.text = LanguageMgr.GetTranslation("feedback.view.Feedback.text6");
         rec = ComponentFactory.Instance.creatCustomObject("feedback.detailTextImg3Rec");
         ObjectUtils.copyPropertyByRectangle(this._detailTextImg3,rec);
         this._delPostsBox.addChildAt(this._detailTextImg3,0);
         this._detailTextArea3 = ComponentFactory.Instance.creatComponentByStylename("feedback.simpleTextArea");
         rec = ComponentFactory.Instance.creatCustomObject("feedback.detailSimpleTextArea3Rec");
         ObjectUtils.copyPropertyByRectangle(this._detailTextArea3,rec);
         this._delPostsBox.addChildAt(this._detailTextArea3,0);
         this._submitAssessmentBtn = ComponentFactory.Instance.creatComponentByStylename("feedback.btn");
         rec = ComponentFactory.Instance.creatCustomObject("feedback.submitAssessmentBtnRec");
         ObjectUtils.copyPropertyByRectangle(this._submitAssessmentBtn,rec);
         this._submitAssessmentBtn.text = LanguageMgr.GetTranslation("feedback.view.submitAssessmentBtnText");
         this._delPostsBox.addChildAt(this._submitAssessmentBtn,0);
         this._continueSubmitBox = new Sprite();
         addToContent(this._continueSubmitBox);
         this._continueSubmitBox.visible = false;
         this._problemTitleTextImg4 = ComponentFactory.Instance.creatComponentByStylename("ddtfeedback.titleText");
         this._problemTitleTextImg4.text = LanguageMgr.GetTranslation("feedback.view.Feedback.text1");
         rec = ComponentFactory.Instance.creatCustomObject("feedback.problemTitleTextImg1Rec");
         ObjectUtils.copyPropertyByRectangle(this._problemTitleTextImg4,rec);
         this._continueSubmitBox.addChildAt(this._problemTitleTextImg4,0);
         this._problemTitleInput4 = ComponentFactory.Instance.creatComponentByStylename("feedback.textInput");
         rec = ComponentFactory.Instance.creatCustomObject("feedback.problemTitleInput1Rec");
         ObjectUtils.copyPropertyByRectangle(this._problemTitleInput4,rec);
         this._problemTitleInput4.enable = false;
         this._continueSubmitBox.addChildAt(this._problemTitleInput4,0);
         this._detailTextImg4 = ComponentFactory.Instance.creatComponentByStylename("ddtfeedback.descriptionText");
         this._detailTextImg4.text = LanguageMgr.GetTranslation("feedback.view.Feedback.text6");
         rec = ComponentFactory.Instance.creatCustomObject("feedback.detailTextImg4Rec");
         ObjectUtils.copyPropertyByRectangle(this._detailTextImg4,rec);
         this._continueSubmitBox.addChildAt(this._detailTextImg4,0);
         this._detailTextArea4 = ComponentFactory.Instance.creatComponentByStylename("feedback.simpleTextArea");
         rec = ComponentFactory.Instance.creatCustomObject("feedback.detailSimpleTextArea4Rec");
         ObjectUtils.copyPropertyByRectangle(this._detailTextArea4,rec);
         this._continueSubmitBox.addChildAt(this._detailTextArea4,0);
         this._infoText = ComponentFactory.Instance.creatComponentByStylename("feedback.infoText");
         rec = ComponentFactory.Instance.creatCustomObject("feedback.detailTextInfoText4Rec");
         ObjectUtils.copyPropertyByRectangle(this._infoText,rec);
         this._infoText.text = LanguageMgr.GetTranslation("feedback.view.infoText",this._detailTextArea4.maxChars);
         this._continueSubmitBox.addChildAt(this._infoText,0);
         this._backBtn = ComponentFactory.Instance.creatComponentByStylename("feedback.btn");
         rec = ComponentFactory.Instance.creatCustomObject("feedback.stealHandBackBtnRec");
         ObjectUtils.copyPropertyByRectangle(this._backBtn,rec);
         this._backBtn.text = LanguageMgr.GetTranslation("tank.view.bagII.baglocked.preview");
         this._continueSubmitBox.addChildAt(this._backBtn,0);
         this._submitBtn = ComponentFactory.Instance.creatComponentByStylename("feedback.btn");
         rec = ComponentFactory.Instance.creatCustomObject("feedback.stealHandSubmitBtnRec");
         ObjectUtils.copyPropertyByRectangle(this._submitBtn,rec);
         this._submitBtn.text = LanguageMgr.GetTranslation("feedback.view.FeedbackSubmitSp.submitBtnText");
         this._continueSubmitBox.addChildAt(this._submitBtn,0);
         this.addEvent();
      }
      
      private function changereplyEvaluationTex(str:String) : void
      {
         switch(str)
         {
            case "0":
               if(Boolean(this._continueSubmitBtn))
               {
                  this._continueSubmitBtn.visible = true;
               }
               break;
            case "1":
               if(Boolean(this._continueSubmitBtn))
               {
                  this._continueSubmitBtn.visible = false;
               }
         }
      }
      
      private function feedbackStopReplyEvt(e:FeedbackEvent) : void
      {
         this.changereplyEvaluationTex(e.data.stopReply);
      }
      
      private function addEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__frameEventHandler);
         this._delPostsBtn.addEventListener(MouseEvent.CLICK,this.__delPostsBtnClick);
         this._continueSubmitBtn.addEventListener(MouseEvent.CLICK,this.__continueSubmitBtnClick);
         this._backBtn.addEventListener(MouseEvent.CLICK,this.__backBtnClick);
         this._submitBtn.addEventListener(MouseEvent.CLICK,this.__submitBtnClick);
         this._submitAssessmentBtn.addEventListener(MouseEvent.CLICK,this.___submitAssessmentBtnClick);
         FeedbackManager.instance.addEventListener(FeedbackEvent.FEEDBACK_StopReply,this.feedbackStopReplyEvt);
         this._detailTextArea4.textField.addEventListener(Event.CHANGE,this.__textInput);
      }
      
      private function remvoeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__frameEventHandler);
         this._delPostsBtn.removeEventListener(MouseEvent.CLICK,this.__delPostsBtnClick);
         this._continueSubmitBtn.removeEventListener(MouseEvent.CLICK,this.__continueSubmitBtnClick);
         this._backBtn.removeEventListener(MouseEvent.CLICK,this.__backBtnClick);
         this._detailTextArea4.textField.removeEventListener(Event.CHANGE,this.__textInput);
         this._submitBtn.removeEventListener(MouseEvent.CLICK,this.__submitBtnClick);
         this._submitAssessmentBtn.removeEventListener(MouseEvent.CLICK,this.___submitAssessmentBtnClick);
      }
   }
}

