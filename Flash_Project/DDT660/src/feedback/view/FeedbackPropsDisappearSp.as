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
   import feedback.FeedbackManager;
   import feedback.data.FeedbackInfo;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   import road7th.utils.StringHelper;
   
   public class FeedbackPropsDisappearSp extends Sprite implements Disposeable
   {
      
      private var _acquirementAsterisk:Bitmap;
      
      private var _acquirementTextImg:FilterFrameText;
      
      private var _acquirementTextInput:TextInput;
      
      private var _closeBtn:TextButton;
      
      private var _detailTextArea:TextArea;
      
      private var _csTelText:FilterFrameText;
      
      private var _detailTextImg:FilterFrameText;
      
      private var _infoText:FilterFrameText;
      
      private var _getTimeAsterisk:Bitmap;
      
      private var _infoDateText:FilterFrameText;
      
      private var _getTimeTextImg:FilterFrameText;
      
      private var _getTimeTextInput:TextInput;
      
      private var _submitBtn:TextButton;
      
      private var _submitFrame:FeedbackSubmitFrame;
      
      private var _textInputBg:ScaleBitmapImage;
      
      public function FeedbackPropsDisappearSp()
      {
         super();
         this._init();
      }
      
      public function get check() : Boolean
      {
         if(this._submitFrame.feedbackInfo.question_type < 0)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("feedback.view.question_type"));
            return false;
         }
         if(!this._submitFrame.feedbackInfo.question_title)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("feedback.view.question_title"));
            return false;
         }
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
         this._acquirementTextImg = null;
         this._acquirementTextInput = null;
         this._acquirementAsterisk = null;
         this._getTimeTextImg = null;
         this._getTimeTextInput = null;
         this._getTimeAsterisk = null;
         this._infoDateText = null;
         this._csTelText = null;
         this._detailTextImg = null;
         this._detailTextArea = null;
         this._submitBtn = null;
         this._closeBtn = null;
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
      
      private function __closeBtnClick(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         FeedbackManager.instance.closeFrame();
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
      
      private function __texeInput(event:Event) : void
      {
         this._infoText.text = LanguageMgr.GetTranslation("feedback.view.infoText",this._detailTextArea.maxChars - this._detailTextArea.textField.length);
      }
      
      private function _init() : void
      {
         var rec:Rectangle = null;
         this._acquirementTextImg = ComponentFactory.Instance.creatComponentByStylename("ddtfeedback.typeText");
         this._acquirementTextImg.text = LanguageMgr.GetTranslation("feedback.view.Feedback.text9");
         rec = ComponentFactory.Instance.creatCustomObject("feedback.propsAcquirementTextImgRec");
         ObjectUtils.copyPropertyByRectangle(this._acquirementTextImg,rec);
         addChildAt(this._acquirementTextImg,0);
         this._acquirementTextInput = ComponentFactory.Instance.creatComponentByStylename("feedback.textInput");
         rec = ComponentFactory.Instance.creatCustomObject("feedback.propsAcquirementInputRec");
         ObjectUtils.copyPropertyByRectangle(this._acquirementTextInput,rec);
         addChildAt(this._acquirementTextInput,0);
         this._acquirementAsterisk = ComponentFactory.Instance.creatBitmap("asset.feedback.asteriskImg");
         rec = ComponentFactory.Instance.creatCustomObject("feedback.propsAcquirementAsteriskRec");
         ObjectUtils.copyPropertyByRectangle(this._acquirementAsterisk,rec);
         addChildAt(this._acquirementAsterisk,0);
         this._getTimeTextImg = ComponentFactory.Instance.creatComponentByStylename("ddtfeedback.typeText");
         this._getTimeTextImg.text = LanguageMgr.GetTranslation("feedback.view.Feedback.text10");
         rec = ComponentFactory.Instance.creatCustomObject("feedback.propsGetTimeTextImgRec");
         ObjectUtils.copyPropertyByRectangle(this._getTimeTextImg,rec);
         addChildAt(this._getTimeTextImg,0);
         this._getTimeTextInput = ComponentFactory.Instance.creatComponentByStylename("feedback.textInput");
         rec = ComponentFactory.Instance.creatCustomObject("feedback.propsGetTimeInputRec");
         ObjectUtils.copyPropertyByRectangle(this._getTimeTextInput,rec);
         this._getTimeTextInput.textField.restrict = "0-9\\-";
         addChildAt(this._getTimeTextInput,0);
         this._getTimeAsterisk = ComponentFactory.Instance.creatBitmap("asset.feedback.asteriskImg");
         rec = ComponentFactory.Instance.creatCustomObject("feedback.propsGetTimeAsteriskRec");
         ObjectUtils.copyPropertyByRectangle(this._getTimeAsterisk,rec);
         addChildAt(this._getTimeAsterisk,0);
         this._infoDateText = ComponentFactory.Instance.creatComponentByStylename("feedback.infoText");
         rec = ComponentFactory.Instance.creatCustomObject("feedback.propsInfoDateTextRec");
         ObjectUtils.copyPropertyByRectangle(this._infoDateText,rec);
         this._infoDateText.text = LanguageMgr.GetTranslation("feedback.view.infoDateText");
         addChildAt(this._infoDateText,0);
         this._detailTextImg = ComponentFactory.Instance.creatComponentByStylename("ddtfeedback.descriptionText");
         this._detailTextImg.text = LanguageMgr.GetTranslation("feedback.view.Feedback.text6");
         rec = ComponentFactory.Instance.creatCustomObject("feedback.propsDisappearDetailTextImgRec");
         ObjectUtils.copyPropertyByRectangle(this._detailTextImg,rec);
         addChildAt(this._detailTextImg,0);
         this._csTelText = ComponentFactory.Instance.creatComponentByStylename("feedback.csTelText");
         this._csTelText.text = LanguageMgr.GetTranslation("feedback.view.csTelNumber",PathManager.solveFeedbackTelNumber());
         if(!StringHelper.isNullOrEmpty(PathManager.solveFeedbackTelNumber()))
         {
            addChild(this._csTelText);
         }
         this._infoText = ComponentFactory.Instance.creatComponentByStylename("feedback.infoText");
         rec = ComponentFactory.Instance.creatCustomObject("feedback.propsDisappearInfoTextRec");
         ObjectUtils.copyPropertyByRectangle(this._infoText,rec);
         this._csTelText.y = 198;
         addChildAt(this._infoText,0);
         this._detailTextArea = ComponentFactory.Instance.creatComponentByStylename("feedback.simpleTextArea");
         rec = ComponentFactory.Instance.creatCustomObject("feedback.propsDisappearDetailTextAreaRec");
         ObjectUtils.copyPropertyByRectangle(this._detailTextArea,rec);
         this._detailTextArea.text = "";
         addChildAt(this._detailTextArea,0);
         this._infoText.text = LanguageMgr.GetTranslation("feedback.view.infoText",this._detailTextArea.maxChars);
         this._textInputBg = ComponentFactory.Instance.creatComponentByStylename("feedbackprop.textBgImg_style");
         addChildAt(this._textInputBg,0);
         this._submitBtn = ComponentFactory.Instance.creatComponentByStylename("feedback.btn");
         rec = ComponentFactory.Instance.creatCustomObject("feedback.submitBtnRec");
         ObjectUtils.copyPropertyByRectangle(this._submitBtn,rec);
         this._submitBtn.text = LanguageMgr.GetTranslation("feedback.view.FeedbackSubmitSp.submitBtnText");
         addChildAt(this._submitBtn,0);
         this._closeBtn = ComponentFactory.Instance.creatComponentByStylename("feedback.btn");
         rec = ComponentFactory.Instance.creatCustomObject("feedback.closeBtnRec");
         ObjectUtils.copyPropertyByRectangle(this._closeBtn,rec);
         this._closeBtn.text = LanguageMgr.GetTranslation("tank.invite.InviteView.close");
         addChildAt(this._closeBtn,0);
         this.addEvent();
      }
      
      private function addEvent() : void
      {
         this._submitBtn.addEventListener(MouseEvent.CLICK,this.__submitBtnClick);
         this._closeBtn.addEventListener(MouseEvent.CLICK,this.__closeBtnClick);
         this._detailTextArea.textField.addEventListener(Event.CHANGE,this.__texeInput);
      }
      
      private function remvoeEvent() : void
      {
         this._submitBtn.removeEventListener(MouseEvent.CLICK,this.__submitBtnClick);
         this._closeBtn.removeEventListener(MouseEvent.CLICK,this.__closeBtnClick);
         this._detailTextArea.textField.removeEventListener(Event.CHANGE,this.__texeInput);
      }
   }
}

