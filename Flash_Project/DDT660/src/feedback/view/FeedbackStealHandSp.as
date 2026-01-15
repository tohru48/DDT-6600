package feedback.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.controls.TextInput;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.text.TextArea;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PathManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import feedback.FeedbackManager;
   import feedback.data.FeedbackInfo;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.text.TextFieldType;
   import road7th.utils.StringHelper;
   
   public class FeedbackStealHandSp extends Sprite implements Disposeable
   {
      
      private var _acquirementAsterisk:Bitmap;
      
      private var _acquirementTextImg:FilterFrameText;
      
      private var _acquirementTextInput:TextInput;
      
      private var _backBtn:TextButton;
      
      private var _closeBtn:TextButton;
      
      private var _detailTextArea:TextArea;
      
      private var _csTelPos:Point;
      
      private var _csTelText:FilterFrameText;
      
      private var _detailTextImg:FilterFrameText;
      
      private var _infoText:FilterFrameText;
      
      private var _explainTextArea:TextArea;
      
      private var _getTimeAsterisk:Bitmap;
      
      private var _infoDateText:FilterFrameText;
      
      private var _getTimeTextImg:FilterFrameText;
      
      private var _getTimeTextInput:TextInput;
      
      private var _nextBtn:TextButton;
      
      private var _submitBtn:TextButton;
      
      private var _submitFrame:FeedbackSubmitFrame;
      
      private var _textInputBg:ScaleBitmapImage;
      
      public function FeedbackStealHandSp()
      {
         super();
         this._init();
      }
      
      public function get check() : Boolean
      {
         if(!this._submitFrame.feedbackInfo.goods_get_method)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("feedback.view.goods_get_method"));
            return false;
         }
         if(!this._submitFrame.feedbackInfo.goods_get_date)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("feedback.view.goods_get_date"));
            return false;
         }
         if(!this._submitFrame.feedbackInfo.question_content)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("feedback.view.question_content"));
            return false;
         }
         if(this._submitFrame.feedbackInfo.question_content.length < 8)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("feedback.view.question_LessThanEight"));
            return false;
         }
         return true;
      }
      
      public function dispose() : void
      {
         this.remvoeEvent();
         ObjectUtils.disposeAllChildren(this);
         this._explainTextArea = null;
         this._acquirementTextImg = null;
         this._acquirementTextInput = null;
         this._acquirementAsterisk = null;
         this._getTimeTextImg = null;
         this._getTimeTextInput = null;
         this._getTimeAsterisk = null;
         this._infoDateText = null;
         this._detailTextImg = null;
         this._csTelText = null;
         this._infoText = null;
         this._detailTextArea = null;
         this._nextBtn = null;
         this._closeBtn = null;
         this._backBtn = null;
         this._submitBtn = null;
         this._submitFrame = null;
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
      
      public function setFeedbackInfo() : void
      {
         this._submitFrame.feedbackInfo.question_content = this._detailTextArea.text;
         this._submitFrame.feedbackInfo.goods_get_method = this._acquirementTextInput.text;
         this._submitFrame.feedbackInfo.goods_get_date = this._getTimeTextInput.text;
      }
      
      public function set submitFrame($submitFrame:FeedbackSubmitFrame) : void
      {
         this._submitFrame = $submitFrame;
         if(Boolean(this._submitFrame.feedbackInfo.question_content))
         {
            this._detailTextArea.text = this._submitFrame.feedbackInfo.question_content;
         }
         if(Boolean(this._submitFrame.feedbackInfo.goods_get_method))
         {
            this._acquirementTextInput.text = this._submitFrame.feedbackInfo.goods_get_method;
         }
         if(Boolean(this._submitFrame.feedbackInfo.goods_get_date))
         {
            this._getTimeTextInput.text = this._submitFrame.feedbackInfo.goods_get_date;
         }
         this.__texeInput(null);
      }
      
      private function __backBtnClick(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._submitFrame.problemCombox.mouseEnabled = true;
         this._submitFrame.problemCombox.mouseChildren = true;
         this._submitFrame.problemTitleInput.mouseEnabled = true;
         this._submitFrame.problemTitleInput.mouseChildren = true;
         this._explainTextArea.visible = true;
         this._nextBtn.visible = true;
         this._closeBtn.visible = true;
         this._backBtn.visible = false;
         this._submitBtn.visible = false;
         this._detailTextImg.visible = false;
         this._detailTextArea.visible = false;
         this._csTelText.y = 85;
         this._infoText.visible = false;
         this._acquirementTextImg.visible = false;
         this._acquirementTextInput.visible = false;
         this._acquirementAsterisk.visible = false;
         this._getTimeTextImg.visible = false;
         this._getTimeTextInput.visible = false;
         this._getTimeAsterisk.visible = false;
         this._infoDateText.visible = false;
         this._csTelText.visible = true;
         this._textInputBg.y = 105;
         this._textInputBg.height = 242;
      }
      
      private function __texeInput(event:Event) : void
      {
         this._infoText.text = LanguageMgr.GetTranslation("feedback.view.infoText",this._detailTextArea.maxChars - this._detailTextArea.textField.length);
      }
      
      private function __closeBtnClick(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         FeedbackManager.instance.closeFrame();
      }
      
      private function __nextBtnClick(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(this._submitFrame.feedbackInfo.question_type < 0)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("feedback.view.question_type"));
            return;
         }
         if(!this._submitFrame.feedbackInfo.question_title)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("feedback.view.question_title"));
            return;
         }
         this._submitFrame.problemCombox.mouseEnabled = false;
         this._submitFrame.problemCombox.mouseChildren = false;
         this._submitFrame.problemTitleInput.mouseEnabled = false;
         this._submitFrame.problemTitleInput.mouseChildren = false;
         this._explainTextArea.visible = false;
         this._nextBtn.visible = false;
         this._closeBtn.visible = false;
         this._infoText.visible = true;
         this._backBtn.visible = true;
         this._submitBtn.visible = true;
         this._detailTextImg.visible = true;
         this._detailTextArea.visible = true;
         this._csTelText.y = 164;
         this._acquirementTextImg.visible = true;
         this._acquirementTextInput.visible = true;
         this._acquirementAsterisk.visible = true;
         this._getTimeTextImg.visible = true;
         this._getTimeTextInput.visible = true;
         this._getTimeAsterisk.visible = true;
         this._infoDateText.visible = true;
         this._csTelText.visible = true;
         this._textInputBg.y = 187;
         this._textInputBg.height = 140;
      }
      
      private function __submitBtnClick(event:MouseEvent) : void
      {
         var info:FeedbackInfo = null;
         SoundManager.instance.play("008");
         this.setFeedbackInfo();
         if(this.check)
         {
            info = new FeedbackInfo();
            info.question_type = this._submitFrame.feedbackInfo.question_type;
            info.question_title = this._submitFrame.feedbackInfo.question_title;
            info.occurrence_date = this._submitFrame.feedbackInfo.occurrence_date;
            info.question_content = this._submitFrame.feedbackInfo.question_content;
            info.goods_get_method = this._submitFrame.feedbackInfo.goods_get_method;
            info.goods_get_date = this._submitFrame.feedbackInfo.goods_get_date;
            FeedbackManager.instance.submitFeedbackInfo(info);
         }
      }
      
      private function _init() : void
      {
         var rec:Rectangle = null;
         this._explainTextArea = ComponentFactory.Instance.creatComponentByStylename("feedback.simpleTextArea");
         rec = ComponentFactory.Instance.creatCustomObject("feedback.stealHandExplainTextAreaRec");
         ObjectUtils.copyPropertyByRectangle(this._explainTextArea,rec);
         this._explainTextArea.textField.htmlText = LanguageMgr.GetTranslation("feedback.view.explainTextAreaText");
         this._explainTextArea.textField.type = TextFieldType.DYNAMIC;
         this._explainTextArea.invalidateViewport();
         addChildAt(this._explainTextArea,0);
         this._acquirementTextImg = ComponentFactory.Instance.creatComponentByStylename("ddtfeedback.typeText");
         this._acquirementTextImg.text = LanguageMgr.GetTranslation("feedback.view.Feedback.text9");
         rec = ComponentFactory.Instance.creatCustomObject("feedback.stealHandAcquirementTextImgRec");
         ObjectUtils.copyPropertyByRectangle(this._acquirementTextImg,rec);
         this._acquirementTextImg.visible = false;
         addChildAt(this._acquirementTextImg,0);
         this._acquirementTextInput = ComponentFactory.Instance.creatComponentByStylename("feedback.textInput");
         rec = ComponentFactory.Instance.creatCustomObject("feedback.stealHandAcquirementInputRec");
         ObjectUtils.copyPropertyByRectangle(this._acquirementTextInput,rec);
         this._acquirementTextInput.visible = false;
         addChildAt(this._acquirementTextInput,0);
         this._acquirementAsterisk = ComponentFactory.Instance.creatBitmap("asset.feedback.asteriskImg");
         rec = ComponentFactory.Instance.creatCustomObject("feedback.stealHandAcquirementAsteriskRec");
         ObjectUtils.copyPropertyByRectangle(this._acquirementAsterisk,rec);
         this._acquirementAsterisk.visible = false;
         addChildAt(this._acquirementAsterisk,0);
         this._getTimeTextImg = ComponentFactory.Instance.creatComponentByStylename("ddtfeedback.typeText");
         this._getTimeTextImg.text = LanguageMgr.GetTranslation("feedback.view.Feedback.text10");
         rec = ComponentFactory.Instance.creatCustomObject("feedback.stealHandGetTimeTextImgRec");
         ObjectUtils.copyPropertyByRectangle(this._getTimeTextImg,rec);
         this._getTimeTextImg.visible = false;
         addChildAt(this._getTimeTextImg,0);
         this._getTimeTextInput = ComponentFactory.Instance.creatComponentByStylename("feedback.textInput");
         rec = ComponentFactory.Instance.creatCustomObject("feedback.stealHandGetTimeInputRec");
         ObjectUtils.copyPropertyByRectangle(this._getTimeTextInput,rec);
         this._getTimeTextInput.visible = false;
         this._getTimeTextInput.textField.restrict = "0-9\\-";
         addChildAt(this._getTimeTextInput,0);
         this._getTimeAsterisk = ComponentFactory.Instance.creatBitmap("asset.feedback.asteriskImg");
         rec = ComponentFactory.Instance.creatCustomObject("feedback.stealHandGetTimeAsteriskRec");
         ObjectUtils.copyPropertyByRectangle(this._getTimeAsterisk,rec);
         this._getTimeAsterisk.visible = false;
         addChildAt(this._getTimeAsterisk,0);
         this._infoDateText = ComponentFactory.Instance.creatComponentByStylename("feedback.infoText");
         rec = ComponentFactory.Instance.creatCustomObject("feedback.stealHandInfoDateTextRec");
         ObjectUtils.copyPropertyByRectangle(this._infoDateText,rec);
         this._infoDateText.text = LanguageMgr.GetTranslation("feedback.view.infoDateText");
         addChildAt(this._infoDateText,0);
         this._infoDateText.visible = false;
         this._detailTextImg = ComponentFactory.Instance.creatComponentByStylename("ddtfeedback.descriptionText");
         this._detailTextImg.text = LanguageMgr.GetTranslation("feedback.view.Feedback.text6");
         rec = ComponentFactory.Instance.creatCustomObject("feedback.stealHandDetailTextImgRec");
         ObjectUtils.copyPropertyByRectangle(this._detailTextImg,rec);
         this._detailTextImg.visible = false;
         addChildAt(this._detailTextImg,0);
         this._infoText = ComponentFactory.Instance.creatComponentByStylename("feedback.infoText");
         rec = ComponentFactory.Instance.creatCustomObject("feedback.stealHandDisappearInfoTextRec");
         ObjectUtils.copyPropertyByRectangle(this._infoText,rec);
         addChildAt(this._infoText,0);
         this._infoText.visible = false;
         this._csTelText = ComponentFactory.Instance.creatComponentByStylename("feedback.csTelText");
         this._csTelText.text = LanguageMgr.GetTranslation("feedback.view.csTelNumber",PathManager.solveFeedbackTelNumber());
         if(!StringHelper.isNullOrEmpty(PathManager.solveFeedbackTelNumber()))
         {
            addChild(this._csTelText);
         }
         this._csTelPos = new Point();
         PositionUtils.setPos(this._csTelPos,this._csTelText);
         this._csTelText.y = 85;
         this._csTelText.visible = true;
         this._detailTextArea = ComponentFactory.Instance.creatComponentByStylename("feedback.simpleTextArea");
         rec = ComponentFactory.Instance.creatCustomObject("feedback.stealHandDetailTextAreaRec");
         ObjectUtils.copyPropertyByRectangle(this._detailTextArea,rec);
         this._detailTextArea.text = "";
         this._detailTextArea.visible = false;
         addChildAt(this._detailTextArea,0);
         this._infoText.text = LanguageMgr.GetTranslation("feedback.view.infoText",this._detailTextArea.maxChars);
         this._textInputBg = ComponentFactory.Instance.creatComponentByStylename("feedbackStealHand.textBgImg_style");
         addChildAt(this._textInputBg,0);
         this._nextBtn = ComponentFactory.Instance.creatComponentByStylename("feedback.btn");
         rec = ComponentFactory.Instance.creatCustomObject("feedback.stealHandNextBtnRec");
         ObjectUtils.copyPropertyByRectangle(this._nextBtn,rec);
         this._nextBtn.text = LanguageMgr.GetTranslation("tank.view.bagII.baglocked.next");
         addChildAt(this._nextBtn,0);
         this._closeBtn = ComponentFactory.Instance.creatComponentByStylename("feedback.btn");
         rec = ComponentFactory.Instance.creatCustomObject("feedback.closeBtnRec");
         ObjectUtils.copyPropertyByRectangle(this._closeBtn,rec);
         this._closeBtn.text = LanguageMgr.GetTranslation("tank.invite.InviteView.close");
         addChildAt(this._closeBtn,0);
         this._backBtn = ComponentFactory.Instance.creatComponentByStylename("feedback.btn");
         rec = ComponentFactory.Instance.creatCustomObject("feedback.stealHandBackBtnRec");
         ObjectUtils.copyPropertyByRectangle(this._backBtn,rec);
         this._backBtn.text = LanguageMgr.GetTranslation("tank.view.bagII.baglocked.preview");
         this._backBtn.visible = false;
         addChildAt(this._backBtn,0);
         this._submitBtn = ComponentFactory.Instance.creatComponentByStylename("feedback.btn");
         rec = ComponentFactory.Instance.creatCustomObject("feedback.stealHandSubmitBtnRec");
         ObjectUtils.copyPropertyByRectangle(this._submitBtn,rec);
         this._submitBtn.text = LanguageMgr.GetTranslation("feedback.view.FeedbackSubmitSp.submitBtnText");
         this._submitBtn.visible = false;
         addChildAt(this._submitBtn,0);
         this.addEvent();
      }
      
      private function addEvent() : void
      {
         this._nextBtn.addEventListener(MouseEvent.CLICK,this.__nextBtnClick);
         this._backBtn.addEventListener(MouseEvent.CLICK,this.__backBtnClick);
         this._submitBtn.addEventListener(MouseEvent.CLICK,this.__submitBtnClick);
         this._closeBtn.addEventListener(MouseEvent.CLICK,this.__closeBtnClick);
         this._detailTextArea.textField.addEventListener(Event.CHANGE,this.__texeInput);
      }
      
      private function remvoeEvent() : void
      {
         this._nextBtn.addEventListener(MouseEvent.CLICK,this.__nextBtnClick);
         this._backBtn.addEventListener(MouseEvent.CLICK,this.__backBtnClick);
         this._submitBtn.addEventListener(MouseEvent.CLICK,this.__submitBtnClick);
         this._closeBtn.removeEventListener(MouseEvent.CLICK,this.__closeBtnClick);
         this._detailTextArea.textField.removeEventListener(Event.CHANGE,this.__texeInput);
      }
   }
}

