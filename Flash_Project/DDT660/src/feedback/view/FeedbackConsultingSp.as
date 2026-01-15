package feedback.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.TextButton;
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
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   import road7th.utils.StringHelper;
   
   public class FeedbackConsultingSp extends Sprite implements Disposeable
   {
      
      private var _csTelText:FilterFrameText;
      
      private var _infoText:FilterFrameText;
      
      private var _closeBtn:TextButton;
      
      private var _detailTextArea:TextArea;
      
      private var _detailTextImg:FilterFrameText;
      
      private var _submitBtn:TextButton;
      
      private var _submitFrame:FeedbackSubmitFrame;
      
      private var _textInputBg:ScaleBitmapImage;
      
      public function FeedbackConsultingSp()
      {
         super();
         this._init();
      }
      
      public function get check() : Boolean
      {
         if(this._submitFrame.feedbackInfo.question_type <= 0)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("feedback.view.question_type"));
            return false;
         }
         if(!this._submitFrame.feedbackInfo.question_title)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("feedback.view.question_title"));
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
         this._detailTextImg = null;
         this._csTelText = null;
         this._infoText = null;
         this._detailTextArea = null;
         this._submitBtn = null;
         this._closeBtn = null;
         this._submitFrame = null;
         this._textInputBg = null;
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
      
      public function setFeedbackInfo() : void
      {
         this._submitFrame.feedbackInfo.question_content = this._detailTextArea.text;
      }
      
      public function set submitFrame($submitFrame:FeedbackSubmitFrame) : void
      {
         this._submitFrame = $submitFrame;
         if(Boolean(this._submitFrame.feedbackInfo.question_content))
         {
            this._detailTextArea.text = this._submitFrame.feedbackInfo.question_content;
         }
         this.__texeInput(null);
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
            FeedbackManager.instance.submitFeedbackInfo(info);
         }
      }
      
      private function _init() : void
      {
         var rec:Rectangle = null;
         this._detailTextImg = ComponentFactory.Instance.creatComponentByStylename("ddtfeedback.descriptionText");
         this._detailTextImg.text = LanguageMgr.GetTranslation("feedback.view.Feedback.text6");
         rec = ComponentFactory.Instance.creatCustomObject("feedback.detailTextImgRec");
         ObjectUtils.copyPropertyByRectangle(this._detailTextImg,rec);
         addChildAt(this._detailTextImg,0);
         this._csTelText = ComponentFactory.Instance.creatComponentByStylename("feedback.csTelText");
         this._csTelText.text = LanguageMgr.GetTranslation("feedback.view.csTelNumber",PathManager.solveFeedbackTelNumber());
         if(!StringHelper.isNullOrEmpty(PathManager.solveFeedbackTelNumber()))
         {
            addChild(this._csTelText);
         }
         this._infoText = ComponentFactory.Instance.creatComponentByStylename("feedback.infoText");
         rec = ComponentFactory.Instance.creatCustomObject("feedback.detailInfoTextRec");
         ObjectUtils.copyPropertyByRectangle(this._infoText,rec);
         addChildAt(this._infoText,0);
         this._csTelText.y = 125;
         this._detailTextArea = ComponentFactory.Instance.creatComponentByStylename("feedback.simpleTextArea");
         rec = ComponentFactory.Instance.creatCustomObject("feedback.detailSimpleTextAreaRec");
         ObjectUtils.copyPropertyByRectangle(this._detailTextArea,rec);
         addChildAt(this._detailTextArea,0);
         this._textInputBg = ComponentFactory.Instance.creatComponentByStylename("feedback.textBgImg_style");
         addChildAt(this._textInputBg,0);
         this._infoText.text = LanguageMgr.GetTranslation("feedback.view.infoText",this._detailTextArea.maxChars);
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

